//
//  IngredientCell.swift
//  Dish Recepiest
//
//  Created by stanislav.milke on 21.05.2020.
//  Copyright © 2020 Kirill Kungurov. All rights reserved.
//

import UIKit

class IngredientCell: UICollectionViewCell {

    private let buttonSize = 20
    
    var removeAction: ((UIButton) -> Void)?
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .center
        return label
    }()
    
    private let removeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = UIColor.white
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupSubviews() {
        contentView.addSubview(removeButton)
        contentView.addSubview(nameLabel)
        
        contentView.backgroundColor = UIColor.recipe_greenColor
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        nameLabel.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.equalToSuperview().inset(10)
            ConstraintMaker.centerY.equalToSuperview()
        }
        
        removeButton.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.size.equalTo(buttonSize).priority(999)
            ConstraintMaker.left.equalTo(nameLabel.snp.right).offset(8)
            ConstraintMaker.right.equalToSuperview().inset(6)
            ConstraintMaker.top.equalToSuperview().offset(6)
            ConstraintMaker.bottom.equalToSuperview().offset(-6)
        }
        
        removeButton.addTarget(self, action: #selector(removeButtonPressed(button:)), for: .touchUpInside)
    }
    
    func setText(text: String?) {
        nameLabel.text = text
        nameLabel.sizeToFit()
    }
    
    @objc private func removeButtonPressed(button: UIButton) {
        if (removeAction != nil) {
            removeAction!(button)
        }
    }
}
