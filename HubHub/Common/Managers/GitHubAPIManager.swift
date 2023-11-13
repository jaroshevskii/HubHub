//
//  GitHubAPIManager.swift
//  GitHub
//
//  Created by Sasha Jarohevskii on 12.10.2023.
//

import Alamofire
import UIKit

struct GitHubAPIManager {
    static let shared = GitHubAPIManager()

    func fetchUserData(for login: String, completion: @escaping (Result<UserProfileData, Error>) -> Void) {
        guard let userURL = GitHubAPI.usersURL?.appendingPathComponent(login) else { return }
        
        AF.request(userURL).validate().responseDecodable(of: UserProfileData.self) { response in
            switch response.result {
            case .success(let userData):
                completion(.success(userData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchUsersTableDatas(from id: Int = 0, completion: @escaping (Result<[UserTableData], Error>) -> Void) {
        guard let usersURL = GitHubAPI.usersURL else { return }
        
        var urlComponents = URLComponents(url: usersURL, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [
            URLQueryItem(name: "since", value: String(id)),
        ]
        
        guard let usersFethURL = urlComponents?.url else { return }
        
        AF.request(usersFethURL).validate().responseDecodable(of: [UserTableData].self) { response in
            switch response.result {
            case .success(let userTableData):
                completion(.success(userTableData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func open(for login: String) {
        guard let usersURL = GitHubAPI.homeURL else { return }
        UIApplication.shared.open(usersURL.appendingPathComponent(login))
    }
    
    func generateQRCode(for login: String) -> UIImage? {
        guard let userURL = GitHubAPI.homeURL?.appendingPathComponent(login) else { return nil }
        
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(userURL.absoluteString.utf8)
        
        guard let outputImage = filter.outputImage,
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent)
        else { return nil }
        
        return UIImage(cgImage: cgImage)
    }
}
