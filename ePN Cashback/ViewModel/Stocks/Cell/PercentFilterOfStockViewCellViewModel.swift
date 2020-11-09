//
//  PercentFilterOfStockViewCellViewModel.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 13/03/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

class PercentFilterOfStockViewCellViewModel: FilterViewCellModelType {
   
    private var filter: StockFilter
    var label: Box<String?> = Box(nil)
    
    func labelTitle() -> String {
        return self.filter.name
    }
    
    func getStatusOfFilter() -> Bool {
        return self.filter.tapped
    }
    
    init(filter currentFilter: StockFilter) {
        self.filter = currentFilter
    }
}
