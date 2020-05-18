//
//  ViewControllerDataSource.swift
//  Dish Recepiest
//
//  Created by Kirill Kungurov on 18.05.2020.
//  Copyright © 2020 Kirill Kungurov. All rights reserved.
//

import UIKit
import PartyPicksVerticalFlowLayout

class ViewControllerDataSource : NSObject, UICollectionViewDataSource {
    
    private var source : [String] = [
        "Amsterdam 🇳🇱", "New York 🇺🇸", "London 🇬🇧", "Berlin 🇩🇪", "Barcelona 🇪🇸", "Lisbon 🇵🇹", "Rio de Janeiro 🇧🇷", "Sydney 🇦🇺", "Paris 🇫🇷", "São Paulo 🇧🇷",
        "Milan 🇮🇹", "Toronto 🇨🇦", "Bogotá 🇨🇴", "Moscow 🇷🇺", "San Francisco 🇺🇸", "Hague 🇳🇱", "Curitiba 🇧🇷", "Melbourne 🇦🇺", "Los Angeles 🇺🇸",
        "New Delhi 🇮🇳", "Vienna 🇦🇹", "Lyon 🇫🇷", "Singapore 🇸🇬", "Zürich 🇨🇭", "Maceió 🇧🇷", "Cairo 🇪🇬", "Rehovot 🇮🇱", "Chicago 🇺🇸",
        "Seoul 🇰🇷", "Taipei 🇹🇼", "Bruxelles 🇧🇪", "Shanghai 🇨🇳", "Marbella 🇪🇸", "Karachi 🇵🇰", "Istanbul 🇹🇷"
    ]
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let object = source[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.cellIdentifier, for: indexPath) as! CollectionCell
        cell.viewModel = CollectionCell.CollectionCellViewModel(title: object)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return source.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

// MARK: - Party Picks Flow Layout Delegate
extension ViewControllerDataSource : PartyPicksVerticalFlowLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, widthForCellAt indexPath: IndexPath, withHeight height: CGFloat) -> CGFloat {
        let object = source[indexPath.row]
        return cellWidthFor(text: object)
    }
    
    private func cellWidthFor(text: String) -> CGFloat {
        
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.text = text
        label.sizeToFit()
        
        var rect = label.intrinsicContentSize
        rect.width += 32 // Padding
        let newWidth = rect.width.rounded()
        
        return newWidth
    }
}
