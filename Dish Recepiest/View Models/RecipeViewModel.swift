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
    
    private var recipe: RecipeInfo
    
    init(recipe: RecipeInfo){
        self.recipe = recipe
    }
}

extension RecipeViewModel{
    public var name: String {
        recipe.name
    }
    
    public var imageUrl: URL? {
        guard let urlToImage = recipe.imageUrl else { return nil }
        return URL(string: urlToImage)
    }
    
//    public var recipeUrl: URL? {
//        URL(string: self.recipe.)
//    }
    
    public var description: String{
        return recipe.description
    }
    public var ingredients: String{
        return "aaa"
//        recipe.ingredientLines.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines)
    }
    

    
}
