//
//  Themable.swift
//  GitHub
//
//  Created by Sasha Jarohevskii on 06.11.2023.
//

import Foundation

protocol Themeable {
    var currentTheme: Theme { get set }
    
    func applyTheme()
}

extension Themeable {
    var currentTheme: Theme {
        get { ThemeManager.shared.current }
        set { ThemeManager.shared.current = newValue }
    }
}
