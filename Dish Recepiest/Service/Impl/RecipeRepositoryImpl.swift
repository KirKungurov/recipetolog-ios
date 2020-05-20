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

    func save(_ recipes: [RecipeInfo]) {
        let recipesObj = recipes.map(RecipeRealm.init(recipe:))
//        for recipe in recipes{
//            var recipeIngedientsLinks = [RecipeIngredientRealm]()
//            for ingredientContainer in recipe.ingredients{
//                recipeIngedientsLinks.append(RecipeIngredientRealm.init(recipeId: recipe.id, ingredientId: ingredientContainer.ingredient.id))
//            }
//        }
        try? realm.write {
            realm.add(recipesObj, update: .modified)
        }
    }

    func getAllRecipes() -> Results<RecipeRealm> {
        realm.objects(RecipeRealm.self)
    }
    
    func getRecipesWithIngrient(ingridients: String) -> Results<RecipeRealm> {
        //SQL injection
    
        realm.objects(RecipeRealm.self).filter("label is not null")
    }
}

