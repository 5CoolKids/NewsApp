//
//  SearchViewController.swift
//  newsapp
//
//  Created by Yueyang Cheng on 4/21/20.
//  Copyright © 2020 Yueyang Cheng. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol SearchResultDelegate {
    func displaySearchResult(query: String)
}

class SearchViewController: UIViewController {

    var wordsBank:[String] = []
    
    @IBOutlet weak var tableView: UITableView!
    var searchResultDelegate: SearchResultDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordsBank.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTermCell") as! SearchTermCell
        cell.setKeyword(keyword: wordsBank[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchResultDelegate.displaySearchResult(query: wordsBank[indexPath.row])
    }
}


