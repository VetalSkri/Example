//
//  PopUpInfoModelType.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 29/03/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

protocol PopUpInfoModelType {
    
    func goOnClose()
    
    func getTitleText() -> String
    func getImageInfo() -> UIImage?
}

