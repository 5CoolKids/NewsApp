//
//  ViewController.swift
//  newsapp
//
//  Created by Yueyang Cheng on 4/9/20.
//  Copyright © 2020 Yueyang Cheng. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import SDWebImage
import SwiftSpinner
import Toast_Swift

class ViewController: UIViewController, CLLocationManagerDelegate, WeatherManagerDelegate {
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    lazy var geocoder = CLGeocoder()
    
    @IBOutlet weak var tableView: UITableView!
    var newsList: [NewsInfo] = []
    var weatherInfo = WeatherInfo(image: UIImage(named: "cloudy_weather")!, temp: "loading..", condition: "loading..", city: "loading..", state: "loading..")
    
    var searchViewController: SearchViewController?
    var searchController: UISearchController!
    var wordsBank:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchHomeNews(fresh: false)
                
        configureRefreshControl()
        locationManager.requestWhenInUseAuthorization()
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
        weatherManager.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        // set up search bar
        searchViewController = storyboard!.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController
        searchViewController?.searchResultDelegate = self
        searchController = UISearchController(searchResultsController: searchViewController)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Enter Keyword.."
    }
    
    func configureRefreshControl () {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        fetchHomeNews(fresh: true)
        self.tableView.reloadData()
        // Dismiss the refresh control.
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func fetchHomeNews(fresh: Bool) {
        let homeURL = "https://newsapp-backend-yyc.appspot.com/home"
        if (!fresh) {
            SwiftSpinner.show("Loading Home Page..")
        } else {
            self.newsList = []
        }
        
        Alamofire.request(homeURL).responseJSON { response in
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
    
    func fetchKeywords(query: String) {
        if query == "" {
            wordsBank.removeAll()
            //self.tableView.reloadData()
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
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations location:[CLLocation]) {
        let lastLocation = location[0]
        // Geocode Location
        geocoder.reverseGeocodeLocation(lastLocation) { (placemarks, error) in
            // Process Response
            self.getLocation(withPlacemarks: placemarks, error: error)
        }
        
    }
    
    private func getLocation(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        if let error = error {
            print("Unable to Reverse Geocode Location (\(error)), or no new location input")
        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                if let city = placemark.locality {
                    weatherManager.fetchWeather(cityName: city)
                    weatherInfo.setCity(city: city)
                }
                weatherInfo.setState(state: placemark.administrativeArea!)
            } else {
                print("No Matching Addresses Found")
            }
        }
    }
    
    func didUpdateWeather(_ weatherManager:WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.weatherInfo.setOther(image: UIImage(named: weather.weatherName)!, temp: weather.tempertureString, condition: weather.weatherCondition)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let weather = weatherInfo
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell") as! WeatherCell
            cell.setWeather(weatherInfo: weather)
            
            return cell
        } else {
            let news = newsList[indexPath.row - 1]
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as! NewsCell
            cell.newsManagerDelegate = self
            if (news.imgUrl == "null") {
                cell.newsImgView.image = UIImage(named: "default-guardian")
            } else {
                let imageUrl:NSURL? = NSURL(string: news.imgUrl)
                if let url = imageUrl {
                    cell.newsImgView.sd_setImage(with: url as URL)
                }
            }
            cell.setNews(news: news)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row > 0) {
            let vc = storyboard?.instantiateViewController(identifier: "DetailsViewController") as? DetailsViewController
            vc?.id = newsList[indexPath.row - 1].id
            vc?.webUrl = newsList[indexPath.row - 1].url
            vc?.date = newsList[indexPath.row - 1].date
            vc?.time = newsList[indexPath.row - 1].time
            vc?.imgUrl = newsList[indexPath.row - 1].imgUrl
            vc?.newstitle = newsList[indexPath.row - 1].title
            vc?.source = newsList[indexPath.row - 1].section
            self.navigationController?.pushViewController(vc!, animated: true)
        } else {
            print("not able to view details of weather")
        }
        
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let item = newsList[indexPath.row - 1]
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            
            // Create an action for sharing
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
                        if let retableCell = tableView.cellForRow(at: indexPath) as? NewsCell {
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
                        if let retableCell = tableView.cellForRow(at: indexPath) as? NewsCell {
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
                    if let retableCell = tableView.cellForRow(at: indexPath) as? NewsCell {
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


extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.count > 2) {
            self.fetchKeywords(query: searchText)
        }
        print("update: new text is \(searchText)")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancel")
        searchBar.text = ""
    }
    
    /*func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }*/
}

extension ViewController: NewsManagerDelegate {
    func popUpAddingToast() {
        self.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view", duration: 3.0, position: .bottom)
    }
    
    func popUpRemovingToast() {
        self.view.makeToast("Article Removed from Bookmarks", duration: 3.0, position: .bottom)
    }
}

extension ViewController: SearchResultDelegate {
    func displaySearchResult(query: String) {
        let searchRes = storyboard?.instantiateViewController(withIdentifier: "SectionViewController") as? SectionViewController
        searchRes!.search = true
        searchRes!.searchQuery = query
        self.navigationController?.pushViewController(searchRes!, animated: true)
    }
}
