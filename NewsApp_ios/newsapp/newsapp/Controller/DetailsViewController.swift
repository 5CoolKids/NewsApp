//
//  DetailsViewController.swift
//  newsapp
//
//  Created by Yueyang Cheng on 4/14/20.
//  Copyright © 2020 Yueyang Cheng. All rights reserved.
//

import UIKit
import SwiftSpinner
import SDWebImage
import SwiftyJSON
import Alamofire

class DetailsViewController: UIViewController {

    @IBOutlet weak var detailImg: UIImageView!
    
    @IBOutlet weak var releaseTime: UILabel!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsSource: UILabel!
    @IBOutlet weak var newsContent: UILabel!
    
    var id: String = ""
    var webUrl: String = ""
    var date:String = ""
    var time:String = ""
    var imgUrl:String = ""
    var newstitle:String = ""
    var source:String = ""
    
    var existed:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchNewsDetail(id: id)
        navigationItem.largeTitleDisplayMode = .never
        existed = isExist()
        let bookmarkBtn = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain
        ,target: self, action: #selector(bookmarkClick))
        if (existed) {
            bookmarkBtn.image = UIImage(systemName: "bookmark.fill")
        }
  
        let shareTwitter = UIBarButtonItem(image: UIImage(named: "twitter"), style: .plain
        ,target: self, action: #selector(twitterClick))
        
        navigationItem.rightBarButtonItems = [shareTwitter, bookmarkBtn]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        existed = isExist()
        if (existed) {
            navigationItem.rightBarButtonItems?[1].image = UIImage(systemName: "bookmark.fill")
        } else {
            navigationItem.rightBarButtonItems?[1].image = UIImage(systemName: "bookmark")
        }
    }

    func fetchNewsDetail(id: String) {
        let url = "https://newsapp-backend-yyc.appspot.com/guardian_detail_page?id=\(id)"
        Alamofire.request(url, encoding: JSONEncoding.default).responseJSON { response in
            SwiftSpinner.show("Loading Detailed article..")
            if let data = response.result.value {
                let curr = JSON(data)["results"]
                self.newsTitle.text = curr["title"].string
                self.navigationItem.title = curr["title"].string
                self.releaseTime.text = curr["section"].string
                self.newsSource.text = curr["date"].string
                let imageUrl = curr["image"].string!
                if (imageUrl == "null") {
                    self.detailImg.image = UIImage(named: "default-guardian")
                } else {
                    let imageUrl:NSURL? = NSURL(string: imageUrl)
                    if let url = imageUrl {
                        self.detailImg.sd_setImage(with: url as URL)
                    }
                }

                self.newsContent.attributedText = curr["content"].stringValue.htmlAttributed(family: "HelveticaNeue", size: 12)
            }
            SwiftSpinner.hide()
        }
    }

    @IBAction func readFullNews(_ sender: Any) {
        let newsUrl = "\(webUrl)"
        UIApplication.shared.open(URL(string: newsUrl)!, options:[:], completionHandler: nil)
    }
    
    @objc func bookmarkClick() {
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
                navigationItem.rightBarButtonItems?[1].image = UIImage(systemName: "bookmark")
                self.view.makeToast("Article Removed from Bookmarks", duration: 3.0, position: .bottom)
                existed = false
            } else {
                newsArray.append(NewsInfo(title: newstitle, time: time, section: source, imgUrl: imgUrl, id: id, url: webUrl, date: date))
                savedArticles = try! JSONEncoder().encode(newsArray)
                UserDefaults.standard.set(savedArticles, forKey: "savedArticles")
                navigationItem.rightBarButtonItems?[1].image = UIImage(systemName: "bookmark.fill")
                self.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view", duration: 3.0, position: .bottom)
                existed = true
            }
        } else {
            var newsArray = [NewsInfo]()
            newsArray.append(NewsInfo(title: newstitle, time: time, section: source, imgUrl: imgUrl, id: id, url: webUrl, date: date))
            let savedArticles = try! JSONEncoder().encode(newsArray)
            UserDefaults.standard.set(savedArticles, forKey: "savedArticles")
            navigationItem.rightBarButtonItems?[1].image = UIImage(systemName: "bookmark.fill")
            self.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view", duration: 3.0, position: .bottom)
            existed = true
        }
    }
    
    @objc func twitterClick() {
        let twitterUrl = "https://www.twitter.com/share?hashtags=CSCI_571_NewsApp&url=\(webUrl)&text=Check%20out%20this%20Article%21%20"
        UIApplication.shared.open(URL(string: twitterUrl)!, options:[:], completionHandler: nil)
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

extension String {
    func htmlAttributed(family: String?, size: CGFloat) -> NSAttributedString? {
        do {
            var htmlCSSString = "<style>" +
                "html *" +
                "{" +
                "font-size: \(size)pt !important;" +
                "font-family: \(family ?? "Helvetica"), Helvetica !important;" +
            "}</style> \(self)"
            
            htmlCSSString = htmlCSSString.replacingOccurrences(of: "(?i)<iframe[^>]*>", with: "", options: String.CompareOptions.regularExpression, range: nil)
            htmlCSSString = htmlCSSString.replacingOccurrences(of: "(?i)</iframe[^>]*>", with: "", options: String.CompareOptions.regularExpression, range: nil)


            guard let data = htmlCSSString.data(using: String.Encoding.utf8) else {
                return nil
            }

            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
}
