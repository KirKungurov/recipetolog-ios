//
//  RecipeIngredientRealm.swift
//  Dish Recepiest
//
//  Created by Kirill Kungurov on 19.05.2020.
//  Copyright © 2020 Kirill Kungurov. All rights reserved.
//

import RealmSwift

class RecipeIngredientRealm: Object{
    @objc dynamic var ingredientId: Int = 0
    @objc dynamic var recipeId: Int = 0
}

extension RecipeIngredientRealm {
    convenience init(recipeId: Int, ingredientId: Int){
        self.init()
        self.recipeId = recipeId
        self.ingredientId = ingredientId
    }
}
