//
//  SettingsViewController.swift
//  GitHub
//
//  Created by Sasha Jarohevskii on 30.10.2023.
//

import UIKit

enum SettingsSection: Titleable, CaseIterable {
    case `default`
    case custom
    
    enum SettingCell: Titleable {
        case light
        case dark
        case dracula
        
        case backgroundColor
        case tintColor
    }
    
    var cells: [SettingCell] {
        switch self {
        case .default:
            return [.light, .dark, .dracula]
        case .custom:
            return [.backgroundColor, .tintColor]
        }
    }
}

enum ColorPickerType {
    case background
    case tint
}

class SettingsViewController: UIViewController {
    private let sections = SettingsSection.allCases
    private var sectionsOpenState: [SettingsSection: Bool] = [
        .default: true,
        .custom: true,
    ]
    
    var delegate: SettingsViewControllerDelegate?
    var selectedPickerType: ColorPickerType?

    enum ColorPickerType {
        case background
        case tint
    }
    
    private let mainView = SettingsView()

    private lazy var colorPickerViewController: UIColorPickerViewController = {
        let obj = UIColorPickerViewController()
        obj.delegate = self
        obj.selectedColor = currentTheme.backgroundColor
        return obj
    }()
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureTableView()
        
        mainView.changeThemeButton.addAction(UIAction { [self] _ in
            present(colorPickerViewController, animated: true, completion: nil)
        }, for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        applyTheme()
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
        if sectionsOpenState[sections[section]] == true {
            return sections[section].cells.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellView = tableView.dequeueReusableCell(withIdentifier: "SettingsCell")
            as? SettingsCellView else { return SettingsCellView() }
        
        let section = sections[indexPath.section]
        let cell = section.cells[indexPath.row]
        let text = cell.title
        cellView.textLabel?.text = text
        cellView.applyTheme()
        
        return cellView
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
        guard let headerView = sender.view as? SettingsSectionHeaderView else { return }

        let section = headerView.tag
        sectionsOpenState[sections[section]]?.toggle()

        let numberOfRows = sections[section].cells.count
        let indexPaths = (0..<numberOfRows).map { IndexPath(row: $0, section: section) }
        
        if let isOpen = sectionsOpenState[sections[section]] {
            mainView.tableView.performBatchUpdates {
                headerView.animateDecorImage(isOpen)
                if isOpen {
                    mainView.tableView.insertRows(at: indexPaths, with: .top)
                } else {
                    mainView.tableView.deleteRows(at: indexPaths, with: .top)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedSection = sections[indexPath.section]
        let selectedCell = selectedSection.cells[indexPath.row]
        
        switch selectedCell {
        case .light:
            changeTheme(to: .light)
        case .dark:
            changeTheme(to: .dark)
        case .dracula:
            changeTheme(to: .dracula)
            
        case .backgroundColor:
            selectedPickerType = .background
            presentColorPicker()
        case .tintColor:
            selectedPickerType = .tint
            presentColorPicker()
        }
    }
    
    func presentColorPicker() {
        let colorPickerViewController = UIColorPickerViewController()
        colorPickerViewController.delegate = self

        switch selectedPickerType {
        case .background:
            colorPickerViewController.selectedColor = currentTheme.backgroundColor
        case .tint:
            colorPickerViewController.selectedColor = currentTheme.tintColor
        default: break
        }
        
        present(colorPickerViewController, animated: true, completion: nil)
    }
}

extension SettingsViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let newColor = viewController.selectedColor
        var newTheme = ThemeManager.shared.current
        
        switch selectedPickerType {
        case .background:
            newTheme.backgroundColor = newColor
        case .tint:
            newTheme.tintColor = newColor
        default: break
        }
        
        changeTheme(to: newTheme)
    }
}

// MARK: - Theme
extension SettingsViewController: Themeable {
    func applyTheme() {
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
