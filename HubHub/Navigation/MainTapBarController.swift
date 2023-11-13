//
//  TapBar.swift
//  GitHub
//
//  Created by Sasha Jarohevskii on 30.10.2023.
//

import UIKit

class MainTapBarController: UITabBarController, SettingsViewControllerDelegate {
    private lazy var userListNavigationController: UINavigationController = {
        let obj = UINavigationController(rootViewController: UserListViewController())
        obj.tabBarItem.image = UIImage(systemName: "person.3")
        obj.tabBarItem.title = "Users"
        return obj
    }()
    
    private lazy var userProfileNavigationController: UINavigationController = {
        let obj = UINavigationController(rootViewController: UserProfileViewController(login: "jaroshevskii"))
        obj.tabBarItem.image = UIImage(systemName: "person")
        obj.tabBarItem.title = "Profile"
        return obj
    }()
    
    private lazy var settingsNavigationController: UINavigationController = {
        let settingsViewController = SettingsViewController()
        settingsViewController.delegate = self
        
        let navigationController = UINavigationController(rootViewController: settingsViewController)
        navigationController.tabBarItem.image = UIImage(systemName: "gear")
        navigationController.tabBarItem.title = "Settings"
        
        return navigationController
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
    
    func didChangeTheme() {
        applyTheme()
    }
}

extension MainTapBarController: Themeable {
    func applyTheme() {
        tabBar.tintColor = currentTheme.tintColor
//        tabBar.barTintColor = currentTheme.backgroundColor
    }
}

extension MainTapBarController {
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
