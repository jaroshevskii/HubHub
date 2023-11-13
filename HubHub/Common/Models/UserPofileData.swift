//
//  UserProfileData.swift
//  GitHub
//
//  Created by Sasha Jarohevskii on 06.10.2023.
//

struct UserProfileData: Codable {
    var login: String
    var avatarURL: String
    var name: String?
    var company: String?
    var blog: String
    var location: String?
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
        case name
        case company
        case blog
        case location
    }
}
