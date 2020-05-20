//
//  Response.swift
//  Dish Recepiest
//
//  Created by Kirill Kungurov on 17.05.2020.
//  Copyright © 2020 Kirill Kungurov. All rights reserved.
//

import Foundation

struct Response<T:Decodable>{
    let recipes: [RecipeInfo]
}

extension Response: Decodable {}
