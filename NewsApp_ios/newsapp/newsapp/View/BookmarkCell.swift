//
//  BookmarkCell.swift
//  newsapp
//
//  Created by Yueyang Cheng on 4/17/20.
//  Copyright © 2020 Yueyang Cheng. All rights reserved.
//

import UIKit

protocol BookmarkManagerDelegate {
    func needUpdateBookmarkPage()
    func popUpToast()
}

class BookmarkCell: UICollectionViewCell {
    @IBOutlet weak var BookmarkImg: UIImageView!
    
    @IBOutlet weak var BookmarkSource: UILabel!
    @IBOutlet weak var BookmarkDate: UILabel!
    @IBOutlet weak var BookmarkTitle: UILabel!
    @IBOutlet weak var BookmarkBtn: UIButton!
    
    var bookmarkManagerDelegate: BookmarkManagerDelegate!
    var id: String = ""
    
    func setBookmark(news: NewsInfo) {
        BookmarkDate.text = news.date
        BookmarkTitle.text = news.title
        BookmarkSource.text = "|\(news.section)"
        id = news.id
    }
    
    @IBAction func deteleFromBookmark(_ sender: Any) {
        if var savedArticles = UserDefaults.standard.data(forKey: "savedArticles") {
            let newsArray = try! JSONDecoder().decode([NewsInfo].self, from: savedArticles)
            
            var temp:[NewsInfo] = []
            for i in 0..<newsArray.count {
                if newsArray[i].id != id {
                    temp.append(newsArray[i])
                }
            }
            savedArticles = try! JSONEncoder().encode(temp)
            UserDefaults.standard.set(savedArticles, forKey: "savedArticles")
            bookmarkManagerDelegate.needUpdateBookmarkPage()
            bookmarkManagerDelegate.popUpToast()
        }
        
    }
    
}
