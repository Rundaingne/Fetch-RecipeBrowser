//
//  LoadFailPopup.swift
//  Fetch-RecipeBrowser
//
//  Created by Erich Kumpunen on 11/12/23.
//

import SwiftUI

struct LoadFailPopup: View {
    @ObservedObject var model: RecipeViewModel
    
    var isDetails: Bool
    
    var body: some View {
        VStack {
            Text("Failed to load \(isDetails ? "recipe details": "recipe"), try again.")
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

    }
}
