//
//  IngredientCell.swift
//  Dish Recepiest
//
//  Created by stanislav.milke on 21.05.2020.
//  Copyright © 2020 Kirill Kungurov. All rights reserved.
//

import UIKit

class IngredientCell: UICollectionViewCell {

    var removeAction: ((UIButton) -> Void)?
    
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var removeButton: UIButton! {
        didSet {
            removeButton.addTarget(self, action: #selector(removeButtonPressed(button:)), for: .touchUpInside)
        }
    }
    
    func setText(text: String?) {
        nameLabel.text = text
    }
    
    @objc private func removeButtonPressed(button: UIButton) {
        if (removeAction != nil) {
            removeAction!(button)
        }
    }
}
