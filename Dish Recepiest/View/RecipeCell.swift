//
//  RecipeCell.swift
//  Dish Recepiest
//
//  Created by Kirill Kungurov on 18.05.2020.
//  Copyright © 2020 Kirill Kungurov. All rights reserved.
//

import UIKit
import Kingfisher

class RecipeCell: UITableViewCell{
    
    @IBOutlet private var recipeName: UILabel!
    @IBOutlet private var recipeImage: UIImageView!
    @IBOutlet private var recipeDescription: UILabel!
    
    private var recipeViewModel: RecipeViewModel?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        recipeImage.image = nil
        recipeImage.kf.cancelDownloadTask()
    }
    
    func setUp(with recipe: RecipeViewModel){
        recipeName.text = recipe.name
        recipeDescription.text = recipe.description
        recipeImage.kf.setImage(
            with: recipe.imageUrl
        )
        
    }
}
