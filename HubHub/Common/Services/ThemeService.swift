//
//  ThemeService.swift
//  HubHub
//
//  Created by jaroshevskii on 16.11.2023.
//

import UIKit

/// Manages the application's themes.
struct ThemeService {
    /// The default theme for the application.
    static var defaultTheme: Theme = .dracula
    
    /// The current theme applied to the application.
    ///
    /// When you set a new theme, it not only updates the current theme but also persists
    /// the change in user defaults and applies the theme to all open windows.
    static var currentTheme: Theme {
        get {
            cachedTheme ?? loadThemeFromUserDefaults()
        }
        set(newTheme) {
            cachedTheme = newTheme
            saveThemeToUserDefaults(newTheme)
            applyThemeToAllWindows()
        }
    }
    
    /// The cached theme that is loaded from UserDefaults.
    ///
    /// This property is used to store the currently loaded theme to avoid unnecessary
    /// repeated loading from UserDefaults, improving performance.
    private static var cachedTheme: Theme?
}

// MARK: Setvice Logic
extension ThemeService {
    /// Loads the theme from UserDefaults or returns the default theme if loading fails.
    ///
    /// - Returns: The loaded theme or the default theme if loading fails.
    private static func loadThemeFromUserDefaults() -> Theme {
        guard let savedThemeData = UserDefaults.standard.object(forKey: "Theme") as? Data,
              let loadedTheme = try? JSONDecoder().decode(Theme.self, from: savedThemeData) else {
            print("Failed to decode Theme from UserDefaults. Using default theme.")
            return ThemeService.defaultTheme
        }
        
        print("Theme loaded successfully from UserDefaults")
        return loadedTheme
    }
    
    /// Saves the specified theme to UserDefaults.
    ///
    /// - Parameter theme: The theme to be saved.
    private static func saveThemeToUserDefaults(_ theme: Theme) {
        do {
            let encoded = try JSONEncoder().encode(theme)
            UserDefaults.standard.set(encoded, forKey: "Theme")
            print("Saved theme to UserDefaults")
        } catch {
            print("Failed to encode theme: \(error)")
        }
    }
    
    /// Applies the current theme to all application windows.
    private static func applyThemeToAllWindows() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                window.overrideUserInterfaceStyle = currentTheme.userInterfaceStyle
            }
        }
    }
}
