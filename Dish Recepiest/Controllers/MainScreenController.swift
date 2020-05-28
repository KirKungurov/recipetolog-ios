//
//  MainScreenController.swift
//  Dish Recepiest
//
//  Created by stanislav.milke on 24.05.2020.
//  Copyright © 2020 Kirill Kungurov. All rights reserved.
//

import UIKit
import SnapKit

class MainScreenController: UIViewController {
    
    let ingredientCollectionHeight = 48
    let sideInset = 20
    let barSideInset = 10

    private let recipeCellIdentifier: String = "RecipeCell"
    private let ingrCellIdentifier = "IngredientCell"
    private var ingredients = [String]()
    private var tmpIngredients = [String]()
    
    private var topBarConstraint: Constraint?
    private var centerBarConstraint: Constraint?
    private var sidesInsetsBarConstraint: Constraint?
    private var ingredientsCollectionConstraint: Constraint?
    private var bottomLayoutConstraint: NSLayoutConstraint?
    private var searchBarIsActive: Bool = false
    
    private let closeBarRecognizer: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer()
        recognizer.maximumNumberOfTouches = 2
        recognizer.minimumNumberOfTouches = 1
        return recognizer
    }()
    
    var viewModel: RecipeListViewModel!
    
    private var recipesVM = [RecipeViewModel](){
        didSet {
            DispatchQueue.main.async {
                self.recipesTable.reloadData()
                UIView.transition(with: self.recipesTable, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    if (self.recipesVM.count != 0) {
                        self.tablePlaceholder?.isHidden = true
                        self.recipesTable.separatorStyle = .singleLine
                    } else {
                        self.tablePlaceholder?.isHidden = false
                        self.recipesTable.separatorStyle = .none
                        if (self.ingredients.isEmpty) {
                            self.tablePlaceholderSetText?(nil)
                        } else {
                            self.tablePlaceholderSetText?(NSLocalizedString("TEXT_PLACEHOLDER_NOT_FOUND", comment: ""))
                        }
                    }
                })
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return searchBarIsActive ? .lightContent : .default
        }
    }
    
    private var tablePlaceholder: UIView?
    private var tablePlaceholderSetText: ((String?) -> Void)?
    
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("RECIPETOLOG", comment: "")
        label.font = UIFont.boldSystemFont(ofSize: 42)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = UIColor.label
        return label
    }()
    
    private let appDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("APP_DESCRIPRION", comment: "")
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = UIColor.label
        return label
    }()
    
    private let searchBar: SearchBar = {
        let bar = SearchBar()
        bar.setButtonBackgroundImage(image: UIImage.init(systemName: "plus"))
        bar.setPlacholderText(text: NSLocalizedString("WRITE_INGREDIENT", comment: ""))
        return bar
    }()
    
    private let searchTypeSwitch: UISwitch = {
        let button = UISwitch()
        button.onTintColor = UIColor.recipe_greenColor
        button.addTarget(self, action: #selector(switchSearchType(check:)), for: .valueChanged)
        return button
    }()
    
    private let switchSearchTypeLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("INGREDIENT_SEARCH", comment: "")
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = UIColor.label
        return label
    }()
    
    private let recipesTable: UITableView = {
        let tableView = UITableView()
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    private let ingredientsCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 0)
        layout.estimatedItemSize = CGSize(width: 80, height: 32)
        layout.itemSize = UICollectionViewFlowLayout.automaticSize

        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.backgroundColor = UIColor.systemBackground
        collection.collectionViewLayout = layout
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onRecipesChanged = { [unowned self] in
            self.recipesVM = $0
        }
        viewModel.getRecipe(ingredients: ingredients)
        self.view.backgroundColor = UIColor.systemBackground
        view.addSubview(appNameLabel)
        view.addSubview(appDescriptionLabel)
        view.addSubview(searchBar)
        view.addSubview(searchTypeSwitch)
        view.addSubview(switchSearchTypeLabel)
        view.addSubview(recipesTable)
        view.addSubview(ingredientsCollection)

        setupConstraints()
        
        searchBar.addGestureRecognizer(closeBarRecognizer)
        closeBarRecognizer.addTarget(self, action: #selector(handleCloseGesture(gestureRecognizer:)))
        searchBar.setDelegate(delegate: self)
        
        recipesTable.delegate = self
        recipesTable.dataSource = self
        recipesTable.isHidden = true
        recipesTable.register(RecipeCell.self, forCellReuseIdentifier: recipeCellIdentifier)
        
        ingredientsCollection.dataSource = self
        ingredientsCollection.isHidden = true
        ingredientsCollection.register(IngredientCell.self, forCellWithReuseIdentifier: ingrCellIdentifier)

        setupPlaceholder()
        recipesTable.backgroundView = tablePlaceholder
        recipesTable.separatorStyle = .none
        
        searchTypeSwitch.isHidden = true
        switchSearchTypeLabel.isHidden = true
        
        bottomLayoutConstraint = NSLayoutConstraint.init(item: view as Any, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
    }
    
    private func setupPlaceholder() {
        let view = UIView()
        let imgView = UIImageView()
        let label = UILabel()
        
        view.addSubview(imgView)
        view.addSubview(label)
        
        let image = UIImage(named: "placeholder_logo")
        imgView.image = image
        imgView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.size.lessThanOrEqualTo(250)
            ConstraintMaker.centerX.equalToSuperview()
            ConstraintMaker.top.equalTo(view.safeAreaInsets)
        }
                
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textColor = UIColor.label
        label.textAlignment = .center
        label.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.width.equalToSuperview().multipliedBy(0.95)
            ConstraintMaker.centerX.equalToSuperview()
            ConstraintMaker.top.equalTo(imgView.snp.bottom).offset(-20)
        }
        
        tablePlaceholderSetText = { [unowned label] text in
            if (text != nil) {
                label.text = text
            } else {
                label.text = NSLocalizedString("TEXT_PLACEHOLDER_" + String(Int.random(in: 1...5)), comment: "")
            }
        }
        tablePlaceholder = view
    }
    
    @objc private func handleCloseGesture(gestureRecognizer: UIPanGestureRecognizer) {
        guard (!(sidesInsetsBarConstraint?.isActive ?? true)) else { return }
        switch gestureRecognizer.state {
        case .began:
            searchBar.resignFirstResponder()
            break
        case .changed:
            searchBar.layer.cornerRadius = min(max(gestureRecognizer.translation(in: searchBar).y / 8, 0), 10)
            let k = min(max(gestureRecognizer.translation(in: searchBar).y / 80, 0), 1)
            recipesTable.alpha = 1 - k
            tablePlaceholder?.alpha = 1 - k
            ingredientsCollection.alpha = 1 - k
            appNameLabel.alpha = k
            appDescriptionLabel.alpha = k
            switchSearchTypeLabel.alpha = k
            searchTypeSwitch.alpha = k
            break
        case .ended:
            if (gestureRecognizer.translation(in: searchBar).y > 40) {
                dismissSearchBar(searchBar)
            } else {
                presentSearchBar(searchBar)
            }
            break
        default:
            break
        }
    }
    
    @objc func showFavoritesToggle() {
        if (viewModel.isBookmarksLoad) {
            ingredients = tmpIngredients
            tmpIngredients = []
            ingredientsCollectionConstraint?.update(offset: ingredientCollectionHeight)
            viewModel.getRecipe(ingredients: ingredients)
        } else {
            tmpIngredients = ingredients
            ingredients = []
            ingredientsCollectionConstraint?.update(offset: 0)
            viewModel.getFavorites()
        }
        viewModel.isBookmarksLoad = !viewModel.isBookmarksLoad
        searchBar.text = ""
        searchBar.setButtonBackgroundImage(image: UIImage.init(systemName: viewModel.isBookmarksLoad ? "heart.fill" : "heart"))
    }
    
    private func ingredientDidWrite() {
        guard let newIngredient = searchBar.text?.lowercased() else { return }
        if (newIngredient.trimmingCharacters(in: .whitespacesAndNewlines).trimmingCharacters(in: .punctuationCharacters).count > 1 && !ingredients.contains(newIngredient)) {
            ingredients.append(newIngredient)
            ingredientsCollection.reloadData()
            viewModel.getRecipe(ingredients: ingredients)
        }
        searchBar.text = ""
    }
    
    private func presentSearchBar(_ searchBar: SearchBar) {
        centerBarConstraint?.deactivate()
        sidesInsetsBarConstraint?.deactivate()
        topBarConstraint?.activate()
        searchBarIsActive = true
        setNeedsStatusBarAppearanceUpdate()
        recipesTable.isHidden = false
        ingredientsCollection.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.appNameLabel.alpha = 0
            self.appDescriptionLabel.alpha = 0
            self.switchSearchTypeLabel.alpha = 0
            self.searchTypeSwitch.alpha = 0
            self.recipesTable.alpha = 1
            self.tablePlaceholder?.alpha = 1
            self.ingredientsCollection.alpha = 1
            searchBar.layer.cornerRadius = 0
        })
    }
    
    private func dismissSearchBar(_ searchBar: SearchBar) {
        topBarConstraint?.deactivate()
        centerBarConstraint?.activate()
        sidesInsetsBarConstraint?.activate()
        searchBar.setButtonBackgroundImage(image: UIImage.init(systemName: "plus"))
        searchBarIsActive = false
        setNeedsStatusBarAppearanceUpdate()
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.appNameLabel.alpha = 1
            self.appDescriptionLabel.alpha = 1
            self.switchSearchTypeLabel.alpha = 1
            self.searchTypeSwitch.alpha = 1
            self.recipesTable.alpha = 0
            self.tablePlaceholder?.alpha = 0
            self.ingredientsCollection.alpha = 0
            searchBar.layer.cornerRadius = 10
        }) { (f) in
            self.recipesTable.isHidden = true
            self.ingredientsCollection.isHidden = true
        }
    }
    
    @objc private func switchSearchType(check: UISwitch) {
        ingredients = []
        ingredientsCollection.reloadData()
        recipesTable.reloadData()
        if (check.isOn) {
            searchBar.setPlacholderText(text: NSLocalizedString("WRITE_INGREDIENT", comment: ""))
        } else {
            searchBar.setPlacholderText(text: NSLocalizedString("WRITE_RECIPE", comment: ""))
        }
    }
}

