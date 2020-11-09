//
//  ManualEnterCheckModelType.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 02/08/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

protocol ManualEnterCheckModelType {
    
    var title: String { get }
    var hintText: String { get }
    var buttonText: String { get }
    
    func goOnBack()
    func goOnScan()
    func goOnHint()
    func goOnClose(qrString: String)
    
}

extension ManualEnterCheckModelType {
    
    var title: String {
        return NSLocalizedString("Entering receipt data", comment: "")
    }
    
    var hintText: String {
        return NSLocalizedString("How to find the necessary data on the receipt?", comment: "")
    }
    
    var buttonText: String {
        return NSLocalizedString("Send", comment: "")
    }
    var dateTimePlaceholderText: String {
        return NSLocalizedString("Date and time of purchase", comment: "")
    }
    var costPlaceholderText: String {
        return NSLocalizedString("Amount of receipt", comment: "")
    }
    var fnPlaceholderText: String {
        return NSLocalizedString("Fiscal memory device (\"ФН\")", comment: "")
    }
    var fdPlaceholderText: String {
        return NSLocalizedString("Fiscal documents (\"ФД\")", comment: "")
    }
    var fpPlaceholderText: String {
        return NSLocalizedString("Fiscal code of documents (\"ФП\" or \"ФПД\")", comment: "")
    }
    var dateTimeHintText: String {
        return NSLocalizedString("Specified at the beginning or at the end of receipt", comment: "")
    }
    var costHintText: String {
        return NSLocalizedString("Specify cost of the purchase with kopecks", comment: "")
    }
    var fnHintText: String {
        return NSLocalizedString("16 numbers specified at the beginning or at the end of receipt", comment: "")
    }
    var fdHintText: String {
        return NSLocalizedString("3-5 numbers specified at the end of receipt", comment: "")
    }
    var fpHintText: String {
        return NSLocalizedString("8-10 numbers specified at the end of receipt", comment: "")
    }
    
}
