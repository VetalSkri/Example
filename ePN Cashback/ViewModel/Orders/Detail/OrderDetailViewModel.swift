//
//  OrderDetailViewModel.swift
//  Backit
//
//  Created by Александр Кузьмин on 24/03/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator

class OrderDetailViewModel: NSObject {
    
    private enum OfferType {
        case online
        case offline
        case multi
    }
    
    private let router: UnownedRouter<OrdersRoute>
    private let transaction: OrdersDataResponse
    private let image: String?
    private let name: String?
    
    var shouldLoadData: Bool {
        isAliExpressOffer
    }
    
    private var isAliExpressOffer: Bool {
        Int(transaction.attributes.offer_id) == 1
    }
 
    init(router: UnownedRouter<OrdersRoute>, transaction: OrdersDataResponse, image: String?, name: String?) {
        self.router = router
        self.transaction = transaction
        self.image = image
        self.name = name
    }
    
    func title() -> String {
        return name ?? ""
    }
    
    func back() {
        router.trigger(.back)
    }
    
    func status() -> String {
        if (Int(transaction.attributes.offer_id) ?? 0 != LocalSymbolsAndAbbreviations.MULTY_OFFER_ID) {
            switch orderStatus() {
            case .processing:
                return NSLocalizedString("TransactionStatus_InProcess", comment: "")
            case .confirmed:
                return NSLocalizedString("TransactionStatus_Completed", comment: "")
            case .rejected:
                return NSLocalizedString("TransactionStatus_Rejectd", comment: "")
            }
        }
        switch orderStatus() {
        case .processing:
            return NSLocalizedString("Looking for cashback in your check", comment: "")
        case .confirmed:
            return NSLocalizedString("TransactionStatus_CashbackFound", comment: "")
        case .rejected:
            return NSLocalizedString("No cashback products found", comment: "")
        }
    }
    
    func subtitleText() -> String {
        if isMultiOffer() {
            return (orderStatus() == .confirmed) ? NSLocalizedString("A separate order has been created for goods", comment: "") : ""
        }
        let cost = format(cost: transaction.attributes.commission_user)+LocalSymbolsAndAbbreviations.getSymbolOfCurrency(value: transaction.attributes.currency)
        return (orderStatus() == .confirmed) ? "+"+cost : cost
    }
    
    func orderStatus() -> OrderStatus {
        switch LocalSymbolsAndAbbreviations.getOrderStatus(fromStatus: transaction.attributes.order_status) {
        case "completed":
            return .confirmed
        case "rejected":
            return .rejected
        default:
            return .processing
        }
    }
    
    func orderTypeId() -> Int {
        return Int(transaction.attributes.type_id ?? "1") ?? 1
    }
    
    func isMultiOffer() -> Bool {
        return Int(transaction.attributes.offer_id) ?? 0 == LocalSymbolsAndAbbreviations.MULTY_OFFER_ID
    }
    
    func format(cost: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.usesGroupingSeparator = false
        formatter.locale = Locale(identifier: "en_US")
        formatter.decimalSeparator = "."
        let costInNumber = formatter.number(from: cost)
        formatter.minimumFractionDigits = 2
        return formatter.string(from: costInNumber ??  NSNumber(floatLiteral: 0.0)) ?? "0.00"
    }
    
    func offerLogoImage() -> String {
        return image ?? ""
    }
    
