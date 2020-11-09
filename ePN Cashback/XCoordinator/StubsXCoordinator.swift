//
//  StubsXCoordinator.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 25/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import XCoordinator

enum StubsRoute: Route {
    case payment
    case support
    case profile
    case statistic
    case back
}

class StubsXCoordinator: NavigationCoordinator<StubsRoute> {
    
    // MARK: - Init

    init(rootViewController: UINavigationController, router: StubsRoute) {
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(router)
    }
    // MARK: - Overrides
    
    override func prepareTransition(for route: StubsRoute) -> NavigationTransition {
        let comingSoonVC: ComingSoonVC = ComingSoonVC.controllerFromStoryboard(.stubs)
        comingSoonVC.hidesBottomBarWhenPushed = true
        switch route {
        case .payment:
            comingSoonVC.viewModel = ComingSoonViewModel(router: unownedRouter, pageType: .Payment)
            return .push(comingSoonVC)
        case .support:
            ///Send event to analytic about open Support
            Analytics.supportEventPressed()
            comingSoonVC.viewModel = ComingSoonViewModel(router: unownedRouter, pageType: .Support)
            return .push(comingSoonVC)
        case .profile:
            ///Send event to analytic about go to Profile
            Analytics.profileEventPressed()
            comingSoonVC.viewModel = ComingSoonViewModel(router: unownedRouter, pageType: .Profile)
            return .push(comingSoonVC)
        case .statistic:
            comingSoonVC.viewModel = ComingSoonViewModel(router: unownedRouter, pageType: .Statistic)
            return .push(comingSoonVC)
        case .back:
            return .pop()
        }
    }
}

