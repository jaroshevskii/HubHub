//
//  Theme.swift
//  GitHub
//
//  Created by Sasha Jarohevskii on 01.11.2023.
//

import UIKit

struct Theme: Codable {
    var userInterfaceStyle: UIUserInterfaceStyle {
        didSet {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.forEach { window in
                    window.overrideUserInterfaceStyle = userInterfaceStyle
                }
            }
            
            
            print("Did")
        }
    }
    var backgroundColor: UIColor
    var tintColor: UIColor
    
    var baseColor: UIColor {
        get { backgroundColor }
        set { self = Theme(baseColor: newValue) }
    }
}

extension Theme {
    init(baseColor: UIColor) {
        userInterfaceStyle = .light
        backgroundColor = baseColor
        tintColor = baseColor.complementary()
    }
}
