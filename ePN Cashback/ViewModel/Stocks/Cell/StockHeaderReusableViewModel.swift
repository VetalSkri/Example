//
//  StockHeaderReusableViewModel.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 13/03/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

class StockHeaderReusableViewModel {
    
    private var selectedIndexPath: IndexPath?
    private var filter:[StockFilter]
    
    init() {
        self.filter = [StockFilter]()
        initDefaultFilter()
    }
    
    func headerText() -> String {
        return NSLocalizedString("Increased cashback", comment: "")
    }
    
    func numberOfItems() -> Int {
        return filter.count
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> FilterViewCellModelType? {
        let currentFilter = filter[indexPath.row]
        return PercentFilterOfStockViewCellViewModel(filter: currentFilter)
    }
    
    func selectRow(atIndexPath indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
    }
    
    func initDefaultFilter() {
        let maxFilterPercent = StockFilter(id: 0, start: 90, end: 100, name: "90%")
        let upAverageFilterPercent = StockFilter(id: 1, start: 60, end: 89, name: "60% - 89%")
        let lowAverageFilterPercent = StockFilter(id: 2, start: 30, end: 59, name: "30% - 59%")
        let minFilterPercent = StockFilter(id: 3, start: 3, end: 29, name: "3% - 29%")
        filter.append(maxFilterPercent)
        filter.append(upAverageFilterPercent)
        filter.append(lowAverageFilterPercent)
        filter.append(minFilterPercent)
    }
    
    func switchOffTapped(indexPath index: IndexPath) {
        filter[index.row].tapped = false
    }
    
    func switchOnTapped(indexPath index: IndexPath) -> StockFilter {
        filter[index.row].tapped = true
        return filter[index.row]
    }
    
}

public class StockFilter {
    var id: Int
    var startRange: Int
    var endRange: Int
    var name: String
    var tapped: Bool
    
    init(id: Int, start: Int, end: Int, name: String, tapped: Bool = false) {
        self.id = id
        self.startRange = start
        self.endRange = end
        self.name = name
        self.tapped = tapped
    }
}
