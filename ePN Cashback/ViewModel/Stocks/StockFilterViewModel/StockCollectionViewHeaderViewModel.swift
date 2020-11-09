//
//  StockCollectionViewHeaderViewModel.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 10/06/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class StockCollectionViewHeaderViewModel {
    
    var titleSection: String
    var titleButton: String
    
    init(name title: String, button titleButton: String) {
        self.titleButton = titleButton
        self.titleSection = title
    }
    
}
