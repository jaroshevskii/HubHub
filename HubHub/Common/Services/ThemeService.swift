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
    static let defaultTheme: Theme = .dracula
    
    /// The current theme applied to the application.
    ///
    /// When you set a new theme, it not only updates the current theme but also persists
    /// the change in user defaults and applies the theme to all open windows.
<<<<<<< HEAD
    static var currentTheme: Theme = cachedTheme {
        didSet {
            cachedTheme = currentTheme
            applyThemeToAllWindows(currentTheme)
=======
    static var currentTheme: Theme {
        get {
            guard let cachedTheme else {
                let loadedTheme = loadThemeFromUserDefaults()
                cachedTheme = loadedTheme
                return loadedTheme
            }
            return cachedTheme
        }
        set(newTheme) {
            cachedTheme = newTheme
            saveThemeToUserDefaults(newTheme)
            applyThemeToAllWindows(newTheme)
>>>>>>> 1ee5e7cfb013b4fd0f5c185906190b9ca69db69e
        }
    }

    
    /// The cached theme that is loaded from UserDefaults.
    ///
    /// This property is used to store the currently loaded theme to avoid unnecessary
    /// repeated loading from UserDefaults, improving performance.
//    private static var cachedTheme: Theme?
    
    
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
        
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: "Theme")
            }
        }
    }
}

// MARK: Setvice Logic
extension ThemeService {
//    
//    /// Loads the theme from UserDefaults or returns the default theme if loading fails.
//    ///
//    /// - Returns: The loaded theme or the default theme if loading fails.
//    private static func loadThemeFromUserDefaults() -> Theme {
//        guard let savedThemeData = UserDefaults.standard.object(forKey: "Theme") as? Data,
//              let loadedTheme = try? JSONDecoder().decode(Theme.self, from: savedThemeData) else {
//            print("Failed to decode Theme from UserDefaults. Using default theme.")
//            return Self.defaultTheme
//        }
//        
//        print("Theme loaded successfully from UserDefaults")
//        return loadedTheme
//    }
//    
//    /// Saves the specified theme to UserDefaults.
//    ///
//    /// - Parameter theme: The theme to be saved.
//    private static func saveThemeToUserDefaults(_ theme: Theme) {
//    
//    }
    
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
