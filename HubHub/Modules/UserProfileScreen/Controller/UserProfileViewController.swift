//
//  UserProfileViewController.swift
//  GitHub
//
//  Created by Sasha Jarohevskii on 06.10.2023.
//

import UIKit
import CoreImage.CIFilterBuiltins

class UserProfileViewController: UIViewController {
    private let mainView = UserProfileView()

    private let login: String
    
    init(login: String) {
        self.login = login
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
    
        view = mainView
        configureNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        applyTheme()
    }
}

// MARK: - Navigatoin bar
extension UserProfileViewController {
    private func configureNavigationBar() {
        title = "Profile"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "safari"),
            style: .plain,
            target: self,
            action: #selector(openGitHub)
        )
    }
    
    @objc private func openGitHub() {
        GitHubAPIManager.shared.open(for: login)
    }
}

// MARK: - Data
extension UserProfileViewController {
    private func loadData() {
        mainView.startLoadingAnimating()
        
        GitHubAPIManager.shared.fetchUserData(for: login) { [self] result in
            switch result {
            case .success(let userData):
                mainView.model = userData
                mainView.stopLoadingAnimating()
            case .failure(let error):
                print("Error fetching user data: \(error.localizedDescription)")
            }
        }
    }
}

extension UserProfileViewController: Themeable {
    func applyTheme() {
        navigationItem.rightBarButtonItem?.tintColor = currentTheme.tintColor
        navigationController?.navigationBar.tintColor = currentTheme.tintColor
        mainView.applyTheme()
    }
}
