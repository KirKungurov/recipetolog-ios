//
//  RecipePageViewController.swift
//  Dish Recepiest
//
//  Created by Kirill Kungurov on 18.05.2020.
//  Copyright © 2020 Kirill Kungurov. All rights reserved.
//

import UIKit
import SnapKit

class RecipeViewController: UIViewController {
    var recipe: RecipeViewModel?
    
    private let recipeImage: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.layer.cornerRadius = 10
        return img
    }()
    
    private let recipeDescription: UITextView = {
        let text = UITextView()
        
        return text
    }()
    
    private let recipeText: UITextView = {
        let text = UITextView()
        
        return text
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.insertSegment(withTitle: NSLocalizedString("RECIPE", comment: ""), at: 0, animated: false)
        segment.insertSegment(withTitle: NSLocalizedString("INGREDIENTS", comment: ""), at: 1, animated: false)
        
        return segment
    }()
    
    private let scrollView: UIScrollView = {
        let scr = UIScrollView()
        return scr
    }()
        
    func segmentedChanged(_ sender: UISegmentedControl){
        if (sender.selectedSegmentIndex == 0) {
            recipeText.text = self.recipe!.directions
        } else if (sender.selectedSegmentIndex == 1) {
            recipeText.text = self.recipe!.ingredients
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        scrollView.addSubview(recipeText)
        scrollView.addSubview(recipeDescription)
        scrollView.addSubview(segmentedControl)
        scrollView.addSubview(recipeImage)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.edges.equalToSuperview()
        }
        
        recipeImage.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.width.equalTo(recipeImage.snp.height)
            ConstraintMaker.left.top.right.equalToSuperview().inset(20)
        }
        
        recipeDescription.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.right.equalToSuperview().inset(10)
            ConstraintMaker.top.equalTo(recipeImage).offset(20)
        }
        
        segmentedControl.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.right.equalToSuperview().inset(10)
            ConstraintMaker.top.equalTo(recipeDescription.snp.bottom).offset(5)
            ConstraintMaker.height.equalTo(40)
        }
        
        recipeText.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.right.equalToSuperview().inset(10)
            ConstraintMaker.top.equalTo(segmentedControl.snp.bottom).offset(5)
            ConstraintMaker.bottom.equalToSuperview()
        }
    }
    
    func setupWithRecipe(_ recipe: Recipe) {
        guard let recipe = self.recipe else { return }
        recipeDescription.text = recipe.description
        recipeText.text = recipe.directions
        recipeImage.kf.setImage(with: recipe.imageUrl)
    }
}
