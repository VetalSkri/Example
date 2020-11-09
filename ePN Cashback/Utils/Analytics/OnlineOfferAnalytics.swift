//
//  OnlineOfferAnalytics.swift
//  Backit
//
//  Created by Elina Batyrova on 12.07.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation

final class OnlineOfferAnalytics: AppMetricaProtocol, FirebaseProtocol {
    
    private enum EventName: String {
        case openOnlineOffer = "OpenOnlineOffer"
        case buyWithCB = "BuyWithCashback"
    }
    
    private enum EventParams: String {
        case offerID = "offerId"
        case fromPage = "fromPage"
    }
    
    class func openOnlineOfferWith(id offerID: Int, fromPage: ShopDetailSource) {
        let params: [String: Any] = [EventParams.offerID.rawValue: offerID,
                                     EventParams.fromPage.rawValue: fromPage.rawValue]
        let eventName = EventName.openOnlineOffer.rawValue
        
        reportToAppMetrica(params: params, eventName: eventName)
        reportToFirebase(params: params, eventName: eventName)
    }
    
    class func clickOnBuyWithCB(offerID: Int) {
        let params = [EventParams.offerID.rawValue: offerID]
        let eventName = EventName.buyWithCB.rawValue
        
        reportToAppMetrica(params: params, eventName: eventName)
        reportToFirebase(params: params, eventName: eventName)
    }
}
