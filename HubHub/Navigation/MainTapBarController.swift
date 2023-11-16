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
        
        loadThemeFromUserDefaults()
        
        setViewControllers([
            userListNavigationController,
            userProfileNavigationController,
            settingsNavigationController,
        ], animated: true)
        
        selectedViewController = settingsNavigationController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        applyTheme()
    }
}

extension MainTabBarController: SettingsViewControllerDelegate {
    func didChangeTheme() {
        applyTheme()
    }
}

extension MainTabBarController: Themeable {
    func applyTheme() {
        tabBar.tintColor = currentTheme.tintColor
        overrideUserInterfaceStyle = currentTheme.userInterfaceStyle
    }
}

extension MainTabBarController {
    private func loadThemeFromUserDefaults() {
        if let savedThemeData = UserDefaults.standard.object(forKey: "Theme") as? Data,
           let loadedTheme = try? JSONDecoder().decode(Theme.self, from: savedThemeData) {
            ThemeManager.shared.current = loadedTheme
            print("Theme loaded successfully from UserDefaults")
        } else {
            print("Failed to decode Theme from UserDefaults")
        }
    }
}
