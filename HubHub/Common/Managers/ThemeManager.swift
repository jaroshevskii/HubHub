//
//  ThemeManager.swift
//  HubHub
//
//  Created by Sasha Jarohevskii on 01.11.2023.
//

import UIKit

/// Manages the application's theme.
struct ThemeManager {
    /// The shared instance of the `ThemeManager`.
    static var shared = ThemeManager()

    /// The current theme applied to the application.
    var current: Theme = .dracula {
        didSet {
            applyThemeToAllWindows()
        }
    }

    /// Applies the current theme to all application windows.
    private func applyThemeToAllWindows() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                window.overrideUserInterfaceStyle = current.userInterfaceStyle
            }
        }
    }
}
