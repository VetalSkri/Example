//
//  Analytics.swift
//  Backit
//
//  Created by Ivan Nikitin on 26/09/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import Crashlytics

final class Analytics {
    
    private enum EventName: String {
        case Log = "Digits"
        case InvireFriends = "InviteFriends"
        case Payments = "Payments"
        case Receipt = "Receipt"
        case FAQ = "FAQ"
        case PaymentHistory = "PaymentHistory"
        case Promocode = "Promocodes"
        case Support = "Support"
        case Notification = "NotificationHistory"
        case Settings = "Settings"
        case Promotions = "Promotions"
        case MyOrders = "MyOrders"
        case Stores = "Stores"
        case Profile = "Profile"
    }
    
    //MARK: Stores
    
    class func detailStoreEventPressed() {
        Answers.logCustomEvent(withName: EventName.Stores.rawValue, customAttributes: ["DetailPage": "Open"])
    }
    
    class func detailStoreEventPressed(byTitle title: String) {
        Answers.logCustomEvent(withName: EventName.Stores.rawValue, customAttributes: ["Store": title])
    }
    
    class func openTargetStoreEventPressed() {
        Answers.logCustomEvent(withName: EventName.Stores.rawValue, customAttributes: ["DetailPage": "OpenTargetStore"])
    }
    
    //MARK: Promotions
    
    class func detailPromotionEventPressed() {
        Answers.logCustomEvent(withName: EventName.Promotions.rawValue, customAttributes: ["DetailPage": "Open"])
    }
    
    class func openTargetPromotionEventPressed() {
        Answers.logCustomEvent(withName: EventName.Promotions.rawValue, customAttributes: ["DetailPage": "OpenTargetPromotion"])
    }
    
    //MARK: MyOrders
    
    class func detailOrderEventPressed() {
        Answers.logCustomEvent(withName: EventName.MyOrders.rawValue, customAttributes: ["DetailPage": "Open"])
    }
    
    //MARK: FAQ
    
    class func faqEventPressed() {
        Answers.logCustomEvent(withName: EventName.FAQ.rawValue, customAttributes: nil)
    }
    
    //MARK: PaymentsHistory
    
    class func paymentsHistoryEventPressed() {
        Answers.logCustomEvent(withName: EventName.PaymentHistory.rawValue,
        customAttributes: nil)
    }
    
    //MARK: Promocodes
    
    class func promocodesEventPressed() {
        Answers.logCustomEvent(withName: EventName.Promocode.rawValue,
        customAttributes: nil)
    }
    
    //MARK: Support
    
    class func supportEventPressed() {
        Answers.logCustomEvent(withName: EventName.Support.rawValue,
        customAttributes: nil)
    }
    
    class func goOnSupportEventPressed() {
        Answers.logCustomEvent(withName: EventName.Support.rawValue,
                               customAttributes: ["Behaviour": "OpenSupport"])
    }
    
    class func supportDialogUnknownTicketStatus(ticketStatus: String) {
        Answers.logCustomEvent(withName: EventName.Support.rawValue,
        customAttributes: ["UnknownTicketStatus": ticketStatus])
    }
    
    //MARK: Profile
    
    class func profileEventPressed() {
        Answers.logCustomEvent(withName: EventName.Profile.rawValue,
        customAttributes: nil)
    }
    
    class func goOnProfileEventPressed() {
        Answers.logCustomEvent(withName: EventName.Profile.rawValue,
                               customAttributes: ["Behaviour": "ChangeProfile"])
    }
    
    //MARK: Notifications
    
    class func notificationsHistoryEventPressed() {
        Answers.logCustomEvent(withName: EventName.Notification.rawValue,
        customAttributes: nil)
    }
    
    //MARK: Settings
    
    class func settingsEventPressed() {
        Answers.logCustomEvent(withName: EventName.Settings.rawValue,
        customAttributes: nil)
    }
    //MARK: Invite Friends
    
    class func inviteFriendsEventPressed() {
        Answers.logInvite(withMethod: EventName.InvireFriends.rawValue,
        customAttributes: nil)
    }
    
    class func inviteFriendsEventPressedSuccess() {
        Answers.logInvite(withMethod: EventName.InvireFriends.rawValue,
                          customAttributes: ["sent":true])
    }
    
    //MARK: SignUp & LogIn
    
    class func logLoginSocialNetwork(name: String) {
        Answers.logLogin(withMethod: EventName.Log.rawValue,
                         success: true,
                         customAttributes: ["SocialNetwork": name])
    }
    
    class func logLogin() {
        Answers.logLogin(withMethod: EventName.Log.rawValue,
                               success: true,
                               customAttributes: nil)
    }
    
    class func logSignUp() {
        Answers.logSignUp(withMethod: EventName.Log.rawValue,
                                success: true,
                                customAttributes: nil)
    }
    
    //MARK: Payment
    
    private enum PaymentEvent: String {
        case addPurse = "paymentAddPurse"
        case orderWithdrawal = "paymentOrderWithdrawal"
    }
    
    class func openEventPayment() {
        Answers.logCustomEvent(withName: EventName.Payments.rawValue, customAttributes: nil)
    }
    
    class func sendEventAddPurse(purseType: PurseType) {
        Answers.logCustomEvent(withName: EventName.Payments.rawValue, customAttributes: [PaymentEvent.addPurse.rawValue: "success", "PurseType": purseType.rawValue])
    }
    
    class func sendEventOrderWithdrawl() {
        Answers.logCustomEvent(withName: EventName.Payments.rawValue, customAttributes: [PaymentEvent.orderWithdrawal.rawValue: "request"])
    }
    
