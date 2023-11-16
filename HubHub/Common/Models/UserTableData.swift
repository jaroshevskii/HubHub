//
//  UserTableData.swift
//  HubHub
//
//  Created by Sasha Jarohevskii on 16.10.2023.
//

/// Represents data for a user in a table.
struct UserTableData {
    /// The unique identifier for the user.
    var id: Int

    /// The GitHub login name of the user.
    var login: String

    /// The URL of the user's avatar image.
    var avatarURL: String
}

// MARK: - Codable
extension UserTableData: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarURL = "avatar_url"
    }
}
