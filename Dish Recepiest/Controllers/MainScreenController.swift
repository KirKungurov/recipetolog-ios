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
    
    private let recipeCellIdentifier: String = "RecipeCell"
    private let ingrCellIdentifier = "IngredientCell"
    private var ingredients = [String]()
    private var shownIndexPaths = [IndexPath]()
    
    private var topBarConstraint: Constraint?
    private var centerBarConstraint: Constraint?
    private var sidesInsetsBarConstraint: Constraint?
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
        didSet{
            DispatchQueue.main.async {
                self.recipesTable.reloadData()
            }
        }
    }
    
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
        bar.setPlacholderText(text: NSLocalizedString("WRITE_RECIPE", comment: ""))
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
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onRecipesChanged = { [unowned self] in
            self.recipesVM = $0
        }
        viewModel.reloadRecipes(ingredients: ingredientsFromBar())
        self.view.backgroundColor = UIColor.systemBackground
        view.addSubview(appNameLabel)
        view.addSubview(appDescriptionLabel)
        view.addSubview(searchBar)
        view.addSubview(searchTypeSwitch)
        view.addSubview(switchSearchTypeLabel)
        view.addSubview(recipesTable)
        
        setupConstraints()
        
        searchBar.addGestureRecognizer(closeBarRecognizer)
        closeBarRecognizer.addTarget(self, action: #selector(handleCloseGesture(gestureRecognizer:)))
        
        searchBar.setDelegate(delegate: self)
        recipesTable.delegate = self
        recipesTable.dataSource = self
        recipesTable.isHidden = true
        bottomLayoutConstraint = NSLayoutConstraint.init(item: view as Any, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        recipesTable.register(RecipeCell.self, forCellReuseIdentifier: recipeCellIdentifier)

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
            self.appNameLabel.alpha = k
            self.appDescriptionLabel.alpha = k
            self.switchSearchTypeLabel.alpha = k
            self.searchTypeSwitch.alpha = k
            break
        case .ended:
            if (gestureRecognizer.translation(in: searchBar).y > 40) {
                resignSearchBar(searchBar)
            } else {
                presentSearchBar(searchBar)
            }
            break
        default:
            break
        }
    }
    
    private func ingredientDidWrite() {
        guard let newIngredient = searchBar.text else { return }
        ingredients.append(newIngredient)
//        updateBarVisibility()
        viewModel.reloadRecipes(ingredients: ingredientsFromBar())
        searchBar.text = ""
    }
    
