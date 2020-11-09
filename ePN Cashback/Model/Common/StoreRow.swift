//
//  StoreRow.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 15/10/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import Foundation

class StoreRow {
    private var labelValue: Labels
    private var storesValue: [Store]
    
    init(labels: Labels, stores: [Store]?) {
        self.labelValue = labels
        self.storesValue = []
        if let stores = stores {
            self.storesValue.append(contentsOf: stores)
        }
    }
    
    func setStores(stores: [Store]) {
        self.storesValue.removeAll()
        self.storesValue.append(contentsOf: stores)
    }
    
    func getLabelId() -> Int {
        return labelValue.id
    }
    
    func getLabelName() -> String {
        return labelValue.name
    }
    func getLabel() -> Labels {
        return labelValue
    }
    func setStore(_ store: Store) {
        self.storesValue.append(store)
    }
    func getStores() -> [Store] {
        return storesValue
    }
    
}
