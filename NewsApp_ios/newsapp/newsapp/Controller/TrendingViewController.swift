//
//  TrendingViewController.swift
//  newsapp
//
//  Created by Yueyang Cheng on 4/10/20.
//  Copyright © 2020 Yueyang Cheng. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Charts


class TrendingViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textInput: UITextField!
    @IBOutlet weak var chtChart: LineChartView!
    var trendData:[Double] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        textInput.delegate = self
        fetchTrendData(keyword: "Coronavirus", displayKeyword: "Coronavirus")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let key = textInput.text!
        let keyword = key.replacingOccurrences(of: " ", with: "+")
        fetchTrendData(keyword: keyword, displayKeyword: key)
        return true
    }
    
    func fetchTrendData(keyword: String, displayKeyword: String) {
        trendData = []
        let fetchTrendURL = "https://newsapp-backend-yyc.appspot.com/search_keyword?q=\(keyword)"
        Alamofire.request(fetchTrendURL).responseJSON { response in
            if let data = response.result.value {
                let safeData = JSON(data)["finalRes"]
                for i in 0...(safeData.count - 1) {
                    self.trendData.append(safeData[i]["value"].double!)
                }
            }
            self.updateGraph(term: displayKeyword)
        }
    }
    
    func updateGraph(term: String) {
        var lineChartEntry = [ChartDataEntry]()
        for i in 0...(trendData.count - 1) {
            let value = ChartDataEntry(x: Double(i), y:trendData[i])
            lineChartEntry.append(value)
        }
        let line1 = LineChartDataSet(entries: lineChartEntry, label: "Trending Chart for \(term)")
        line1.colors = [NSUIColor.systemBlue]
        line1.drawCircleHoleEnabled = false
        line1.circleColors = [NSUIColor.systemBlue]
        line1.circleRadius = 4
        
        let data = LineChartData()
        data.addDataSet(line1)
        chtChart.data = data
    }
}
