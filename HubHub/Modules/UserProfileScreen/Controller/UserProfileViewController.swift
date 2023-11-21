//
//  UserProfileViewController.swift
//  HubHub
//
//  Created by Sasha Jarohevskii on 06.10.2023.
//

import UIKit

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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureAvatarImage()
        
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        applyTheme()
    }
}

// MARK: - Navigatoin Bar
extension UserProfileViewController {
    private func configureNavigationBar() {
        title = "Profile"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "safari"),
            style: .plain,
            target: self,
            action: #selector(didTapOpenGitHubProfileButton)
        )
    }
}

// MARK: - Avatar Image
extension UserProfileViewController {
    private func configureAvatarImage() {
        mainView.avatarImageView.isUserInteractionEnabled = true
        mainView.avatarImageView.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(didTapAvatarImage)
        ))
    }
    
    func toggleAvatarImage() {
        guard let avatarImage = mainView.avatarImage,
              let qrCodeImage = mainView.qrCodeImage
        else { return }
        
        if mainView.avatarImageView.image == avatarImage {
            mainView.avatarImageView.layer.minificationFilter = .nearest
            mainView.avatarImageView.layer.magnificationFilter = .nearest
            
            UIView.transition(
                with: mainView.avatarImageView,
                duration: 0.5,
                options: .transitionFlipFromRight,
                animations: { [self] in
                    mainView.avatarImageView.image = qrCodeImage
                    mainView.avatarImageView.layer.cornerRadius = 0

                })
        } else {
            mainView.avatarImageView.layer.minificationFilter = .linear
            mainView.avatarImageView.layer.magnificationFilter = .linear
            
            UIView.transition(
                with: mainView.avatarImageView,
                duration: 0.5,
                options: .transitionFlipFromLeft,
                animations: { [self] in
                    mainView.avatarImageView.image = avatarImage
                    mainView.avatarImageView.layer.cornerRadius = mainView.avatarImageView.bounds.height / 2
                })
        }
    }
}

// MARK: - User Actions
extension UserProfileViewController {
    @objc private func didTapOpenGitHubProfileButton() {
        GitHubLinkManager.shared.openProfile(for: login)
    }
    
    @objc private func didTapAvatarImage() {
        toggleAvatarImage()
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

// MARK: - Theme
extension UserProfileViewController: Themeable {
    func applyTheme() {
        navigationItem.rightBarButtonItem?.tintColor = currentTheme.tintColor
        navigationController?.navigationBar.tintColor = currentTheme.tintColor
        mainView.applyTheme()
    }
}

// MARK: - Device Chanege Orientation
extension UserProfileViewController {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        mainView.remakeConstraintsByOrientation()
    }
}
