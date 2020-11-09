//
//  ReceiptMainHeaderViewModel.swift
//  Backit
//
//  Created by Ivan Nikitin on 10/02/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation

class ReceiptMainHeaderViewModel {
    
    private var selectedIndexPath: IndexPath?
    private var filter: CategoriesFilter
    
    init(categories: CategoriesFilter) {
        self.filter = categories
    }
    
    func headerText() -> String {
        return NSLocalizedString("Increased cashback", comment: "")
    }
    
    func numberOfItems() -> Int {
        return filter.categories.count
    }
    
    func filterTitle(forIndexPath indexPath: IndexPath) -> String {
        let currentFilter = filter.categories[indexPath.row]
        return currentFilter.name
    }
    
    func isSelectedFilter(forIndexPath indexPath: IndexPath) -> Bool {
        guard let selectedIndex = filter.selected.indexSelected, let selectedName = filter.selected.categorySelected?.name else {
            return false
        }
        
        if selectedIndex == indexPath.row && selectedName == filter.categories[indexPath.row].name {
            return true
        } else {
            return false
        }
    }
    
    func selectRow(atIndexPath indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
    }
    
    func selectedRow() -> IndexPath? {
        return self.selectedIndexPath
    }
    
    func switchOffTapped() {
        filter.deselectFilter()
    }
    
    func switchOnTapped(indexPath index: IndexPath) {
        filter.selectFilter(index: index.row)
    }
}
