//
//  RecipeCell.swift
//  Fetch-RecipeBrowser
//
//  Created by Erich Kumpunen on 11/11/23.
//

import SwiftUI

struct RecipeCell: View {
    
    @Environment(\.scenePhase) var scenePhase
    
    var recipe: DisplayRecipe
    @State var favorited = false
    
    var body: some View {
        VStack(spacing: 4) {
            recipe.image
                .resizable()
                .clipShape(Circle())
                .scaledToFit()
                .padding(4)
            HStack {
                Button {
                    favorited.toggle()
                } label: {
                    Image(systemName: favorited ? "heart.fill" : "heart")
                        .imageScale(.large)
                        .foregroundStyle(.pink)
                }
                .buttonStyle(.plain)
                Spacer()
                
                Text(recipe.name)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                Spacer()
                Image(systemName: "chevron.right")
                    .imageScale(.small)
            }
        }
        .padding(4)
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 6).fill(LinearGradient(colors: [.gray, .gray.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)))
        .shadow(radius: 4)
        .padding(4)
        
        .onAppear {
            /// Load if favorited or not. Again, not a scalable method. Just for simplicity.
            let fav = UserDefaults.standard.bool(forKey: recipe.id)
            self.favorited = fav
        }
        
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .background, .inactive:
                /// Save. NOTE that this method is not scalable. To scale, use of Core Data locally is recommended, or saving directly to a db like CloudKit, Firebase, AWS, etc etc. Just going to use UserDefaults here since there is a small number of objects, and only saving a bool for each meal id as a key..
                UserDefaults.standard.setValue(favorited, forKey: recipe.id)
                print("App going to background, saving favorites. \(favorited): \(recipe.id)")
            default:
                break
            }
        }
    }
}
