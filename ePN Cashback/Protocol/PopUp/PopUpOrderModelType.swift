//
//  PopUpOrderModelType.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 16/11/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import UIKit

protocol PopUpOrderModelType: DownloaderImagesProtocol {
    
    var image: Box<UIImage?> { get }
    func titleOfStatus() -> String
    func identifierOfOrder() -> String
    func costOfOrder() -> String
    func cashbackForUser() -> String
    func currencyOfOrder() -> String
    func typeOfOrderStatus() -> OrderStatus
    func linkText() -> String
    func linkTitle() -> String
    func firstStatusInfo() -> String
    func secondStatusErrorInfo() -> String
    func secondStatusSuccesInfo() -> String
    func getLogo() -> UIImage
    
    
    var cashbackTitle: String { get }
    var priceTitle: String { get }
    func cashbackAmount() -> String
    func priceAmount() -> String
    var appearingInProccessTitle: String { get }
    func firstStatusDate() -> String
    func secondStatusTitle() -> String
    func secondStatusDate() -> String
    func isMultiOffer() -> Bool
    func goOnBack()
}

extension PopUpOrderModelType {
    
    func getLogo() -> UIImage {
        return UIImage(named: "defaultStore")!
    }
    
    var cashbackTitle: String {
        return "\(NSLocalizedString("cashback_title", comment: "")):"
    }
    
    var priceTitle: String {
        return "\(NSLocalizedString("price_title", comment: "")):"
    }
    
    var appearingInProccessTitle: String {
        return NSLocalizedString("appearceToProcessing", comment: "")
    }
    
}
