//
//  MainTabBarController.swift
//  HubHub
//
//  Created by Sasha Jarohevskii on 30.10.2023.
//

import UIKit

class MainTabBarController: UITabBarController {
    private lazy var userListNavigationController: UINavigationController = {
        let obj = UINavigationController(rootViewController: UserListViewController())
        obj.tabBarItem.image = UIImage(systemName: "person.3")
        obj.tabBarItem.title = "Users"
        return obj
    }()
    
    private lazy var userProfileNavigationController: UINavigationController = {
        let obj = UINavigationController(
            rootViewController: UserProfileViewController(login: "jaroshevskii")
        )
        obj.tabBarItem.image = UIImage(systemName: "person")
        obj.tabBarItem.title = "Profile"
        return obj
    }()
    
    private lazy var settingsNavigationController: UINavigationController = {
        let settingsViewController = SettingsViewController()
        settingsViewController.delegate = self
        
        let obj = UINavigationController(rootViewController: settingsViewController)
        obj.tabBarItem.image = UIImage(systemName: "gear")
        obj.tabBarItem.title = "Settings"
        return obj
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewControllers([
            userListNavigationController,
            userProfileNavigationController,
            settingsNavigationController,
        ], animated: true)
        
        selectedViewController = userProfileNavigationController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        applyTheme()
    }
}

// MARK: - Theme
extension MainTabBarController: Themeable {
    func applyTheme() {
        tabBar.tintColor = currentTheme.tintColor
        overrideUserInterfaceStyle = currentTheme.userInterfaceStyle
    }
}

extension MainTabBarController: SettingsViewControllerDelegate {
    func didChangeTheme() {
        applyTheme()
    }
}
