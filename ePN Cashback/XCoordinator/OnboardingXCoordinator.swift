//
//  OnboardingXCoordinator.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 05/08/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import XCoordinator

class OnboardingXCoordinator: NavigationCoordinator<FAQRoute> {
    
    // MARK: - Init
    
    init() {
        super.init(initialRoute: .introduction)
    }
    
    override func prepareTransition(for route: FAQRoute) -> NavigationTransition {
        switch route {
        case .introduction:
            let introductionVC: IntroductionToTheAppVC = IntroductionToTheAppVC.controllerFromStoryboard(.faq)
            introductionVC.viewModel = IntroductionToTheAppViewModel(router: unownedRouter, type: .onBoarding)
            Session.shared.isFirstLaunchApp = false
            return .push(introductionVC)
        case .dismiss:
            self.viewController?.dismiss(animated: false, completion: nil)
            return .dismissToRoot(animation: nil)
        default:
            return .none()
        }
    }
}
