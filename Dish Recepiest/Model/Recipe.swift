//
//  RecepieRealm.swift
//  Dish Recepiest
//
//  Created by Kirill Kungurov on 07.05.2020.
//  Copyright © 2020 Kirill Kungurov. All rights reserved.
//

import RealmSwift

class Recipe: Object, Decodable{
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var imageUrl: String? = ""
    @objc dynamic var source: String? = ""
//    @objc dynamic var recipeDescription: String = ""
    
    var ingredients = List<RecipeIngredient>()
        
    override class func primaryKey() -> String? {
        "id"
    }
}

extension Recipe {
    convenience init(recipe: Recipe){
        self.init()
        self.id = recipe.id
        self.source = recipe.source
        self.name = recipe.name
        self.imageUrl = recipe.imageUrl
//        self.recipeDescription = recipe.recipeDescription
//        self.links.append(objectsIn: links)
        self.ingredients = recipe.ingredients
    }
}
