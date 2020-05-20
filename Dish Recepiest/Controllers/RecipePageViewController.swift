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
    @IBOutlet private var recipeDescription: UILabel!
    @IBOutlet private var switchTextLabel: UILabel!
    
    @IBAction func `switch`(_ sender: UISwitch){
        if (sender.isOn == true) {
            switchTextLabel.text = self.recipe?.ingredients
        } else {
            switchTextLabel.text = self.recipe?.description

        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let recipe = self.recipe else { return }
        recipeDescription.text = recipe.description
        switchTextLabel.text = recipe.description
        recipeImage.kf.setImage(
            with: recipe.imageUrl)
    }
}
