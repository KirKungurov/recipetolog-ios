//
//  DishInfo.swift
//  Dish Recepiest
//
//  Created by Kirill Kungurov on 18.05.2020.
//  Copyright © 2020 Kirill Kungurov. All rights reserved.
//

import Foundation

struct RecipeInfo{
//    let id: Int
//    let name: String
//    let imageUrl: String?
//    let description: String
 //   let ingredients: [IngredientContainer]
//    let directions: [String]
    let uri: String
    let label: String
    let image: String?
    let ingredientLines: [String] = [String]()
    
}

extension RecipeInfo: Decodable {}

