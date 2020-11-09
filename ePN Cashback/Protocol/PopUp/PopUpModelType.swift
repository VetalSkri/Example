//
//  PopUpModelType.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 07/09/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import UIKit

protocol PopUpModelType {
    
    func getType() -> EPNPopUp.ContentType
    
    func getHeadTitle() -> String
    
    func getTitleText() -> String
    
    func getInfoText(_ errorCode: Int) -> String
    
    func getButtonTitle() -> String
    
    func getPlaceholderText() -> String
    
    func getPromocode() -> String
    
    func setPromocode(promo: String)
    
    func sendRequestToCheckPromoCode(promo promocode: String, completion: (()->())?, failureHandle: ((Int)->())?)
}

