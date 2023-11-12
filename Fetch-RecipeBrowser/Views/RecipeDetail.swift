//
//  RecipeDetail.swift
//  Fetch-RecipeBrowser
//
//  Created by Erich Kumpunen on 11/11/23.
//

import SwiftUI

struct RecipeDetail: View {
    
    @ObservedObject private var model: RecipeViewModel
    var recipe: DisplayRecipe
    
    init(model: RecipeViewModel, recipe: DisplayRecipe) {
        self.model = model
        self.recipe = recipe
    }
    
    var details: DisplayDetails? {
        return model.details.first(where: { $0.name == recipe.name })
    }
    
    var body: some View {
        ZStack {
            if let details = details {
                VStack {
                    VStack(spacing: 4) {
                        Text("Ingredients:")
                            .font(.title)
                        Divider()
                        List {
                            ForEach(details.ingredients, id: \.self) { ingredient in
                                Text(ingredient)
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparatorTint(.cyan.opacity(0.4))
                        }
                        .listStyle(.plain)
                        .background(RoundedRectangle(cornerRadius: 6).fill(LinearGradient(colors: [.black, .gray.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing)))
                        .shadow(radius: 4)
                    }
                    .padding(.horizontal)
                    
                    VStack(spacing: 4) {
                        Text("Instructions:")
                            .font(.title)
                        Divider()
                        ScrollView(.vertical, showsIndicators: true) {
                            Text(details.instructions)
                        }
                        .padding(.bottom)
                        .background(RoundedRectangle(cornerRadius: 6).fill(LinearGradient(colors: [.black, .gray.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing)))
                        .shadow(radius: 4)
                    }
                    .padding(.horizontal)
                }
                .multilineTextAlignment(.center)
                .navigationTitle(recipe.name)
            }
            
            Loader(category: "")
                .isHidden(details != nil)
            
            VStack {
                Text("Failed to load recipe details, try again.")
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
        .onAppear {
            Task {
                await model.fetchDetails(for: recipe)
            }
        }
    }
}
