//
//  VerifyLinkXCoordinator.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 26/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import XCoordinator

enum VerifyLinkRoute: Route {
    case main
    case result(String,OfferLinkInfo)
    case incorrectLink
    case dynamics(String,PriceDynamicsResponse,OfferLinkInfo)
    case noDynamics
    case infoMessage
    case back
    
}

class VerifyLinkXCoordinator: NavigationCoordinator<VerifyLinkRoute> {
    
    // MARK: - Init

    init(rootViewController: UINavigationController) {
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(.main)
    }
    
    // MARK: - Overrides
    
    override func prepareTransition(for route: VerifyLinkRoute) -> NavigationTransition {
        switch route {
        case .main:
            let verifyLinkVC: VerifyLinkVC = VerifyLinkVC.controllerFromStoryboard(.verifyLink)
            verifyLinkVC.hidesBottomBarWhenPushed = true
            verifyLinkVC.viewModel = VerifyLinkViewModel(router: unownedRouter)
            return .push(verifyLinkVC)
        case let .result(link, info):
            let linkVerifyResultVC: VerifyLinkResultVC = VerifyLinkResultVC.controllerFromStoryboard(.verifyLink)
            linkVerifyResultVC.viewModel = VerifyLinkResultViewModel(router: unownedRouter, link: link, linkInfo: info)
            return .push(linkVerifyResultVC)
        case .incorrectLink:
            let incorrectLinkVC: IncorrectLinkPopupVC = IncorrectLinkPopupVC.controllerFromStoryboard(.verifyLink)
            incorrectLinkVC.providesPresentationContextTransitionStyle = true
            incorrectLinkVC.definesPresentationContext = true
            incorrectLinkVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            incorrectLinkVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            return .present(incorrectLinkVC)
        case let .dynamics(urlLink, currentPriceDynamics, offerLinkInfo):
            let dynamicsVC: DynamicsVC = DynamicsVC.controllerFromStoryboard(.verifyLink)
            dynamicsVC.viewModel = DynamicViewModel(router: unownedRouter, link: urlLink, priceDynamics: currentPriceDynamics, offerLinkInfo: offerLinkInfo)
            return .push(dynamicsVC)
        case .noDynamics:
            let noDataVC: NoDataPopupVC = NoDataPopupVC.controllerFromStoryboard(.verifyLink)
            noDataVC.providesPresentationContextTransitionStyle = true
            noDataVC.definesPresentationContext = true
            noDataVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            noDataVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            return .present(noDataVC)
        case .infoMessage:
            let infoMessageVC: InfoMessagePopupVC = InfoMessagePopupVC.controllerFromStoryboard(.verifyLink)
            infoMessageVC.providesPresentationContextTransitionStyle = true
            infoMessageVC.definesPresentationContext = true
            infoMessageVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            infoMessageVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            return .present(infoMessageVC)
        case .back:
            return .pop()
        }
    }
}
