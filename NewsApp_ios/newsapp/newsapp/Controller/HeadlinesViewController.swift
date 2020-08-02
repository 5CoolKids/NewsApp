//
//  HeadlinesViewController.swift
//  newsapp
//
//  Created by Yueyang Cheng on 4/10/20.
//  Copyright © 2020 Yueyang Cheng. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire
import SwiftyJSON

class HeadlinesViewController: ButtonBarPagerTabStripViewController, UISearchBarDelegate, UISearchControllerDelegate {
    
    var searchViewController: SearchViewController?
    var searchController: UISearchController!

    var wordsBank:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // change selected bar color
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = .systemBlue
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 1.25
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .gray
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = {(oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .gray
            newCell?.label.textColor = .systemBlue
        }
        
        searchViewController = storyboard!.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController
        searchViewController?.searchResultDelegate = self
        setupNavBar()
    }
    
    func setupNavBar() {
        print("test")
        searchController = UISearchController(searchResultsController: searchViewController)
        //searchController.delegate = self
        //searchController.searchResultsUpdater = searchController as? UISearchResultsUpdating
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Enter Keyword.."
    }
    

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let secOne = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SectionViewController") as! SectionViewController
        secOne.sectionName = "WORLD"
        
        let secTwo = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SectionViewController") as! SectionViewController
        secTwo.sectionName = "BUSINESS"
        
        let secThree = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SectionViewController") as! SectionViewController
        secThree.sectionName = "POLITICS"
        
        let secFour = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SectionViewController") as! SectionViewController
        secFour.sectionName = "SPORTS"
        
        let secFive = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SectionViewController") as! SectionViewController
        secFive.sectionName = "TECHNOLOGY"
        
        let secSix = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SectionViewController") as! SectionViewController
        secSix.sectionName = "SCIENCE"
        
        return [secOne, secTwo, secThree, secFour, secFive, secSix]
    }
    
    func fetchKeywords(query: String) {
        if query == "" {
            wordsBank.removeAll()
            return
        }
        let queryURL = "https://api.cognitive.microsoft.com/bing/v7.0/suggestions?q=\(query)"
        let headers: HTTPHeaders = [
            "Ocp-Apim-Subscription-Key": "d5ad46e790e843e1bc8e69ea73a2cbaf"
        ]
        Alamofire.request(queryURL, headers: headers).responseJSON { response in
            var currWords:[String] = []
            if let data = response.result.value {
                let safeData = JSON(data)["suggestionGroups"][0]["searchSuggestions"]
                
                for i in 0..<safeData.count {
                    let keyword = safeData[i]["displayText"].string
                    currWords.append(keyword!)
                }
                self.wordsBank = currWords
            }
            self.searchViewController?.wordsBank = self.wordsBank
            self.searchViewController?.tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.count > 2) {
            self.fetchKeywords(query: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
}

extension HeadlinesViewController: SearchResultDelegate {
    func displaySearchResult(query: String) {
        let searchRes = storyboard?.instantiateViewController(withIdentifier: "SectionViewController") as? SectionViewController
        searchRes!.search = true
        searchRes!.searchQuery = query
        self.navigationController?.pushViewController(searchRes!, animated: true)
    }
}
