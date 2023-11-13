//
//  SettingsCellVIew.swift
//  GitHub
//
//  Created by Sasha Jarohevskii on 08.11.2023.
//

import UIKit

class SettingsCellView: UITableViewCell {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }

    private func setup() {
        makeConstraints()
    }
     
    private func makeConstraints() {
        // ...
    }
}

extension SettingsCellView: Themeable {
    func applyTheme() {
        backgroundColor = currentTheme.backgroundColor
        tintColor = currentTheme.tintColor
    }
}
