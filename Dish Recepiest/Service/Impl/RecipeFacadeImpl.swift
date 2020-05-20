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

    func getRecipes(nextUrl: URL?, completion: @escaping OnUpdateRecipes) {
        recipeService.getRecipes(nextUrl: nextUrl){
            guard let recipes = $0 else { return }
            let tmp = recipes.map{$0}
            self.recipeRepository.save(tmp)
        }
        let recipes = recipeRepository.getAllRecipes()
        recipeToken = recipes.observe { _ in
            completion(recipes.map {$0.recipe})
        }
    }
}
