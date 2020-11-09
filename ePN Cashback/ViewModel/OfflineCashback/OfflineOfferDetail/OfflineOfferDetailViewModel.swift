//
//  OfflineOfferDetailViewModel.swift
//  Backit
//
//  Created by Александр Кузьмин on 08/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator

class OfflineOfferDetailViewModel: NSObject {
    
    private let offer: OfferOffline!
    private let source: TicketDetailSource!
    private var shopInfo: OfflineShopInfo?
    private var successLoad = false
    private let repository: ReceiptRepositoryProtocol
    private let router: UnownedRouter<OfflineCBRoute>
    private let idOfShop: Int
    private let keyNotification: Notification.Name = .detailPageReceiptQR
    
    init(router: UnownedRouter<OfflineCBRoute>, offlineRepository: ReceiptRepositoryProtocol, offer: OfferOffline, source: TicketDetailSource) {
        self.router = router
        self.repository = offlineRepository
        self.offer = offer
        self.source = source
        self.idOfShop = (offer.type == ShopTypeId.offlineMulty.rawValue) ? LocalSymbolsAndAbbreviations.MULTY_OFFER_ID : offer.id
        super.init()
    }
    
    func getKeyNotificationName() -> Notification.Name {
        return keyNotification
    }
    
    var scanButtonText: String {
        return NSLocalizedString("Scan the receipt", comment: "")
    }
    
    var averageTimeText: String {
        return NSLocalizedString("Average time of waiting cashback", comment: "")
    }
    
    var cashbackText: String {
        return NSLocalizedString("Cashback rates", comment: "")
    }
    
    var conditionsText: String {
        return NSLocalizedString("Conditions", comment: "")
    }
    
    var repeatText: String {
        return NSLocalizedString("Repeat", comment: "")
    }
    
    var offerHeaderImageUrl: String {
        if let logo = shopInfo?.offlineCbImage {
            return logo
        }
        return offer.image ?? ""
    }
    
    var averageTimeValue: String {
        if let shopInfo = shopInfo {
            return shopInfo.confirmTime.isEmpty ? NSLocalizedString("Undefined", comment: "") : shopInfo.confirmTime
        }
        return NSLocalizedString("Undefined", comment: "")
    }
    
    var titleText: String {
        if let shopInfo = shopInfo {
            return shopInfo.title
        }
        return offer.title
    }
    
    func goOnBack() {
        router.trigger(.back)
    }
    
    func sendOpenPageAnalytics() {
        OfflineOfferAnalytics.openOfflineOfferWith(id: offer.id, fromPage: source)
    }
    
    func goOnScan() {
        ///Send event to analytic about scan from detail offer
        Analytics.openEventScanFromDetailOffer()
        OfflineOfferAnalytics.clickOnScanTicket(offerID: offer.id)
        
        router.trigger(.scan(keyNotification))
    }
    
    func goOnShowResultSuccess() {
        router.trigger(.successScan)
    }
    
    func goOnShowResultError(errorMessage: String) {
        router.trigger(.errorScan(errorMessage))
    }
    
    func displayResult(qrString qrCode: String, completion: @escaping (()->())) {
        repository.getResultOfCheck(idOffer: idOfShop, qrString: qrCode) { [weak self] (errorMessage) in
            completion()
            if errorMessage == nil {
                self?.goOnShowResultSuccess()
            } else {
                self?.goOnShowResultError(errorMessage: errorMessage!)
            }
        }
    }
    
    func showOfflineOfferInfo(completion: (()->())?, failure:((Int)->())?) {
        repository.loadShopInfo(id: offer.id, completion: { [weak self] (result) in
            switch result {
            case .success(let shopDetail):
                self?.shopInfo = shopDetail
                self?.successLoad = true
                completion?()
            case .failure(let error):
                failure?(error.code)
            }
        })
    }
    
    func getShopInfo() -> OfflineShopInfo? {
        return shopInfo
    }
    
    func numberOfRates() -> Int {
        return shopInfo?.rates?.count ?? 0
    }
    
    func getConditionText() -> String {
        return shopInfo?.ratesDesc ?? ""
    }
    
    func rate(row: Int) -> OfflineShopInfoRates? {
        if let rates = shopInfo?.rates {
            return rates[row]
        }
        return nil
    }
 
    func isSuccessLoaded() -> Bool {
        return successLoad
    }
    
    func isMultiOffer() -> Bool {
        return offer.type == ShopTypeId.offlineMulty.rawValue
    }
}
