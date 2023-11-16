//
//  ThemeManager.swift
//  GitHub
//
//  Created by Sasha Jarohevskii on 01.11.2023.
//

import UIKit

struct ThemeManager {
    static var shared = ThemeManager()
    
    var current: Theme = .dracula {
        didSet {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.forEach { window in
                    window.overrideUserInterfaceStyle = current.userInterfaceStyle
                }
            }
        }
    }
}
