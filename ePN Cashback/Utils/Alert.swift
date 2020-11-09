//
//  Alert.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 23/05/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import Toast_Swift

struct Alert {
    
    static let errorCodeMessage = [-1009: NSLocalizedString("Error internet connection", comment: ""),
        -1001: NSLocalizedString("Error time out request", comment: ""),
        4864: NSLocalizedString("Error something went wrong", comment: ""),
        400001: NSLocalizedString("Required api version", comment: ""),
        400005: NSLocalizedString("Required grand type", comment: ""),
        400006: NSLocalizedString("Unsupported grant type", comment: ""),
        400007: NSLocalizedString("Wrong url for cut", comment: ""),
        400009: NSLocalizedString("Wrong confirmation code", comment: ""),
        400010: NSLocalizedString("Required fields", comment: ""),
        400011: NSLocalizedString("Wrong client id", comment: ""),
        400012: NSLocalizedString("Wrong username or password", comment: ""),
        400013: NSLocalizedString("Wrong refresh token", comment: ""),
        400014: NSLocalizedString("Wrong email format", comment: ""),
        400015: NSLocalizedString("Wrong password format", comment: ""),
        400016: NSLocalizedString("Email already exists", comment: ""),
        400017: NSLocalizedString("Invalid ssid token", comment: ""),
        400018: NSLocalizedString("Required client id", comment: ""),
        400019: NSLocalizedString("Wrong input params", comment: ""),
        400020: NSLocalizedString("Wrong state parameter", comment: ""),
        400021: NSLocalizedString("Email not found", comment: ""),
        400022: NSLocalizedString("Wrong currency format", comment: ""),
        400023: NSLocalizedString("Purse not found", comment: ""),
        400025: NSLocalizedString("Batch request parsed body error", comment: ""),
        400026: NSLocalizedString("Status error purse", comment: ""),
        400027: NSLocalizedString("Status error type", comment: ""),
        400028: NSLocalizedString("Status error purse json", comment: ""),
        400029: NSLocalizedString("Status error purse exist", comment: ""),
        400030: NSLocalizedString("Promocode not found", comment: ""),
        400031: NSLocalizedString("Promocode expired", comment: ""),
        400032: NSLocalizedString("Promocode has not yet begun", comment: ""),
        400033: NSLocalizedString("Promocode over limit", comment: ""),
        400034: NSLocalizedString("Promocode already activated", comment: ""),
        400035: NSLocalizedString("Social network authorization error email already exists", comment: ""),
        400036: NSLocalizedString("Promocode wrong user role", comment: ""),
        400037: NSLocalizedString("Promocode denied by acl", comment: ""),
        400040: NSLocalizedString("Send code limited", comment: ""),
        400041: NSLocalizedString("Send confirmation timeout minutes", comment: ""),
        400042: NSLocalizedString("Send confirmation code timeout days", comment: ""),
        400045: NSLocalizedString("Sms code not exist", comment: ""),
        400046: NSLocalizedString("Check code limited", comment: ""),
        400047: NSLocalizedString("Request is limited", comment: ""),
        400050: NSLocalizedString("Confirmation send timeout", comment: ""),
        400051: NSLocalizedString("Email already confirmed", comment: ""),
        400060: NSLocalizedString("Phones are equal", comment: ""),
        400061: NSLocalizedString("Current phone not correct", comment: ""),
        400062: NSLocalizedString("Phone not confirmed", comment: ""),
        400063: NSLocalizedString("Wrong sso token", comment: ""),
        400070: NSLocalizedString("Tracking number not found", comment: ""),
        400071: NSLocalizedString("Tracking number user subscribe", comment: ""),
        401001: NSLocalizedString("Grant type not allowed", comment: ""),
        401002: NSLocalizedString("Unauthorized invalid token", comment: ""),
        401003: NSLocalizedString("Unauthorized invalid hash", comment: ""),
        403001: NSLocalizedString("Acl role not allowed for request", comment: ""),
        403002: NSLocalizedString("Csrf invalid or expired", comment: ""),
        403003: NSLocalizedString("Acl user status not allowed", comment: ""),
        403004: NSLocalizedString("Acl user project not allowed", comment: ""),
        403005: NSLocalizedString("Current client ip not equals token payload client ip", comment: ""),
        403006: NSLocalizedString("Acl user id method not allowed", comment: ""),
        404001: NSLocalizedString("Request handler not found", comment: ""),
        422001: NSLocalizedString("Validation not passed", comment: ""),
        422100: NSLocalizedString("Validation unknown error", comment: ""),
        422102: NSLocalizedString("Validation amount not correct", comment: ""),
        422103: NSLocalizedString("Validation limit request exceeded", comment: ""),
        422104: NSLocalizedString("Validation not correct purse for currency", comment: ""),
        422105: NSLocalizedString("Validation payout available with larger amount", comment: ""),
        422106: NSLocalizedString("Validation purse not found", comment: ""),
        422107: NSLocalizedString("Validation payment is blocked", comment: ""),
        422108: NSLocalizedString("Validation amount balance exceeded", comment: ""),
        422109: NSLocalizedString("Validation user status banned", comment: ""),
        422110: NSLocalizedString("Validation wiretransfer add address", comment: ""),
        422111: NSLocalizedString("Validation wiretransfer contract signed", comment: ""),
        422112: NSLocalizedString("Validation payment is hold", comment: ""),
        422113: NSLocalizedString("Validation out of range date", comment: ""),
        422114: NSLocalizedString("Validation invalid goods or store link", comment: ""),
        422115: NSLocalizedString("You try to order payout, that bigger than maximum payout limit for this wallet type", comment: ""),
        422116: NSLocalizedString("Price history is empty", comment: ""),
        429000: NSLocalizedString("Too many requests", comment: ""),
        429001: NSLocalizedString("Need captcha", comment: ""),
        429002: NSLocalizedString("User is deleting", comment: ""),
        429003: NSLocalizedString("Wrong captcha", comment: ""),
        429004: NSLocalizedString("Missing linked captcha key", comment: ""),
        500000: NSLocalizedString("Undefined server error", comment: ""),
        500001: NSLocalizedString("Server error while creating access token", comment: ""),
        500002: NSLocalizedString("Error while creating new user", comment: ""),
        500003: NSLocalizedString("Server error while creating refresh token", comment: ""),
        500004: NSLocalizedString("Server error while creating social network auth", comment: ""),
        500005: NSLocalizedString("Undefined service error", comment: ""),
        500010: NSLocalizedString("Get profile from social network error", comment: ""),
        500011: NSLocalizedString("Link social profile error", comment: ""),
        500017: NSLocalizedString("Error while creating ssid token", comment: ""),
        500020: NSLocalizedString("Password recovery server error", comment: ""),
        500021: NSLocalizedString("Cant lock user payments", comment: ""),
        500022: NSLocalizedString("Cant update user password", comment: ""),
        500030: NSLocalizedString("Sending confirmation email error", comment: ""),
        500031: NSLocalizedString("Subscribe user error", comment: ""),
        500032: NSLocalizedString("Cant add new hash for short url", comment: ""),
        500023: NSLocalizedString("Server error while unlink social network for user", comment: ""),
        500024: NSLocalizedString("Cant get balance", comment: ""),
        500025: NSLocalizedString("Cant get user purses", comment: ""),
        500026: NSLocalizedString("Cant get confirm purse", comment: ""),
        500027: NSLocalizedString("Cant remove purse", comment: ""),
        500028: NSLocalizedString("Cant add new purse", comment: ""),
        500029: NSLocalizedString("Incorrect batch response", comment: ""),
        500033: NSLocalizedString("Cant make purse charity", comment: ""),
        500034: NSLocalizedString("Purse charity is not exist", comment: ""),
        500035: NSLocalizedString("Promocode activation failed", comment: ""),
        500050: NSLocalizedString("Acquire lock error", comment: ""),
        500101: NSLocalizedString("Current password not correct", comment: ""),
        500102: NSLocalizedString("Password change is blocked", comment: ""),
        500103: NSLocalizedString("Passwords not equal", comment: ""),
        500104: NSLocalizedString("Password not edited", comment: ""),
        500105: NSLocalizedString("Confirmation impossible", comment: ""),
        500106: NSLocalizedString("Profile not edited", comment: ""),
        500107: NSLocalizedString("Send email retry limited", comment: ""),
        500108: NSLocalizedString("Phone already confirmed", comment: ""),
        500109: NSLocalizedString("Phone not confirmed by sms", comment: ""),
        500110: NSLocalizedString("Active code not exist", comment: ""),
        500111: NSLocalizedString("Account got deleted", comment: ""),
        500112: NSLocalizedString("Avatar not found", comment: "")
]
    
