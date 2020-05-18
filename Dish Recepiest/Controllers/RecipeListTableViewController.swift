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
    
    private let cellIdentifier = "RecipeCell"
    var ingredients = ""
    var viewModel: RecipeListViewModel!
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var addIngredientImage: UIImageView!
    @IBOutlet private var ingredientsTextField: UITextField!



    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onRecipesChanged = { [unowned self] in
            self.recipesVM = $0
        }
        viewModel.loadMore()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        addIngredientImage.isUserInteractionEnabled = true
        addIngredientImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        _ = tapGestureRecognizer.view as! UIImageView
        guard let newIngredient = self.ingredientsTextField.text else { return }
        self.ingredients += newIngredient + ","
        self.ingredientsTextField.text = ""
        viewModel.reloadRecipes(ingredients: self.ingredients)
    }
}

// MARK: - UITableViewDataSource
extension RecipeListTableViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipesVM.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let recipeCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RecipeCell else{
            fatalError("TableView wasn't configured")
        }
        recipeCell.setUp(with: recipesVM[indexPath.row])
        return recipeCell
    }
    
    
}

// MARK: - UITableViewDelegate
extension RecipeListTableViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == recipesVM.count - 1 {
            viewModel.loadMore()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let RecipePageViewController = UIStoryboard(name: "RecipePage", bundle: nil)
            .instantiateViewController(withIdentifier: "RecipePageViewController") as? RecipePageViewController else { return }
        RecipePageViewController.recipe = recipesVM[indexPath.row]
        navigationController?.pushViewController(RecipePageViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
