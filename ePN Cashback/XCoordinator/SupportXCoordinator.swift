//
//  SupportXCoordinator.swift
//  Backit
//
//  Created by Александр Кузьмин on 08/11/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import UIKit
import XCoordinator

enum SupportRoute: Route {
    case main
    case ticketType
    case chat(replyToId: Int?, subjectId: Int?, subjectName: String?, isOpen: Bool)
    case back
    case dismiss
    case backToSupportVCFrom(dialogID: Int)
    case popToRoot
    case closeModule
    case closeChatAlert(dialogID: Int)
    case showEvaluateSupport(dialogID: Int)
}

class SupportXCoordinator: NavigationCoordinator<SupportRoute> {
    
    weak var main: SupportVC?
    
    init(rootViewController: UINavigationController) {
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(.main)
    }
    
    // MARK: - Overrides
    
    override func prepareTransition(for route: SupportRoute) -> NavigationTransition {
        switch route {
        case .main:
            let supportVC: SupportVC = SupportVC.controllerFromStoryboard(.support)
            supportVC.viewModel = SupportViewModel(router: unownedRouter)
            supportVC.hidesBottomBarWhenPushed = true
            self.main = supportVC
            return .push(supportVC)
        case .ticketType:
            let ticketTypeVC = SelectTicketTypeVC.controllerFromStoryboard(.support)
            ticketTypeVC.viewModel = SelectTicketTypeViewModel(router: unownedRouter)
            return .push(ticketTypeVC)
        case .chat(let replyToId, let subjectId, let subjectName, let isOpen):
            let chatVC = SupportChatVC.controllerFromStoryboard(.support)
            chatVC.viewModel = SupportChatViewModel(router: unownedRouter, subjectId: subjectId, subjectName: subjectName, dialogId: replyToId ?? 0, isDialogOpen: isOpen)
            return .push(chatVC)
        case .back:
            return .pop()
        case .popToRoot:
            guard let main = main else {
                return .pop()
            }
            
            return .pop(to: main)
        case .dismiss:
            return .dismiss()
        case .backToSupportVCFrom(let dialogID):
            guard let main = main else {
                fatalError()
            }
            
            main.refresh()
            main.viewModel.setForEvaluation(dialogID: dialogID)
            
            return .multiple(.dismiss(), .pop(to: main))
        case .closeModule:
            return .multiple([.popToRoot(), .dismiss()])
        case .closeChatAlert(let dialogID):
            let closeChatAlertViewController = CloseChatAlertViewController()
            closeChatAlertViewController.viewModel = CloseChatAlertViewModel(router: unownedRouter,
                                                                             dialogID: dialogID)
            closeChatAlertViewController.modalPresentationStyle = .overFullScreen
            closeChatAlertViewController.modalTransitionStyle = .crossDissolve
            return .present(closeChatAlertViewController)
        case .showEvaluateSupport(let dialogID):
            let evaluateSupportViewController = EvaluateSupportAlertViewController()
            evaluateSupportViewController.viewModel = EvaluateSupportAlertViewModel(router: unownedRouter,
                                                                                    dialogID: dialogID)
            evaluateSupportViewController.modalPresentationStyle = .overFullScreen
            evaluateSupportViewController.modalTransitionStyle = .crossDissolve
            return .present(evaluateSupportViewController)
        }
    }
}
