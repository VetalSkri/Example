//
//  OfflineOfferAnalytics.swift
//  Backit
//
//  Created by Elina Batyrova on 12.07.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation

final class OfflineOfferAnalytics: AppMetricaProtocol, FirebaseProtocol {
    
    private enum EventName: String {
        case openOfflineOffer = "OpenOfflineOffer"
        case scanTicket = "ScanTicket"
    }
    
    private enum EventParams: String {
        case offerID = "offerId"
        case fromPage = "fromPage"
    }
    
    class func openOfflineOfferWith(id offerID: Int, fromPage: TicketDetailSource) {
        let params: [String: Any] = [EventParams.offerID.rawValue: offerID,
                                     EventParams.fromPage.rawValue: fromPage.rawValue]
        let eventName = EventName.openOfflineOffer.rawValue
        
        reportToAppMetrica(params: params, eventName: eventName)
        reportToFirebase(params: params, eventName: eventName)
    }
    
    class func clickOnScanTicket(offerID: Int) {
        let params = [EventParams.offerID.rawValue: offerID]
        let eventName = EventName.scanTicket.rawValue
        
        reportToAppMetrica(params: params, eventName: eventName)
        reportToFirebase(params: params, eventName: eventName)
    }
}
