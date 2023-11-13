//
//  SettingsViewController.swift
//  GitHub
//
//  Created by Sasha Jarohevskii on 30.10.2023.
//

import UIKit

class SettingsViewController: UIViewController {
    private struct Section {
        var title: String
        var items: [String]
        var isVisible = true
    }
    
    private var sections = [
        Section(title: "Standart", items: ["Light", "Dark", "Dracula"]),
        Section(title: "Custom", items: ["Background Color", "Tini Color"]),
    ]
    
    private var lastSelectedIndexPath: IndexPath?
    
    var delegate: SettingsViewControllerDelegate?

    
    private lazy var colorPickerViewController: UIColorPickerViewController = {
        let obj = UIColorPickerViewController()
        obj.delegate = self
        obj.selectedColor = ThemeManager.shared.current.backgroundColor
        return obj
    }()
    
    private let mainView = SettingsView()
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureTableView()
        
        mainView.changeThemeButton.addTarget(self, action: #selector(showColorPicker), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        applyTheme()
    }
    
    @objc func showColorPicker() {
        present(colorPickerViewController, animated: true, completion: nil)
    }
}

// MARK: - Navigation Bar Configuration
extension SettingsViewController {
    private func configureNavigationBar() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

// MARK: - Table View
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    private func configureTableView() {
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
        mainView.tableView.register(SettingsCellView.self, forCellReuseIdentifier: "SettingsCell")
        mainView.tableView.register(SettingsSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "SettingsSectionHeader")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        return section.isVisible ? section.items.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell") as? SettingsCellView else {
            return SettingsCellView()
        }
        
        let section = sections[indexPath.section]
        let text = section.items[indexPath.row]
        cell.textLabel?.text = text
        cell.applyTheme()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SettingsSectionHeader") as? SettingsSectionHeaderView else {
            return UITableViewHeaderFooterView()
        }
        
        headerView.model = sections[section].title
        headerView.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(toggleSection(_:))
        ))
        headerView.tag = section
        headerView.applyTheme()
        
        return headerView
    }
    
    @objc func toggleSection(_ sender: UITapGestureRecognizer) {
        guard let section = sender.view?.tag else { return }
        
        sections[section].isVisible.toggle()
        
        let indices = sections[section].items.indices.map { IndexPath(row: $0, section: section) }
        
        mainView.tableView.beginUpdates()
        if sections[section].isVisible {
            mainView.tableView.insertRows(at: indices, with: .top )
        } else {
            mainView.tableView.deleteRows(at: indices, with: .top)
        }
        mainView.tableView.endUpdates()
        
        
        if let headerView = mainView.tableView.headerView(forSection: section) as? SettingsSectionHeaderView {
            headerView.animateDecorImage(sections[section].isVisible)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let lastIndexPath = lastSelectedIndexPath {
            if let lastSelectedCell = tableView.cellForRow(at: lastIndexPath) {
                lastSelectedCell.accessoryType = .none
            }
        }
        
        if let selectedCell = tableView.cellForRow(at: indexPath) {
            selectedCell.accessoryType = .checkmark
            lastSelectedIndexPath = indexPath
            
            switch selectedCell.textLabel?.text {
            case "Light":
                changeTheme(to: .light)
            case "Dark":
                changeTheme(to: .dark)
            case "Dracula":
                changeTheme(to: .dracula)
            default: break
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SettingsViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let newTheme = Theme(color: viewController.selectedColor)
        changeTheme(to: newTheme)
    }
}

// MARK: - Theme
extension SettingsViewController: Themeable {
    func applyTheme() {
//        navigationController?.navigationBar.barTintColor = currentTheme.backgroundColor
        
        mainView.applyTheme()
    }
    
    func changeTheme(to newTheme: Theme) {
        ThemeManager.shared.current = newTheme
        
        applyTheme()
        delegate?.didChangeTheme()

        do {
            let encoded = try JSONEncoder().encode(newTheme)
            UserDefaults.standard.set(encoded, forKey: "Theme")
            print("Saved theme to UserDefaults")
        } catch {
            print("Failed to encode theme: \(error)")
        }
    }
}
