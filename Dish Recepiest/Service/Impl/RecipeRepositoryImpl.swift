//
//  RecipeRepositoryImpl.swift
//  Dish Recepiest
//
//  Created by Kirill Kungurov on 12.05.2020.
//  Copyright © 2020 Kirill Kungurov. All rights reserved.
//

import RealmSwift

final class RecipeRepositoryImpl: RecipeRepository {
    var realm: Realm {
        do {
            return try Realm()
        } catch {
            fatalError("Realm can't be created")
        }
    }

    func save(_ recipes: [DishInfo]) {
        let recipes = recipes.map(RecipeRealm.init(recipe:))
        print("Count " + "\(recipes.count)")
        try? realm.write {
            realm.add(recipes, update: .modified)
        }
    }

    func getRecipes() -> Results<RecipeRealm> {
        realm.objects(RecipeRealm.self)
    }
}

