//
//  SettingsXCoordinator.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 25/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import XCoordinator

enum SettingsRoute: Route {
    case main
    case profile
    case back
    
}

class SettingsXCoordinator: NavigationCoordinator<SettingsRoute> {

    var childCoordinator: Presentable?

    // MARK: - Init
    
    init(rootViewController: UINavigationController, presentMain: Bool = true) {
        super.init(rootViewController: rootViewController, initialRoute: nil)
        if presentMain {
            trigger(.main)
        }
    }
    
    // MARK: - Overrides
    
    override func prepareTransition(for route: SettingsRoute) -> NavigationTransition {
        if let coordinator = childCoordinator {
            removeChild(coordinator)
        }
        switch route {
        case .main:
            let settingsVC: SettingsMainVC = SettingsMainVC.controllerFromStoryboard(.settings)
            settingsVC.hidesBottomBarWhenPushed = true
            settingsVC.viewModel = SettingsViewModel(router: unownedRouter)
            return .push(settingsVC)
        case .profile:
            childCoordinator = ProfileXCoordinator(rootViewController: rootViewController)
            addChild(childCoordinator!)
            return .none()
        case .back:
            return .pop()
        }
    }
}
