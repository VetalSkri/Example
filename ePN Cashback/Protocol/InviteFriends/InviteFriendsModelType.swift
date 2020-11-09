//
//  InviteFriendsModelType.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 25/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

protocol InviteFriendsModelType {
    var mainText: String { get }
    var conditionText: String { get }
    var emptyStatsText: String { get }
    var infoText: String { get }
    var buttonDetailText: String { get }
    var headTitle: String { get }
    var referralsCountText: String { get }
    var amountHoldTotalText: String { get }
    var amountTotalText: String { get }
    var buttonTryAgainText: String { get }
    var errorInfoText: String { get }
    
    
    func totalAmount() -> String
    func holdAmount() -> String
    func countOfReferrals() -> String
    func getTypeOfResponse() -> TypeOfStatsInviteFriendsInfo
    func shareReferralLink() -> String?
    
    func loadLink(completion: (()->())?, failure: ((Int)->())?)
    func loadReferralsStats(completion: (()->())?, failure: (()->())?)
    
    func goOnBack()
    func goOnFAQ()
    func goOnStatistic()
    
}

extension InviteFriendsModelType {
    
    var mainText: String {
        return NSLocalizedString("Statistics", comment: "")
    }
    
    var conditionText: String {
        return NSLocalizedString("Terms", comment: "")
    }
    
    var emptyStatsText: String {
        return NSLocalizedString("Here you can see the statistics by ", comment: "")
    }
    
    var infoText: String {
        return NSLocalizedString("Share with a link and get up", comment: "")
    }
    
    var buttonDetailText: String {
        return NSLocalizedString("Learn more", comment: "")
    }
    
    var headTitle: String {
        return NSLocalizedString("Invite your friends", comment: "")
    }
    
    var referralsCountText: String {
        return NSLocalizedString("Registration", comment: "")
    }
    
    var amountHoldTotalText: String {
        return NSLocalizedString("In processing", comment: "")
    }
    
    var amountTotalText: String {
        return NSLocalizedString("Income", comment: "")
    }
    
    var buttonTryAgainText: String {
        return NSLocalizedString("Try again", comment: "")
    }
    
    var errorInfoText: String {
        return NSLocalizedString("ErrorInfoStatsReferrals", comment: "")
    }
    
}
