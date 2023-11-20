//
//  UserTableViewCell.swift
//  HubHub
//
//  Created by Anton Andreev on 10/20/23.
//

import UIKit
import Kingfisher
import SnapKit

class UserTableViewCell: UITableViewCell {
    static var identifier: String { String(describing: self) }
    
    var model: UserTableData? {
        didSet {
            if let model { handle(model) }
        }
    }
    
    let avatarImageView: UIImageView = {
        let obj = UIImageView()
        obj.backgroundColor = .secondarySystemBackground
        return obj
    }()
    
    let titleLable: UILabel = {
        let obj = UILabel()
        obj.font = .boldSystemFont(ofSize: UIFont.labelFontSize)
        return obj
    }()
    
    let desctiptionLable: UILabel = {
        let obj = UILabel()
        obj.font = .systemFont(ofSize: UIFont.systemFontSize)
        obj.textColor = .secondaryLabel
        return obj
    }()
    
    let contaiterStackView: UIStackView = {
        let obj = UIStackView()
        obj.axis = .vertical
        obj.spacing = 4
        return obj
    }()
    
    let decorImageView: UIImageView = {
        let obj = UIImageView(image: UIImage(systemName: "chevron.right"))
        return obj
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    private func setup() {
        contentView.addSubview(avatarImageView)
        
        contentView.addSubview(contaiterStackView)
        contaiterStackView.addArrangedSubview(titleLable)
        contaiterStackView.addArrangedSubview(desctiptionLable)
        
        contentView.addSubview(decorImageView)
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        avatarImageView.snp.makeConstraints { make in
            make.size.equalTo(64)
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        contaiterStackView.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }
        
        decorImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
        avatarImageView.clipsToBounds = true
        avatarImageView.layoutIfNeeded()
    }
}

// MARK: - Hendlers
extension UserTableViewCell {
    func handle(_ model: UserTableData) {
        avatarImageView.kf.setImage(
            with: URL(string: model.avatarURL),
            options: [
                .transition(.fade(0.25)),
            ],
            completionHandler: { _ in
                self.layoutSubviews()
            })
        titleLable.text = model.login
        desctiptionLable.text = "ID \(model.id)"
    }
}

// MARK: - Theme
extension UserTableViewCell: Themeable {
    func applyTheme() {
        backgroundColor = currentTheme.backgroundColor
        decorImageView.tintColor = currentTheme.tintColor
    }
}
