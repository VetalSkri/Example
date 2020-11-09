//
//  PromocodeCheckResultModelType.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 29/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

protocol PromocodeCheckResultModelType {
    
    var headTitle: String { get }
    var headerStatusResultTitle: String { get }
    var activatePeriodTitle: String { get }
    var validityTitle: String { get }
    var activateButtonTitle: String { get }
    
    func goOnBack()
    
    
    func promocodeNameText() -> String
    func activatePeriodText() -> String
    func validityText() -> String
    func currentPromocode() -> PromocodeInfo
    func convertToDateTime(dateString: String) -> String
    func activatePromocode(completion: ((PromocodeActivateInfo)->())?, failure: (()->())?)
    
}

extension PromocodeCheckResultModelType {
    
    var headTitle: String {
        return NSLocalizedString("PromocodeResult", comment: "")
    }
    
    var headerStatusResultTitle: String {
        return NSLocalizedString("ActivationAvailable", comment: "")
    }
    
    var activatePeriodTitle: String {
        return NSLocalizedString("ActivationTimePromocode", comment: "")
    }
    
    var validityTitle: String {
        return NSLocalizedString("ValidityPromocode", comment: "")
    }
    
    var activateButtonTitle: String {
        return NSLocalizedString("ActivatePromocode", comment: "")
    }
}