    private static func showAlert(on vc: UIViewController, with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let applyAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        applyAction.setValue(UIColor.sydney, forKey: "titleTextColor")
        alert.addAction(applyAction)
        vc.present(alert, animated: true)
    }
    
    private static func showAlertAction(on vc: UIViewController, with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let applyAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            Util.performOpenURL(stringURL: Util.signInURL)
        })
        applyAction.setValue(UIColor.sydney, forKey: "titleTextColor")
        alert.addAction(applyAction)
        vc.present(alert, animated: true)
    }
    
    static func showErrorAlert(by code: Int, on vc: UIViewController) {
        print("The error code is \(code)")
        let errorMessage = errorCodeMessage[code] ?? NSLocalizedString("Error something went wrong", comment: "")
        showAlert(on: vc, with: NSLocalizedString("Error", comment: ""), message: "\(errorMessage)")
    }
    
    static func showErrorAlertWithAction(by code: Int, on vc: UIViewController) {
        print("The error code is \(code)")
        let errorMessage = errorCodeMessage[code] ?? NSLocalizedString("Error something went wrong", comment: "")
        showAlertAction(on: vc, with: NSLocalizedString("Error", comment: ""), message: "\(errorMessage)")
    }
    
    static func showErrorAlertWithAction(by code: Int, message errorMessage: String, on vc: UIViewController) {
        print("The error code is \(code)")
        showAlertAction(on: vc, with: NSLocalizedString("Error", comment: ""), message: "\(errorMessage)")
    }
    
    static func showErrorAlert(by code: Int, message errorMessage: String, on vc: UIViewController) {
        print("The error code is \(code)")
        showAlert(on: vc, with: NSLocalizedString("Error", comment: ""), message: "\(errorMessage)")
    }
    
    static func showErrorAlert(by code: Int, message errorMessage: String, on vc: UIViewController, okHandler: @escaping () -> Void) {
        print("The error code is \(code)")
        
        let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""),
                                      message: errorMessage,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            okHandler()
        })
        
        okAction.setValue(UIColor.sydney, forKey: "titleTextColor")
        alert.addAction(okAction)
        vc.present(alert, animated: true)
    }
    
    static func showErrorAlert(by error: Error) {
        print("MYLOG: Request error for code: \((error as NSError).code)")
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: self.getMessage(by: error), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: .cancel, handler: {    (action) in    }))
            topController.present(alert, animated: true)
        }
    }
    
    static func showAlert(by title: String, message: String) {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let closeAction = UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: .cancel, handler: {    (action) in    })
            closeAction.setValue(UIColor.sydney, forKey: "titleTextColor")
            alert.addAction(closeAction)
            topController.present(alert, animated: true)
        }
    }
    
    static func showErrorToast(by error: Error) {
        print("MYLOG: Request error for code: \((error as NSError).code)")
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            var toastStyle = ToastStyle()
            toastStyle.backgroundColor = .prague
            toastStyle.messageAlignment = .center
            toastStyle.messageFont = .medium13
            OperationQueue.main.addOperation {
                topController.view.makeToast(self.getMessage(by: error), duration: 1.0, position: .bottom, style: toastStyle)
            }
        }
    }
    
    static func showErrorToast(by message: String) {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            var toastStyle = ToastStyle()
            toastStyle.backgroundColor = .prague
            toastStyle.messageAlignment = .center
            toastStyle.messageFont = .medium13
            OperationQueue.main.addOperation {
                topController.view.makeToast(message, duration: 1.0, position: .bottom, style: toastStyle)
            }
        }
    }
    
    //TODO: remove this method when we'll have moved on Alamofire
    static func showErrorToast(by errorCode: Int) {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            var toastStyle = ToastStyle()
            toastStyle.backgroundColor = .prague
            toastStyle.messageAlignment = .center
            toastStyle.messageFont = .medium13
            let errorMessage = errorCodeMessage[errorCode] ?? NSLocalizedString("Error something went wrong", comment: "")
            OperationQueue.main.addOperation {
                topController.view.makeToast(errorMessage, duration: 1.0, position: .bottom, style: toastStyle)
            }
        }
    }
    
    static func getMessage(by error: Error) -> String {
        if let errorMessage = Alert.errorCodeMessage[(error as NSError).code] {
            return errorMessage
        } else {
            return NSLocalizedString("Error something went wrong", comment: "")
        }
    }
}
