//
//  PriceDynamicsAnalytics.swift
//  Backit
//
//  Created by Александр Кузьмин on 09/01/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
import Crashlytics

final class PriceDynamicsAnalytics {
    
    static let eventName = "PriceDynamics"
    
    private enum EventTypes: String {
        case Open = "Open"
        case Clicked = "Clicked"
    }
    
    private enum EventTypeValues: String {
        case VerifyLinkOpen = "VerifyLink"
        case PriceDynamicOpen = "PriceDynamic"
        case CheckButtonClicked = "CheckLinkButton"
        case BuyWithCashbackClicked = "BuyWithCashbackButton"
        case ShowPriceDynamicsClicked = "ShowPriceDynamicsButton"
        case FaqClicked = "FaqButton"
    }
    
    class func verifyLinkOpen() {
        Answers.logCustomEvent(withName: eventName, customAttributes: [EventTypes.Open.rawValue: EventTypeValues.VerifyLinkOpen.rawValue])
    }
    
    class func priceDynamicsOpen() {
        Answers.logCustomEvent(withName: eventName, customAttributes: [EventTypes.Open.rawValue: EventTypeValues.PriceDynamicOpen.rawValue])
    }
    
    class func checkClicked() {
        Answers.logCustomEvent(withName: eventName, customAttributes: [EventTypes.Clicked.rawValue: EventTypeValues.CheckButtonClicked.rawValue])
    }
    
    class func buyWithCashbackClicked(fromPriceDynamics: Bool) {
        Answers.logCustomEvent(withName: eventName, customAttributes: [EventTypes.Clicked.rawValue: EventTypeValues.BuyWithCashbackClicked.rawValue, "fromPriceDynamicsDetailPage": fromPriceDynamics])
    }
    
    class func showPriceDynamicsClicked() {
        Answers.logCustomEvent(withName: eventName, customAttributes: [EventTypes.Clicked.rawValue: EventTypeValues.ShowPriceDynamicsClicked.rawValue])
    }
    
    class func faqClicked() {
        Answers.logCustomEvent(withName: eventName, customAttributes: [EventTypes.Clicked.rawValue: EventTypeValues.FaqClicked.rawValue])
    }
    
}
