//
//  RecepieRealm.swift
//  Dish Recepiest
//
//  Created by Kirill Kungurov on 07.05.2020.
//  Copyright © 2020 Kirill Kungurov. All rights reserved.
//

import RealmSwift

class RecipeRealm: Object{
    @objc dynamic var recipeId: Int = 0
    @objc dynamic var source: String? = ""
    @objc dynamic var name: String = ""
    @objc dynamic var imageUrl: String? = ""
    @objc dynamic var recipeDescription: String = ""
        
    //TODO заменить на id
    override class func primaryKey() -> String? {
        "recipeId"
    }
}

extension RecipeRealm {
    var recipe: RecipeInfo{
        //TODO ingredientLines хранение
        RecipeInfo(id: recipeId, source: source, name: name, imageUrl: imageUrl, description: recipeDescription, ingredients: [], directions: [])
    }
    
    convenience init(recipe: RecipeInfo){
        self.init()
        self.recipeId = recipe.id
        self.source = recipe.source
        self.name = recipe.name
        self.imageUrl = recipe.imageUrl
        self.recipeDescription = recipe.description
    }
}
