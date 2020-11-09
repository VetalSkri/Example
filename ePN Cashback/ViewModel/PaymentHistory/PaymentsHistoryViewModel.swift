//
//  PaymentsHistoryViewModel.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 04/02/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import XCoordinator
class PaymentsHistoryViewModel: PaymentsHistoryModelType {

    private var typeOfResponse: TypeOfEmptyPaymentResponse?
    private let router: UnownedRouter<AccountRoute>
    private var payments: [[Payments]]!
    var page: Int!
    private let DEFAULT_PAGE = 1
    private let DEFAULT_SIZE = 40
    private var isPagging: Bool = false
    private let requestQueue = OperationQueue()
    
    var headTitle: String {
        return NSLocalizedString("Payment history", comment: "")
    }
    
    func numberOfRowsInSection(fromSection section: Int) -> Int {
        return payments[section].count
    }
    
    func titleOfSection(inSection section: Int) -> String {
        return Util.convertDateToShortString(payments[section].first!.payment.created_at)
    }
    
    func numberOfSections() -> Int {
        return payments.count
    }
    
    func getTypeOfResponse() -> TypeOfEmptyPaymentResponse {
        return typeOfResponse!
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> PaymentViewCellViewModelType? {
        let paymentsInSection = payments[indexPath.section]
        let currentPayment = paymentsInSection[indexPath.row]
        return PaymentViewCellViewModel(payment: currentPayment)
    }
    
    func getTextForEmptyPage() -> String {
        return NSLocalizedString("On this page the list of the payouts that have been ordered will be displayed.", comment: "")
    }
    
    func groupedPayments(_ paymentsResponse: PaymentsResponse?, completion: (()->())?) {
        OperationQueue.main.addOperation { [weak self] in
            guard let response = paymentsResponse else {
                OperationQueue.main.addOperation {
                    CoreDataStorageContext.shared.removeAllPayments()
                }
                self?.payments.removeAll()
                completion?()
                return
            }
            let mappedPayments = response.data?.map{ Payments(id: $0.id, payment: $0.attributes) }
            guard let myCurrentPayments = mappedPayments else {
                OperationQueue.main.addOperation {
                    CoreDataStorageContext.shared.removeAllPayments()
                }
                self?.payments.removeAll()
                completion?()
                return
            }
            self?.replaceCache(payments: myCurrentPayments)
            self?.groupedPayments(myCurrentPayments, completion: completion)
        }
    }
    
    func groupedPayments(_ payments: [Payments], completion: (()->())?) {
        let groupedDictionary = Dictionary(grouping: payments, by: { (payment) -> String in
            return Util.convertDateToShortString(payment.payment.created_at)
        })
        let keys = groupedDictionary.keys.sorted(by: {$0 > $1})
        
        self.payments.removeAll()
        
        keys.forEach({ (key) in
            self.payments.append(groupedDictionary[key]!.sorted{ $0.payment.created_at ?? Date(timeIntervalSince1970: 0) > $1.payment.created_at ?? Date(timeIntervalSince1970: 0) })
        })
    }
    
    func groupPaymentAfterPaging(_ paymentsResponse: PaymentsResponse?, page: Int, completion: (()->())?) {
        OperationQueue.main.addOperation { [weak self] in
            guard let response = paymentsResponse else {
                completion?()
                return
            }
            let mappedPayments = response.data?.map{ Payments(id: $0.id, payment: $0.attributes) }
            guard let myCurrentPayments = mappedPayments else {
                completion?()
                return
            }
            
            var commonPayments = myCurrentPayments
            if(page == 2 && self != nil) {
                self?.replaceCache(payments: Array(myCurrentPayments.prefix(self!.DEFAULT_SIZE)))
            } else {
                self?.payments.forEach { (payments) in
                    payments.forEach {
                        commonPayments.append($0)
                    }
                }
            }
            self?.groupedPayments(commonPayments, completion: completion)
        }
    }
    
    func loadPaymentsHistory(completion: (()->())?, failure: (()->())?) {
        synced(self) {
            self.page = DEFAULT_PAGE
            typeOfResponse = .empty
            
            PaymentApiClient.history(page: page, perPage: DEFAULT_SIZE) { [weak self] (result) in
                switch result {
                case .success(let paymentResponse):
                    self?.typeOfResponse = .new
                    self?.groupedPayments(paymentResponse) {
                        completion?()
                        return
                    }
                    if paymentResponse.meta?.hasNext == 1 {
                        self?.isPagging = true
                        self?.page += 1
                    } else {
                        self?.isPagging = false
                    }
                    completion?()
                    break
                case .failure(let error):
                    self?.typeOfResponse = .empty
                    failure?()
                    Alert.showErrorAlert(by: error)
                    break
                }
            }
        }
    }
    
    func pagingPaymentsHistory(completion: (()->())?, failure: (()->())?) {
        synced(self) {
            typeOfResponse = .empty
            
            PaymentApiClient.history(page: (page == 2) ? 1 : page, perPage: (page == 2) ? DEFAULT_SIZE * 2 : DEFAULT_SIZE) { [weak self] (result) in
                switch result {
                case .success(let paymentResponse):
                    self?.typeOfResponse = .new
                    
                    //TODO: - not this method need to use, cause we need to append result with previous results
                    self?.groupPaymentAfterPaging(paymentResponse, page: self?.page ?? 1) {
                        completion?()
                        return
                    }
                    if paymentResponse.meta?.hasNext == 1 {
                        self?.isPagging = true
                        self?.page += 1
                    } else {
                        self?.isPagging = false
                    }
                    completion?()
                    break
                case .failure(let error):
                    failure?()
                    Alert.showErrorAlert(by: error)
                    break
                }
            }
        }
    }
    
    func isPagingPayments(atIndexPath indexPath: IndexPath) -> Bool {
        guard payments.count > 0 else { print("error here"); return false }
        if (indexPath.section == payments.count - 1) && (indexPath.row == payments.last!.count - 1) && isPagging {
            return true
        } else {
            return false
        }
        
    }
    
    init(router: UnownedRouter<AccountRoute>) {
        self.router = router
        self.typeOfResponse = .empty
        self.requestQueue.maxConcurrentOperationCount = 1
        self.requestQueue.qualityOfService = .userInitiated
        self.payments = [[Payments]]()
        if let payments = CoreDataStorageContext.shared.fetchPayments() {
            self.groupedPayments(payments, completion: nil)
        }
        self.isPagging = (self.countOfPayments() >= DEFAULT_SIZE)
        self.page = isPagging ? 2 : DEFAULT_PAGE
    }
    
    func goOnBack() {
        router.trigger(.back)
    }
    
    deinit {
        self.requestQueue.cancelAllOperations()
    }
    
    private func countOfPayments() -> Int {
        guard let payments = payments else {
            return 0
        }
        var result = 0
        payments.forEach { (paymentArray) in
            result += paymentArray.count
        }
        return result
    }
    
    private func replaceCache(payments: [Payments]) {
        OperationQueue.main.addOperation {
            Session.shared.timeOfTablePayments = Date()
            CoreDataStorageContext.shared.addAllPayments(objects: payments)
        }
    }
    
    func cacheLifeTimeIsExpired() -> Bool {
        let now = Date()
        guard let date = Session.shared.timeOfTablePayments else {
            return true
        }
        if now.timeIntervalSince(date) > Util.TIME_OF_UPDATING_PAYMENT {
            return true
        } else {
            return false
        }
    }
    
}
public enum TypeOfEmptyPaymentResponse {
    case new, empty
}
