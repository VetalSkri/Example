//
//  FilterOfStocksViewCellModelType.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 13/03/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

protocol FilterViewCellModelType {
 
    var label: Box<String?> { get set }
    
    func labelTitle() -> String
    
    func getStatusOfFilter() -> Bool
}
