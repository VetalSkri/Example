//
//  MessagesXCoordinator.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 30/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import XCoordinator

enum MessagesRoute: Route {
    case main
    case back
}
class MessagesXCoordinator: NavigationCoordinator<MessagesRoute> {
    
    // MARK: - Init
    init(rootViewController: UINavigationController) {
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(.main)
    }
    
    // MARK: - Overrides
    
    override func prepareTransition(for route: MessagesRoute) -> NavigationTransition {
        switch route {
        case .main:
            let messagesVC: MessageVC = MessageVC.controllerFromStoryboard(.messages)
            messagesVC.hidesBottomBarWhenPushed = true
            messagesVC.viewModel = MessageViewModel(router: unownedRouter)
            return .push(messagesVC)
        case .back:
            return .pop()
        }
    }
}
