//
//  NewsViewController.swift
//  ReadingRSS
//
//  Created by Данил Казаков on 12.06.2020.
//  Copyright © 2020 Danil Moguchiy. All rights reserved.
//


import UIKit
import Foundation


class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let refreshControl: UIRefreshControl = {
        let myRefreshControl = UIRefreshControl()
        myRefreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return myRefreshControl
    }()

    var rssItems: [News]?
    var categoryArray: [String] = []
    
    @IBOutlet var newsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.removeObject(forKey: "selectedCategory")
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchData()
    }
    
    //MARK: TableView Setup
    private func setupTableView() {
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.keyboardDismissMode = .onDrag
        newsTableView.estimatedRowHeight = 155.0
        newsTableView.rowHeight = UITableView.automaticDimension
        newsTableView.refreshControl = refreshControl
        fetchData()
        
        newsTableView.reloadData()
    }
    
    //MARK: Get Data
    private func fetchData() {
        let feedParser = FeedParser()
        feedParser.parseFeed(url: "https://www.vesti.ru/vesti.rss") { (rssItems) in
            self.rssItems = rssItems
            OperationQueue.main.addOperation {
                
                var i = 0
                while i <= (self.rssItems!.count - 1) {
                    if self.categoryArray.contains(self.rssItems![i].category) {
                       
                    } else {
                        self.categoryArray.append(self.rssItems![i].category)
                    }
                    i = i + 1
                }
                self.filterTableView()
                self.newsTableView.reloadData()
            }
        }
    }
  
    //MARK: NavigationBar Button Action
    @IBAction func openCategoryList(_ sender: UIBarButtonItem) {
        let popVC = self.storyboard?.instantiateViewController(identifier: "ChooseCategoryTableViewController") as! ChooseCategoryTableViewController
        popVC.categoryList = categoryArray
        self.navigationController?.pushViewController(popVC, animated: true)
    }
    
    @IBAction func resetNews(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "selectedCategory")
        filterTableView()
    }
    
    //MARK: News Filter
    private func filterTableView() {
        guard let selectedCategory = UserDefaults.standard.value(forKey: "selectedCategory") as? String else {
            return
        }
            rssItems = rssItems?.filter({ (mod) -> Bool in
                return mod.category.contains(selectedCategory)
            })
        newsTableView.reloadData()
    }
   
    //MARK: PullToRefresh
    @objc private func refresh(sender: UIRefreshControl) {
        fetchData()
        sender.endRefreshing()
    }
    
    //MARK: TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rssItemsForTable = rssItems else {
            return 0
        }
        return rssItemsForTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newsTableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsTableViewCell

        if let item = rssItems?[indexPath.item] {
            cell.item = item
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsRow = rssItems![indexPath.row]
        let nextVC = self.storyboard?.instantiateViewController(identifier: "SelectedNewsViewController") as! SelectedNewsViewController
        nextVC.selectedRSSItems = newsRow
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

}