    func offerFirstDetail() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: transaction.attributes.order_time)
        dateFormatter.dateFormat = "d MMMM"
        let presentedDate = (date != nil) ? dateFormatter.string(from: date!) : ""
        let resultString: String
        
        switch self.getOfferType() {
        case .online:
            resultString = NSLocalizedString("Purchase for", comment: "") + " " + format(cost: transaction.attributes.revenue) + LocalSymbolsAndAbbreviations.getSymbolOfCurrency(value: transaction.attributes.currency) + " " + NSLocalizedString("on", comment: "") + " " + presentedDate
            
        case .multi:
            resultString = NSLocalizedString("Receipt in processing since", comment: "") + " " + presentedDate
            
        case .offline:
            resultString = NSLocalizedString("Item was found in receipt on", comment: "") + " " + presentedDate
        }

        switch orderStatus() {
        case .processing:
            return ""
        case .confirmed, .rejected:
            return resultString
        }
    }
    
    func offerDetail() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let date = dateFormatter.date(from: transaction.attributes.date)
        dateFormatter.dateFormat = "d MMMM"
        let presentedDate = (date != nil) ? dateFormatter.string(from: date!) : ""
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let transactionDate = dateFormatter.date(from: transaction.attributes.transaction_time)
        dateFormatter.dateFormat = "d MMMM"
        let transactionPresentDate = (transactionDate != nil) ? dateFormatter.string(from: transactionDate!) : ""
        
        switch self.getOfferType() {
        case .online:
            switch orderStatus() {
            case .processing:
                return NSLocalizedString("Purchase for", comment: "") + " " + format(cost: transaction.attributes.revenue)+LocalSymbolsAndAbbreviations.getSymbolOfCurrency(value: transaction.attributes.currency) + " " + NSLocalizedString("on", comment: "") + " " + presentedDate
            case .confirmed:
                return NSLocalizedString("Cashback was credited to the balance on", comment: "") + " " + transactionPresentDate
            case .rejected:
                return NSLocalizedString("Cashback for purchase was rejected on", comment: "") + " " + transactionPresentDate
            }
            
        case .multi:
            switch orderStatus() {
            case .processing:
                return NSLocalizedString("Receipt in processing since", comment: "") + " " + presentedDate
            case .confirmed:
                return NSLocalizedString("Receipt was checked on", comment: "") + " " + transactionPresentDate
            case .rejected:
                return NSLocalizedString("Receipt was declined on", comment: "") + " " + transactionPresentDate
            }
            
        case .offline:
            switch orderStatus() {
            case .processing:
                return NSLocalizedString("Item was found in receipt on", comment: "") + " " + presentedDate
            case .confirmed:
                return NSLocalizedString("Cashback for the product was accrued on", comment: "") + " " + transactionPresentDate
            case .rejected:
                return NSLocalizedString("Cashback was rejected on", comment: "") + " " + transactionPresentDate
            }
        }
    }
    
    func offerNumber() -> String {
        return NSLocalizedString("Order №", comment: "")+" "+transaction.attributes.order_number
    }
    
    func descriptionText() -> String {
        switch orderStatus() {
        case .processing:
            if Int(transaction.attributes.offer_id) ?? 0 == 1 {
                return NSLocalizedString("Confirm receipt of order on AliExpress to get cashback faster.", comment: "")
            }
            if orderTypeId() == 1 || orderTypeId() == 2 {
                return NSLocalizedString("Order processing takes from several days to a couple of months.", comment: "")
            } else {
                return NSLocalizedString("Checking a check takes from a few days to a couple of months.", comment: "")
            }
        case .confirmed:
            return NSLocalizedString("Cashback has switched to balance and is available for withdrawal.", comment: "")
        case .rejected:
            return (orderTypeId() == 1 || orderTypeId() == 2) ? NSLocalizedString("Cashback for order canceled", comment: "") : NSLocalizedString("Please check the check again. If there is exactly the right product there, write to tech support.", comment: "")
        }
    }
    
    func statusImageName() -> String {
        switch orderStatus() {
        case .processing:
            if Int(transaction.attributes.offer_id) ?? 0 == 1 { //Aliexpress
                return "aliOrderProcessing"
            }
            if orderTypeId() == 1 || orderTypeId() == 2 {   //Online offers
                return "checkOrderProcessing"
            } else {
                return "checkOrderProcessing"
            }
        case .confirmed:
            return "orderConfirmed"
        case .rejected:
            return (orderTypeId() == 1 || orderTypeId() == 2) ? "onlineOrderCancel" : "receiptCancel"
        }
    }
    
    func copyOrderNumberToClipboard() {
        DispatchQueue.main.async { [weak self] in
            UIPasteboard.general.string = self?.transaction.attributes.order_number ?? ""
        }
    }
    
    func isShowActionButton() -> Bool {
        return !((orderTypeId() == 1 || orderTypeId() == 2) && Int(transaction.attributes.offer_id) ?? 0 != 1) && transaction.attributes.product_link.count > 0
    }
    
    func actionButtonText() -> String {
        return (orderTypeId() == 3 || orderTypeId() == 4) ? NSLocalizedString("Receipt Information", comment: "") : NSLocalizedString("Go to the store", comment: "")
    }
    
    func actionButtonClicked(completion: (() -> Void)? = nil) {
        if ((orderTypeId() == 3 || orderTypeId() == 4)) {
            guard let url = URL(string: transaction.attributes.product_link) else { return }
            UIApplication.shared.open(url)
            return
        }
        var productLink = ""
        if transaction.attributes.product_link.hasPrefix("//") {
            productLink = "https:\(transaction.attributes.product_link)"
        } else {
            productLink = transaction.attributes.product_link
        }
        
        if isAliExpressOffer {
            VerifyLinkApiClient.verifyLink(link: productLink) { [weak self] result in
                guard let `self` = self else {
                    return
                }
                
                switch result {
                case .success(let response):
                    let link = response.data.attributes.redirectUrl
                    
                    if let schema = response.data.attributes.cashbackPackage?.schema,
                        !schema.isEmpty,
                        UIApplication.shared.canOpenURL(URL(string: "\(schema)://")!),
                        let mobileLink = response.data.attributes.cashbackPackage?.link,
                        let url = URL(string: mobileLink) {
                        URLSession.shared.dataTask(with: url, completionHandler: { [weak self] data, response, error in
                            guard let `self` = self else {
                                return
                            }
                            
                            guard let data = data, error == nil else {
                                self.open(link: link)
                                
                                return
                            }
                            
                            OperationQueue.main.addOperation {
                                do {
                                    let json = try JSONDecoder().decode(RedirectLinkResponse.self, from: data)
                                    
                                    self.open(link: json.redirect_url)
                                } catch {
                                    self.open(link: link)
                                }
                            }
                        }).resume()
                    } else {
                        self.open(link: link)
                    }

                case .failure:
                    self.open(link: productLink)
                }
                
                completion?()
            }
        } else {
            open(link: productLink)
        }
    }
    
    func productNameText() -> String {
        return (Int(transaction.attributes.offer_id) ?? 0 == 1) ? transaction.attributes.product : ""
    }
    
    func showHelpArrow() -> Bool {
        return isMultiOffer() && orderStatus() == .confirmed
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
    }
    
    private func getOfferType() -> OfferType {
        if orderTypeId() == 1 { // Online offer
            return .online
        } else if isMultiOffer() { // Multi offer
            return .multi
        } else { // Offline single offer
            return .offline
        }
    }
    
    private func open(link: String) {
        guard let url = URL(string: link) else {
            return
        }
        
        UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
    }
}
