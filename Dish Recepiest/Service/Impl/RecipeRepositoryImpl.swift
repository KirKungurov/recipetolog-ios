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

    func save(_ recipes: [Recipe]) {
        try? realm.write {
            realm.add(recipes, update: .modified)
        }
    }

    func getAllRecipes() -> Results<Recipe> {
        return realm.objects(Recipe.self)
    }
    
    func getRecipesWithIngrient(ingridients: [String]) -> Results<Recipe> {
        var recipes = realm.objects(Recipe.self).makeIterator()
        var recipeIds: [Int] = []
        while let recipe = recipes.next() {
            if Set(ingridients).isSubset(of: recipe.ingredients.map{$0.ingredient?.name}) && ingridients.count > 0 {
                recipeIds.append(recipe.id)
            }

        }
        return realm.objects(Recipe.self).filter("id IN %@", Array(recipeIds))
    }
}

