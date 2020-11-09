//
//  VerifyLinkResultViewModel.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 25/03/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import XCoordinator

class VerifyLinkResultViewModel: VerifyLinkResultModelType {
    
    private var urlLink: String
    private var offerLinkInfo: OfferLinkInfo
    private let period = "two_months"
    private var priceDynamics: PriceDynamicsResponse?
    private let router: UnownedRouter<VerifyLinkRoute>
    
    init(router: UnownedRouter<VerifyLinkRoute>, link urlLink: String, linkInfo offerLinkInfo: OfferLinkInfo) {
        self.router = router
        self.urlLink = urlLink
        self.offerLinkInfo = offerLinkInfo
    }
    
    
    func hotSaleStatus() -> Bool? {
        return offerLinkInfo.isHotsale
    }
    
    func affiliateStatus() -> Int {
        return offerLinkInfo.affiliateType
    }
    
    func affiliateMessage() -> String? {
        switch offerLinkInfo.affiliateType {
        case 1:
            return NSLocalizedString("Affiliated product", comment: "")
        case 2:
            return NSLocalizedString("Non-affiliated product", comment: "")
        default:
            return nil
        }
    }
    
    func messageTitle() -> String {
        guard let message = offerLinkInfo.cashback else { return NSLocalizedString("Cashback rate depends on item", comment: "") }
        return "\(NSLocalizedString("You cashback is", comment: "")) \(message)"
    }
    
    func unaffiliateMessageTitle() -> String {
        return NSLocalizedString("Your cashback depends on the country of delivery", comment: "")
    }
    
    func unaffiliatePercentCashbackTitle() -> String {
        return offerLinkInfo.cashback ?? ""
    }
    
    func productName() -> String? {
        guard let productName = offerLinkInfo.productName else { return nil }
        return "\(NSLocalizedString("Product:", comment: "")) \(String(describing: productName))"
    }
    
    func hotSalePercent() -> String {
        guard let message = offerLinkInfo.cashback else { return NSLocalizedString("Cashback rate depends on item", comment: "") }
        return "\(NSLocalizedString("You cashback is", comment: "")) \(message)"
    }
    
    func urlStringOfLeftLogo() -> String? {
        return offerLinkInfo.logoSmall
    }
    
    func urlStringOfLogo() -> String? {
        return offerLinkInfo.image
    }
    
    func defaultLogo() -> UIImage {
        return UIImage(named: "defaultStore")!
    }
    
    func redirectLink() -> String {
        return offerLinkInfo.redirectUrl
    }
    
    func goOnBack() {
        router.trigger(.back)
    }
    
    func goOnNoData() {
        router.trigger(.noDynamics)
    }
    
    func goOnDynamic() {
        guard let currentPriceDynamics = priceDynamics else { return }
        PriceDynamicsAnalytics.showPriceDynamicsClicked()
        router.trigger(.dynamics(urlLink, currentPriceDynamics, offerLinkInfo))
    }
    
    func openStore(completion: @escaping ((URL)->())) {
        PriceDynamicsAnalytics.buyWithCashbackClicked(fromPriceDynamics: false)
        checkLinkForMobileApp(offerLinkInfo) { (urlLink) in
            completion(urlLink)
        }
    }
    
    func priceDynamics(completion: (()->())?, failure: ((Int)->())?) {
        VerifyLinkApiClient.priceDynamics(link: urlLink, period: period) { [weak self] (result) in
            switch result {
            case .success(let response):
                self?.priceDynamics = response
                completion?()
                break
            case .failure(let error):
                failure?((error as NSError).code)
                break
            }
        }
    }
}
