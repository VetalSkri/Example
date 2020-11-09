//
//  InviteFriendsFaqModelType.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 25/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

protocol InviteFriendsFaqModelType {
    var title: String { get }
    var sendReferalLinkText : String { get }
    var friendsRegisterText : String { get }
    var whenFriendBuyText : String { get }
    var onTheInviteFriendsText : String { get }
    var inProcessingIncomeText : String { get }
    var whenWeConfirmIncomeText : String { get }
    var allTheIncomeYouHaveText : String { get }
    var inTheAccountText : String { get }
    var registrationText : String { get }
    var inProcessText : String { get }
    var incomeText : String { get }
    
    func goOnBack()
}

extension InviteFriendsFaqModelType {
    var title: String {
        return NSLocalizedString("FAQ_How it works?", comment: "")
    }
    
    var sendReferalLinkText : String {
        return NSLocalizedString("FAQ_Send a personal link to your friends", comment: "")
    }
    
    var friendsRegisterText : String {
        return NSLocalizedString("FAQ_A friend registers on your personal link", comment: "")
    }
    
    var whenFriendBuyText : String {
        return NSLocalizedString("FAQ_When a friend buys with a cashback", comment: "")
    }
    
    var onTheInviteFriendsText : String {
        return NSLocalizedString("FAQ_On the Invite Friends page", comment: "")
    }
    
    var inProcessingIncomeText : String {
        return NSLocalizedString("FAQ_In processing income may be different to the value", comment: "")
    }
    
    var whenWeConfirmIncomeText : String {
        return NSLocalizedString("FAQ_When we confirm income", comment: "")
    }
    
    var allTheIncomeYouHaveText : String {
        return NSLocalizedString("FAQ_All the income you have", comment: "")
    }
    
    var inTheAccountText : String {
        return NSLocalizedString("FAQ_In the Account we add the confirmed income", comment: "")
    }
    
    var registrationText : String {
        return NSLocalizedString("FAQ_registration", comment: "")
    }
    
    var inProcessText : String {
        return NSLocalizedString("FAQ_inProcessing", comment: "")
    }
    
    var incomeText : String {
        return NSLocalizedString("FAQ_income", comment: "")
    }
}
