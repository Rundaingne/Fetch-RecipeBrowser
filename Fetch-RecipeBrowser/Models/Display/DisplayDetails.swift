//
//  DisplayDetails.swift
//  Fetch-RecipeBrowser
//
//  Created by Erich Kumpunen on 11/11/23.
//

import Foundation

class DisplayDetails {
    let name: String
    let instructions: String
    let youtubeLink: String
    let articleLink: String
    let ingredients: [String]
    
    init(name: String, instructions: String, youtubeLink: String, articleLink: String, ingredients: [String]) {
        self.name = name
        self.instructions = instructions
        self.youtubeLink = youtubeLink
        self.articleLink = articleLink
        self.ingredients = ingredients
    }
    
    class func make(from details: MealDetail) -> DisplayDetails {
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
        return newDetails
    }
}
