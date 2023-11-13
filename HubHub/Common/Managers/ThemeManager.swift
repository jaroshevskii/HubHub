//
//  ThemeManager.swift
//  GitHub
//
//  Created by Sasha Jarohevskii on 01.11.2023.
//

import UIKit

struct ThemeManager {
    static var shared = ThemeManager()
    
    var current: Theme = .dracula
}
