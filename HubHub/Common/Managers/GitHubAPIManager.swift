//
//  GitHubAPIManager.swift
//  HubHub
//
//  Created by Sasha Jarohevskii on 12.10.2023.
//

import Alamofire
import UIKit

/// Manages GitHub API requests.
struct GitHubAPIManager {
    /// Shared instance of `GitHubAPIManager`.
    static let shared = GitHubAPIManager()

    /// Fetches detailed user profile data for a given login.
    ///
    /// - Parameters:
    ///   - login: The GitHub login of the user.
    ///   - completion: A closure to be called upon request completion.
    func fetchUserData(for login: String, completion: @escaping (Result<UserProfileData, Error>) -> Void) {
        guard let userURL = GitHubAPIConstants.usersURL?.appendingPathComponent(login) else { return }

        AF.request(userURL).validate().responseDecodable(of: UserProfileData.self) { response in
            switch response.result {
            case .success(let userData):
                completion(.success(userData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Fetches a list of users starting from a given ID.
    ///
    /// - Parameters:
    ///   - id: The starting user ID for fetching users.
    ///   - completion: A closure to be called upon request completion.
    func fetchUsersTableData(from id: Int = 0, completion: @escaping (Result<[UserTableData], Error>) -> Void) {
        guard let usersURL = GitHubAPIConstants.usersURL else { return }

        var urlComponents = URLComponents(url: usersURL, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [URLQueryItem(name: "since", value: String(id))]

        guard let usersFetchURL = urlComponents?.url else { return }

        AF.request(usersFetchURL).validate().responseDecodable(of: [UserTableData].self) { response in
            switch response.result {
            case .success(let userTableData):
                completion(.success(userTableData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
