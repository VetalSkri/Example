//
//  CustomBottomAxisFormatter.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 09/04/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import Charts

class CustomBottomAxisFormatter: NSObject, IAxisValueFormatter {
    
    private var scores: [CostOfGoods]?
    
    convenience init(usingScore scores: [CostOfGoods]) {
        self.init()
        self.scores = scores
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let index = Int(value)
        
        guard let scores = scores, index < scores.count else {
            return "?"
        }
        let dateString = scores[index].date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateString)!
        dateFormatter.dateFormat = "dd.MM.yy"
        return dateFormatter.string(from: date)
    }
    
    
}
