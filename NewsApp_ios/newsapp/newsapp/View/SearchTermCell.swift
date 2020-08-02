//
//  SearchTermCell.swift
//  newsapp
//
//  Created by Yueyang Cheng on 4/23/20.
//  Copyright © 2020 Yueyang Cheng. All rights reserved.
//

import UIKit

class SearchTermCell: UITableViewCell {

    @IBOutlet weak var keywordLabel: UILabel!
    
    func setKeyword(keyword: String) {
        keywordLabel.text = keyword
    }
}
