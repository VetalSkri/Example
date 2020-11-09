//
//  SearchOrderViewModel.swift
//  Backit
//
//  Created by Александр Кузьмин on 11/03/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator
import RxSwift
import RxRelay

class SearchOrderViewModel: NSObject {
    
    private let router: UnownedRouter<OrdersRoute>
    private let disposeBag = DisposeBag()
    let repository: OrderRepositoryProtocol = OrderRepository.shared
    var orders = BehaviorRelay<[[OrdersDataResponse]]>(value: [])
    var state = BehaviorRelay<OrderPageState>(value: .firstLoad)
    
    var orderOperationQueue = OperationQueue()
    
    var noFoundOrderTitle: String {
        NSLocalizedString("Don't you find your order?", comment: "")
    }
    
    init(router: UnownedRouter<OrdersRoute>) {
        self.router = router
    }
    
    func openLostOrders() {
        OldAPI.performTransition(type: .searchOrder)
    }
    
    func getOrders(searchText: String?) {
        var numberOfOrders = 0
        orders.value.forEach { numberOfOrders += $0.count }
        let op = BlockOperation { [weak self] in
            self?.getOrdersProcess(searchText: searchText)
        }
        orderOperationQueue.addOperation(op)
    }
    
    func getOrdersProcess(searchText: String?) {
        let semaphore = DispatchSemaphore(value: 0)
        _ = repository.getOrders(page: 1, perPage: 20, offerIds: nil, tsFrom: nil, tsTo: nil, type: nil, searchText: searchText).subscribe { [weak self] (result) in
            guard let element = result.element else { return }
            switch element {
            case .success(let elements):
                if self?.orderOperationQueue.operationCount ?? 0 <= 1 {
                    self?.state.accept(.allIsLoadeds)
                }
                self?.grouped(orders: elements)
                break
            case .failure(let error):
                self?.state.accept(.error)
                Alert.showErrorToast(by: error)
                break
            }
            semaphore.signal()
        }
        semaphore.wait()
    }
    
    private func grouped(orders: [OrdersDataResponse]) {
        let groupedDict = Dictionary(grouping: orders) { (order) -> String in
            return Util.convertDateForSort(order.attributes.date)
        }
        let keys = groupedDict.keys.sorted(by: {$0 > $1})
        var orders = [[OrdersDataResponse]]()
        keys.forEach({ (key) in
            orders.append(groupedDict[key]!.sorted{ $0.attributes.order_time > $1.attributes.order_time })
        })
        self.orders.accept(orders)
    }
    
    func numberOfSections() -> Int {
        return orders.value.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        return orders.value[section].count
    }
    
    func order(for indexPath: IndexPath) -> OrdersDataResponse? {
        if orders.value[indexPath.section].count > indexPath.row {
            return orders.value[indexPath.section][indexPath.row]
        }
        return nil
    }
    
    func title(for section: Int) -> String {
        return Util.convertToPresentDate(orders.value[section].first!.attributes.date)
    }
    
    func noFoundText() -> String {
        return NSLocalizedString("No orders found", comment: "")
    }
    
    func reset() {
        orders.accept([])
    }
    
    func shopNameAndLogo(for offerId: Int, typeId: String?) -> (shopLogo: String?, shopName: String?) {
        let type = Int(typeId ?? "1") ?? 1
        if offerId == LocalSymbolsAndAbbreviations.MULTY_OFFER_ID {
            return (shopLogo: "checkTransaction", shopName: NSLocalizedString("Scanning a receipt", comment: ""))
        }
        if (type == 1 || type == 2) {
            let shop = CoreDataStorageContext.shared.fetchShop(byId: offerId)
            return (shopLogo: shop?.store.image, shopName: shop?.store.title)
        }
        let offlineShop = CoreDataStorageContext.shared.fetchOfflineOffer(id: offerId)
        return (shopLogo: offlineShop?.image, shopName: offlineShop?.title)
    }
    
    func orderWasSelected(indexPath: IndexPath) {
        if (orders.value.count <= indexPath.section) || (state.value == .firstLoad) { return }
        if orders.value[indexPath.section].count > indexPath.row {
            let transaction = orders.value[indexPath.section][indexPath.row]
            let nameAndLogo = shopNameAndLogo(for: Int(transaction.attributes.offer_id) ?? 0, typeId: transaction.attributes.type_id)
            router.trigger(.orderDetail(transaction: transaction, image: nameAndLogo.shopLogo, name: nameAndLogo.shopName))
        }
    }
    
}
