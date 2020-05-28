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
    @objc dynamic var recipeDescription: String = ""
    @objc dynamic var isBookmark: Bool = false
    
    var ingredients = List<RecipeIngredient>()
    var directions = List<String>()
        
    override class func primaryKey() -> String? {
        "id"
    }
    
    private enum CodingKeys: String,CodingKey{
        case id,name,imageUrl,source,description,ingredients,directions
    }
    
    required convenience init(from decoder: Decoder) throws{
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.imageUrl = try container.decode(String?.self, forKey: .imageUrl)
        self.source = try container.decode(String?.self, forKey: .source)
        self.recipeDescription = try container.decode(String.self, forKey: .description)
        self.ingredients = try container.decodeIfPresent(List<RecipeIngredient>.self, forKey: .ingredients) ?? List()
        self.directions = try container.decodeIfPresent(List<String>.self, forKey: .directions) ?? List()
    }
}
