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
    
    private var recipe: Recipe
    
    init(recipe: Recipe){
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
    
    public var source: URL? {
        guard let source = recipe.source else { return nil }
        return URL(string: source)
    }
    
    public var description: String{
        recipe.recipeDescription
    }

    public var ingredients: String{
        var ingredients = [String]()
        for ingredient in recipe.ingredients{
            let tmp = "- " + ingredient.ingredient!.name + ": " + ingredient.amount
            ingredients.append(tmp)
        }
        return ingredients.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    //Костыль
    public var directions: String{
        recipe.directions.joined(separator: "\n-").trimmingCharacters(in: .whitespacesAndNewlines)
    }
    

    
}
