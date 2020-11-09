//
//  ScanXCoordinator.swift
//  Backit
//
//  Created by Ivan Nikitin on 14/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import XCoordinator

enum ScanRoute: Route {
    case scan
    case manual(isModal: Bool)
    case hint
    case back
    case close
    case dismiss(String)
    
}

class ScanXCoordinator: NavigationCoordinator<ScanRoute> {
    
    // MARK: - Init
    private var keyNotificationCenter: Notification.Name
    init(key: Notification.Name, route: ScanRoute = .scan) {
        self.keyNotificationCenter = key
        super.init(initialRoute: route)
    }

    // MARK: - Overrides
    override func prepareTransition(for route: ScanRoute) -> NavigationTransition {
        switch route {
        case .scan:
            let scannerVC: QRScannerVC = QRScannerVC.controllerFromStoryboard(.offlineCB)
            scannerVC.hidesBottomBarWhenPushed = true
            scannerVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            scannerVC.viewModel = QRScannerViewModel(router: unownedRouter)
            ///Send event to analytic about scan event
            Analytics.openScanEvent()
            return .set([scannerVC])
        case .manual(let isModal):
            let manualEnterVC: ManualEnterCheckVC = ManualEnterCheckVC.controllerFromStoryboard(.offlineCB)
            manualEnterVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            manualEnterVC.viewModel = ManualEnterCheckViewModel(router: unownedRouter, openSingleModal: isModal)
            ///Send event to analytic about manual enter event
            Analytics.openEventManualyEnter()
            return .set([manualEnterVC])
        case let .dismiss(qrString):
            NotificationCenter.default.post(name: keyNotificationCenter, object: qrString)
            return .dismiss()
        case .hint:
            let hintCheckVC: HintCheckOfflineCBVC = HintCheckOfflineCBVC.controllerFromStoryboard(.offlineCB)
            hintCheckVC.providesPresentationContextTransitionStyle = true
            hintCheckVC.definesPresentationContext = true
            hintCheckVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            hintCheckVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            ///Send event to analytic about hint event
            Analytics.openEventHint()
            return .present(hintCheckVC)
        case .back:
            return .pop()
        case .close:
            return .dismiss()
        }
    }
}

