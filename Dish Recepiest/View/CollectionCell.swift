//
//  CollectionCell.swift
//  Dish Recepiest
//
//  Created by Kirill Kungurov on 18.05.2020.
//  Copyright © 2020 Kirill Kungurov. All rights reserved.
//
import UIKit

class CollectionCell : UICollectionViewCell {
    
    static let cellIdentifier : String = "cell"
    
    @IBOutlet weak private var title : UILabel!
    
    var viewModel : CollectionCellViewModel? { didSet {
        title.text = viewModel?.title
        }}
}

extension CollectionCell {
    struct CollectionCellViewModel {
        var title : String = ""
        init(title: String) {
            self.title = title
        }
    }
}
