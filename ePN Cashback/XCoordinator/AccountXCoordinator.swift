//
//  AccountXCoordinator.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 16/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import XCoordinator

enum AccountRoute: Route {
    case main
    case orderPayment
    case paymentHistory
    case verifyLink
    case promocodes
    case inviteFriends
    case support
    case logout
    case faq
    case settings
    case notifications
    case faqInviteFriends
    case profileSettings
    case statistics
    case back
}

class AccountXCoordinator: NavigationCoordinator<AccountRoute> {
    
    // MARK: - Init
    
    init() {
        super.init(rootViewController: PaymentsNavigationController(), initialRoute: .main)
    }
    
    // MARK: - Overrides
    
    var childCoordinator: Presentable?
    
    override func prepareTransition(for route: AccountRoute) -> NavigationTransition {
        (rootViewController as? UINavigationController)?.navigationBar.shadowImage = UIImage()
        if let coordinator = childCoordinator {
            removeChild(coordinator)
        }
        switch route {
        case .main:
            let accountVC: AccountVC = AccountVC.controllerFromStoryboard(.account)
            accountVC.viewModel = AccountMainViewModel(router: unownedRouter)
            return .push(accountVC)
        case .orderPayment:
            childCoordinator = PaymentsXCoordinator(rootViewController: rootViewController, parentCoordinator: self)
            addChild(childCoordinator!)
            return .none()
        case .paymentHistory:
            let paymentHistoryVC: PaymentsHistoryVC = PaymentsHistoryVC.controllerFromStoryboard(.account)
            paymentHistoryVC.hidesBottomBarWhenPushed = true
            paymentHistoryVC.viewModel = PaymentsHistoryViewModel(router: unownedRouter)
            return .push(paymentHistoryVC)
        case .verifyLink:
            childCoordinator = VerifyLinkXCoordinator(rootViewController: rootViewController)
            addChild(childCoordinator!)
            return .none()
        case .promocodes:
            childCoordinator = PromocodesXCoordinator(rootViewController: rootViewController)
            addChild(childCoordinator!)
            return .none()
        case .inviteFriends:
            let inviteFriendsVC: InviteFriendsVC = InviteFriendsVC.controllerFromStoryboard(.account)
            inviteFriendsVC.hidesBottomBarWhenPushed = true
            inviteFriendsVC.viewModel = InviteFriendsViewModel(router: unownedRouter)
            return .push(inviteFriendsVC)
        case .statistics:
            childCoordinator = StubsXCoordinator(rootViewController: rootViewController, router: .statistic)
            addChild(childCoordinator!)
            return .none()
        case .faqInviteFriends:
            let faqVC: InviteFriendsFaqVC = InviteFriendsFaqVC.controllerFromStoryboard(.faq)
            faqVC.hidesBottomBarWhenPushed = true
            faqVC.viewModel = InviteFriendsFaqViewModel(router: unownedRouter)
            return .push(faqVC)
        case .support:
            childCoordinator = SupportXCoordinator(rootViewController: rootViewController)
            addChild(childCoordinator!)
            return .none()
        case .logout:
            self.viewController?.dismiss(animated: false, completion: nil)
            return .none()
        case .faq:
            childCoordinator = FAQXCoordinator(rootViewController: rootViewController)
            addChild(childCoordinator!)
            return .none()
        case .settings:
            childCoordinator = SettingsXCoordinator(rootViewController: rootViewController)
            addChild(childCoordinator!)
            return .none()
        case .profileSettings:
            let coordinator = SettingsXCoordinator(rootViewController: rootViewController, presentMain: false)
            childCoordinator = coordinator
            addChild(childCoordinator!)
            coordinator.trigger(.profile)
            return .none()
        case .notifications:
            childCoordinator = MessagesXCoordinator(rootViewController: rootViewController)
            addChild(childCoordinator!)
            return .none()
        case .back:
            return .pop()
        }
    }
}
