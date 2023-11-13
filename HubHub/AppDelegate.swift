//
//  AppDelegate.swift
//  GitHub
//
//  Created by Sasha Jarohevskii on 06.10.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainTapBarController()
        window?.makeKeyAndVisible()
        return true
    }
}
