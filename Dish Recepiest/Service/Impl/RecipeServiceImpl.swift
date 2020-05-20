//
//  RecipeServiceImpl.swift
//  Dish Recepiest
//
//  Created by Kirill Kungurov on 12.05.2020.
//  Copyright © 2020 Kirill Kungurov. All rights reserved.
//

import Foundation

final class RecipeServiceImpl: RecipeService{
    func getRecipes(nextUrl: URL?, completion: @escaping RecipesCompletion) {
        guard let url = nextUrl else {
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            let response = try? JSONDecoder().decode(Response<RecipeContainer>.self, from: data)
            completion(response?.recipes)
        }
        .resume()
    }
}
