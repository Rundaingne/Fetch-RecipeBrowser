//
//  RecipeDetail.swift
//  Fetch-RecipeBrowser
//
//  Created by Erich Kumpunen on 11/11/23.
//

import SwiftUI

struct RecipeDetail: View {
    
    @ObservedObject private var model: RecipeViewModel
    @Environment(\.scenePhase) var scenePhase

    var recipe: DisplayRecipe
    
    @State var selectedTag = 0
    @State var notes = String()
    
    init(model: RecipeViewModel, recipe: DisplayRecipe) {
        self.model = model
        self.recipe = recipe
    }
    
    var details: DisplayDetails? {
        return model.details.first(where: { $0.name == recipe.name })
    }
    
    func view<U: View>(for title: String, _ details: DisplayDetails, viewProvider: () -> U) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.title)
            Divider()
            viewProvider()
                .background(RoundedRectangle(cornerRadius: 6).fill(LinearGradient(colors: [.black, .gray.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing)))
                .shadow(radius: 4)
        }
        .padding(.horizontal)
    }
    
    var body: some View {
        ZStack {
            if let details = details {
                VStack {
                    view(for: "Ingredients:", details) {
                        List {
                            ForEach(details.ingredients, id: \.self) { ingredient in
                                Text(ingredient)
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparatorTint(.cyan.opacity(0.4))
                        }
                        .listStyle(.plain)
                        .padding(4)
                    }
                    
                    view(for: selectedTag == 0 ? "Instructions" : "Notes", details) {
                        TabView(selection: $selectedTag) {
                            ScrollView(.vertical, showsIndicators: true) {
                                Text(details.instructions)
                            }
                            .padding()
                            .tag(0)
                            
                            /// Text editor kind of sucks still, but I'll use it here for now for a quick notes section. Would probably substitute this out in the future for a UIViewRepresentable TextView.
                            TextEditor(text: $notes)
                                .padding()
                                .tag(1)
                            
                        }.tabViewStyle(.page)
                    }
                    HStack {
                        if !details.youtubeLink.isEmpty {
                            Link(destination: URL(string: details.youtubeLink)!) {
                                Text("Watch on YouTube")
                                    .foregroundStyle(.cyan.opacity(0.9))
                            }
                        }
                        Spacer()
                        if !details.articleLink.isEmpty {
                            Link(destination: URL(string: details.articleLink)!) {
                                Text("View article")
                                    .foregroundStyle(.cyan.opacity(0.9))
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 6)

                }
                .multilineTextAlignment(.center)
                .navigationTitle(recipe.name)
            }
            
            Loader(category: "")
                .isHidden(details != nil)
            
            LoadFailPopup(model: model, isDetails: true)
                .isHidden(model.fetchError == nil)
        }
        .background(Color.primary.opacity(0.5))
        .onAppear {
            Task {
                await model.fetchDetails(for: recipe)
                self.notes = model.getNotes(for: recipe)
            }
        }
        .onDisappear {
            model.setNotes(for: recipe, notes)
        }
        
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .inactive, .background:
                model.setNotes(for: recipe, notes)
            default:
                break
            }
        }
    }
}
