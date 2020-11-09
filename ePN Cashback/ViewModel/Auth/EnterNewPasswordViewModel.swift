//
//  EnterNewPasswordViewModel.swift
//  Backit
//
//  Created by Александр Кузьмин on 03/02/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator

class EnterNewPasswordViewModel: NSObject {
    
    private let router: UnownedRouter<AuthRoute>
    private let protectionHash: String
    
    init(router: UnownedRouter<AuthRoute>, protectionHash:String) {
        self.router = router
        self.protectionHash = protectionHash
    }
    
    func popToRoot() {
        router.trigger(.popToRoot)
    }
    
    func goToLogin() {
        router.trigger(.popToRoot, with: TransitionOptions(animated: false))
        router.trigger(.login)
    }
    
    func changePassword(password: String, completion:((String?)->())?) {
        AuthApiClient.newPassword(hash: protectionHash, password: password) { (result) in
            switch result {
            case .success(let response):
                if response.data.attributes.password_changed.lowercased() != "yes" {
                    completion?(NSLocalizedString("Password not change", comment: ""))
                    return
                }
                completion?(nil)
                break
            case .failure(let error):
                completion?(Alert.getMessage(by: error))
                break
            }
        }
    }
    
}
