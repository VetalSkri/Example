//
//  PromocodesModelType.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 29/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

protocol PromocodesModelType: SyncClosure {
    
    var isErrorCheckPromo: Bool  { get }
    var isActivating: Bool  { get }
    
    var headTitle: String { get }
    var infoText: String { get }
    var getPlaceholderText: String { get }
    var buttonText: String { get }
    var getTextForEmptyPromocodes: String { get }
    
    func goOnVerifyLink()
    func goOnCheckPromocode()
    func goOnBack()
    func goOnShowActivatePromocodeResult()
    
    func errorMessage() -> String
    func getErrorCode() -> Int
    func numberOfSections() -> Int
    func numberOfItemsInSection(section: Int) -> Int
    func cellViewModel(index: Int) -> PromocodeViewCellViewModel?
    func setPromocode(promocode: String)
    func checkPromocode(completion: (()->())?, failure: ((String?)->())?)
    func activateNewPromocode(_ activatedPromocode: PromocodeActivateInfo?)
    func isPagingPromocodes(atIndexPath indexPath: IndexPath) -> Bool
    func loadListOfPromocodes(completion: (()->())?, failure: (()->())?)
    func pagingListOfPromocodes(completion: (()->())?, failure: (()->())?)
    func cacheLifeTimeIsExpired() -> Bool
    
}

extension PromocodesModelType {
    var headTitle: String {
        return NSLocalizedString("Promocodes", comment: "")
    }
    
    var infoText: String {
        return NSLocalizedString("CheckInfoAboutPromo", comment: "")
    }
    
    var getPlaceholderText: String {
        return NSLocalizedString("Enter a promo code", comment: "")
    }
    
    var buttonText: String {
        return NSLocalizedString("Check", comment: "")
    }
    
    var getTextForEmptyPromocodes: String {
        return NSLocalizedString("EmptyPromocodePage", comment: "")
    }
    
}
