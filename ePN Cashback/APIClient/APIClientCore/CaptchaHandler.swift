//
//  CaptchaHandler.swift
//  BackitmodalPresentationStyle = .fullScreen
//
//  Created by Александр Кузьмин on 05/11/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import UIKit

public class CaptchaHandler: NSObject {
    
    public class func show(captcha: ErrorCaptcha, enterCaptcha:((String)->())?, cancel:(()->())?) {
        let storyboard = UIStoryboard(name: "Captcha", bundle: nil)
        let captchaVC = storyboard.instantiateViewController(withIdentifier: "CaptchaVC") as! CaptchaVC
        captchaVC.captcha = captcha
        captchaVC.modalPresentationStyle = .overFullScreen
        captchaVC.modalTransitionStyle = .crossDissolve
        captchaVC.enterHandler = enterCaptcha
        captchaVC.cancel = cancel
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.present(captchaVC, animated: true, completion: nil)
        }
    }
    
}
