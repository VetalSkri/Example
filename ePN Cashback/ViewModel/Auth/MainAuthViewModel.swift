//
//  MainAuthViewModel.swift
//  Backit
//
//  Created by Александр Кузьмин on 17/01/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator

class MainAuthViewModel: NSObject {
    
    private let router: UnownedRouter<AuthRoute>
    let animate: Bool
    
    init(router: UnownedRouter<AuthRoute>, animate: Bool) {
        self.router = router
        self.animate = animate
    }
    
    func login() {
        router.trigger(.login)
    }
    
    func register() {
        AppMetricaAuthAnalytics.runMailRegister()
        router.trigger(.register)
    }
    
    func socialAuth(token: String, email: String?, appleId: String?, firstName: String?, lastName: String?, type: SocialType, complete:(()->())?, needAttachEmail:((SocialType, String)->())?) {
        AppMetricaAuthAnalytics.runSocialAuth(socialType: type)
        AuthApiClient.socialAuth(token: token, email: email, appleId: appleId, firstName: firstName, lastName: lastName, promocode: nil, checkIp: nil, socialType: type.rawValue) { [weak self] (result) in
            switch result {
            case .success(let response):
                let base64Encoded = response.data.attributes.access_token.replacingOccurrences(of: ".", with: ",").split(separator: ",").map(String.init)[1]
                guard let decodedData = base64Encoded.base64Decoded() else {
                    complete?()
                    Alert.showErrorToast(by: NSLocalizedString("Unexpected response from server", comment: ""))
                    return
                }
                let cashbackUserRole = decodedData.components(separatedBy: "user_role\":\"")[1].split(separator: "\"")[0].elementsEqual("cashback")
                if !cashbackUserRole {
                    self?.router.trigger(.webmaster)
                    complete?()
                    return
                }
                Session.shared.access_token = response.data.attributes.access_token
                Session.shared.refresh_token = response.data.attributes.refresh_token
                AuthAnalytics.auth(type: type.rawValue)
                Session.shared.isAuth = true
                AppMetricaAuthAnalytics.successRegister(socialType: type)
                complete?()
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.router.trigger(.main(0), with: TransitionOptions(animated: false))
                break
            case .failure(let error):
                complete?()
                if (error as NSError).code == 400016 {
                    if type == .apple {
                        Alert.showAlert(by: "", message: NSLocalizedString("You already have an account registered by this mail attached to your Apple id", comment: ""))
                        return
                    }
                    needAttachEmail?(type, email ?? "")
                    return
                }
                Alert.showErrorToast(by: error)
                break
            }
        }
    }
    
    func attach(email: String, socialName: String, socialType: SocialType, socialToken: String) {
        router.trigger(.attach(email: email, socialName: socialName, socialType: socialType, socialToken: socialToken))
    }
    
}
