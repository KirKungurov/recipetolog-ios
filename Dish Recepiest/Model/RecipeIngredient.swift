//
//  RecipeIngredient.swift
//  Dish Recepiest
//
//  Created by Kirill Kungurov on 21.05.2020.
//  Copyright © 2020 Kirill Kungurov. All rights reserved.
//

import RealmSwift

class RecipeIngredient: Object, Decodable{
    @objc dynamic var ingredient: Ingredient?
    @objc dynamic var amount: String = ""
}
