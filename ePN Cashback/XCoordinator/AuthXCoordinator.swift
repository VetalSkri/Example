//
//  AuthXCoordinator.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 16/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator

enum AuthRoute: Route {
    case main(animate: Bool)
    case login
    case webmaster
    case recoverPassword(email:String)
    case enterNewPassword(hash: String)
    case register
    case attach(email: String, socialName: String, socialType: SocialType, socialToken: String)
    case back
    case popToRoot
}

class AuthXCoordinator: NavigationCoordinator<AuthRoute> {
    
    // MARK: - Properties
    
    var childCoordinator: Presentable?
    
    // MARK: - Init
    
    init(_ action: AuthType, animate: Bool) {
        super.init(initialRoute: .main(animate: animate))
    }
    
    // MARK: - Overrides
    override func prepareTransition(for route: AuthRoute) -> NavigationTransition {
        if let coordinator = childCoordinator {
            removeChild(coordinator)
        }
        
        switch route {
        case .main(let animate):
            let authVC = MainAuthVC.controllerFromStoryboard(.authorization)
            authVC.viewModel = MainAuthViewModel(router: unownedRouter, animate: animate)
            return .set([authVC])
        case .login:
            AuthAnalytics.open(page: .Auth)
            let loginVC = LoginVC.controllerFromStoryboard(.authorization)
            loginVC.viewModel = LoginViewModel(router: unownedRouter)
            return .push(loginVC)
        case .webmaster:
            AuthAnalytics.open(page: .Webmaster)
            let faqCoordinator = FAQXCoordinator(rootViewController: rootViewController, type: .webmasterInfo)
            faqCoordinator.viewController.modalPresentationStyle = .fullScreen
            childCoordinator = faqCoordinator
            addChild(childCoordinator!)
            return .none()
        case .recoverPassword(let email):
            AuthAnalytics.open(page: .ForgotPassword)
            let recoverVC = RecoverPasswordVC.controllerFromStoryboard(.authorization)
            recoverVC.viewModel = RecoverPasswordViewModel(router: unownedRouter, email: email)
            return .push(recoverVC)
        case .enterNewPassword(let hash):
            AuthAnalytics.open(page: .EnterNewPassword)
            let enterNewPasswordVC = EnterNewPasswordVC.controllerFromStoryboard(.authorization)
            enterNewPasswordVC.viewModel = EnterNewPasswordViewModel(router: unownedRouter, protectionHash: hash)
            return .push(enterNewPasswordVC)
        case .register:
            AuthAnalytics.open(page: .Register)
            let registerVC = RegisterVC.controllerFromStoryboard(.authorization)
            registerVC.viewModel = RegisterViewModel(router: unownedRouter)
            return .push(registerVC)
        case .attach(let email, let socialName, let socialType, let socialToken):
            AuthAnalytics.open(page: .BindSocial)
            let bindVC = BindMailVC.controllerFromStoryboard(.authorization)
            bindVC.viewModel = BindMailViewModel(router: unownedRouter, email: email, socialName: socialName, socialType: socialType, socialToken: socialToken)
            return .push(bindVC)
        case .back:
            return .pop()
        case .popToRoot:
            return .popToRoot()
        }
    }
}
