//
//  UIColor+LightDark.swift
//  GitHub
//
//  Created by Sasha Jarohevskii on 06.11.2023.
//

import UIKit

extension UIColor {
    var isLight: Bool {
        var white: CGFloat = 0
        getWhite(&white, alpha: nil)
        return white > 0.5
    }
    
    var isDark: Bool { !isLight }
}
