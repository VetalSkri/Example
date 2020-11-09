//
//  BindMailViewModel.swift
//  Backit
//
//  Created by Александр Кузьмин on 28/01/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator

class BindMailViewModel: NSObject {
    
    private let router: UnownedRouter<AuthRoute>
    let email: String
    let socialName: String
    let socialType: SocialType
    let socialToken: String
    
    init(router: UnownedRouter<AuthRoute>, email: String, socialName: String, socialType: SocialType, socialToken: String) {
        self.router = router
        self.email = email
        self.socialName = socialName
        self.socialType = socialType
        self.socialToken = socialToken
    }
    
    func back() {
        router.trigger(.back)
    }
    
    func recoveryPassword() {
        router.trigger(.recoverPassword(email: email))
    }
    
    func bind(password: String, complete:((String?)->())?) {
        guard let oauthURL = URL(string: Constants.ProductionServer.oauthURL) else { return }
        AuthApiClient.auth(url: oauthURL, username: email, password: password) { [weak self] (result) in
            switch result {
            case .success(let response):
                guard let self = self else { return }
                
                let base64Encoded = response.data.attributes.access_token.replacingOccurrences(of: ".", with: ",").split(separator: ",").map(String.init)[1]
                guard let decodedData = base64Encoded.base64Decoded() else {
                    complete?(NSLocalizedString("Unexpected response from server", comment: ""))
                    return
                }
                let cashbackUserRole = decodedData.components(separatedBy: "user_role\":\"")[1].split(separator: "\"")[0].elementsEqual("cashback")
                if !cashbackUserRole {
                    self.router.trigger(.webmaster)
                    complete?("")
                    return
                }
                AuthApiClient.bindSocial(socialType: self.socialType, socialToken: self.socialToken, accessToken: response.data.attributes.access_token) { (result) in
                    switch result {
                    case .success(_):
                        Session.shared.access_token = response.data.attributes.access_token
                        Session.shared.refresh_token = response.data.attributes.refresh_token
                        Session.shared.isAuth = true
                        complete?(nil)
                        break
                    case .failure(let error):
                        complete?(Alert.getMessage(by: error))
                        break;
                    }
                }
                break
            case .failure(let error):
                complete?(Alert.getMessage(by: error))
                break
            }
        }
    }
    
    func goToMain() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.router.trigger(.main(0), with: TransitionOptions(animated: false))
    }
    
}
