//
//  LoginViewModel.swift
//  Backit
//
//  Created by Александр Кузьмин on 17/01/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator

class LoginViewModel: NSObject {
    
    private let router: UnownedRouter<AuthRoute>
    
    init(router: UnownedRouter<AuthRoute>) {
        self.router = router
    }
    
    func back() {
        router.trigger(.back)
    }
    
    func recoverPassword(startEmail: String) {
        router.trigger(.recoverPassword(email: startEmail))
    }
    
    func enter(login: String, password: String, complete:((String?)->())?) {
        guard let oauthURL = URL(string: Constants.ProductionServer.oauthURL) else { return }
        AuthApiClient.auth(url: oauthURL, username: encodeEmail(email: login), password: password, checkIp: false) { [weak self] (result) in
            switch result {
            case .success(let response):
                Session.shared.access_token = response.data.attributes.access_token
                Session.shared.refresh_token = response.data.attributes.refresh_token
                let base64Encoded = response.data.attributes.access_token.replacingOccurrences(of: ".", with: ",").split(separator: ",").map(String.init)[1]
                guard let decodedData = base64Encoded.base64Decoded() else {
                    complete?(NSLocalizedString("Unexpected response from server", comment: ""))
                    return
                }
                let cashbackUserRole = decodedData.components(separatedBy: "user_role\":\"")[1].split(separator: "\"")[0].elementsEqual("cashback")
                if !cashbackUserRole {
                    self?.router.trigger(.webmaster)
                    complete?("")
                } else {
                    complete?(nil)
                    AuthAnalytics.auth(type: "email")
                    Session.shared.isAuth = true
                    Session.shared.user_login = login
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.router.trigger(.main(0), with: TransitionOptions(animated: false))
                }
                break
            case .failure(let error):
                complete?(Alert.getMessage(by: error))
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
