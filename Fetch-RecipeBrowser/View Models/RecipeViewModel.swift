//
//  RecipeViewModel.swift
//  Fetch-RecipeBrowser
//
//  Created by Erich Kumpunen on 11/10/23.
//

import SwiftUI
import Combine

@MainActor
class RecipeViewModel: NSObject, ObservableObject {
    
    @Published var viewState: State = .initialize
    @Published var details = [DisplayDetails]()
    @Published var fetchError: Error?
    
    @Published private(set) var favorites = [DisplayRecipe]()
    @Published private(set) var recipeNotes = [String: String]()
        
    enum State {
        case initialize
        case results([DisplayRecipe])
    }
    
    override init() {
        /// You could fetch when the view loads, or you can do it when this object is created. Or, we could make this an @EnvironmentObject and put it in the .app file, and do the fetch there. Just make sure however you do it that there is a loading screen. Nothing turns a user off faster than a UI that appears to be slow and unresponsive. 
        /// Also make sure to do threading appropriately. if not using async await style code with Tasks, then use GCD and DispatchQueues correctly.
        /// Could also do  an Operation Queue. But async-await style code replaces that pretty effectively.
        super.init()
        Task {
            await fetchRecipes()
            loadRecipeNotes()
        }
    }
    
    func setNotes(for recipe: DisplayRecipe, _ notes: String) {
        recipeNotes[recipe.id] = notes
        self.saveToPersistentStorage()
    }
    
    func getNotes(for recipe: DisplayRecipe) -> String {
        return recipeNotes[recipe.id] ?? ""
    }
    
    func setFavorites(for recipes: [DisplayRecipe]) {
        for recipe in recipes {
            let fav = UserDefaults.standard.bool(forKey: recipe.id)
            if fav {
                print("Recipe is favorited!!")
                self.favorites.append(recipe)
            }
        }
    }
    
    func toggleFavorite(_ recipe: DisplayRecipe, isFavorite: Bool) {
        if !isFavorite {
            self.favorites.removeAll(where: { $0.id == recipe.id })
        } else {
            if !self.favorites.contains(where: { $0.id == recipe.id }) {
                self.favorites.append(recipe)
            }
        }
    }
    
    func fetchRecipes(category: MealCategory = .dessert) async {
        do {
            viewState = .initialize
            let meals: Meals = try await URLService.getData(from: .recipes, and: category)
            async let recipes = DisplayRecipe.makeGroup(from: meals.meals)
            await self.setFavorites(for: recipes)
            viewState = await .results(recipes)
        } catch {
            print("Error fetching recipes. Rip. Error: \(error), \(error.localizedDescription)")
            self.fetchError = error
        }
    }
    
    func fetchDetails(for recipe: DisplayRecipe) async {
        /// Do this in such a way that the user does not have to make an API call and sit at a loading screen every time they click on a recipe they've already selected in this session.
        do {
            if self.details.contains(where: { $0.name == recipe.name }) { return }
            let detail: MealDetails = try await URLService.getData(from: .details, with: recipe.id)
            guard let details = detail.meals.first else { return }
            let newDetails = DisplayDetails.make(from: details)
            self.details.append(newDetails)
        } catch {
            print("Error fetching details for \(recipe.name): \(error), \(error.localizedDescription)")
            self.fetchError = error
        }
    }
    
    private func fileURL() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileName = "recipeNotes.json"
        let documentsDirectoryURL = urls[0].appendingPathComponent(fileName)
        return documentsDirectoryURL
    }
    
    private func loadRecipeNotes() {
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: fileURL())
            let recipeNotes = try decoder.decode([String: String].self, from: data)
            print("Recipe notes: \(recipeNotes)")
            self.recipeNotes = recipeNotes
        } catch let error {
            print("There was an error loading notes: \(error)")
        }
    }
    
    private func saveToPersistentStorage() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(recipeNotes)
            try data.write(to: fileURL())
        } catch let error {
            print("There was an error saving notes: \(error)")
        }
    }
}
