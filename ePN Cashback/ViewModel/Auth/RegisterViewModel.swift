//
//  RegisterViewModel.swift
//  Backit
//
//  Created by Александр Кузьмин on 21/01/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator

class RegisterViewModel: NSObject {
    
    private let router: UnownedRouter<AuthRoute>
    var acceptToNewsSubscription = true
    var promocode: String? = nil
    
    init(router: UnownedRouter<AuthRoute>) {
        self.router = router
    }
    
    func back() {
        router.trigger(.back)
    }
    
    func getPrivacyUrl() -> URL? {
        return URL(string: "https://backit.me/\(Util.languageOfContent())/cashback/privacy")
    }
    
    func getRulesUrl() -> URL? {
        return URL(string: "https://backit.me/\(Util.languageOfContent())/cashback/rules")
    }
    
    func register(email: String, password: String, complete:((String?)->())?) {
        AuthApiClient.register(email: encodeEmail(email: email), password: password, promocode: promocode, checkIp: nil, newsSubscription: acceptToNewsSubscription ? 1 : 0) { (result) in
            switch result {
            case .success(let response):
                Session.shared.access_token = response.data.attributes.access_token
                Session.shared.refresh_token = response.data.attributes.refresh_token
                AuthAnalytics.register(type: "email")
                Session.shared.isAuth = true
                AppMetricaAuthAnalytics.successRegister(socialType: nil)
                complete?(nil)
                break
            case .failure(let error):
                complete?(Alert.getMessage(by: error))
                break
            }
        }
    }
    
    func checkPromocode(promocode: String, complete:((String?)->())?) {
        AuthApiClient.checkPromo(prmocode: promocode) { [weak self] (result) in
            switch result {
            case .success(_):
                self?.promocode = promocode
                AuthAnalytics.enterPromocode()
                complete?(nil)
                break
            case .failure(let error):
                complete?(Alert.getMessage(by: error))
                break
            }
        }
    }
    
    func enter() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.router.trigger(.main(0), with: TransitionOptions(animated: false))
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
