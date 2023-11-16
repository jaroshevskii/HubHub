//
//  UIColor+Complementary.swift
//  HubHub
//
//  Created by Sasha Jarohevskii on 06.11.2023.
//

import UIKit

extension UIColor {
    /// Complementary color of the current color.
    ///
    /// - Note: If the current color is not in the RGB color space, the property equal the original color.
    var complementary: UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        guard getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) else {
            return self
        }
        
        let complementaryHue = (hue + 0.5).truncatingRemainder(dividingBy: 1.0)
        
        return UIColor(hue: complementaryHue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
}
