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
    @objc dynamic var ingredientName: String = ""
    @objc dynamic var recipeId: Int = 0
    @objc dynamic var ingredientAmout: String = ""
    @objc dynamic var commpositeKey: String = ""
    
    override class func primaryKey() -> String? {
        "commpositeKey"
    }}

extension RecipeIngredientRealm {
    convenience init(recipeId: Int, ingredientId: Int, ingredientName: String, ingredientAmout: String){
        self.init()
        self.ingredientAmout = ingredientAmout
        self.ingredientName = ingredientName
        self.commpositeKey = "\(recipeId)_\(ingredientId)"
        self.recipeId = recipeId
        self.ingredientId = ingredientId
    }
}
