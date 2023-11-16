//
//  UserProfileView.swift
//  HubHub
//
//  Created by Sasha Jarohevskii on 06.10.2023.
//

import UIKit
import SnapKit

class UserProfileView: UIView {
    var model: UserProfileData? {
        didSet {
            if let model { handle(model) }
        }
    }
    
    private var avatarImage: UIImage?
    private var qrCodeImage: UIImage?
    
    private let openGitHubButton: UIButton = {
        let obj = UIButton(type: .system)
        obj.setImage(UIImage(systemName: "safari"), for: .normal)
        return obj
    }()
    
    var avatarImageView: UIImageView = {
        let obj = UIImageView()
        obj.isUserInteractionEnabled = true
        obj.layer.masksToBounds = true
        obj.backgroundColor = .secondarySystemBackground
        return obj
    }()
    
    private let loginSectionView: UserProfileSectionView = {
        let obj = UserProfileSectionView(icon: .login, title: "Login")
        return obj
    }()
    
    private let nameSectionView: UserProfileSectionView = {
        let obj = UserProfileSectionView(icon: .name, title: "Name")
        return obj
    }()
    
    private let companySectionView: UserProfileSectionView = {
        let obj = UserProfileSectionView(icon: .company, title: "Company")
        return obj
    }()
    
    private let blogSectionView: UserProfileSectionView = {
        let obj = UserProfileSectionView(icon: .blog, title: "Blog")
        return obj
    }()
    
    private let locationSectionView: UserProfileSectionView = {
        let obj = UserProfileSectionView(icon: .location, title: "Location")
        return obj
    }()
    
    private let containerStackView: UIStackView = {
        let obj = UIStackView()
        obj.axis = .vertical
        return obj
    }()
    
    private let loadingIndicatorView: UIActivityIndicatorView = {
        let obj = UIActivityIndicatorView(style: .medium)
        obj.hidesWhenStopped = true
        return obj
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
     
    private func setup() {
        avatarImageView.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(toggleAvatarImage)
        ))
                
        addSubview(avatarImageView)
        containerStackView.addArrangedSubview(loginSectionView)
        containerStackView.addArrangedSubview(nameSectionView)
        containerStackView.addArrangedSubview(companySectionView)
        containerStackView.addArrangedSubview(blogSectionView)
        containerStackView.addArrangedSubview(locationSectionView)
        addSubview(containerStackView)
        addSubview(loadingIndicatorView)
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(16)
            make.centerX.equalToSuperview()
            make.size.equalTo(196)
        }
        
        containerStackView.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(16)
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        loadingIndicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalToSuperview()
        }
    }
    
    @objc func toggleAvatarImage() {
        guard let avatarImage = avatarImage, let qrCodeImage = qrCodeImage else { return }
        
        if avatarImageView.image == avatarImage {
            avatarImageView.layer.minificationFilter = .nearest
            avatarImageView.layer.magnificationFilter = .nearest
            
            UIView.transition(
                with: avatarImageView,
                duration: 0.5,
                options: .transitionFlipFromRight,
                animations: { [self] in
                    avatarImageView.image = qrCodeImage
                    avatarImageView.layer.cornerRadius = 0

                })
        } else {
            avatarImageView.layer.minificationFilter = .linear
            avatarImageView.layer.magnificationFilter = .linear
            
            UIView.transition(
                with: avatarImageView,
                duration: 0.5,
                options: .transitionFlipFromLeft,
                animations: { [self] in
                    avatarImageView.image = avatarImage
                    avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
                })
        }
    }
}

// MARK: - Loading Indicator Animation
extension UserProfileView {
    func startLoadingAnimating() {
        loadingIndicatorView.startAnimating()
    }

    func stopLoadingAnimating() {
        UIView.animate(withDuration: 0.25) { [self] in
            loadingIndicatorView.alpha = 0
        } completion: { [self] _ in
            loadingIndicatorView.stopAnimating()
        }
    }
}

// MARK: - Hendlers
extension UserProfileView {
    private func handle(_ model: UserProfileData) {
        avatarImageView.kf.setImage(
            with: URL(string: model.avatarURL),
            options: [
                .transition(.fade(0.25)),
            ],
            completionHandler: { _ in
                self.avatarImage = self.avatarImageView.image
            })
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
        
        qrCodeImage = GitHubAPIManager.shared.generateQRCode(for: model.login)
                
        loginSectionView.model = model.login
        nameSectionView.model = model.name
        companySectionView.model = model.company
        blogSectionView.model = model.blog
        locationSectionView.model = model.location
    }
}

// MARK: - Theme
extension UserProfileView: Themeable {
    func applyTheme() {
        backgroundColor = currentTheme.backgroundColor
        loadingIndicatorView.backgroundColor = currentTheme.backgroundColor
        
        containerStackView.arrangedSubviews.forEach { view in
            if let sectionView = view as? UserProfileSectionView {
                sectionView.applyTheme()
            }
        }
    }
}
