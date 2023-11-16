//
//  SettingsView.swift
//  HubHub
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

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    private func setup() {
        addSubview(tableView)
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Theme
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
    }
}
