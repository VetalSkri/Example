//
//  FAQXCoordinator.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 25/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import XCoordinator

enum FAQRoute: Route {
    case main(FaqViewType)
    case back
    case introduction
    case support
    case popupGuid
    case rulesToBuy
    case whatIsCB
    case howOrderPayments
    case whatToDoAfter
    case howToBuy
    case dismiss
    case dismissWithoutAnimation
}

class FAQXCoordinator: NavigationCoordinator<FAQRoute> {

    // MARK: - Properties
    
    var childCoordinator: Presentable?
    
    // MARK: - Init
    
    init(rootViewController: UINavigationController, type: FaqViewType = .normal) {
       super.init(rootViewController: rootViewController, initialRoute: .main(type))
       //trigger(.main(type))
   }
    
    // MARK: - Overrides
    
    override func prepareTransition(for route: FAQRoute) -> NavigationTransition {
        if let coordinator = childCoordinator {
            removeChild(coordinator)
        }
        
        switch route {
        case let .main(type):
            let faqVC: FaqMainVC = FaqMainVC.controllerFromStoryboard(.faq)
            faqVC.hidesBottomBarWhenPushed = true
            faqVC.viewModel = FaqViewModel(router: unownedRouter, type: type)
            return .push(faqVC)
        case .introduction:
            let introductionVC: IntroductionToTheAppVC = IntroductionToTheAppVC.controllerFromStoryboard(.faq)
            introductionVC.viewModel = IntroductionToTheAppViewModel(router: unownedRouter)
            return .push(introductionVC)
        case .support:
            childCoordinator = SupportXCoordinator(rootViewController: rootViewController)
            addChild(childCoordinator!)
            return .none()
        case .popupGuid:
            let popupGuidVC: OfflineCbPopupGuidVC = OfflineCbPopupGuidVC.controllerFromStoryboard(.faq)
            popupGuidVC.providesPresentationContextTransitionStyle = true
            popupGuidVC.definesPresentationContext = true
            popupGuidVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            popupGuidVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            return .present(popupGuidVC)
        case .rulesToBuy:
            let rulesVC: RulesOfBuyVC = RulesOfBuyVC.controllerFromStoryboard(.faq)
            return .push(rulesVC)
        case .whatIsCB:
            let whatIsCBVC: WhatIsCbVC = WhatIsCbVC.controllerFromStoryboard(.faq)
            return .push(whatIsCBVC)
        case .howOrderPayments:
            let howOrderVC: HowOrderPaymentsVC = HowOrderPaymentsVC.controllerFromStoryboard(.faq)
            return .push(howOrderVC)
        case .whatToDoAfter:
            let whatToDoVC: WhatToDoAfterVC = WhatToDoAfterVC.controllerFromStoryboard(.faq)
            return .push(whatToDoVC)
        case .howToBuy:
            let howToBuyVC: HowToBuyVC = HowToBuyVC.controllerFromStoryboard(.faq)
            howToBuyVC.viewModel = HowToBuyViewModel(router: unownedRouter)
            return .push(howToBuyVC)
        case .back:
            return .pop()
        case .dismiss:
            return .dismiss()
        default:
            return .none()
        }
    }
}
