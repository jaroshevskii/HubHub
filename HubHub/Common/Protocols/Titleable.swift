//
//  Titleable.swift
//  HubHub
//
//  Created by admin on 14.11.2023.
//

import Foundation

/// A protocol for objects that have a title.
protocol Titleable {
    /// The title of the object.
    var title: String { get }
}

// MARK: - Default Implementation
extension Titleable {
    /// Default implementation for the title property, using the description of the object in capitalized form.
    var title: String {
        var result = ""

        for (index, char) in String(describing: self).enumerated() {
            if char.isUppercase {
                result += index == 0 ? String(char) : " \(char)"
            } else {
                result += String(char)
            }
        }

        return result.capitalized.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
