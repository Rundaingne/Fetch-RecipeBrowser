//
//  RecipeList.swift
//  Fetch-RecipeBrowser
//
//  Created by Erich Kumpunen on 11/10/23.
//

import SwiftUI
let screenSize = UIScreen.main.bounds

/// Main app view. This uses a simple navigation view to move from a list to details. The list view here is done with a grid, scrolling horizontally. The details screen has two scroll views on it: one for ingredients, one for instructions. You can tap the heart icon to favorite a recipe, and you can display only favorites if you wish by using the toggle in the top left.

struct RecipeList: View {
    
    @StateObject private var model = RecipeViewModel()
    
    @State var recipes = [DisplayRecipe]()
    @State var showFavorites = false
    
    var favorites: [DisplayRecipe] {
        return recipes.filter({ UserDefaults.standard.bool(forKey: $0.id) == true })
    }
    
    let gridRows: [GridItem] = Array(repeating: .init(.fixed(screenSize.width * 0.55), spacing: screenSize.height / 51.2, alignment: .leading), count: 3)
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView(.horizontal, showsIndicators: true) {
                    LazyHGrid(rows: gridRows, spacing: screenSize.height / 32, content: {
                        ForEach(showFavorites ? favorites : recipes) { recipe in
                            NavigationLink {
                                RecipeDetail(model: model, recipe: recipe)
                            } label: {
                                RecipeCell(recipe: recipe)
                            }
                            .buttonStyle(.plain)
                        }
                    })
                }
                .navigationTitle("Recipes")
                .navigationBarTitleDisplayMode(.inline)
                .onReceive(model.$viewState, perform: { state in
                    switch state {
                    case .initialize:
                        break
                    case .results(let recipes):
                        self.recipes = recipes.sorted(by: { ($0.name) < ($1.name) })
                    }
                })
                
                Loader()
                    .frame(width: 200, height: 200)
                    .isHidden(!recipes.isEmpty)
            }
            .background(Color.primary.opacity(0.5))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Toggle(isOn: $showFavorites.animation(.smooth)) {
                        Text(showFavorites ? "Favorites" : "All")
                            .font(.caption)
                    }.toggleStyle(.switch)
                        .tint(.red)
                }
            }
        }
        .tint(.black)
    }
}

