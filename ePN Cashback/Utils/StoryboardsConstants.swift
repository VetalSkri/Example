//
//  Constants.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 10/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

// MARK:- Typealiases
typealias CompletionBlock      = () -> ()
typealias AlertCompletionBlock = (String) -> ()

// MARK:- Storyboards enum
enum Storyboards: String {
    
    case authorization = "Auth"
    case main          = "Main"
    case rules         = "RulesOfService"
    case faq           = "FAQ"
    case captcha       = "CaptchaPopUp"
    case popup         = "PopUpInfo"
    case shops         = "ShopsMain"
    case offlineCB     = "OfflineCB"
    case account       = "AccountMain"
    case orders        = "OrdersMain"
    case stocks        = "StocksMain"
    case stubs         = "ComingSoon"
    case settings      = "Settings"
    case verifyLink    = "VerifyLink"
    case payments      = "Payments"
    case promocodes    = "Promocodes"
    case messages      = "Message"
    case support       = "Support"
    case profile       = "Profile"
//    case onboarding    = "Onboarding"
    
}
