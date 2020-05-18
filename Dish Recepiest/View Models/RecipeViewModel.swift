//
//  RecipeListViewModel.swift
//  Dish Recepiest
//
//  Created by Kirill Kungurov on 17.05.2020.
//  Copyright © 2020 Kirill Kungurov. All rights reserved.
//

import Foundation
import Kingfisher

struct RecipeViewModel {
    
    private var recipe: DishInfo
    
    init(recipe: DishInfo){
        self.recipe = recipe
    }
}

extension RecipeViewModel{
    public var label: String {
        self.recipe.label
    }
    
    public var image: URL? {
        guard let urlToImage = self.recipe.image else { return nil }
        return URL(string: urlToImage)
    }
    
    public var recipeUrl: URL? {
        URL(string: self.recipe.uri)
    }
    
    public var description: String{
        "Aaaaaaaaaaaaaaaaaaaaaaaa"
    }
    public var ingredients: String{
        recipe.ingredientLines.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines)
    }
    

    
}
