//
//  RegAuthAnalytics.swift
//  Backit
//
//  Created by Александр Кузьмин on 11/02/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
import Crashlytics

final class AuthAnalytics {
    
    static let eventName = "Auth"
    
    private enum EventTypes: String {
        case Open = "Open"
        case Clicked = "Clicked"
        case Auth = "Authorization"
        case Register = "Registration"
        case Promocode = "Promocode"
        case Send = "Send email"
    }
    
    enum EventTypeValues: String {
        case Auth = "AuthorizationPage"
        case Register = "RegistrationPage"
        case Promocode = "EnterPromocodePopup"
        case BindEmailPopup = "SocialBindPopup"
        case BindSocial = "BindSocialEmailPage"
        case ForgotPassword = "ForgotPasswordPage"
        case EnterNewPassword = "EnterNewPasswordFromEmailPage"
        case Webmaster = "WebmasterPage"
        case Email = "Recovery emails"
    }
    
    class func auth(type: String) {
        Answers.logCustomEvent(withName: eventName, customAttributes: [EventTypes.Auth.rawValue: type])
    }
    
    class func register(type: String) {
        Answers.logCustomEvent(withName: eventName, customAttributes: [EventTypes.Register.rawValue: type])
    }
    
    class func enterPromocode() {
        Answers.logCustomEvent(withName: eventName, customAttributes: [EventTypes.Promocode.rawValue: true])
    }
    
    class func open(page: EventTypeValues) {
        Answers.logCustomEvent(withName: eventName, customAttributes: [EventTypes.Open.rawValue: page])
    }
    
    class func successSendEmail() {
        Answers.logCustomEvent(withName: eventName, customAttributes: [EventTypes.Send.rawValue: EventTypeValues.Email])
    }
    
}
