
//
//  AllCategoryModelType.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 30/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

protocol AllCategoryModelType {
    var headTitle: String { get }
    var cancelTitle: String { get }
    
    func numberOfItems() -> Int
    
    func presentCategories(isForced: Bool, completion: (()->())?, failure: ((Int)->())?)
    
    func goOnBack()
    func goOnShops(atIndexPath indexPath: IndexPath)
    
    func category(for indexPath: IndexPath) -> (Categories, String)
}

extension AllCategoryModelType {
    var headTitle: String {
        return NSLocalizedString("AllCategoryTitleLabel", comment: "")
    }
    
    var cancelTitle: String {
        return NSLocalizedString("Close", comment: "")
    }
}
