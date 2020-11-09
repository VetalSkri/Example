//
//  InviteFriendsViewModel.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 20/03/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import XCoordinator

class InviteFriendsViewModel: InviteFriendsModelType {

    private var typeOfResponse: TypeOfStatsInviteFriendsInfo!
    private var statsReferralsInfo: StatsReferrals!
    private var referralLink: String?
    private let OFFER_ID = 95
    
    private let router: UnownedRouter<AccountRoute>
    
    init(router: UnownedRouter<AccountRoute>) {
        self.router = router
        self.typeOfResponse = .loading
        statsReferralsInfo = StatsReferrals(amountTotal: 0, amountHoldTotal: 0, referralsCount: 0)
    }
    
    
    func totalAmount() -> String {
        return "\(statsReferralsInfo.amountTotal) $"
    }
    
    func holdAmount() -> String {
        return "\(statsReferralsInfo.amountHoldTotal) $"
    }
    
    func countOfReferrals() -> String {
        return "\(statsReferralsInfo.referralsCount)"
    }
    
    func getTypeOfResponse() -> TypeOfStatsInviteFriendsInfo {
        return typeOfResponse
    }
    
    func shareReferralLink() -> String? {
        return referralLink
    }
    
    func goOnBack() {
        router.trigger(.back)
    }
    func goOnFAQ() {
        router.trigger(.faqInviteFriends)
    }
    func goOnStatistic() {
        router.trigger(.statistics)
    }
    
    func loadLink(completion: (()->())?, failure: ((Int)->())?) {
        getAffiliateLink(completion: { [weak weakSelf = self] (affiliateLink) in
            weakSelf?.referralLink = affiliateLink
            weakSelf?.linkReduction(affiliateLink: affiliateLink, completion: {
                completion?()
            }, failure: { (errorMessage) in
                print("Error is \(errorMessage). But we'll show full link")
                completion?()
            })
        }, failure: { (errorCode) in
            failure?(errorCode)
        })
    }
    
    private func getAffiliateLink(completion: ((String)->())?, failure: ((Int)->())?) {
        LinkGenerateApiClient.generate(offerId: OFFER_ID, link: Util.refLink) { (result) in
            switch result {
            case .success(let response):
                guard let fullAffiliateLink = response.data.first?.attributes.cashbackDefault else {
                    failure?(000004)//"The link's not been gotten")
                    return
                }
                completion?(fullAffiliateLink)
                break
            case .failure(let error):
                failure?((error as NSError).code)
                break
            }
        }
    }
    
    private func linkReduction(affiliateLink: String, completion: (()->())?, failure: ((Int)->())?) {
        LinkReductionApiClient.reduction(urlString: affiliateLink) { [weak self] (result) in
            switch result {
            case .success(let response):
                guard let shortAffiliateLink = response.data.attributes.first?.result else {
                    failure?(000003)//"The link's not been reduction")
                    return
                }
                self?.referralLink = shortAffiliateLink
                completion?()
                break
            case .failure(let error):
                failure?((error as NSError).code)
                break
            }
        }
    }
    
    func loadReferralsStats(completion: (()->())?, failure: (()->())?) {
        InviteFriendsApiClient.refferalStatusInfo { [weak self] (result) in
            switch result {
            case .success(let refferalStatusResponse):
                self?.statsReferralsInfo = refferalStatusResponse.data.attributes
                if self?.statsReferralsInfo.referralsCount == 0 {
                    self?.typeOfResponse = .empty
                } else {
                    self?.typeOfResponse = .notEmpty
                }
                completion?()
                break
            case .failure(let error):
                Alert.showErrorAlert(by: error)
                failure?()
                break
            }
        }
    }
    
}

public enum TypeOfStatsInviteFriendsInfo {
    case empty, error, notEmpty, loading
}
