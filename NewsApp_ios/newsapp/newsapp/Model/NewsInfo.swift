//
//  NewsInfo.swift
//  newsapp
//
//  Created by Yueyang Cheng on 4/13/20.
//  Copyright © 2020 Yueyang Cheng. All rights reserved.
//

import Foundation
import UIKit

class NewsInfo: Codable {
    var title: String
    var time: String
    var section: String
    var imgUrl: String
    var id: String
    var url: String
    var date: String
    
    init(title: String, time: String, section: String, imgUrl: String, id: String, url: String, date: String) {
        self.title = title
        self.time = time
        self.section = section
        self.imgUrl = imgUrl
        self.id = id
        self.url = url
        self.date = date
    }
}
