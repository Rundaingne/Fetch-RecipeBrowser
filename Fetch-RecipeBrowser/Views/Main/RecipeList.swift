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
    @State var selectedCategory: MealCategory = .dessert
    @State var showCategories = false
    @State var searchText = ""
        
    var filteredRecipes: [DisplayRecipe] {
        if showFavorites {
            if searchText.isEmpty { return favorites }
            return favorites.filter({ $0.name.contains(searchText) })
        } else {
            if searchText.isEmpty { return recipes }
            return recipes.filter({ $0.name.contains(searchText) })
        }
    }
    
    let gridRows: [GridItem] = Array(repeating: .init(.fixed(screenSize.width * 0.55), spacing: screenSize.height / 51.2, alignment: .leading), count: 3)
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    SearchBar(placeholder: "Search for a recipe...", text: $searchText) { }
                        .padding([.horizontal, .top])
                    
                    ScrollView(.horizontal, showsIndicators: true) {
                        LazyHGrid(rows: gridRows, spacing: screenSize.height / 32, content: {
                            ForEach(filteredRecipes) { recipe in
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
                }
                .keyboardAdaptive()
                
                Loader(category: selectedCategory.rawValue)
                    .frame(width: 200, height: 200)
                    .isHidden(!recipes.isEmpty)
                
                VStack {
                    Text("Failed to load recipes, try again.")
                        .padding()
                        .multilineTextAlignment(.center)
                    
                    Button {
                        model.fetchError = nil
                        Task {
                            await model.fetchRecipes()
                        }
                    } label: {
                        Text("Okay")
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).fill(Color.cyan.opacity(0.2)))
                    }.buttonStyle(.plain)

                }
                .frame(width: screenSize.width * 0.5, height: screenSize.height * 0.5)
                .background(RoundedRectangle(cornerRadius: 8).fill(LinearGradient(colors: [.black, .gray.opacity(0.9)], startPoint: .topLeading, endPoint: .bottomTrailing)))
                .shadow(radius: 4)
                .isHidden(model.fetchError == nil)
            }
            .background(Color.primary.opacity(0.5))
            .popover(isPresented: $showCategories, content: {
                VStack {
                    Text("Select a Category to search")
                    Divider()
                    
                    List {
                        ForEach(MealCategory.allCases, id: \.self) { cat in
                            Button {
                                selectedCategory = cat
                                showCategories.toggle()
                            } label: {
                                Text(cat.rawValue)
                            }
                            .buttonStyle(.plain)
                            .listRowSeparatorTint(.cyan)
                            .listRowBackground(Color.clear)
                        }
                    }
                    .listStyle(.plain)
                }
                .padding(8)
                .background(Color.black)
            })
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Toggle(isOn: $showFavorites.animation(.smooth)) {
                        Text(showFavorites ? "Favorites" : "All")
                            .font(.caption)
                    }.toggleStyle(.switch)
                        .tint(.red)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showCategories.toggle()
                    } label: {
                        Text(selectedCategory.rawValue)
                            .foregroundStyle(.mint)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .tint(.black)
        .onChange(of: selectedCategory) { cat in
            self.recipes = []
            Task {
                await model.fetchRecipes(category: cat)
            }
        }
    }
}

