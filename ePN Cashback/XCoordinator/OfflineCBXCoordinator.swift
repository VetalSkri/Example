//
//  OfflineCBXCoordinator.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 02/08/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import XCoordinator

enum TicketDetailSource: String {
    case main
    case pushNotification
    case search
    case spotlight
    case doodle
    case specialOffer
}

enum OfflineCBRoute: Route {
    case main
    case specialOffer
    case detailPage(OfferOffline, TicketDetailSource)
    case scan(Notification.Name)
    case faq
    case successScan
    case errorScan(String)
    case back
    case showHelp(Bool, HelpAnimationType)
    case landing
    case manual(Notification.Name)
    case dismiss
    case popToRoot
}

class OfflineCBXCoordinator: NavigationCoordinator<OfflineCBRoute> {
    
    private let repository: ReceiptRepositoryProtocol
    
    // MARK: - Init
        
    init(rootViewController: UINavigationController, offer: OfferOffline, source: TicketDetailSource) {
        repository = ReceiptRepository()
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(.detailPage(offer, source))
    }
    
    init() {
        repository = ReceiptRepository()
        super.init(initialRoute: .main)
    }
    var childCoordinator: Presentable?
    
    // MARK: - Overrides
    
    override func prepareTransition(for route: OfflineCBRoute) -> NavigationTransition {
        
        if let coordinator = childCoordinator {
            removeChild(coordinator)
        }
        switch route {
        case .main:
            let receiptsVC: ReceiptsMainVC = ReceiptsMainVC.controllerFromStoryboard(.offlineCB)
            receiptsVC.viewModel = ReceiptMainViewModel(router: unownedRouter, offlineRepository: repository)
            return .push(receiptsVC)
        case .specialOffer:
            let receiptsVC: ReceiptsVC = ReceiptsVC.controllerFromStoryboard(.offlineCB)
            receiptsVC.viewModel = SpecialReceiptsViewModel(router: unownedRouter, offlineRepository: repository)
            ///Send event to analytic about SpecialOffers OfflineCB
            Analytics.showEventSpecOffers()
            return .push(receiptsVC)
        case let .detailPage(offer, source):
            let detailPageVC:OfflineOfferDetailVC = OfflineOfferDetailVC.controllerFromStoryboard(.offlineCB)
            detailPageVC.hidesBottomBarWhenPushed = true
            detailPageVC.bindViewModel(viewModel: OfflineOfferDetailViewModel(router: unownedRouter, offlineRepository: repository, offer: offer, source: source))
            return .push(detailPageVC)
        case let .scan(keyNotification):
            let scanCoordinator = ScanXCoordinator(key: keyNotification)
            scanCoordinator.viewController?.modalPresentationStyle = .fullScreen
            childCoordinator = scanCoordinator
            addChild(childCoordinator!)
            return .present(scanCoordinator)
        case .faq:
            childCoordinator = FAQXCoordinator(rootViewController: rootViewController, type: .fromOfflineCB)
            addChild(childCoordinator!)
            return .none()
        case .successScan:
            let successScanResult: SuccessResultOfflineCBVC = SuccessResultOfflineCBVC.controllerFromStoryboard(.offlineCB)
            successScanResult.modalPresentationStyle = .fullScreen
            successScanResult.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            ///Send event to analytic about fail popup
            Analytics.openEventSuccessPopUp()
            return .present(successScanResult)
        case let .errorScan(errorMessage):
            let errorScanResult: ErrorResultOfflineCBVC = ErrorResultOfflineCBVC.controllerFromStoryboard(.offlineCB)
            errorScanResult.modalPresentationStyle = .fullScreen
            errorScanResult.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            errorScanResult.errorMessage = errorMessage
            ///Send event to analytic about fail popup
            Analytics.openEventFailPopUp()
            return .present(errorScanResult)
        case .back:
            return .pop()
        case .showHelp(let fromFaq, let type):
            let helpVC = HelpAnimationVC.controllerFromStoryboard(.offlineCB)
            helpVC.viewModel = HelpAnimationViewModel(router: unownedRouter, fromFaq: fromFaq, type: type)
            helpVC.modalPresentationStyle = .overFullScreen
            helpVC.modalTransitionStyle = .crossDissolve
            return .present(helpVC)
        case .landing:
            let landingVC = LandingVC()
            landingVC.viewModel = LandingViewModel(router: unownedRouter)
            return .push(landingVC)
        case .manual(let notificationName):
            childCoordinator = ScanXCoordinator(key: notificationName, route: .manual(isModal: true))
            addChild(childCoordinator!)
            return .present(childCoordinator!)
        case .dismiss:
            return .dismiss()
        case .popToRoot:
            return .popToRoot()
        }
    }
}
