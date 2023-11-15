//
//  SettingsView.swift
//  GitHub
//
//  Created by Sasha Jarohevskii on 30.10.2023.
//

import UIKit
import SnapKit

class SettingsView: UIView {
    let tableView: UITableView = {
        let obj = UITableView()
        obj.sectionHeaderTopPadding = 0
        return obj
    }()
    
    let changeThemeButton: UIButton = {
        let obj = UIButton(type: .system)
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Custom"
        obj.configuration = configuration
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
        addSubview(tableView)
        addSubview(changeThemeButton)
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        changeThemeButton.snp.makeConstraints { make in
            make.trailing.equalTo(safeAreaLayoutGuide).inset(8)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(8)
        }
    }
}

extension SettingsView: Themeable {
    func applyTheme() {
        backgroundColor = .systemBackground
        tableView.backgroundColor = currentTheme.backgroundColor
        
        for section in 0..<tableView.numberOfSections {
            if let headerView = tableView.headerView(forSection: section) as? SettingsSectionHeaderView {
                headerView.applyTheme()
            }
            
            for row in 0..<tableView.numberOfRows(inSection: section) {
                if let cell = tableView.cellForRow(at: IndexPath(row: row, section: section)) as? SettingsCellView {
                    cell.applyTheme()
                }
            }
        }

        changeThemeButton.configuration?.baseBackgroundColor = currentTheme.tintColor
    }
}
