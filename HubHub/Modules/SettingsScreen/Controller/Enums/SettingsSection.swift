//
//  SettingsSection.swift
//  HubHub
//
//  Created by Sasha Jaroshevskii on 20.11.2023.
//

import Foundation

enum SettingsSection: Titleable, CaseIterable {
    case standard
    case custom
    
    enum SettingCell: Titleable {
        case light
        case dark
        case dracula
        
        case backgroundColor
        case tintColor
    }
    
    var cells: [SettingCell] {
        switch self {
        case .standard:
            return [.light, .dark, .dracula]
        case .custom:
            return [.backgroundColor, .tintColor]
        }
    }
}
