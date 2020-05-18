//
//  RecepieFacade.swift
//  Dish Recepiest
//
//  Created by Kirill Kungurov on 12.05.2020.
//  Copyright © 2020 Kirill Kungurov. All rights reserved.
//
import Foundation

protocol RecipeFacade {
    typealias OnUpdateRecipes = ([DishInfo]?) -> Void
    func getRecipes(nextUrl: URL?, completion: @escaping OnUpdateRecipes)
}
