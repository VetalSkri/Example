//
//  OldAPI.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 29/01/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import ProgressHUD

public enum SsoTransitionType {
    case payout
    case statsInviteFriends
    case profile
    case searchOrder
    case support
}

class OldAPI {
    
    static let basicURL = "https://backit.me"
    
    static func performTransition(type: SsoTransitionType) {
        OperationQueue.main.addOperation {
            ProgressHUD.show()
        }
        SsoApiClient.sso { (result) in
            OperationQueue.main.addOperation {
                ProgressHUD.dismiss()
            }
            switch result {
            case .success(let response):
                OperationQueue.main.addOperation {
                    Util.performOpenURL(stringURL: getPath(for: type, ssoToken: response.data.attributes.ssoToken))
                }
                break
            case .failure(let error):
                Alert.showErrorToast(by: error)
                break
            }
        }
    }
    
    static func getPath(for type: SsoTransitionType, ssoToken: String) -> String {
        switch type {
        case .payout:
            return "\(basicURL)/ru/sso/auth?ssoToken=\(ssoToken)&urlAlias=payments"
        case .statsInviteFriends:
            return "\(basicURL)/ru/sso/auth?ssoToken=\(ssoToken)&urlAlias=ref-stat"
        case .profile:
            return"\(basicURL)/ru/sso/auth?ssoToken=\(ssoToken)&urlAlias=profile"
        case .searchOrder:
            return"\(basicURL)/ru/sso/auth?ssoToken=\(ssoToken)&urlAlias=orders-search"
        case .support:
            return "\(basicURL)/ru/sso/auth?ssoToken=\(ssoToken)&urlAlias=support"
        }
    }
    
    static func performTranstionOnTheConditionStatsInviteFriends() {
        Util.performOpenURL(stringURL: "\(basicURL)/cashback/friends/?termType=smart")
    }
}
