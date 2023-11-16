//
//  UIColor+Codable.swift
//  HubHub
//
//  Created by Sasha Jarohevskii on 06.11.2023.
//

import UIKit

extension UIColor: Codable {}

// MARK: - Encodable
extension Encodable where Self: UIColor {
    public func encode(to encoder: Encoder) throws {
        var r, g, b, a: CGFloat
        (r, g, b, a) = (0, 0, 0, 0)
        var container = encoder.singleValueContainer()
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        try container.encode([r,g,b,a])
    }
}

// MARK: - Decodable
extension Decodable where Self: UIColor {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let components = try container.decode([CGFloat].self)
        self = Self(red: components[0], green: components[1], blue: components[2], alpha: components[3])
    }
}
