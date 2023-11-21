//
//  UserListView.swift
//  HubHub
//
//  Created by Sasha Jarohevskii on 13.10.2023.
//

import UIKit

class UserListView: UIView {
    private let loadingMoreUsersIndicatorView: UIActivityIndicatorView = {
        let obj = UIActivityIndicatorView(style: .medium)
        obj.frame = CGRect(x: 0, y: 0, width: obj.frame.width, height: 96)
        obj.startAnimating()
        return obj
    }()
    
    lazy var tableView: UITableView = {
        let obj = UITableView()
        obj.tableFooterView = loadingMoreUsersIndicatorView
        return obj
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
extension UserListView: Themeable {
    func applyTheme() {
        tableView.backgroundColor = currentTheme.backgroundColor
    }
}
