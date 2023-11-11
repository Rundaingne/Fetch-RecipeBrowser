//
//  DisplayRecipe.swift
//  Fetch-RecipeBrowser
//
//  Created by Erich Kumpunen on 11/11/23.
//

import SwiftUI

struct DisplayRecipe: Identifiable {
    let id: String
    let name: String
    let image: Image
    
    static func make(from recipe: Recipe) async -> DisplayRecipe? {
        if let image = await ImageRequestHandler.shared.getRequest(url: recipe.imageRef ?? "") {
            guard let name = recipe.name, let id = recipe.id else { return nil }
            let dR = DisplayRecipe(id: id, name: name, image: Image(uiImage: image))
            return dR
        }
        return nil
    }
    
    static func makeGroup(from recipes: [Recipe]) async -> [DisplayRecipe] {
        var displays = [DisplayRecipe]()
        for recipe in recipes {
            if recipe.id?.isEmpty == true { continue }
            if let r = await self.make(from: recipe) {
                displays.append(r)
            }
        }
        return displays
    }
}
