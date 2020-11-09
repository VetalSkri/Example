//
//  FilterOfPricesDynamicViewCellViewModel.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 21/05/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

class FilterOfPricesDynamicViewCellViewModel: FilterViewCellModelType {
    
    private var filter: DynamicFilter
    var label: Box<String?> = Box(nil)
    
    func labelTitle() -> String {
        return self.filter.name
    }
    
    func getStatusOfFilter() -> Bool {
        return self.filter.tapped
    }
    
    init(filter currentFilter: DynamicFilter) {
        self.filter = currentFilter
    }
}
