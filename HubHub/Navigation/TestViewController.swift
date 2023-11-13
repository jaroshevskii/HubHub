//
//  SettingsViewController.swift
//  HubHub
//
//  Created by Sasha Jarohevskii on 13.11.2023.
//
//
//import UIKit
//
//class TestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//
//    let tableView = UITableView()
//    let cellIdentifier = "cell"
//
//    // Data for the table view
//    let sections = ["Standard", "Custom"]
//    let standardOptions = ["Light", "Dark", "Dracula"]
//    let customOptions = ["Background Color", "Tint Color"]
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Set up the table view
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
//
//        view.addSubview(tableView)
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//
//        // Set up constraints
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.topAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
//
//    // MARK: - Table view data source
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return sections.count
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return section == 0 ? standardOptions.count : customOptions.count
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return sections[section]
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
//
//        // Configure the cell
//        let option = indexPath.section == 0 ? standardOptions[indexPath.row] : customOptions[indexPath.row]
//        cell.textLabel?.text = option
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        // Handle cell selection
//        if indexPath.section == 1 {
//            // Custom section, show color picker or perform any custom action
//            if indexPath.row == 0 {
//                // Handle Background Color selection
//                showColorPicker()
//            } else if indexPath.row == 1 {
//                // Handle Tint Color selection
//                showColorPicker()
//            }
//        }
//    }
//
//    func showColorPicker() {
//        // Implement your logic to show a color picker
//        // This could be a separate view controller or a custom view
//        // You can use UIAlertController with a color picker library, or create a custom UI for color selection.
//        // For simplicity, you can use a UIAlertController with a color picker library.
//    }
//}
