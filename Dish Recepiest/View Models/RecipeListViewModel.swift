//
//  RecipeListViewModel.swift
//  Dish Recepiest
//
//  Created by Kirill Kungurov on 18.05.2020.
//  Copyright © 2020 Kirill Kungurov. All rights reserved.
//

import Foundation

protocol RecipeListViewModelProtocol {
    typealias RecipesCompletion = ([RecipeViewModel]?) -> Void

    var onRecipesChanged: (([RecipeViewModel]) -> Void)? { get set } 
    func reloadRecipes(ingredients: String)
    func loadMore()
}

class RecipeListViewModel: RecipeListViewModelProtocol {
    private let recipeService: RecipeService = RecipeServiceImpl()
    private let recipeFacade: RecipeFacade = RecipeFacadeImpl(recipeRepostory: RecipeRepositoryImpl(), recipeService: RecipeServiceImpl())
    private var recipesVM = [RecipeViewModel](){
        didSet{
            onRecipesChanged?(recipesVM)
        }
    }
    private var from: Int = 0
    private var count: Int = 20
    private var ingredients: String = ""
    private var nextUrl:  URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "recipetolog.herokuapp.com"
        components.path = "/recipes/with-all-these-ingredients"
        components.queryItems = [
            URLQueryItem(name: "ing", value: self.ingredients.trimmingCharacters(in: .punctuationCharacters)),
            URLQueryItem(name: "from", value: "\(self.from)"),
            URLQueryItem(name: "count", value: "\(self.count)")
        ]
        return components.url
    }
    
    var onRecipesChanged: (([RecipeViewModel]) -> Void)?
    
    func reloadRecipes(ingredients: String){
        self.ingredients = ingredients
        self.from = 0
        self.recipesVM = []
        recipeService.getRecipes(nextUrl: nextUrl){
            guard let newRecipes = $0 else { return }
            self.recipesVM = newRecipes.map{RecipeViewModel(recipe: $0)}
        }
        self.from += self.count
    }
    
    func loadMore() {
        //переделать на фасад для кэширования
        recipeService.getRecipes(nextUrl: nextUrl){
            guard let newRecipes = $0 else { return }
            if newRecipes.count != 0 {
                self.from += self.count
            }
            self.recipesVM.append(contentsOf: newRecipes.map{RecipeViewModel(recipe: $0)})
        }
    }
}
