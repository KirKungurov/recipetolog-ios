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
        text.font = UIFont.systemFont(ofSize: 14)
        text.textColor = UIColor.label
        text.isEditable = false
        return text
    }()
    
    private let recipeTextView: UITextView = {
        let text = UITextView()
        text.font = UIFont.systemFont(ofSize: 14)
        text.textColor = UIColor.label
        text.isEditable = false

        return text
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.insertSegment(withTitle: NSLocalizedString("RECIPE", comment: ""), at: 0, animated: false)
        segment.insertSegment(withTitle: NSLocalizedString("INGREDIENTS", comment: ""), at: 1, animated: false)
        
        return segment
    }()
        
    @objc private func segmentedChanged(_ sender: UISegmentedControl){
        recipeTextView.setContentOffset(CGPoint.zero, animated: false)
        if (sender.selectedSegmentIndex == 0) {
            recipeTextView.text = self.recipe?.directions
        } else if (sender.selectedSegmentIndex == 1) {
            recipeTextView.text = self.recipe?.ingredients
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemBackground
        view.addSubview(recipeTextView)
        view.addSubview(recipeDescription)
        view.addSubview(segmentedControl)
        view.addSubview(recipeImage)
        
        segmentedControl.addTarget(self, action: #selector(segmentedChanged(_:)), for: .valueChanged)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        recipeTextView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.right.equalTo(view.safeAreaLayoutGuide).inset(10)
            ConstraintMaker.bottom.equalTo(view.safeAreaLayoutGuide)
            ConstraintMaker.height.greaterThanOrEqualTo(150)
        }
        
        segmentedControl.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.right.equalTo(view.safeAreaLayoutGuide).inset(10)
            ConstraintMaker.bottom.equalTo(recipeTextView.snp.top).offset(-5)
            ConstraintMaker.height.equalTo(30)
        }
        
        recipeDescription.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.right.equalTo(view.safeAreaLayoutGuide).inset(10)
            ConstraintMaker.bottom.equalTo(segmentedControl.snp.top).offset(-5)
            ConstraintMaker.height.equalTo(80)
        }
        
        recipeImage.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.height.equalTo(recipeImage.snp.width).priority(999)
            ConstraintMaker.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            ConstraintMaker.centerX.equalToSuperview()
            ConstraintMaker.bottom.equalTo(recipeDescription.snp.top).offset(-10)
        }
    }
    
    func setupWithViewModel(_ vm: RecipeViewModel) {
        recipe = vm
        segmentedControl.selectedSegmentIndex = 0
        recipeDescription.text = vm.description
        recipeTextView.text = vm.directions
        recipeDescription.setContentOffset(CGPoint.zero, animated: false)
        recipeTextView.setContentOffset(CGPoint.zero, animated: false)
        recipeImage.kf.setImage(with: vm.imageUrl)
    }
}
