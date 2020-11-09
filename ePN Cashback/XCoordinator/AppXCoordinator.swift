//
//  AppXCoordinator.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 16/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator

enum AppRoute: Route {
    case auth(animate: Bool)
    case onboarding
    case main(Int, needUpdate: Bool = true)
    case deepLinkCreateNewPassword(String)
    case deepLinkOfflineCB
    case deepLinkNotifications
    case deepLinkPaymentsHistory
    case deepLinkPayments
    case deepLinkFAQ
    case deepLinkVerifyLink
    case deepLinkInvite
    case deepLinkPromo
    case deepLinkPromotions
    case deepLinkOrderHistory
    case deepLinkAccount
    case deepLinkSupport
    case deepLinkSetting
    case deepLinkOnlineShopDetail(Store, ShopDetailSource)
    case deepLinkOfflineShopDetail(OfferOffline, TicketDetailSource)
}

class AppXCoordinator: NavigationCoordinator<AppRoute> {
    
    // MARK: - Stored properties
    
    // We need to keep a reference to the HomeCoordinator
    // as it is not held by any viewModel or viewController
    private var home: Presentable?
    
    // MARK: - Init
    
    init(_ action: AppRoute? = nil) {
        if let action = action {
            if !Session.shared.isAuth {
                super.init(initialRoute: .auth(animate: false))
            } else {
                super.init(initialRoute: action)
            }
        } else {
            let launchInstructor = LaunchInstructor.configure()
            switch launchInstructor {
            case .auth:
                super.init(initialRoute: .auth(animate: true))
            case .main:
                super.init(initialRoute: .main(0))
            case .onboarding:
                super.init(initialRoute: .auth(animate: true))
            }
        }
    }
    
    // MARK: - Overrides
    
    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        if let coordinator = home {
            removeChild(coordinator)
        }
        
        switch route {
        case .auth(let animate):
            let coordinator = AuthXCoordinator(.SignIn, animate: animate)
            coordinator.viewController?.modalPresentationStyle = .fullScreen
            self.home = coordinator
            addChild(home!)
            let transition = StaticTransitionAnimation(duration: 1.0) { (context) in
                let fromController = context.viewController(forKey: .from)
                let toController = context.viewController(forKey: .to)
                fromController?.view.isUserInteractionEnabled = false
                context.containerView.addSubview(toController!.view)
                toController?.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                context.completeTransition(true)
            }
            let animation = Animation(presentation: transition, dismissal: transition)
            return .multiple(
            .dismissAll(), .presentFullScreen(coordinator, animation: animation))
        case let .main(page, needUpdate):
            let coordinator: Presentable = HomeTabCoordinator(pageIndex: page, needUpdate: needUpdate)
            coordinator.viewController?.modalPresentationStyle = .fullScreen
            self.home = coordinator
            addChild(home!)
            let transition = StaticTransitionAnimation(duration: 1.0) { (context) in
                let fromController = context.viewController(forKey: .from)
                let toController = context.viewController(forKey: .to)
                fromController?.view.isUserInteractionEnabled = false
                context.containerView.addSubview(toController!.view)
                toController?.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                context.completeTransition(true)
            }
            let animation = Animation(presentation: transition, dismissal: transition)
            return .multiple(
                .dismissAll(), .presentFullScreen(coordinator, animation: animation))
        case .onboarding:
            let coordinator = OnboardingXCoordinator()
            coordinator.viewController?.modalPresentationStyle = .fullScreen
            self.home = coordinator
            addChild(home!)
            return .presentFullScreen(coordinator)
        case let .deepLinkCreateNewPassword(hash):
            return .multiple(
                .dismissAll(),
                .popToRoot(),
                deepLink(AppRoute.auth(animate: false), AuthRoute.enterNewPassword(hash: hash))
            )
        case .deepLinkOfflineCB:
            return .multiple(
            .dismissAll(),
            .popToRoot(), deepLink(AppRoute.main(1)))
        case .deepLinkAccount:
            return .multiple(
                .dismissAll(),
                .popToRoot(), deepLink(AppRoute.main(4)))
        case .deepLinkNotifications:
            return .multiple(
                .dismissAll(),
                .popToRoot(), deepLink(AppRoute.main(4), HomeRoute.account, AccountRoute.notifications))
        case .deepLinkPaymentsHistory:
            return .multiple(
            .dismissAll(),
            .popToRoot(), deepLink(AppRoute.main(4), HomeRoute.account, AccountRoute.paymentHistory))
        case .deepLinkPayments:
            return .multiple(
            .dismissAll(),
            .popToRoot(), deepLink(AppRoute.main(4), HomeRoute.account, AccountRoute.orderPayment))
        case .deepLinkFAQ:
            return .multiple(
            .dismissAll(),
            .popToRoot(), deepLink(AppRoute.main(4), HomeRoute.account, AccountRoute.faq))
        case .deepLinkVerifyLink:
            return .multiple(
            .dismissAll(),
            .popToRoot(), deepLink(AppRoute.main(4), HomeRoute.account, AccountRoute.verifyLink))
        case .deepLinkInvite:
            return .multiple(
            .dismissAll(),
            .popToRoot(), deepLink(AppRoute.main(4), HomeRoute.account, AccountRoute.inviteFriends))
        case .deepLinkPromo:
            return .multiple(
            .dismissAll(),
            .popToRoot(), deepLink(AppRoute.main(4), HomeRoute.account, AccountRoute.promocodes))
        case .deepLinkPromotions:
            return .multiple(
            .dismissAll(),
            .popToRoot(), deepLink(AppRoute.main(2)))
        case .deepLinkOrderHistory:
            return .multiple(.dismissAll(), .popToRoot(), deepLink(AppRoute.main(3)))
        case .deepLinkSupport:
            return .multiple(.popToRoot(), deepLink(AppRoute.main(4), HomeRoute.account, AccountRoute.support))
        case .deepLinkSetting:
            return .multiple(.popToRoot(), deepLink(AppRoute.main(4), HomeRoute.account, AccountRoute.settings))
        case .deepLinkOnlineShopDetail(let store, let source):
            return .multiple(.dismissAll(), .popToRoot(), deepLink(AppRoute.main(0, needUpdate: false), HomeRoute.shops, ShopsRoute.shopDetail(store, source)))
        case .deepLinkOfflineShopDetail(let offlineOffer, let source):
            return .multiple(.dismissAll(), .popToRoot(), deepLink(AppRoute.main(1, needUpdate: false), HomeRoute.offlineCB, OfflineCBRoute.detailPage(offlineOffer, source)))
        }
    }
}
