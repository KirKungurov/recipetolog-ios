//
//  RecipeRepository.swift
//  Dish Recepiest
//
//  Created by Kirill Kungurov on 12.05.2020.
//  Copyright © 2020 Kirill Kungurov. All rights reserved.
//

import RealmSwift

protocol RecipeRepository {
    func save(_ recipes: [Recipe])
    func getRecipesWithIngrient() -> Results<Recipe>
    func updateBookmark(recipe: Recipe)
    func getBookmarks() -> Results<Recipe>
}
