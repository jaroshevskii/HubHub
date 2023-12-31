//
//  GitHubAPIConstants.swift
//  HubHub
//
//  Created by Sasha Jaroshevskii on 25.10.2023.
//

import Foundation

/// Represents a set of constants related to the GitHub API.
struct GitHubAPIConstants {
    /// The base URL for fetching information about GitHub users.
    static let usersURL = URL(string: "https://api.github.com/users")
}
