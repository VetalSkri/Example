//
//  FilterOfShopViewCellModelType.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 27/11/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import Foundation

protocol FilterOfShopViewCellModelType: class {
    
    var nameOfCategory: String { get }
    
    func getStatusOfSelected() -> Bool
    
    func changeStatusOfSelected()
}
