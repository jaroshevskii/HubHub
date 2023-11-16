//
//  UIColor+LightDark.swift
//  HubHub
//
//  Created by Sasha Jarohevskii on 06.11.2023.
//

import UIKit

extension UIColor {
    /// Determines whether the color is considered light.
    ///
    /// A color is considered light if its luminance is greater than 0.5.
    var isLight: Bool {
        var white: CGFloat = 0
        getWhite(&white, alpha: nil)
        return white > 0.5
    }
    
    /// Determines whether the color is considered dark.
    ///
    /// A color is considered dark if it is not light.
    var isDark: Bool { !isLight }
}
