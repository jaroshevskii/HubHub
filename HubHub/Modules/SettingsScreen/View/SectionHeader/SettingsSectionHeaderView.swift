//
//  SettingsSectionHeaderView.swift
//  HubHub
//
//  Created by Sasha Jarohevskii on 06.11.2023.
//

import UIKit
import SnapKit

class SettingsSectionHeaderView: UITableViewHeaderFooterView {
    var model: String? {
        didSet {
            if let model {
                textLable.text = model
            }
        }
    }
    
    var isSectionCellsVisible = true
    
    private let textLable: UILabel = {
        let obj = UILabel()
        obj.font = .boldSystemFont(ofSize: obj.font.pointSize)
        return obj
    }()
    
    private let decorImageView: UIImageView = {
        let obj = UIImageView(image: UIImage(systemName: "chevron.down"))
        return obj
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setup()
    }

    private func setup() {
        addSubview(textLable)
        addSubview(decorImageView)
        
        makeConstraints()
    }
     
    private func makeConstraints() {
        textLable.snp.makeConstraints { make in
            make.centerY.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(safeAreaLayoutGuide).inset(12)
        }
        
        decorImageView.snp.makeConstraints { make in
            make.centerY.equalTo(safeAreaLayoutGuide)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(12)
        }
    }
}

// MARK: - Theme
extension SettingsSectionHeaderView: Themeable {
    func applyTheme() {
        contentView.backgroundColor = currentTheme.tintColor
        decorImageView.tintColor = currentTheme.backgroundColor
    }
}

// MARK: - Animation
extension SettingsSectionHeaderView {
    func animateDecorImage(_ isSectionCellsVisible: Bool) {
        UIView.animate(withDuration: 0.25) { [self] in
            let rotationAngle: CGFloat = .pi / 2
            decorImageView.transform = isSectionCellsVisible
                ? decorImageView.transform.rotated(by: rotationAngle)
                : decorImageView.transform.rotated(by: -rotationAngle)
        }
    }
}
