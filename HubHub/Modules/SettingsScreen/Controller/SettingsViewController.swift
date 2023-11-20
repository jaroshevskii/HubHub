//
//  SettingsViewController.swift
//  HubHub
//
//  Created by Sasha Jarohevskii on 30.10.2023.
//

import UIKit

class SettingsViewController: UIViewController {
    private let sections = SettingsSection.allCases
    private var sectionsOpenState: [SettingsSection: Bool] = [
        .standard: true,
        .custom: true,
    ]
    
    var delegate: SettingsViewControllerDelegate?
    var selectedPickerType: ColorPickerType?
    
    private let mainView = SettingsView()

    private lazy var colorPickerViewController: UIColorPickerViewController = {
        let obj = UIColorPickerViewController()
        obj.delegate = self
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

// MARK: - Table View Configuration
extension SettingsViewController {
    private func configureTableView() {
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
        mainView.tableView.register(SettingsCellView.self, forCellReuseIdentifier: "SettingsCell")
        mainView.tableView.register(SettingsSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "SettingsSectionHeader")
    }
}

// MARK: - Table View Data Source
extension SettingsViewController: UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SettingsSectionHeader") as? SettingsSectionHeaderView else {
            return UITableViewHeaderFooterView()
        }
        
        headerView.model = sections[section].title
        headerView.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(didTapOnHeaderInSection)
        ))
        headerView.tag = section
        headerView.applyTheme()
        
        return headerView
    }
}

// MARK: - Table View Delegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedSection = sections[indexPath.section]
        let selectedCell = selectedSection.cells[indexPath.row]
        
        handleSelectedCell(type: selectedCell)
    }
}

// MARK: - User Actions
extension SettingsViewController {
    @objc func didTapOnHeaderInSection(_ sender: UITapGestureRecognizer) {
        toggleSection(sender)
    }
}

// MARK: - Section Toggling
extension SettingsViewController {
    func toggleSection(_ sender: UITapGestureRecognizer) {
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
}

// MARK: - Color Picker Presentation
extension SettingsViewController {
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

// MARK: - Handle Selected Cell
extension SettingsViewController {
    private func handleSelectedCell(type: SettingsSection.SettingCell) {
        switch type {
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
}

// MARK: - Color Piker Delegate
extension SettingsViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let newColor = viewController.selectedColor
        var newTheme = currentTheme
        
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
        colorPickerViewController.selectedColor = currentTheme.backgroundColor
        mainView.applyTheme()
    }
    
    func changeTheme(to newTheme: Theme) {
        ThemeService.currentTheme = newTheme

        applyTheme()
        delegate?.didChangeTheme()
    }
}
