//
//  PaymentsHistoryModelType.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 24/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

protocol PaymentsHistoryModelType: SyncClosure {
    var headTitle: String { get }
    func goOnBack()
    func numberOfRowsInSection(fromSection section: Int) -> Int
    func titleOfSection(inSection section: Int) -> String
    func numberOfSections() -> Int
    func getTypeOfResponse() -> TypeOfEmptyPaymentResponse
    func cellViewModel(forIndexPath indexPath: IndexPath) -> PaymentViewCellViewModelType?
    func getTextForEmptyPage() -> String
    func groupedPayments(_ paymentsResponse: PaymentsResponse?, completion: (()->())?)
    func groupedPayments(_ payments: [Payments], completion: (()->())?)
    func groupPaymentAfterPaging(_ paymentsResponse: PaymentsResponse?, page: Int, completion: (()->())?)
    func loadPaymentsHistory(completion: (()->())?, failure: (()->())?)
    func pagingPaymentsHistory(completion: (()->())?, failure: (()->())?)
    func isPagingPayments(atIndexPath indexPath: IndexPath) -> Bool
    func cacheLifeTimeIsExpired() -> Bool
}
