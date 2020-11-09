//
//  FAQOfflineCBXCoordinator.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 02/08/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import XCoordinator

class FAQHowToBuyXCoordinator: NavigationCoordinator<FAQRoute> {
    
    // MARK: - Init
    
    init(rootViewController: UINavigationController) {
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(.howToBuy)
    }
    // MARK: - Overrides
    
    override func prepareTransition(for route: FAQRoute) -> NavigationTransition {
        switch route {
        case .howToBuy:
            let howToBuyVC: HowToBuyVC = HowToBuyVC.controllerFromStoryboard(.faq)
            howToBuyVC.hidesBottomBarWhenPushed = true
            howToBuyVC.viewModel = HowToBuyViewModel(router: unownedRouter)
            return .push(howToBuyVC)
        case .back:
            return .pop()
        default:
            return .none()
        }
    }
}