//MARK: - Setup constraints
extension MainScreenController {
    private func setupConstraints() {
        searchBar.snp.makeConstraints { (ConstraintMaker) in
            topBarConstraint = ConstraintMaker.top.left.right.equalToSuperview().constraint
        }
        
        topBarConstraint?.deactivate()
        searchBar.snp.makeConstraints { (ConstraintMaker) in
            centerBarConstraint = ConstraintMaker.center.equalToSuperview().constraint
            sidesInsetsBarConstraint = ConstraintMaker.left.right.equalTo(view.safeAreaLayoutGuide).inset(barSideInset).constraint
        }
        
        appDescriptionLabel.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.centerX.equalTo(searchBar)
            ConstraintMaker.bottom.equalTo(view.snp.centerY).offset(-60)
            ConstraintMaker.right.left.equalToSuperview().inset(sideInset)
        }

        appNameLabel.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.centerX.equalTo(searchBar)
            ConstraintMaker.bottom.equalTo(appDescriptionLabel.snp.top).inset(-10)
            ConstraintMaker.right.left.equalToSuperview().inset(sideInset)
        }

        searchTypeSwitch.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.top.equalTo(view.snp.centerY).offset(40)
            ConstraintMaker.right.equalTo(view.safeAreaLayoutGuide).inset(sideInset)
        }

        switchSearchTypeLabel.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.right.equalTo(searchTypeSwitch.snp.left).inset(sideInset)
            ConstraintMaker.height.centerY.equalTo(searchTypeSwitch)
            ConstraintMaker.left.equalTo(view.safeAreaLayoutGuide).inset(sideInset)
        }
        
        ingredientsCollection.snp.makeConstraints { (ConstraintMaker) in
            ingredientsCollectionConstraint = ConstraintMaker.height.equalTo(ingredientCollectionHeight).constraint
            ConstraintMaker.left.right.equalTo(view.safeAreaLayoutGuide)
            ConstraintMaker.top.equalTo(searchBar.snp.bottom)
        }
        
        recipesTable.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.bottom.equalToSuperview()
            ConstraintMaker.left.right.equalTo(view.safeAreaLayoutGuide)
            ConstraintMaker.top.equalTo(ingredientsCollection.snp.bottom)
        }
    }
}

