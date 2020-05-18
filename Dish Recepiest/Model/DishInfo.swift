//
//  DishInfo.swift
//  Dish Recepiest
//
//  Created by Kirill Kungurov on 18.05.2020.
//  Copyright © 2020 Kirill Kungurov. All rights reserved.
//

import Foundation

struct DishInfo{
    let uri: String
    let label: String
    let image: String?
    let ingredientLines: [String]
}

extension DishInfo: Decodable {}

struct Ingridient: Decodable {
    let text: String
    let weight: String
}
