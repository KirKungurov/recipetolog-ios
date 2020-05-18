//
//  RecipePageViewController.swift
//  Dish Recepiest
//
//  Created by Kirill Kungurov on 18.05.2020.
//  Copyright © 2020 Kirill Kungurov. All rights reserved.
//

import UIKit

class RecipePageViewController: UIViewController{
    var recipe: RecipeViewModel?
    
    @IBOutlet private var recipeImage: UIImageView!
    @IBOutlet private var recipeName: UILabel!
    @IBOutlet private var recipeDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let recipe = self.recipe else { return }
        recipeName.text = recipe.label
        recipeDescription.text = recipe.description
        recipeImage.kf.setImage(
            with: recipe.image)
    }
}
