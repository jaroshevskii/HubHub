//
//  UserProfileData.swift
//  HubHub
//
//  Created by Sasha Jarohevskii on 06.10.2023.
//

/// Represents detailed profile data for a GitHub user.
struct UserProfileData {
    /// The GitHub login name of the user.
    public var login: String

    /// The URL of the user's avatar image.
    public var avatarURL: String

    /// The full name of the user.
    public var name: String?

    /// The company the user is associated with.
    public var company: String?

    /// The user's blog URL.
    public var blog: String

    /// The geographical location of the user.
    public var location: String?
}

// MARK: - Codable
extension UserProfileData: Codable {
    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
        case name
        case company
        case blog
        case location
    }
}