//MARK: - SearchBarDelegate
extension MainScreenController: SearchBarDelegate {
    func searchBarButtonDidTouch(_ searchBar: SearchBar) {
        if (searchBar.isFirstResponder) {
            ingredientDidWrite()
        } else {
            showFavoritesToggle()
        }
    }
    
    func searchBarDidEndEditing(_ searchBar: SearchBar) {
        searchBar.setButtonBackgroundImage(image: UIImage.init(systemName: viewModel.isBookmarksLoad ? "heart.fill" : "heart"))
    }
    
    func searchBarWillBeginEditing(_ searchBar: SearchBar) {
        searchBar.setButtonBackgroundImage(image: UIImage.init(systemName: "plus"))
        presentSearchBar(searchBar)
    }
}

// MARK: - UICollectionViewDataSource
extension MainScreenController: UICollectionViewDataSource {
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ingredients.count
    }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ingrCellIdentifier, for: indexPath) as? IngredientCell else { fatalError("CollectionView wasn't configured") }
        let position = indexPath.row
        cell.setText(text: ingredients[position])
        cell.removeAction = { [unowned self] button in
            self.ingredients.remove(at: position)
            self.ingredientsCollection.reloadData()
            self.viewModel.getRecipe(ingredients: self.ingredients)
        }
        return cell
    }
}

