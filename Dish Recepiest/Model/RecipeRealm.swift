//
//  RecepieRealm.swift
//  Dish Recepiest
//
//  Created by Kirill Kungurov on 07.05.2020.
//  Copyright © 2020 Kirill Kungurov. All rights reserved.
//

import RealmSwift

class RecipeRealm: Object{
    @objc dynamic var uri: String = ""
    @objc dynamic var label: String = ""
    @objc dynamic var image: String? = ""
//    @objc dynamic var ingredientLines: [String] = []
    
    //TODO заменить на id
    override class func primaryKey() -> String? {
        "label"
    }
}

extension RecipeRealm {
    var recipe: DishInfo{
        DishInfo(uri: uri, label: label, image: image, ingredientLines: [])
    }
    
    convenience init(recipe: DishInfo){
        self.init()
        self.uri = recipe.uri
        self.label = recipe.label
        self.image = recipe.image
//        self.ingredientLines = recipe.ingredientLines
    }
}
