//
//  UIColor+Complementary.swift
//  GitHub
//
//  Created by Sasha Jarohevskii on 06.11.2023.
//

import UIKit

extension UIColor {
    func complementary() -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            let complementaryHue = (hue + 0.5).truncatingRemainder(dividingBy: 1.0)
            return UIColor(hue: complementaryHue, saturation: saturation, brightness: brightness, alpha: alpha)
        }

        return self
    }
}
