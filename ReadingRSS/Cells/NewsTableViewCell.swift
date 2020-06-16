//
//  NewsTableViewCell.swift
//  ReadingRSS
//
//  Created by Данил Казаков on 12.06.2020.
//  Copyright © 2020 Danil Moguchiy. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var pubDate: UILabel!
    
    var item: News! {
        didSet {
            titleLabel.text = item.title
            pubDate.text = item.pubDate
        }
    }
    
}
