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
            guard let model else { return }
            
            handleAvatar(with: model.avatarURL)
            handleQRCode(for: model.login)
            handleSections(with: model)
        }
    }
    
    var avatarImage: UIImage?
    var qrCodeImage: UIImage?
    
    lazy var avatarImageView: UIImageView = {
        let obj = UIImageView()
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
        addSubview(avatarImageView)
        containerStackView.addArrangedSubview(loginSectionView)
        containerStackView.addArrangedSubview(nameSectionView)
        containerStackView.addArrangedSubview(companySectionView)
        containerStackView.addArrangedSubview(blogSectionView)
        containerStackView.addArrangedSubview(locationSectionView)
        addSubview(containerStackView)
        addSubview(loadingIndicatorView)
        
        makeConstraints()
        remakeConstraintsByOrientation()
    }
    
    private func makeConstraints() {
        loadingIndicatorView.snp.remakeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalToSuperview()
        }
    }

    func remakeConstraintsByOrientation() {
        let isPortraitOrientation = UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height
        if isPortraitOrientation {
            avatarImageView.snp.remakeConstraints { make in
                make.size.equalTo(196)
                make.top.equalTo(safeAreaLayoutGuide).inset(16)
                make.centerX.equalToSuperview()
            }
            
            containerStackView.snp.remakeConstraints { make in
                make.top.equalTo(avatarImageView.snp.bottom).offset(16)
                make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(16)
            }
        } else {
            avatarImageView.snp.remakeConstraints { make in
                make.size.equalTo(196)
                make.top.equalTo(safeAreaLayoutGuide).inset(16)
                make.centerX.equalTo(safeAreaLayoutGuide).multipliedBy(0.5)
            }
            
            containerStackView.snp.remakeConstraints { make in
                make.top.equalTo(safeAreaLayoutGuide).offset(16)
                make.leading.equalTo(safeAreaLayoutGuide.snp.trailing).multipliedBy(0.5).inset(16)
                make.trailing.equalTo(safeAreaLayoutGuide).inset(16)
            }
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
    private func handleAvatar(with avatarURL: String) {
        avatarImageView.kf.setImage(
            with: URL(string: avatarURL),
            options: [.transition(.fade(0.25))],
            completionHandler: { _ in
                self.avatarImage = self.avatarImageView.image
            }
        )
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
    }
    
    private func handleQRCode(for login: String) {
        qrCodeImage = GitHubQRCodeManager.shared.generate(for: login)
    }
    
    private func handleSections(with model: UserProfileData) {
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
