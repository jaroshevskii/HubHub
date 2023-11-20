//
//  GitHubLinkManager.swift
//  HubHub
//
//  Created by Sasha Jaroshevskii on 20.11.2023.
//

import UIKit

/// A manager for handling links related to GitHub profiles.
struct GitHubLinkManager {
    /// The shared instance of `GitHubLinkManager`.
    static let shared = GitHubLinkManager()

    /// Opens the GitHub profile page for a given user login.
    ///
    /// - Parameter login: The GitHub login of the user to open.
    func openProfile(for login: String) {
        guard let usersURL = GitHub.homeURL else { return }

        let userProfileURL = usersURL.appendingPathComponent(login)
        UIApplication.shared.open(userProfileURL)
    }
}
