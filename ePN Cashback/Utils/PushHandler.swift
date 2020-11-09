//
//  PushHandler.swift
//  Backit
//
//  Created by Александр Кузьмин on 19/11/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import UIKit
import XCoordinator

public final class PushHandler {
    
    enum PushType: Int {
        case popup = 1
        case navigation = 2
        case none = 3
        case openUrl = 4
    }
    
    enum PushPopupSubtype: Int {
        case lotteryWin = 1
    }
    
    enum PushNavigationSubtype: Int {
        case offline = 1
        case promotions = 2
        case orders = 3
        case account = 4
        case paymentHistory = 5
        case priceDynamic = 6
        case promocodes = 7
        case inviteFriends = 8
        case support = 9
        case notifications = 10
        case faq = 11
        case settings = 12
        case payment = 13
        case onlineOffer = 14
        case offlineOffer = 17
    }
    
    static func handle(data: [AnyHashable: Any]) {
        if let type = data["type"] as? Int ?? Int(data["type"] as? String ?? "") {
            if type == PushType.openUrl.rawValue {
                handleNavigationOpenUrl(data: data)
                return
            }
        }
        if let type = data["type"] as? Int ?? Int(data["type"] as? String ?? ""), let subtype = data["subtype"] as? Int ?? Int(data["subtype"] as? String ?? "") {
            switch type {
                
            case PushType.popup.rawValue:
                handlePopupSubtype(data: data, subtype: subtype)
                break
                
            case PushType.navigation.rawValue:
                handleNavigationSubtype(data: data, subtype: subtype)
                break
                
            case PushType.none.rawValue:
                break
                
            case PushType.openUrl.rawValue:
                handleNavigationOpenUrl(data: data)
                break
            default:
                return
            }
        }
    }
    
    private static func handlePopupSubtype(data: [AnyHashable: Any], subtype: Int) {
        switch subtype {
        case PushPopupSubtype.lotteryWin.rawValue:
            if !Session.shared.isAuth { return } //Do nothing, if user not login
            if let lotteryData = data["data"] as? String {
                if let jsonData = lotteryData.data(using: .utf8), let jsonDict = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? NSDictionary {
                    if let percent = jsonDict["percent"] as? String, let receiptNumber = jsonDict["receiptNumber"] as? String, let cashback = jsonDict["cashback"] as? String {
                        OperationQueue.main.addOperation {
                            let router = (UIApplication.shared.delegate as! AppDelegate).router
                            router?.trigger(.deepLinkOrderHistory, completion: {
                                let popUpVC = LotteryPopupVC(nibName: "LotteryPopupVC", bundle: nil)
                                popUpVC.modalPresentationStyle = .overFullScreen
                                popUpVC.modalTransitionStyle = .crossDissolve
                                popUpVC.setup(percent: percent, cashback: cashback, receiptNumber: receiptNumber)
                                UIApplication.shared.topMostViewController()?.present(popUpVC, animated: true, completion: nil)
                            })
                        }
                    }
                }
            }
            break
        default:
            return
        }
    }
    
