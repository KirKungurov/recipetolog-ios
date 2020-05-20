//
//  Ingridient.swift
//  Dish Recepiest
//
//  Created by Kirill Kungurov on 19.05.2020.
//  Copyright © 2020 Kirill Kungurov. All rights reserved.
//

import Foundation

struct IngredientContainer: Decodable {
    let ingredient: IngredientInfo
    let amount: String
}

struct IngredientInfo: Decodable{
    let id: Int
    let name: String
}