    class func sendEventSuccessOrderWithdrawl() {
        Answers.logCustomEvent(withName: EventName.Payments.rawValue, customAttributes: [PaymentEvent.orderWithdrawal.rawValue: "success"])
    }
    
    //MARK: Receipt
    
    private enum ReceiptCategory: String {
        case Multy
        case Spec
        case Scan
    }
    
    private enum ReceiptEvent: String {
        case Scan
        case multyOffers = "ShowMultyOffers"
        case specOffers = "ShowSpecOffers"
        case multyScan = "OpenScanFromMultyOffers"
        case specScan = "OpenScanFromSpecOffers"
        case detailScan = "OpenScanFromDetailOffer"
        case detailMultyScan = "OpenScanFromDetailMultyOffer"
        case detailSpecScan = "OpenScanFromDetailSpecOffer"
        case detailSpecOffer = "OpenDetailSpecOffer"
        case detailMultyOffer = "OpenDetailMultyOffer"
        case popupMultyOffer = "OpenPopUpAnimationFromMultyOffers"
        case popupSpecOffer = "OpenPopUpAnimationFromSpecOffers"
        case popupHint = "OpenPopUpHint"
        case manual = "OpenManualEnter"
        case manualSendQr = "SendQRFromManualEnter"
        case scanSendQr = "SendQRFromScan"
        case success
        case fail
    }
    class func showEventMultyOffers() {
        Answers.logCustomEvent(withName: EventName.Receipt.rawValue, customAttributes: [ReceiptCategory.Multy.rawValue: ReceiptEvent.multyOffers.rawValue])
    }
    
    class func showEventSpecOffers() {
        Answers.logCustomEvent(withName: EventName.Receipt.rawValue, customAttributes: [ReceiptCategory.Spec.rawValue: ReceiptEvent.specOffers.rawValue])
    }
    
    class func openScanEvent() {
        Answers.logCustomEvent(withName: EventName.Receipt.rawValue, customAttributes: [ReceiptCategory.Scan.rawValue: ReceiptEvent.Scan.rawValue])
    }
    
    class func openEventScanFromMultyOffers() {
        Answers.logCustomEvent(withName: EventName.Receipt.rawValue, customAttributes: [ReceiptCategory.Multy.rawValue: ReceiptEvent.multyScan.rawValue])
    }
    
    class func openEventScanFromSpecOffers() {
        Answers.logCustomEvent(withName: EventName.Receipt.rawValue, customAttributes: [ReceiptCategory.Spec.rawValue: ReceiptEvent.specScan.rawValue])
    }
    
    class func openEventScanFromDetailOffer() {
        Answers.logCustomEvent(withName: EventName.Receipt.rawValue, customAttributes: [ReceiptCategory.Scan.rawValue: ReceiptEvent.detailScan.rawValue])
    }
    
    class func openEventScanFromDetailMultyOffer() {
        Answers.logCustomEvent(withName: EventName.Receipt.rawValue, customAttributes: [ReceiptCategory.Multy.rawValue: ReceiptEvent.detailMultyScan.rawValue])
    }
    
    class func openEventScanFromDetailSpecOffer() {
        Answers.logCustomEvent(withName: EventName.Receipt.rawValue, customAttributes: [ReceiptCategory.Spec.rawValue: ReceiptEvent.detailSpecScan.rawValue])
    }
    
    class func openEventDetailMultyOffer(title: String) {
        Answers.logCustomEvent(withName: EventName.Receipt.rawValue, customAttributes: [ReceiptCategory.Multy.rawValue: ReceiptEvent.detailMultyOffer.rawValue, "Product": title])
    }
    
    class func openEventDetailSpecOffer(title: String) {
        Answers.logCustomEvent(withName: EventName.Receipt.rawValue, customAttributes: [ReceiptCategory.Spec.rawValue: ReceiptEvent.detailSpecOffer.rawValue, "Product": title])
    }
    
    class func openEventHint() {
        Answers.logCustomEvent(withName: EventName.Receipt.rawValue, customAttributes: [ReceiptCategory.Scan.rawValue: ReceiptEvent.popupHint.rawValue])
    }
    
    class func openEventSuccessPopUp() {
        Answers.logCustomEvent(withName: EventName.Receipt.rawValue, customAttributes: [ReceiptCategory.Scan.rawValue: ReceiptEvent.success.rawValue])
    }
    
    class func openEventFailPopUp() {
        Answers.logCustomEvent(withName: EventName.Receipt.rawValue, customAttributes: [ReceiptCategory.Scan.rawValue: ReceiptEvent.fail.rawValue])
    }
    
    class func showEventAnimationPopUpMulty() {
        Answers.logCustomEvent(withName: EventName.Receipt.rawValue, customAttributes: [ReceiptCategory.Multy.rawValue: ReceiptEvent.popupMultyOffer.rawValue])
    }
    
    class func showEventAnimationPopUpSpec() {
        Answers.logCustomEvent(withName: EventName.Receipt.rawValue, customAttributes: [ReceiptCategory.Spec.rawValue: ReceiptEvent.popupSpecOffer.rawValue])
    }
    
    class func openEventManualyEnter() {
       Answers.logCustomEvent(withName: EventName.Receipt.rawValue, customAttributes: [ReceiptCategory.Scan.rawValue: ReceiptEvent.manual.rawValue])
    }
    
    class func sentEventManualySendQR() {
        Answers.logCustomEvent(withName: EventName.Receipt.rawValue, customAttributes: [ReceiptCategory.Scan.rawValue: ReceiptEvent.manualSendQr.rawValue])
    }
    
    class func sentEventScanSendQR() {
        Answers.logCustomEvent(withName: EventName.Receipt.rawValue, customAttributes: [ReceiptCategory.Scan.rawValue: ReceiptEvent.scanSendQr.rawValue])
    }
           
}
