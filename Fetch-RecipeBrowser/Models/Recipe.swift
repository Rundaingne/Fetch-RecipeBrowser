//
//  Recipe.swift
//  Fetch-RecipeBrowser
//
//  Created by Erich Kumpunen on 11/10/23.
//

import SwiftUI

class Recipe: Decodable, Identifiable {
    
    let id: String?
    var imageRef: String?
    var name: String?
    
    init(id: String, imageRef: String, name: String) {
        self.id = id
        self.imageRef = imageRef
        self.name = name
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case imageRef = "strMealThumb"
    }
}

class Meals: Decodable {
    var meals: [Recipe]
}
