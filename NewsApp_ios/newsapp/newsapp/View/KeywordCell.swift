//
//  KeywordCell.swift
//  newsapp
//
//  Created by Yueyang Cheng on 4/16/20.
//  Copyright © 2020 Yueyang Cheng. All rights reserved.
//

import UIKit

class KeywordCell: UITableViewCell {

    @IBOutlet weak var optionLabel: UILabel!
    
    func setOption(option: String) {
        optionLabel.text = option
    }
}
