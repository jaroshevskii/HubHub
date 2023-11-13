//
//  DefaultThemes.swift
//  GitHub
//
//  Created by Sasha Jarohevskii on 06.11.2023.
//

import UIKit

extension Theme {
    static var dark: Theme {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                window.overrideUserInterfaceStyle = .dark
            }
        }
        return Theme(
            backgroundColor: .systemBackground,
            tintColor: .tintColor
        )
    }

    static var light: Theme {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                window.overrideUserInterfaceStyle = .light
            }
        }
        return Theme(
            backgroundColor: .systemBackground,
            tintColor: .tintColor
        )
    }

    static var dracula: Theme {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                window.overrideUserInterfaceStyle = .dark
            }
        }
        return Theme(
            backgroundColor: UIColor(red: 0.157, green: 0.165, blue: 0.212, alpha: 1.000),
            tintColor: UIColor(red: 1.000, green: 0.475, blue: 0.776, alpha: 1)
        )
    }
}