// MARK: - UITableViewDataSource
extension MainScreenController: UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipesVM.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let recipeCell = tableView.dequeueReusableCell(withIdentifier: recipeCellIdentifier, for: indexPath) as? RecipeCell else{
            fatalError("TableView wasn't configured")
        }
        recipeCell.setUp(with: recipesVM[indexPath.row])
        recipeCell.updateFavorite = { [unowned self] sender in
            self.viewModel.updateFavorite(recipe: self.recipesVM[indexPath.row])
        }
        return recipeCell
    }
}

// MARK: - UITableViewDelegate
extension MainScreenController: UITableViewDelegate {
    internal func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == recipesVM.count - 1 else { return }
        viewModel.loadMore(ingredients: ingredients)
    }
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipeViewController = RecipeViewController()
        tableView.deselectRow(at: indexPath, animated: true)
        recipeViewController.setupWithViewModel(recipesVM[indexPath.row])
        recipeViewController.title = recipesVM[indexPath.row].name.uppercased()
        navigationController?.pushViewController(recipeViewController, animated: true)
    }
}

//MARK: - KeyboardAdditions
extension MainScreenController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        NotificationCenter.default.addObserver(self,
                                       selector: #selector(self.keyboardWillShowNotification(_:)),
                                       name: UIResponder.keyboardWillShowNotification,
                                       object: nil)
        NotificationCenter.default.addObserver(self,
                                       selector: #selector(self.keyboardWillHideNotification(_:)),
                                       name: UIResponder.keyboardWillHideNotification,
                                       object: nil)
    }

    @objc func keyboardWillShowNotification(_ notification: NSNotification) {
        updateBottomLayoutConstraintWithNotification(notification)
    }

    @objc func keyboardWillHideNotification(_ notification: NSNotification) {
        updateBottomLayoutConstraintWithNotification(notification)
    }

    func updateBottomLayoutConstraintWithNotification(_ notification: NSNotification) {
        let userInfo = notification.userInfo!

        let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let keyboardEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let convertedKeyboardEndFrame = view.convert(keyboardEndFrame, from: view.window)
        let rawAnimationCurve = (notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).uint32Value << 16
        let animationCurve = UIView.AnimationOptions(rawValue: UInt(rawAnimationCurve))

        if let constr = bottomLayoutConstraint {
            constr.constant = view.bounds.maxY - convertedKeyboardEndFrame.minY
        }

        UIView.animate(withDuration: animationDuration,
                       delay: 0.0,
                       options: [.beginFromCurrentState, animationCurve],
                       animations: {
                self.view.layoutIfNeeded()
            },
                       completion: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
