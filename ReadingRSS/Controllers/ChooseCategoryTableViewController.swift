//
//  ChooseCategoryTableViewController.swift
//  ReadingRSS
//
//  Created by Данил Казаков on 14.06.2020.
//  Copyright © 2020 Danil Moguchiy. All rights reserved.
//

import UIKit

class ChooseCategoryTableViewController: UITableViewController {
    
    var categoryList: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    //MARK: TableView Setup
    private func setupTableView() {
        tableView.estimatedRowHeight = 100
               tableView.rowHeight = UITableView.automaticDimension
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryTableViewCell

        cell.categoryLabel.text = "\(categoryList[indexPath.row])"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(categoryList[indexPath.row])
        UserDefaults.standard.set("\(categoryList[indexPath.row])", forKey: "selectedCategory")
        navigationController?.popToRootViewController(animated: true)
    }
}
