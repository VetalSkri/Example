//
//  VerifyLinkResultModelType.swift
//  Backit
//
//  Created by Ivan Nikitin on 13/01/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit

protocol VerifyLinkResultModelType: DownloaderImagesProtocol, RedirectLinkProtocol {
    
    var buttonInfoText: String { get }
    var dynamicButtonInfoText: String { get }
    var headResultText: String { get}
    var hotSaleTitle: String { get }
    
    func hotSaleStatus() -> Bool?
    func affiliateStatus() -> Int
    func affiliateMessage() -> String?
    func messageTitle() -> String
    func unaffiliateMessageTitle() -> String
    func unaffiliatePercentCashbackTitle() -> String 
    func productName() -> String?
    func hotSalePercent() -> String
    func urlStringOfLogo() -> String?
    func urlStringOfLeftLogo() -> String?
    func defaultLogo() -> UIImage
    func redirectLink() -> String
    func goOnBack()
    func goOnNoData()
    func goOnDynamic()
    func openStore(completion: @escaping ((URL)->()))
    func priceDynamics(completion: (()->())?, failure: ((Int)->())?)
}

extension VerifyLinkResultModelType {
    
    var buttonInfoText: String {
        return NSLocalizedString("To the store", comment: "")
    }
    
    var dynamicButtonInfoText: String {
        return NSLocalizedString("Link Price dynamics", comment: "")
    }
    
    var headResultText: String {
        return NSLocalizedString("You will receive cashback", comment: "")
    }
    
    var hotSaleTitle: String {
        return "Hotsale"
    }
      
}
