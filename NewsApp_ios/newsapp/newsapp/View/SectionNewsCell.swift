//
//  SectionNewsCell.swift
//  newsapp
//
//  Created by Yueyang Cheng on 4/15/20.
//  Copyright © 2020 Yueyang Cheng. All rights reserved.
//

import UIKit

protocol SectionNewsDelegate {
    func popUpAddingToast()
    func popUpRemovingToast()
}

class SectionNewsCell: UITableViewCell {

    @IBOutlet weak var sectionNewsImg: UIImageView!
    
    @IBOutlet weak var bookmarkBtn: UIButton!
    @IBOutlet weak var sectionSL: UILabel!
    @IBOutlet weak var sectionTiL: UILabel!
    @IBOutlet weak var sectionTL: UILabel!
    var id:String = ""
    var url:String = ""
    var date:String = ""
    var imgUrl:String = ""
    var time:String = ""
    var title:String = ""
    var source:String = ""
    var existed:Bool = false
    
    var sectionNewsDelegate: SectionNewsDelegate!
    
    func setSectionNews(news: NewsInfo) {
        sectionTL.text = news.title
        sectionTiL.text = news.time
        sectionSL.text = "| \(news.section)" 
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

    @IBAction func onClickFav(_ sender: Any) {
        if var savedArticles = UserDefaults.standard.data(forKey: "savedArticles") {
            var newsArray = try! JSONDecoder().decode([NewsInfo].self, from: savedArticles)
            print("smth inside: ")
            print(newsArray)
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
                sectionNewsDelegate.popUpRemovingToast()
                existed = false
            } else {
                newsArray.append(NewsInfo(title: title, time: time, section: source, imgUrl: imgUrl, id: id, url: url, date: date))
                savedArticles = try! JSONEncoder().encode(newsArray)
                UserDefaults.standard.set(savedArticles, forKey: "savedArticles")
                bookmarkBtn.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                sectionNewsDelegate.popUpAddingToast()
                existed = true
            }
        } else {
            var newsArray = [NewsInfo]()
            newsArray.append(NewsInfo(title: title, time: time, section: source, imgUrl: imgUrl, id: id, url: url, date: date))
            print("empty: ")
            print(newsArray)
            let savedArticles = try! JSONEncoder().encode(newsArray)
            UserDefaults.standard.set(savedArticles, forKey: "savedArticles")
            bookmarkBtn.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            sectionNewsDelegate.popUpRemovingToast()
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
