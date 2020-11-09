//
//  CategoryOfShop.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 27/11/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import Foundation

class CategoryOfShop {
    private var category: Categories
    private var isActive: Bool

    init(category: Categories) {
        self.category = category
        self.isActive = false
    }

    func getStatus() -> Bool {
        return isActive
    }

    func getCategoryId() -> String? {
        return String(category.id)
    }

    func getCategoryName() -> String? {
        return category.name
    }

    func getCategory() -> Categories {
        return category
    }

    func setStatus(is selected: Bool) {
        isActive = selected
    }

    func resetStatus() {
        isActive = false
    }
}
