//
//  RecoverPasswordViewModel.swift
//  Backit
//
//  Created by Александр Кузьмин on 21/01/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator

class RecoverPasswordViewModel: NSObject {
    
    private let router: UnownedRouter<AuthRoute>
    let startEmail: String
    
    init(router: UnownedRouter<AuthRoute>, email:String = "") {
        self.router = router
        self.startEmail = email
    }
    
    func back() {
        router.trigger(.back)
    }
    
    func popToRoot() {
        router.trigger(.popToRoot)
    }
    
    func send(email: String, completion: ((String?)->())?) {
        AuthApiClient.recoveryEmail(email: encodeEmail(email: email)) { (result) in
            switch result {
            case .success(_):
                completion?(nil)
                AuthAnalytics.successSendEmail()
                break
            case .failure(let error):
                completion?(Alert.getMessage(by: error))
                break
            }
        }
    }
    
    private func encodeEmail(email : String) -> String {
        var result = email
        if let atIndex = email.firstIndex(of: "@") {
            let secondPart = email[email.index(after: atIndex)...]
            let decodedSecondPart = Punycode().encodeIDNA(secondPart)
            result = result.replacingOccurrences(of: secondPart, with: decodedSecondPart ?? String(secondPart))
        }
        return result
    }
    
}
