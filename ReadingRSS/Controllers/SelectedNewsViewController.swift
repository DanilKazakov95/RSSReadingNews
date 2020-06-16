//
//  SelectedNewsViewController.swift
//  ReadingRSS
//
//  Created by Данил Казаков on 12.06.2020.
//  Copyright © 2020 Danil Moguchiy. All rights reserved.
//

import UIKit

class SelectedNewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var selectedNewsTableView: UITableView!
    var selectedRSSItems: News?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    //MARK: TableView Setup
    private func setupTableView() {
        selectedNewsTableView.delegate = self
        selectedNewsTableView.dataSource = self
        selectedNewsTableView.estimatedRowHeight = 155.0
        selectedNewsTableView.rowHeight = UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = selectedNewsTableView.dequeueReusableCell(withIdentifier: "selectedCell", for: indexPath) as! SelectedTableViewCell
        
        if let item = selectedRSSItems {
            cell.item = item
            print(item)
        }
        return cell
    }
    
}
