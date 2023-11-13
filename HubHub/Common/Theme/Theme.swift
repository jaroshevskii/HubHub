//
//  Theme.swift
//  GitHub
//
//  Created by Sasha Jarohevskii on 01.11.2023.
//

import UIKit

struct Theme: Codable {
    var userInterfaceStyle: UIUserInterfaceStyle = .light
    var backgroundColor: UIColor
    var tintColor: UIColor
}


extension Theme {
    init(color: UIColor) {
        backgroundColor = color
        tintColor = color.complementary()
    }
}

//enum Theme {
//    case light
//    case dark
//    case dracula
//    
//    var userInterfaceStyle: UIUserInterfaceStyle = .light
//    
//    var backgroundColor: UIColor {
//        switch self {
//        case .light, .dark:
//            return .systemBackground
//        case .dracula:
//            return UIColor(red: 0.157, green: 0.165, blue: 0.212, alpha: 1.000)
//        }
//    }
//    
//    var tintColor: UIColor {
//        switch self {
//        case .light, .dark:
//            return .tintColor
//        case .dracula:
//            return UIColor(red: 1.000, green: 0.475, blue: 0.776, alpha: 1)
//        }
//    }
//}
