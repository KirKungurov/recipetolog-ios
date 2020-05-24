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
    @IBOutlet private var favoriteButton: UIButton!
    @IBOutlet private var recipeImage: UIImageView!
    @IBOutlet private var recipeDescription: UILabel!
    
    private var recipeViewModel: RecipeViewModel?
    
    var updateFavorite: ((UIButton) -> Void)?

    override func prepareForReuse() {
        super.prepareForReuse()
        recipeImage.image = nil
        recipeImage.kf.cancelDownloadTask()
    }
    
    func setUp(with recipe: RecipeViewModel){
        recipeImage.image = nil
        recipeViewModel = recipe
        recipeName.text = recipe.name.uppercased()
        if recipe.isBookmark {
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else{
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        recipeDescription.text = recipe.description
        favoriteButton.addTarget(self, action: #selector(addToFavorites(sender:)), for: .touchUpInside)
        recipeImage.kf.setImage(
            with: recipe.imageUrl
        )
    }
    
    @objc func addToFavorites(sender: UIButton) {
        guard let recipeVM = recipeViewModel else { return }
        if recipeVM.isBookmark {
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
            updateFavorite!(sender)
            return
        }
        sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        updateFavorite!(sender)
    }
}
