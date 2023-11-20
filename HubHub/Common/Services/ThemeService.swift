//
//  ThemeService.swift
//  HubHub
//
//  Created by Sasha Jaroshevskii on 16.11.2023.
//

import UIKit

/// Manages the application's themes.
struct ThemeService {
    /// The default theme for the application.
    static let defaultTheme: Theme = .dracula
    
    /// The currently applied theme for the application.
    ///
    /// When you set a new theme, it updates the current theme, persists the change
    /// in user defaults, and applies the theme to all open windows.
    static var currentTheme: Theme = cachedTheme {
        didSet {
            cachedTheme = currentTheme
            applyThemeToAllWindows(currentTheme)
        }
    }

    /// The cached theme loaded from `UserDefaults`.
    ///
    /// This property stores the currently loaded theme to avoid unnecessary
    /// repeated loading from `UserDefaults`, improving performance.
    private static var cachedTheme: Theme {
        get {
            guard let savedThemeData = UserDefaults.standard.object(forKey: "Theme") as? Data,
                  let loadedTheme = try? JSONDecoder().decode(Theme.self, from: savedThemeData) else {
                print("Failed to decode Theme from UserDefaults. Using default theme.")
                return Self.defaultTheme
            }
            print("Theme loaded successfully from UserDefaults")
            return loadedTheme
        }
        set(newTheme) {
            do {
                let encoded = try JSONEncoder().encode(newTheme)
                UserDefaults.standard.set(encoded, forKey: "Theme")
                print("Saved theme to UserDefaults")
            } catch {
                print("Failed to encode theme: \(error)")
            }
        }
    }
}

// MARK: - Theme Windows
extension ThemeService {
    /// Applies the given theme to all application windows.
    ///
    /// - Parameter theme: The theme to be applied.
    private static func applyThemeToAllWindows(_ theme: Theme) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                window.overrideUserInterfaceStyle = theme.userInterfaceStyle
            }
        }
    }
}
