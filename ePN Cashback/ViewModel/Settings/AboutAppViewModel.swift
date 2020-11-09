//
//  AboutAppViewModel.swift
//  CashBackEPN
//
//  Created by Александр on 14/05/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import UIKit

class AboutAppViewModel : NSObject
{
    
    private let epnUrl = "https://backit.me"
    private let vkUrl = "https://vk.com/backit"
    private let facebookUrl = "https://www.facebook.com/backit.me"
    private let instagramUrl = "https://www.instagram.com/backit.me"
    private let youtubeUrl = "https://www.youtube.com/backit"
    private let telegramUrl = "https://t.me/backit"
    
    var title : String {
        return NSLocalizedString("Settings_About", comment: "")
    }
    
    var officialSite: String{
        return NSLocalizedString("Settings_OfficialSite", comment: "")
    }
    
    var joinUs: String{
        return NSLocalizedString("Settings_JoinUsOnSocialMedia", comment: "")
    }
    
    var version: String{
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        let versionText = NSLocalizedString("Settings_Version", comment: "")
        return String(format: "%@ %@", versionText, appVersion ?? "")
    }
    
    func openEpnSite(){
        UIApplication.shared.open(URL(string: epnUrl)!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
    }
    
    func openVk(){
        UIApplication.shared.open(URL(string: vkUrl)!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
    }
    
    func openFacebook(){
        UIApplication.shared.open(URL(string: facebookUrl)!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
    }
    
    func openInstagram(){
        UIApplication.shared.open(URL(string: instagramUrl)!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
    }
    
    func openYoutube(){
        UIApplication.shared.open(URL(string: youtubeUrl)!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
    }
    
    func openTelegram(){
        UIApplication.shared.open(URL(string: telegramUrl)!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
