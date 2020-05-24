//
//  RecipesFacadeImpl.swift
//  Dish Recepiest
//
//  Created by Kirill Kungurov on 12.05.2020.
//  Copyright © 2020 Kirill Kungurov. All rights reserved.
//

import RealmSwift

final class RecipeFacadeImpl: RecipeFacade{
    
    private let recipeRepository: RecipeRepository
    private let recipeService: RecipeServiceImpl
    private var recipeToken: NotificationToken?

    init(recipeRepostory: RecipeRepository, recipeService: RecipeServiceImpl) {
        self.recipeRepository = recipeRepostory
        self.recipeService = recipeService
    }

    func loadMore(nextUrl: URL?){
      recipeService.getRecipes(nextUrl: nextUrl){
            guard let recipes = $0 else { return }
            self.recipeRepository.save(recipes.map{$0})
        }
    }
    
    
    func getRecipes(nextUrl: URL?, ingredients: [String], completion: @escaping OnUpdateRecipes) {
        recipeService.getRecipes(nextUrl: nextUrl){
            guard let recipes = $0 else { return }
            self.recipeRepository.save(recipes.map{$0})
        }
        let recipes = recipeRepository.getRecipesWithIngrient()
        recipeToken = recipes.observe { _ in
            var allRecipes = recipes.map{$0}.makeIterator()
            var result = [Recipe]()
            while let recipe = allRecipes.next() {
                if Set(ingredients).isSubset(of: recipe.ingredients.map{$0.ingredient?.name}) && ingredients.count > 0 {
                    result.append(recipe)
                }
            }
            completion(result)
        }
    }
}