    private static func handleNavigationSubtype(data: [AnyHashable: Any], subtype: Int) {
        if !Session.shared.isAuth { return }
        switch subtype {
        case PushNavigationSubtype.offline.rawValue:
            (UIApplication.shared.delegate as! AppDelegate).router.trigger(.deepLinkOfflineCB, with: TransitionOptions(animated: false))
            break
        case PushNavigationSubtype.promotions.rawValue:
            (UIApplication.shared.delegate as! AppDelegate).router.trigger(.deepLinkPromotions, with: TransitionOptions(animated: false))
            break
        case PushNavigationSubtype.orders.rawValue:
            (UIApplication.shared.delegate as! AppDelegate).router.trigger(.deepLinkOrderHistory, with: TransitionOptions(animated: false))
            break
        case PushNavigationSubtype.account.rawValue:
            (UIApplication.shared.delegate as! AppDelegate).router.trigger(.deepLinkAccount, with: TransitionOptions(animated: false))
            break
        case PushNavigationSubtype.paymentHistory.rawValue:
            (UIApplication.shared.delegate as! AppDelegate).router.trigger(.deepLinkPaymentsHistory, with: TransitionOptions(animated: false))
            break
        case PushNavigationSubtype.priceDynamic.rawValue:
            (UIApplication.shared.delegate as! AppDelegate).router.trigger(.deepLinkVerifyLink, with: TransitionOptions(animated: false))
            break
        case PushNavigationSubtype.promocodes.rawValue:
            (UIApplication.shared.delegate as! AppDelegate).router.trigger(.deepLinkPromo, with: TransitionOptions(animated: false))
            break
        case PushNavigationSubtype.inviteFriends.rawValue:
            (UIApplication.shared.delegate as! AppDelegate).router.trigger(.deepLinkInvite, with: TransitionOptions(animated: false))
            break
        case PushNavigationSubtype.support.rawValue:
            (UIApplication.shared.delegate as! AppDelegate).router.trigger(.deepLinkSupport, with: TransitionOptions(animated: false))
            break
        case PushNavigationSubtype.notifications.rawValue:
            (UIApplication.shared.delegate as! AppDelegate).router.trigger(.deepLinkNotifications, with: TransitionOptions(animated: false))
            break
        case PushNavigationSubtype.faq.rawValue:
            (UIApplication.shared.delegate as! AppDelegate).router.trigger(.deepLinkFAQ, with: TransitionOptions(animated: false))
            break
        case PushNavigationSubtype.settings.rawValue:
            (UIApplication.shared.delegate as! AppDelegate).router.trigger(.deepLinkSetting, with: TransitionOptions(animated: false))
            break
        case PushNavigationSubtype.payment.rawValue:
            (UIApplication.shared.delegate as! AppDelegate).router.trigger(.deepLinkPayments, with: TransitionOptions(animated: false))
            break
        case PushNavigationSubtype.onlineOffer.rawValue:
            if let pushData = data["data"] as? String {
                if let jsonData = pushData.data(using: .utf8), let jsonDict = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? NSDictionary {
                    if let offerId = jsonDict["offerId"] as? Int {
                        let store = Store(id: offerId, name: "", title: "", tag: "", image: "", logo: "", logo_s: nil, priority: 0, maxRate: nil,maxRatePretext: nil, typeId: ShopTypeId.offlineMulty.rawValue, offlineCbImage: nil, offlineCbDescription: nil, linkDefault: nil, url: nil)
                        (UIApplication.shared.delegate as! AppDelegate).router.trigger(.deepLinkOnlineShopDetail(store, .pushNotification), with: TransitionOptions(animated: false))
                    } else if let offerIdString = jsonDict["offerId"] as? String, let offerId = Int(offerIdString) {
                        let store = Store(id: offerId, name: "", title: "", tag: "", image: "", logo: "", logo_s: nil, priority: 0, maxRate: nil,maxRatePretext: nil, typeId: ShopTypeId.offlineMulty.rawValue, offlineCbImage: nil, offlineCbDescription: nil, linkDefault: nil, url: nil)
                        (UIApplication.shared.delegate as! AppDelegate).router.trigger(.deepLinkOnlineShopDetail(store, .pushNotification), with: TransitionOptions(animated: false))
                    }
                }
            }
            break
            case PushNavigationSubtype.offlineOffer.rawValue:
            if let pushData = data["data"] as? String {
                if let jsonData = pushData.data(using: .utf8), let jsonDict = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? NSDictionary {
                    if let offerId = jsonDict["offerId"] as? Int {
                        (UIApplication.shared.delegate as! AppDelegate).router.trigger(.deepLinkOfflineShopDetail(OfferOffline(id: offerId, title: "", description: nil, priority: 0, image: nil, tag: nil, url: nil, typeId: 0, type: ShopTypeId.offlineMulty.rawValue), .pushNotification))
                    } else if let offerIdString = jsonDict["offerId"] as? String, let offerId = Int(offerIdString) {
                        (UIApplication.shared.delegate as! AppDelegate).router.trigger(.deepLinkOfflineShopDetail(OfferOffline(id: offerId, title: "", description: nil, priority: 0, image: nil, tag: nil, url: nil, typeId: 0, type: ShopTypeId.offlineMulty.rawValue), .pushNotification))
                    }
                }
            }
            break
        default:
            return
        }
    }
    
    private static func handleNavigationOpenUrl(data: [AnyHashable: Any]) {
        if let pushData = data["data"] as? String {
            if let jsonData = pushData.data(using: .utf8), let jsonDict = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? NSDictionary {
                if let urlString = jsonDict["url"] as? String {
                    guard let url = URL(string: urlString) else { return }
                    UIApplication.shared.open(url)
                }
            }
        }
    }
    
}
