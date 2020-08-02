//
//  NewsCell.swift
//  newsapp
//
//  Created by Yueyang Cheng on 4/12/20.
//  Copyright © 2020 Yueyang Cheng. All rights reserved.
//

import UIKit

protocol NewsManagerDelegate {
    func popUpAddingToast()
    func popUpRemovingToast()
}

class NewsCell: UITableViewCell {
    @IBOutlet weak var newsImgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var bookmarkBtn: UIButton!
    var id:String = ""
    var url:String = ""
    var date:String = ""
    var time:String = ""
    var imgUrl:String = ""
    var title:String = ""
    var source:String = ""
    var existed:Bool = false
    
    var newsManagerDelegate: NewsManagerDelegate!
    
    func setNews(news: NewsInfo) {
        titleLabel.text = news.title
        timeLabel.text = news.time
        sourceLabel.text = "| \(news.section)" 
        id = news.id
        url = news.url
        date = news.date
        imgUrl = news.imgUrl
        title = news.title
        source = news.section
        time = news.time
        
        existed = isExist()
        if (existed) {
            bookmarkBtn.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        } else {
            bookmarkBtn.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
    }
    
    @IBAction func clickedFavorite(_ sender: Any) {
        if var savedArticles = UserDefaults.standard.data(forKey: "savedArticles") {
            var newsArray = try! JSONDecoder().decode([NewsInfo].self, from: savedArticles)
            if (existed) {
                var temp:[NewsInfo] = []
                for i in 0..<newsArray.count {
                    if newsArray[i].id != id {
                        temp.append(newsArray[i])
                    }
                }
                savedArticles = try! JSONEncoder().encode(temp)
                UserDefaults.standard.set(savedArticles, forKey: "savedArticles")
                bookmarkBtn.setImage(UIImage(systemName: "bookmark"), for: .normal)
                newsManagerDelegate.popUpRemovingToast()
                existed = false
            } else {
                newsArray.append(NewsInfo(title: title, time: time, section: source, imgUrl: imgUrl, id: id, url: url, date: date))
                savedArticles = try! JSONEncoder().encode(newsArray)
                UserDefaults.standard.set(savedArticles, forKey: "savedArticles")
                bookmarkBtn.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                newsManagerDelegate.popUpAddingToast()
                existed = true
            }
        } else {
            var newsArray = [NewsInfo]()
            newsArray.append(NewsInfo(title: title, time: time, section: source, imgUrl: imgUrl, id: id, url: url, date: date))
            let savedArticles = try! JSONEncoder().encode(newsArray)
            UserDefaults.standard.set(savedArticles, forKey: "savedArticles")
            bookmarkBtn.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            newsManagerDelegate.popUpAddingToast()
            existed = true
        }
    }
    
    func isExist() -> Bool {
        if let savedArticles = UserDefaults.standard.data(forKey: "savedArticles") {
            let newsArray = try! JSONDecoder().decode([NewsInfo].self, from: savedArticles)
            for i in 0..<newsArray.count {
                if newsArray[i].id == id {
                    return true
                }
            }
        }
        return false
    }
}
