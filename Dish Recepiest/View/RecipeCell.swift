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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(recipeName)
        addSubview(recipeImage)
        addSubview(recipeDescription)
        addSubview(favoriteButton)
        
        recipeName.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.top.equalToSuperview().inset(10)
            ConstraintMaker.left.equalToSuperview().inset(10)
            ConstraintMaker.height.equalTo(20)
        }
          
        favoriteButton.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.top.bottom.equalTo(recipeName)
            ConstraintMaker.width.equalTo(favoriteButton.snp.height)
            ConstraintMaker.left.equalTo(recipeName.snp.right).inset(4)
            ConstraintMaker.right.equalToSuperview().inset(10)
        }
        
        recipeImage.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.size.equalTo(120).priority(999)
            ConstraintMaker.top.equalTo(recipeName.snp.bottom).offset(10)
            ConstraintMaker.bottom.left.equalToSuperview().inset(10)
        }
        
        recipeDescription.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.top.equalTo(recipeImage)
            ConstraintMaker.left.equalTo(recipeImage.snp.right).offset(10)
            ConstraintMaker.right.equalToSuperview().inset(10)
            ConstraintMaker.bottom.equalToSuperview().inset(15)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private let recipeName: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.label
        return label
    }()
    private let recipeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    private let recipeDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.label
        label.numberOfLines = 0
        return label
    }()
    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor.systemRed
        return button
    }()
    
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
        } else {
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
