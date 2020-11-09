//
//  OrderRepository.swift
//  Backit
//
//  Created by Александр Кузьмин on 02/03/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

enum OrderPageState {
    case firstLoad
    case paging
    case allIsLoadeds
    case error
}

class OrderRepository: OrderRepositoryProtocol {
    
    static let shared = OrderRepository()
    
    var offersByOrders: [OffersWithMyOrdersDataResponse]?
    
    private init() {
    }
    
    func getOrders(page: Int, perPage: Int, offerIds: [Int]?, tsFrom: String?, tsTo: String?, type: String?, searchText: String?) -> Observable<Result<[OrdersDataResponse], Error>> {
        return Observable.create { [weak self] (observer) -> Disposable in
            guard let self = self else { return Disposables.create() }
            let offerIdsString = (offerIds?.count ?? 0 > 0) ? offerIds?.map { return String($0) }.joined(separator: ",") : nil
            let typeIds = type
            OrderApiClient.orders(page: page, perPage: perPage, offerIds: offerIdsString, tsFrom: tsFrom ?? self.getDefaultEndOfPeriod(), tsTo: tsTo ?? self.getCurrentDayWithString(), confirmTsFrom: nil, confirmTsTo: nil, orderNumber: searchText, fields: nil, typeIds: typeIds) { (result) in
                switch result {
                case .success(let response):
                    if let loadedOrders = response.data {
                        observer.onNext(.success(loadedOrders))
                    } else {
                        observer.onNext(.success([]))
                    }
                    break
                case .failure(let error):
                    observer.onNext(.failure(error))
                    break
                }
            }
            return Disposables.create()
        }
    }
    
    func getOfferByTransactions() -> Observable<Result<[OffersWithMyOrdersDataResponse], Error>>
    {
        return Observable.create { [weak self] (observer) -> Disposable in
            if let offersByOrders = self?.offersByOrders {
                observer.onNext(.success(offersByOrders))
                return Disposables.create()
            }
            OrderApiClient.offersWithMyOrders { [weak self] (result) in
                switch result {
                case .success(let result):
                    self?.offersByOrders = result.data ?? []
                    observer.onNext(.success(result.data ?? []))
                    break
                case .failure(let error):
                    observer.onNext(.failure(error))
                    break
                }
            }
            return Disposables.create()
        }
    }
    
    
    
    
    
    
    
    //Help methoods
    
    private func convertDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    private func getCurrentDayWithString() -> String {
        let today = Date()
        return convertDateToString(date: today)
    }
    
    private func getDefaultEndOfPeriod() -> String {
        return convertDateToString(date: getDateBefore(daysAgo: 180))
    }
    
    private func getDateBefore(daysAgo days: Int, fromDate date: Date = Date()) -> Date {
        let fromDateDay = Calendar.current.date(byAdding: .day, value: -days, to: date)
        return fromDateDay!
    }
    
}
