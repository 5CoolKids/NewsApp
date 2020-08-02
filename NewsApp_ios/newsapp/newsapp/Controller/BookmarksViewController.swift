//
//  BookmarksViewController.swift
//  newsapp
//
//  Created by Yueyang Cheng on 4/10/20.
//  Copyright © 2020 Yueyang Cheng. All rights reserved.
//
import UIKit
import SDWebImage
import Toast_Swift

class BookmarksViewController: UIViewController {
    var newsInMemory:[NewsInfo] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noNewsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedArticles = UserDefaults.standard.data(forKey: "savedArticles") {
            newsInMemory = try! JSONDecoder().decode([NewsInfo].self, from: savedArticles)
            noNewsLabel.text = ""
        } else {
            noNewsLabel.text = "No bookmarks added."
        }
        setUpCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let savedArticles = UserDefaults.standard.data(forKey: "savedArticles") {
            newsInMemory = try! JSONDecoder().decode([NewsInfo].self, from: savedArticles)
            if (newsInMemory.count > 0) {
                noNewsLabel.text = ""
            } else {
                noNewsLabel.text = "No bookmarks added."
            }
            collectionView.reloadData()
        } else {
            noNewsLabel.text = "No bookmarks added."
        }
    }
    
    func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension BookmarksViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsInMemory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let news = newsInMemory[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookmarkCell", for: indexPath) as! BookmarkCell
        cell.bookmarkManagerDelegate = self
        
        cell.setBookmark(news: news)
        if (news.imgUrl == "null") {
            cell.BookmarkImg.image = UIImage(named: "default-guardian")
        } else {
            let imageUrl:NSURL? = NSURL(string: news.imgUrl)
            if let url = imageUrl {
                cell.BookmarkImg.sd_setImage(with: url as URL)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "DetailsViewController") as? DetailsViewController
        vc?.id = newsInMemory[indexPath.item].id
        vc?.webUrl = newsInMemory[indexPath.item].url
        vc?.date = newsInMemory[indexPath.item].date
        vc?.time = newsInMemory[indexPath.item].time
        vc?.imgUrl = newsInMemory[indexPath.item].imgUrl
        vc?.newstitle = newsInMemory[indexPath.item].title
        vc?.source = newsInMemory[indexPath.item].section
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration?{
        let item = newsInMemory[indexPath.item]
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            
            // Create an action for sharing
            let share = UIAction(title: "Share with Twitter", image: UIImage(named: "twitter")) { action in
                let twitterUrl = "https://www.twitter.com/share?hashtags=CSCI_571_NewsApp&url=\(item.url)&text=Check%20out%20this%20Article%21%20"
                UIApplication.shared.open(URL(string: twitterUrl)!, options:[:], completionHandler: nil)
            }
            
            
            let bookmark = UIAction(title: "Bookmark", image: UIImage(systemName: "bookmark.fill")) { action in
                if var savedArticles = UserDefaults.standard.data(forKey: "savedArticles") {
                    let newsArray = try! JSONDecoder().decode([NewsInfo].self, from: savedArticles)
                    
                    var temp:[NewsInfo] = []
                    for i in 0..<newsArray.count {
                        if newsArray[i].id != item.id {
                            temp.append(newsArray[i])
                        }
                    }
                    savedArticles = try! JSONEncoder().encode(temp)
                    UserDefaults.standard.set(savedArticles, forKey: "savedArticles")
                    
                    self.view.makeToast("Article Removed from Bookmarks", duration: 3.0, position: .bottom)
                    self.newsInMemory = try! JSONDecoder().decode([NewsInfo].self, from: savedArticles)
                    
                    if self.newsInMemory.count == 0 {
                        self.noNewsLabel.text = "No bookmarks added."
                    } else {
                        self.noNewsLabel.text = ""
                    }
                    collectionView.reloadData()
                }
                
            }
            
            return UIMenu(title: "Menu", children: [share, bookmark])
        }
    }
}

extension BookmarksViewController: BookmarkManagerDelegate {
    func needUpdateBookmarkPage() {
        if let savedArticles = UserDefaults.standard.data(forKey: "savedArticles") {
            newsInMemory = try! JSONDecoder().decode([NewsInfo].self, from: savedArticles)
            if newsInMemory.count == 0 {
                noNewsLabel.text = "No bookmarks added."
            } else {
                noNewsLabel.text = ""
            }

        }
        collectionView.reloadData()
    }
    
    func popUpToast() {
        self.view.makeToast("Article Removed from Bookmarks", duration: 3.0, position: .bottom)
    }
}
