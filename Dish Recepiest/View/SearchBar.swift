//
//  SearchBar.swift
//  Dish Recepiest
//
//  Created by stanislav.milke on 24.05.2020.
//  Copyright © 2020 Kirill Kungurov. All rights reserved.
//

import UIKit

class SearchBar: UIView {
    private let field = UITextField()
    private let button = UIButton()
    private var delegate: SearchBarDelegate?
    
    var text: String? {
        set {
            self.field.text = newValue
        }
        get {
            return self.field.text
        }
    }
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(field)
        addSubview(button)
        field.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.leading.equalTo(safeAreaLayoutGuide).inset(10)
            ConstraintMaker.top.bottom.equalTo(safeAreaLayoutGuide)
            ConstraintMaker.height.equalTo(40)
        }
        button.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.trailing.equalTo(safeAreaLayoutGuide).inset(10)
            ConstraintMaker.leading.equalTo(field.snp.trailing).inset(10)
            ConstraintMaker.centerY.equalTo(field)
            ConstraintMaker.size.equalTo(24)
        }
        snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.height.greaterThanOrEqualTo(40)
        }
        button.addTarget(self, action: #selector(buttonTouch(button:)), for: .touchUpInside)
        button.tintColor = UIColor.white
        backgroundColor = UIColor.recipe_greenColor
        layer.cornerRadius = 10
        field.delegate = self
        field.textColor = UIColor.white
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setButtonBackgroundImage(image: UIImage?) {
        button.setBackgroundImage(image, for: .normal)
    }
    
    func setDelegate(delegate: SearchBarDelegate?) {
        self.delegate = delegate
    }
    
    func setPlacholderText(text: String) {
        self.field.attributedPlaceholder = NSAttributedString.init(string: text, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
    }
    
    @discardableResult override func resignFirstResponder() -> Bool {
        return field.resignFirstResponder()
    }
}

//MARK: - SearchBarDelegate linkers
extension SearchBar: UITextFieldDelegate {
    @objc func buttonTouch(button: UIButton) {
        if (delegate != nil) {
            resignFirstResponder()
            delegate?.searchBarButtonDidTouch(self)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (delegate != nil) {
            resignFirstResponder()
            delegate?.searchBarDidEndEditing(self)
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (delegate != nil) {
            delegate?.searchBarWillBeginEditing(self)
        }
        return true
    }
}

@objc protocol SearchBarDelegate {
    func searchBarButtonDidTouch(_ searchBar: SearchBar)
    func searchBarDidEndEditing(_ searchBar: SearchBar)
    func searchBarWillBeginEditing(_ searchBar: SearchBar)
}
