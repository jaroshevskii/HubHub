//
//  UserListController.swift
//  GitHub
//
//  Created by Sasha Jarohevskii on 13.10.2023.
//

import UIKit

class UserListViewController: UIViewController {
    private var users = [UserTableData]()
    
    private let mainView = UserListView()
    
    private var isLoadingData = false
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureTableView()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        applyTheme()
    }
}

// MARK: - Navigation Bar
extension UserListViewController {
    private func configureNavigationBar() {
        title = "Users"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "qrcode.viewfinder"),
            style: .plain,
            target: self,
            action: #selector(openQRCodeScanner)
        )
    }
    
    @objc private func openQRCodeScanner() {
        navigationController?.pushViewController(QRCodeScannerViewController(), animated: true)
    }
}

// MARK: - Table View
extension UserListViewController: UITableViewDataSource, UITableViewDelegate {
    private func configureTableView() {
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
        mainView.tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        
        let tableRefreshControll = UIRefreshControl()
        tableRefreshControll.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        mainView.tableView.refreshControl = tableRefreshControll
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier,for: indexPath) as? UserTableViewCell else {
            return UITableViewCell()
        }
        cell.model = users[indexPath.row]
        cell.applyTheme()
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        let userProfileViewController = UserProfileViewController(login: user.login)
        navigationController?.pushViewController(userProfileViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height  {
            loadData()
        }
    }
}

// MARK: - Data
extension UserListViewController {
    private func loadData() {
        if isLoadingData { return }
        isLoadingData = true
        
        let lastUserID = users.last?.id ?? 0
        GitHubAPIManager.shared.fetchUsersTableDatas(from: lastUserID) { [self] result in
            switch result {
            case .success(let userTableDatas):
                let initialCount = users.count
                users.append(contentsOf: userTableDatas)
                let indexPaths = (initialCount..<users.count).map { IndexPath(row: $0, section: 0) }
                mainView.tableView.insertRows(at: indexPaths, with: .automatic)
                
                isLoadingData = false
            case .failure(let error):
                print("Error loading data: \(error.localizedDescription)")
            }
        }
    }
    
    @objc private func refreshData() {
        GitHubAPIManager.shared.fetchUsersTableDatas() { [self] result in
            switch result {
            case .success(let userTableDatas):
                users = userTableDatas
                mainView.tableView.reloadData()
                
                mainView.tableView.refreshControl?.endRefreshing()
            case .failure(let error):
                print("Error refreshing data: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Theme
extension UserListViewController: Themeable {
    func applyTheme() {
        navigationItem.rightBarButtonItem?.tintColor = currentTheme.tintColor
//        navigationController?.navigationBar.barTintColor = currentTheme.backgroundColor
        
        mainView.applyTheme()
        mainView.tableView.reloadData()
    }
}
