//
//  LabelCellOfShopMainHeaderViewModel.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 12/02/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

class CategoryCellOfShopMainHeaderViewModel {
    
    private var category: Categories
    
    init(category currentCategory: Categories) {
        self.category = currentCategory
    }
    
    var headTitle: String {
        return String(describing: category.name)
    }
    
    func getCategoryId() -> Int {
        return category.id
    }
    
    
}
