//
//  RecipeListTableViewController.swift
//  Dish Recepiest
//
//  Created by Kirill Kungurov on 17.05.2020.
//  Copyright © 2020 Kirill Kungurov. All rights reserved.
//

import UIKit

class RecipeListTableViewController: UIViewController{
 
    private var recipesVM = [RecipeViewModel](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private let recipeCellIdentifier = "RecipeCell"
    private let ingrCellIdentifier = "IngredientCell"
    private var ingredients = [String]()
    private var shownIndexPaths = [IndexPath]()
    
    var viewModel: RecipeListViewModel!
    
    @IBOutlet private var addedInredientsBar: UICollectionView!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var addIngredientButton: UIButton!
    @IBOutlet private var ingredientsTextField: UITextField!
    @IBOutlet private var barHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientsTextField.placeholder = NSLocalizedString("WRITE_INGREDIENT", comment: "")
        barHeightConstraint.constant = 0
        viewModel.onRecipesChanged = { [unowned self] in
            self.recipesVM = $0
        }
        viewModel.getRecipe(ingredients: self.ingredients)
        addIngredientButton.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
    }
    
    @objc func buttonTapped(sender: UIView) {
        guard let newIngredient = ingredientsTextField.text else { return }
        //костыль, надо пофиксить
        if newIngredient.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .punctuationCharacters).count == 0 { return}
        ingredients.append(newIngredient.trimmingCharacters(in: .whitespacesAndNewlines).trimmingCharacters(in: .punctuationCharacters))
        updateBarVisibility()
        viewModel.getRecipe(ingredients: self.ingredients)
        ingredientsTextField.text = ""
        ingredientsTextField.resignFirstResponder();
    }
    
    private func updateBarVisibility() {
        if (ingredients.count > 0) {
            barHeightConstraint.constant = 46
        } else {
            barHeightConstraint.constant = 0
            shownIndexPaths = [IndexPath]()
        }
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        self.addedInredientsBar.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension RecipeListTableViewController: UITableViewDataSource{
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
extension RecipeListTableViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == recipesVM.count - 1 else { return }
        viewModel.loadMore(ingredients: self.ingredients)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let RecipePageViewController = UIStoryboard(name: "RecipePage", bundle: nil)
            .instantiateViewController(withIdentifier: "RecipePageViewController") as? RecipeViewController else { return }
        RecipePageViewController.recipe = recipesVM[indexPath.row]
        RecipePageViewController.title = recipesVM[indexPath.row].name
        navigationController?.pushViewController(RecipePageViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UICollectionViewDelegate
extension RecipeListTableViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard !shownIndexPaths.contains(indexPath) else { return }
        shownIndexPaths.append(indexPath)
        cell.transform = cell.transform.scaledBy(x: 0.5, y: 0.5)
        cell.alpha = 0
        UIView.animate(withDuration: 0.1) {
            cell.alpha = 1
            cell.transform = CGAffineTransform.identity
        }
    }
}

extension RecipeListTableViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ingrCellIdentifier, for: indexPath) as? IngredientCell else { fatalError("CollectionView wasn't configured") }
        let position = indexPath.row
        cell.setText(text: ingredients[position])
        cell.removeAction = { [unowned self] button in
            self.ingredients.remove(at: position)
            self.updateBarVisibility()
            self.viewModel.getRecipe(ingredients: self.ingredients)
        }
        return cell
    }
}

extension RecipeListTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == ingredientsTextField) {
            buttonTapped(sender: textField)
            return false
        }
        return true
    }
}
