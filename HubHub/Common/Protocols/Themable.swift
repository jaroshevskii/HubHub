//
//  Themable.swift
//  HubHub
//
//  Created by Sasha Jarohevskii on 06.11.2023.
//

import Foundation

/// A protocol for objects that can be themed.
protocol Themeable {
    /// The current theme applied to the object.
    var currentTheme: Theme { get set }
    
    /// Applies the current theme to the object.
    func applyTheme()
}

// MARK: - Default Implementation
extension Themeable {
    /// The current theme applied to the object. Defaults to the shared theme from `ThemeService`.
    var currentTheme: Theme {
        get { ThemeService.currentTheme }
        set { ThemeService.currentTheme = newValue }
    }
}
