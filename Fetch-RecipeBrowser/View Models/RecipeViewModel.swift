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
    
    @Published var favorites = [DisplayRecipe]()
        
    enum State {
        case initialize
        case results([DisplayRecipe])
    }
    
    override init() {
        /// You could fetch when the view loads, or you can do it when this object is created. Or, we could make this an @EnvironmentObject and put it in the .app file, and do the fetch there. Just make sure however you do it that there is a loading screen. Nothing turns a user off faster than a UI that appears to be slow and unresponsive. Also make sure to do threading appropriately. if not using async await style code with Tasks, then use GCD and DispatchQueues correctly.
        super.init()
        Task {
            await fetchRecipes()
        }
    }
    
    func fetchRecipes(category: MealCategory = .dessert) async {
        do {
            viewState = .initialize
            let meals: Meals = try await URLService.getData(from: .recipes, and: category)
            async let recipes = DisplayRecipe.makeGroup(from: meals.meals)
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
            var ingredientGroup: [(String?, String?)] = [
                (details.strMeasure1, details.strIngredient1),
                (details.strMeasure2, details.strIngredient2),
                (details.strMeasure3, details.strIngredient3),
                (details.strMeasure4, details.strIngredient4),
                (details.strMeasure5, details.strIngredient5),
                (details.strMeasure6, details.strIngredient6),
                (details.strMeasure7, details.strIngredient7),
                (details.strMeasure8, details.strIngredient8),
                (details.strMeasure9, details.strIngredient9),
                (details.strMeasure10, details.strIngredient10),
                (details.strMeasure11, details.strIngredient11),
                (details.strMeasure12, details.strIngredient12),
                (details.strMeasure13, details.strIngredient13),
                (details.strMeasure14, details.strIngredient14),
                (details.strMeasure15, details.strIngredient15),
                (details.strMeasure16, details.strIngredient16),
                (details.strMeasure17, details.strIngredient17),
                (details.strMeasure18, details.strIngredient18),
                (details.strMeasure19, details.strIngredient19),
                (details.strMeasure20, details.strIngredient20)
            ]
            ingredientGroup.removeAll(where: { $0.0 == nil || $0.1 == nil })
            ingredientGroup.removeAll(where: { $0.0 == "" || $0.1 == "" })
            
            let ingredients: [String] = ingredientGroup.map({ "\($0.0 ?? "") \($0.1 ?? "")"})
            
            let newDetails = DisplayDetails(name: details.strMeal ?? "", instructions: details.strInstructions ?? "", youtubeLink: details.strYoutube ?? "", articleLink: details.strSource ?? "", ingredients: ingredients)
            self.details.append(newDetails)
        } catch {
            print("Error fetching details for \(recipe.name): \(error), \(error.localizedDescription)")
            self.fetchError = error
        }
    }
}
