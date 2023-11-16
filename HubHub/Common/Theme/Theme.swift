//
//  Theme.swift
//  HubHub
//
//  Created by Sasha Jarohevskii on 01.11.2023.
//

import UIKit

/// A struct representing a theme for the application.
struct Theme: Codable {
    /// The user interface style associated with the theme.
    ///
    /// - Note: All themes in the app use the same user interface style as the base theme.
    var userInterfaceStyle: UIUserInterfaceStyle

    /// The background color of the theme.
    var backgroundColor: UIColor

    /// The tint color of the theme.
    var tintColor: UIColor
}
