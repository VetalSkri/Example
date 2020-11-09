//
//  StockFilterModelType.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 29/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

protocol StockFilterModelType {
    
    var title: String { get }
    var closeTitle : String { get }
    var buttonText: String { get }
    
    func objectName(forIndexPath: IndexPath) -> String
    func numberOfSections() -> Int
    func numberOfRowsInSection(section: Int) -> Int
    func categoryName(section: Int) -> String
    func isSelectedItem(forIndexPath: IndexPath) -> Bool
    func selectItem(atIndexPath: IndexPath)
    func sectionButtonTitle(section: Int) -> String
    func header(forSection: Int) -> StockCollectionViewHeaderViewModel
    func resetSection(section: Int)
    func getFilters() -> [StockFilterCategory]
    
    func goOnBack()
}

extension StockFilterModelType {
    
    var title: String {
        return NSLocalizedString("Filter", comment: "")
    }
    
    var closeTitle : String {
        return NSLocalizedString("Close", comment: "")
    }
    
    var buttonText: String {
        return NSLocalizedString("Show result", comment: "")
    }
    
}
