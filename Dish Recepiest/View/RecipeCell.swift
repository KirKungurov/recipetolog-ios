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
        
        recipeImage.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.size.equalTo(120).priority(999)
            ConstraintMaker.top.bottom.left.equalToSuperview().inset(10)
        }
        
        recipeName.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.top.equalToSuperview().inset(15)
            ConstraintMaker.left.equalTo(recipeImage.snp.right).offset(20)
            ConstraintMaker.right.equalToSuperview().inset(10)
            ConstraintMaker.height.equalTo(20)
        }
                
        recipeDescription.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.top.equalTo(recipeName).offset(15)
            ConstraintMaker.left.equalTo(recipeImage.snp.right).offset(20)
            ConstraintMaker.right.equalToSuperview().inset(10)
            ConstraintMaker.bottom.equalToSuperview().inset(15)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private var recipeName: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.label
        return label
    }()
    private var recipeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    private var recipeDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.label
        label.numberOfLines = 0
        return label
    }()
    
    private var recipeViewModel: RecipeViewModel?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        recipeImage.image = nil
        recipeImage.kf.cancelDownloadTask()
    }
    
    func setUp(with recipe: RecipeViewModel){
        recipeName.text = recipe.name.uppercased()
        recipeDescription.text = recipe.description
        recipeImage.kf.setImage(
            with: recipe.imageUrl
        )
    }
}
