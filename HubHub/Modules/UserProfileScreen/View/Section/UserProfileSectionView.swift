//
//  UserProfileSectionView.swift
//  HubHub
//
//  Created by Sasha Jarohevskii on 06.10.2023.
//

import UIKit
import SnapKit

class UserProfileSectionView: UIView {
    var model: String? {
        didSet {
            if let model, !model.isEmpty {
                isHidden = false
                desctiptionLabel.text = model
            } else {
                isHidden = true
            }
        }
    }
    
    private let iconImageView: UIImageView = {
        let obj = UIImageView()
        return obj
    }()
    
    private let titleLabel: UILabel = {
        let obj = UILabel()
        obj.font = .boldSystemFont(ofSize: obj.font.pointSize)
        return obj
    }()
    
    private let desctiptionLabel: UILabel = {
        let obj = UILabel()
        obj.numberOfLines = 0
        return obj
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(icon: SectionIcon, title: String) {
        self.iconImageView.image = icon.image
        self.titleLabel.text = title
        
        super.init(frame: .zero)
        
        setup()
    }

    private func setup() {
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(desctiptionLabel)
        
        makeConstraints()
    }
     
    private func makeConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.leading.top.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(8)
            make.centerY.equalTo(iconImageView)
        }
        
        desctiptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualToSuperview()
            make.top.equalTo(titleLabel)
            make.bottom.equalToSuperview().inset(2)
        }
    }
}

extension UserProfileSectionView {
    enum SectionIcon {
        case login
        case name
        case company
        case blog
        case location

        var imageName: String {
            switch self {
            case .login: return "bolt.horizontal.circle.fill"
            case .name: return "person.crop.circle.fill"
            case .company: return "building.2.crop.circle.fill"
            case .blog: return "link.circle.fill"
            case .location: return "mappin.circle.fill"
            }
        }

        var image: UIImage? { UIImage(systemName: imageName) }
    }
}

extension UserProfileSectionView: Themeable {
    func applyTheme() {
        iconImageView.tintColor = currentTheme.tintColor
    }
}