//    private func updateBarVisibility() {
//        if (ingredients.count > 0) {
//            barHeightConstraint.constant = 46
//        } else {
//            barHeightConstraint.constant = 0
//            shownIndexPaths = [IndexPath]()
//        }
//        UIView.animate(withDuration: 0.2) {
//            self.view.layoutIfNeeded()
//        }
//        self.addedInredientsBar.reloadData()
//    }
    
    private func ingredientsFromBar() -> String {
        let result = NSMutableString()
        for item in ingredients {
            result.append(item)
            result.append(",")
        }
        return result as String
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return searchBarIsActive ? .lightContent : .default
        }
    }
    
    private func presentSearchBar(_ searchBar: SearchBar) {
        centerBarConstraint?.deactivate()
        sidesInsetsBarConstraint?.deactivate()
        topBarConstraint?.activate()
        searchBarIsActive = true
        setNeedsStatusBarAppearanceUpdate()
        recipesTable.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.appNameLabel.alpha = 0
            self.appDescriptionLabel.alpha = 0
            self.switchSearchTypeLabel.alpha = 0
            self.searchTypeSwitch.alpha = 0
            self.recipesTable.alpha = 1
            searchBar.layer.cornerRadius = 0
        })
    }
    
    private func resignSearchBar(_ searchBar: SearchBar) {
        topBarConstraint?.deactivate()
        centerBarConstraint?.activate()
        sidesInsetsBarConstraint?.activate()
        searchBarIsActive = false
        setNeedsStatusBarAppearanceUpdate()
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.appNameLabel.alpha = 1
            self.appDescriptionLabel.alpha = 1
            self.switchSearchTypeLabel.alpha = 1
            self.searchTypeSwitch.alpha = 1
            self.recipesTable.alpha = 0
            searchBar.layer.cornerRadius = 10
        }) { (f) in
            self.recipesTable.isHidden = true
        }
    }
    
    @objc private func switchSearchType(check: UISwitch) {
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
            sidesInsetsBarConstraint = ConstraintMaker.left.right.equalTo(view.safeAreaLayoutGuide).inset(10).constraint
        }
        
        appDescriptionLabel.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.centerX.equalTo(searchBar)
            ConstraintMaker.bottom.equalTo(view.snp.centerY).offset(-60)
            ConstraintMaker.right.left.equalToSuperview().inset(20)
        }

        appNameLabel.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.centerX.equalTo(searchBar)
            ConstraintMaker.bottom.equalTo(appDescriptionLabel.snp.top).inset(-10)
            ConstraintMaker.right.left.equalToSuperview().inset(20)
        }

        searchTypeSwitch.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.top.equalTo(view.snp.centerY).offset(40)
            ConstraintMaker.right.equalTo(view.safeAreaLayoutGuide).inset(20)
        }

        switchSearchTypeLabel.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.right.equalTo(searchTypeSwitch.snp.left).inset(20)
            ConstraintMaker.height.centerY.equalTo(searchTypeSwitch)
            ConstraintMaker.left.equalTo(view.safeAreaLayoutGuide).inset(20)
        }

        recipesTable.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.bottom.equalToSuperview()
            ConstraintMaker.left.right.equalTo(view.safeAreaLayoutGuide)
            ConstraintMaker.top.equalTo(self.searchBar.snp.bottom)
        }
    }
}

//MARK: - SearchBarDelegate
extension MainScreenController: SearchBarDelegate {
    func searchBarButtonDidTouch(_ searchBar: SearchBar) {
        ingredientDidWrite()
//        resignSearchBar(searchBar)
    }
    
    func searchBarDidEndEditing(_ searchBar: SearchBar) {
        ingredientDidWrite()
//        resignSearchBar(searchBar)
    }
    
    func searchBarWillBeginEditing(_ searchBar: SearchBar) {
        presentSearchBar(searchBar)
    }
}

//// MARK: - UICollectionViewDelegate
//extension RecipeListTableViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        guard !shownIndexPaths.contains(indexPath) else { return }
//        shownIndexPaths.append(indexPath)
//        cell.transform = cell.transform.scaledBy(x: 0.5, y: 0.5)
//        cell.alpha = 0
//        UIView.animate(withDuration: 0.1) {
//            cell.alpha = 1
//            cell.transform = CGAffineTransform.identity
//        }
//    }
//}
//
//extension RecipeListTableViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return ingredients.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ingrCellIdentifier, for: indexPath) as? IngredientCell else { fatalError("CollectionView wasn't configured") }
//        let position = indexPath.row
//        cell.setText(text: ingredients[position])
//        cell.removeAction = { [unowned self] button in
//            self.ingredients.remove(at: position)
//            self.updateBarVisibility()
//            self.viewModel.reloadRecipes(ingredients: self.ingredientsFromBar())
//        }
//        return cell
//    }
//}

// MARK: - UITableViewDataSource
extension MainScreenController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipesVM.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let recipeCell = tableView.dequeueReusableCell(withIdentifier: recipeCellIdentifier, for: indexPath) as? RecipeCell else{
            fatalError("TableView wasn't configured")
        }
        recipeCell.setUp(with: recipesVM[indexPath.row])
        return recipeCell
    }
}

// MARK: - UITableViewDelegate
extension MainScreenController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == recipesVM.count - 1 else { return }
        viewModel.loadMore()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let recipePageViewController = UIStoryboard(name: "RecipePage", bundle: nil)
            .instantiateViewController(withIdentifier: "RecipePageViewController") as? RecipePageViewController else { return }
        recipePageViewController.recipe = recipesVM[indexPath.row]
        recipePageViewController.title = recipesVM[indexPath.row].name
        navigationController?.pushViewController(recipePageViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - KeyboardAdditions

extension MainScreenController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

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
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
