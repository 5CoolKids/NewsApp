//
//  SectionViewController.swift
//  newsapp
//
//  Created by Yueyang Cheng on 4/15/20.
//  Copyright © 2020 Yueyang Cheng. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SDWebImage
import Alamofire
import SwiftyJSON
import SwiftSpinner
import Toast_Swift


class SectionViewController: UIViewController, IndicatorInfoProvider {
    
    @IBOutlet weak var tableView: UITableView!
    var sectionName: String = ""
    var searchQuery: String = ""
    var search:Bool = false
    var newsList: [NewsInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSectionNews(fresh: false)
        tableView.delegate = self
        tableView.dataSource = self
        if search {
            navigationItem.title = "Search Result"
        }
        configureRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func configureRefreshControl () {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action:
            #selector(handleRefreshControl),
                                            for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        fetchSectionNews(fresh: true)
        self.tableView.reloadData()
        // Dismiss the refresh control.
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    
    func fetchSectionNews(fresh: Bool) {
        var fetchURL: String = ""
        if (!search) {
            fetchURL = "https://newsapp-backend-yyc.appspot.com/\(sectionName.lowercased())"
            if (!fresh) {
                SwiftSpinner.show("Loading \(sectionName) page..")
            }
        } else {
            fetchURL = "https://newsapp-backend-yyc.appspot.com/search_news?q=\(searchQuery)"
            fetchURL = fetchURL.replacingOccurrences(of: " ", with: "+")
            if (!fresh) {
                SwiftSpinner.show("Loading Search Results..")
            }
        }
        
        Alamofire.request(fetchURL).responseJSON { response in
            if let data = response.result.value {
                let safeData = JSON(data)["results"]
                for i in 0..<safeData.count {
                    let curr = safeData[i]
                    let title = curr["title"].string
                    let time = curr["time"].string
                    let section = curr["section"].string
                    var img = curr["image"].string
                    if (img == nil) {
                        img = "null"
                    }
                    let id = curr["id"].string
                    let url = curr["webUrl"].string
                    let date = curr["date"].string
                    
                    let news = NewsInfo(title: title!, time: time!, section: section!, imgUrl: img!, id: id!, url: url!, date: date!)
                    self.newsList.append(news)
                }
            }
            self.tableView.reloadData()
            SwiftSpinner.hide()
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "\(sectionName)")
    }
    
}

extension SectionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let news = newsList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SectionNewsCell") as! SectionNewsCell
        cell.sectionNewsDelegate = self
        if (news.imgUrl == "null") {
            cell.sectionNewsImg.image = UIImage(named: "default-guardian")
        } else {
            let imageUrl:NSURL? = NSURL(string: news.imgUrl)
            if let url = imageUrl {
                cell.sectionNewsImg.sd_setImage(with: url as URL)
            }
        }
        cell.setSectionNews(news: news)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(identifier: "DetailsViewController") as? DetailsViewController
        vc?.id = newsList[indexPath.row].id
        vc?.webUrl = newsList[indexPath.row].url
        vc?.date = newsList[indexPath.row].date
        vc?.time = newsList[indexPath.row].time
        vc?.imgUrl = newsList[indexPath.row].imgUrl
        vc?.newstitle = newsList[indexPath.row].title
        vc?.source = newsList[indexPath.row].section
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let item = newsList[indexPath.row]
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            
            let share = UIAction(title: "Share with Twitter", image: UIImage(named: "twitter")) { action in
                let twitterUrl = "https://www.twitter.com/share?hashtags=CSCI_571_NewsApp&url=\(item.url)&text=Check%20out%20this%20Article%21%20"
                UIApplication.shared.open(URL(string: twitterUrl)!, options:[:], completionHandler: nil)
            }
            var symbol = "bookmark"
            var isExist: Bool = false
            if let savedArticles = UserDefaults.standard.data(forKey: "savedArticles") {
                let newsArray = try! JSONDecoder().decode([NewsInfo].self, from: savedArticles)
                for i in 0..<newsArray.count {
                    if newsArray[i].id == item.id {
                        symbol = "bookmark.fill"
                        isExist = true
                        break
                    }
                }
            }
            let bookmark = UIAction(title: "Bookmark", image: UIImage(systemName: symbol)) { action in
                if var savedArticles = UserDefaults.standard.data(forKey: "savedArticles") {
                    var newsArray = try! JSONDecoder().decode([NewsInfo].self, from: savedArticles)

                    if (!isExist) {
                        newsArray.append(item)
                        savedArticles = try! JSONEncoder().encode(newsArray)
                        UserDefaults.standard.set(savedArticles, forKey: "savedArticles")
                        if let retableCell = tableView.cellForRow(at: indexPath) as? SectionNewsCell {
                            retableCell.bookmarkBtn.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                            retableCell.existed = true
                        }
                        self.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view", duration: 3.0, position: .bottom)
                    } else {
                        var temp:[NewsInfo] = []
                        for i in 0..<newsArray.count {
                            if newsArray[i].id != item.id {
                                temp.append(newsArray[i])
                            }
                        }
                        savedArticles = try! JSONEncoder().encode(temp)
                        UserDefaults.standard.set(savedArticles, forKey: "savedArticles")
                        if let retableCell = tableView.cellForRow(at: indexPath) as? SectionNewsCell {
                            retableCell.bookmarkBtn.setImage(UIImage(systemName: "bookmark"), for: .normal)
                            retableCell.existed = false
                        }
                        self.view.makeToast("Article Removed from Bookmarks", duration: 3.0, position: .bottom)
                    }
                } else {
                    var newsArray = [NewsInfo]()
                    newsArray.append(item)
                    let savedArticles = try! JSONEncoder().encode(newsArray)
                    UserDefaults.standard.set(savedArticles, forKey: "savedArticles")
                    if let retableCell = tableView.cellForRow(at: indexPath) as? SectionNewsCell {
                        retableCell.bookmarkBtn.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                        retableCell.existed = true
                    }
                    self.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view", duration: 3.0, position: .bottom)
                }
            }
            
            return UIMenu(title: "Menu", children: [share, bookmark])
        }
    }
}

extension SectionViewController: SectionNewsDelegate {
    func popUpAddingToast() {
        self.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view", duration: 3.0, position: .bottom)
    }
    
    func popUpRemovingToast() {
        self.view.makeToast("Article Removed from Bookmarks", duration: 3.0, position: .bottom)
    }
}
