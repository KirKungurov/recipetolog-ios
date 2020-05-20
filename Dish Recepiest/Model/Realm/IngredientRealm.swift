//
//  IngredientRealm.swift
//  Dish Recepiest
//
//  Created by Kirill Kungurov on 19.05.2020.
//  Copyright © 2020 Kirill Kungurov. All rights reserved.
//

import RealmSwift

class IngredientRealm: Object{
    @objc dynamic var ingredientId: Int = 0
    @objc dynamic var ingredientName: String = ""
    
    override class func primaryKey() -> String? {
        "ingredientId"
    }
}

extension IngredientRealm{
    var ingredient: IngredientInfo{
        IngredientInfo(id: ingredientId, name: ingredientName)
    }
    
    convenience init(ingredientInfo: IngredientInfo){
        self.init()
        self.ingredientId = ingredientInfo.id
        self.ingredientName = ingredientInfo.name
    }
}
