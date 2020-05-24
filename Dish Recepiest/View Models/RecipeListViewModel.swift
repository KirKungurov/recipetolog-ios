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
    
    func getRecipe(ingredients: [String])
    func loadMore(ingredients: [String])
}

class RecipeListViewModel: RecipeListViewModelProtocol {
    var onRecipesChanged: (([RecipeViewModel]) -> Void)?

    private let recipeFacade: RecipeFacade = RecipeFacadeImpl(recipeRepostory: RecipeRepositoryImpl(), recipeService: RecipeServiceImpl())
    
    private var recipesVM = [RecipeViewModel](){
        didSet{
            onRecipesChanged?(recipesVM)
        }
    }
    var isBookmarksLoad = false
    private var from: Int = 0
    private var count: Int = 20
    private var ingredients: [String] = []
    
    private var nextUrl:  URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "recipetolog.herokuapp.com"
        components.path = "/recipes/with-all-these-ingredients"
        components.queryItems = [
            URLQueryItem(name: "ing", value: self.ingredients.joined(separator: ",").trimmingCharacters(in: .punctuationCharacters)),
            URLQueryItem(name: "from", value: "\(self.from)"),
            URLQueryItem(name: "count", value: "\(self.count)")
        ]
        return components.url
    }
    
    func getRecipe(ingredients: [String]){
        self.ingredients = ingredients
        self.from = 0
        recipeFacade.getRecipes(nextUrl: nextUrl, ingredients: ingredients){
            guard let recipes = $0 else { return }
            self.recipesVM = recipes.map{RecipeViewModel.init(recipe: $0)}
        }
    }
    
    func loadMore(ingredients: [String]){
        self.from += self.count
        recipeFacade.loadMore(nextUrl: nextUrl)
    }
    
    func updateFavorite(recipe: RecipeViewModel){
        recipeFacade.updateRecipe(recipe: recipe)
    }
    
    func getFavorites(){
        recipeFacade.getFavorites{
            guard let recipes = $0 else { return }
            self.recipesVM = recipes.map{RecipeViewModel.init(recipe: $0)}
        }
    }
}
