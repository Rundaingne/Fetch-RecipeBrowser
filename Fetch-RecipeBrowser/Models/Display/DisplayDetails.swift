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
}
