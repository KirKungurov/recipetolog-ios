//
//  RecipeRepositoryImpl.swift
//  Dish Recepiest
//
//  Created by Kirill Kungurov on 12.05.2020.
//  Copyright © 2020 Kirill Kungurov. All rights reserved.
//

import RealmSwift

final class RecipeRepositoryImpl: RecipeRepository {
    private let configuration: Realm.Configuration

    var realm: Realm {
        do {
            return try Realm(configuration: configuration)
        } catch {
            fatalError("Realm can't be created")
        }
    }

    init(configuration: Realm.Configuration = .defaultConfiguration) {
        self.configuration = configuration
    }
    
    func save(_ recipes: [Recipe]) {
        try? realm.write {
            //Чобы не обновлять статус закладки про обычной загрузке рецептов
            for recipe in recipes{
                if realm.object(ofType: Recipe.self, forPrimaryKey: recipe.id) == nil {
                    realm.add(recipe, update: .modified)
                }
            }
        }
    }
    
    func updateBookmark(recipe: Recipe){
        try? realm.write{
            recipe.isBookmark = !recipe.isBookmark
        }
    }
    
    func getBookmarks() -> Results<Recipe>{
        realm.objects(Recipe.self).filter("isBookmark = true")
    }
    
    func getRecipesWithIngrient() -> Results<Recipe> {
        return realm.objects(Recipe.self)
    }
}

