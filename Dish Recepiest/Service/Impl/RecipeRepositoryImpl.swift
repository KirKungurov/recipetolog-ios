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
            realm.add(recipes, update: .modified)
        }
    }

    
    func getRecipesWithIngrient() -> Results<Recipe> {
        return realm.objects(Recipe.self)
    }
}

