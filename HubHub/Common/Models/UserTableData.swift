//
//  UserTableData.swift
//  GitHub
//
//  Created by Sasha Jarohevskii on 16.10.2023.
//

struct UserTableData: Codable {
    var id: Int
    var login: String
    var avatarURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarURL = "avatar_url"
    }
}
