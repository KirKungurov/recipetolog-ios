//
//  Ingredient.swift
//  Dish Recepiest
//
//  Created by Kirill Kungurov on 21.05.2020.
//  Copyright © 2020 Kirill Kungurov. All rights reserved.
//
import  RealmSwift

class Ingredient: Object, Decodable{
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    
    override class func primaryKey() -> String? {
        "id"
    }
}

extension Ingredient{
    convenience init(ingredient: Ingredient){
        self.init()
        self.id = ingredient.id
        self.name = ingredient.name
    }
}
