//
//  PromocodesXCoordinator.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 29/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import XCoordinator

enum PromocodesRoute: Route {
    case main
    case back
    case resultOfChecking(PromocodeInfo)
    case result(Bool)
    case close
}
class PromocodesXCoordinator: NavigationCoordinator<PromocodesRoute> {
    
    // MARK: - Init
    
     init(rootViewController: UINavigationController) {
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(.main)
    }
    
    // MARK: - Overrides
    
    override func prepareTransition(for route: PromocodesRoute) -> NavigationTransition {
        switch route {
        case .main:
            let promocodesVC: PromocodesVC = PromocodesVC.controllerFromStoryboard(.promocodes)
            promocodesVC.hidesBottomBarWhenPushed = true
            promocodesVC.viewModel = PromocodesViewModel(router: unownedRouter)
            return .push(promocodesVC)
        case let .resultOfChecking(promocode):
            let checkResultVC: PromocodeCheckResultVC = PromocodeCheckResultVC.controllerFromStoryboard(.promocodes)
            checkResultVC.viewModel = PromocodeCheckResultViewModel(router: unownedRouter, promocode: promocode)
            return .push(checkResultVC)
        case let .result(isActivated):
            let result: PopUpInfoVC = PopUpInfoVC.controllerFromStoryboard(.promocodes)
            result.viewModel = PopUpInfoViewModel(router: unownedRouter, isActive: isActivated)
            result.providesPresentationContextTransitionStyle = true
            result.definesPresentationContext = true
            result.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            result.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            return .present(result)
        case .back:
            return .pop()
        case .close:
            return .dismiss()
        }
    }
}
