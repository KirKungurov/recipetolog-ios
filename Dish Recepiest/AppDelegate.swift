//
//  AppDelegate.swift
//  Dish Recepiest
//
//  Created by Kirill Kungurov on 06.05.2020.
//  Copyright © 2020 Kirill Kungurov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()

        let viewController = MainScreenController()
        viewController.viewModel = RecipeListViewModel()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.tintColor = UIColor.recipe_greenColor
        
        window?.rootViewController = navigationController
        return true
    }
}

