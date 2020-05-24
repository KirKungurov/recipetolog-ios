//
//  Recepie.swift
//  Dish Recepiest
//
//  Created by Kirill Kungurov on 07.05.2020.
//  Copyright © 2020 Kirill Kungurov. All rights reserved.
//

import Foundation

struct Recipe2{
    let id: Int
    let source: String?
    let name: String
    let imageUrl: String?
    let description: String
    let ingredients: [IngredientContainer]
    let directions: [String]
}

extension Recipe2: Decodable {}
