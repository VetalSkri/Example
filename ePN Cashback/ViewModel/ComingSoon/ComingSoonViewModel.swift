//
//  ComingSoonViewModel.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 25/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import XCoordinator

class ComingSoonViewModel: ComingSoonModelType {
    private var pageType : ComingSoonType
    private let router: UnownedRouter<StubsRoute>
    
    init(router: UnownedRouter<StubsRoute>, pageType: ComingSoonType = .Payment) {
        self.router = router
        self.pageType = pageType
    }
    
    func goOnBack() {
        router.trigger(.back)
    }
    
    var titleHeader: String {
        switch pageType {
        case .Payment:
            return NSLocalizedString("ComingSoon_PaymentsTitle", comment: "")
        case .Support:
            return NSLocalizedString("ComingSoon_SupportTitle", comment: "")
        case .Profile:
            return NSLocalizedString("ComingSoon_ProfileTitle", comment: "")
        case .Statistic:
            return NSLocalizedString("ComingSoon_StatisticTitle", comment: "")
        }
    }
    
    var image: UIImage? {
        switch pageType {
        case .Payment:
            return UIImage(named: "stubPayments")
        case .Support:
            return UIImage(named: "stubSupport")
        case .Profile:
            return UIImage(named: "stubEditProfile")
        case .Statistic:
            return UIImage(named: "stubStatistics")
        }
    }
    
    var descriptionTitle: String {
        switch pageType {
        case .Payment:
            return NSLocalizedString("ComingSoon_PaymentsDescription", comment: "")
        case .Support:
            return NSLocalizedString("ComingSoon_SupportDescription", comment: "")
        case .Profile:
            return NSLocalizedString("ComingSoon_ProfileDescription", comment: "")
        case .Statistic:
            return NSLocalizedString("ComingSoon_StatisticDescription", comment: "")
        }
    }
    
    var buttonTitle: String {
        switch pageType {
        case .Payment:
            return NSLocalizedString("ComingSoon_PaymentsButtonTitle", comment: "")
        case .Support:
            return NSLocalizedString("ComingSoon_SupportButtonTitle", comment: "")
        case .Profile:
            return NSLocalizedString("ComingSoon_ProfileButtonTitle", comment: "")
        case .Statistic:
            return NSLocalizedString("ComingSoon_StatisticButtonTitle", comment: "")
        }
    }
    
    func goToPage() {
        switch pageType {
        case .Payment:
            OldAPI.performTransition(type: .payout)
        case .Support:
            ///Send event to analytic about go on site Support
            Analytics.goOnSupportEventPressed()
            OldAPI.performTransition(type: .support)
        case .Profile:
            ///Send event to analytic about go on site Profile
            Analytics.goOnProfileEventPressed()
            OldAPI.performTransition(type: .profile)
        case .Statistic:
            OldAPI.performTransition(type: .statsInviteFriends)
        }
    }
}

enum ComingSoonType {
    case Payment
    case Support
    case Profile
    case Statistic
}
