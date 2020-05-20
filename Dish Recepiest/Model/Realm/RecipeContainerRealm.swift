//
//  RecipeContainerRealm.swift
//  Dish Recepiest
//
//  Created by Kirill Kungurov on 20.05.2020.
//  Copyright © 2020 Kirill Kungurov. All rights reserved.
//

import RealmSwift

class RecipeContainerRealm: Object{
    var recipeInfo: RecipeRealm? = RecipeRealm()
    var ingredientsInfo: [IngredientInfo]? = []
}

extension RecipeContainerRealm{
    
    convenience init(recipeInfo: RecipeRealm, ingredientsInfo: [IngredientInfo]) {
        self.init()
        self.recipeInfo = recipeInfo
        self.ingredientsInfo = ingredientsInfo
    }
}
