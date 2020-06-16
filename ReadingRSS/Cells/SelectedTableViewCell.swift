//
//  SelectedTableViewCell.swift
//  ReadingRSS
//
//  Created by Данил Казаков on 12.06.2020.
//  Copyright © 2020 Danil Moguchiy. All rights reserved.
//

import UIKit

class SelectedTableViewCell: UITableViewCell {
    
    @IBOutlet var selectedNewsImage: UIImageView!
    @IBOutlet var selectedTitle: UILabel!
    @IBOutlet var selectedFullText: UILabel!
    
    var item: News! {
        didSet {
            selectedNewsImage.downloaded(from: item.imageUrl)
            selectedTitle.text = item.title
            selectedFullText.text = item.yandexFullText
        }
    }
    
}
