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
        for recipe in recipes{
            var recipeIngedientsLinks = [RecipeIngredientRealm]()
            var ingredients = [IngredientRealm]()
            for ingredientContainer in recipe.ingredients{
                ingredients.append(IngredientRealm.init(ingredientInfo: ingredientContainer.ingredient))
                recipeIngedientsLinks.append(RecipeIngredientRealm.init(recipeId: recipe.id, ingredientId: ingredientContainer.ingredient.id, ingredientName: ingredientContainer.ingredient.name, ingredientAmout: ingredientContainer.amount))
            }
            
            try? realm.write {
                realm.add(ingredients, update: .modified)
                realm.add(recipeIngedientsLinks, update: .modified)
            }
        }
        let recipesObj = recipes.map(RecipeRealm.init(recipe:))
        try? realm.write {
            realm.add(recipesObj, update: .modified)
        }
    }

    func getAllRecipes() -> Results<RecipeRealm> {
        return realm.objects(RecipeRealm.self)
    }
    
    func getRecipesWithIngrient(ingridients: [String]) -> Results<RecipeRealm> {
        var recipeWithIngredients = realm.objects(RecipeIngredientRealm.self).makeIterator()
        var tmp: [Int: [String]] = [:]
        while let ingredient = recipeWithIngredients.next() {
            if tmp.keys.contains(ingredient.recipeId){
                tmp.updateValue(tmp[ingredient.recipeId]!+[ingredient.ingredientName], forKey: ingredient.recipeId)
            } else {
                tmp[ingredient.recipeId] = [ingredient.ingredientName]
            }
        }
        var results: [Int] = []
        for recipe in tmp.keys{
            if let ingrs = tmp[recipe] {
                if Set(ingridients).isSubset(of: ingrs){
                    results.append(recipe)
                }
            }
        }
        return realm.objects(RecipeRealm.self).filter("recipeId IN %@", Array(results))
    }
}

