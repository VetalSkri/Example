//
//  OrdersViewModel.swift
//  Backit
//
//  Created by Александр Кузьмин on 02/03/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator
import RxSwift
import RxRelay

class OrdersViewModel: NSObject {
    
    private let router: UnownedRouter<OrdersRoute>
    private let disposeBag = DisposeBag()
    let repository: OrderRepositoryProtocol = OrderRepository.shared
    let pageSize = 20
    var orders = BehaviorRelay<[[OrdersDataResponse]]>(value: [])
    var state = BehaviorRelay<OrderPageState>(value: .firstLoad)
    var filter: BehaviorRelay<OrderFilter>
    var hasFilter = BehaviorRelay<Bool>(value: false)
    var orderOperationQueue = OperationQueue()
    var dateFormatter = DateFormatter()
    
    init(router: UnownedRouter<OrdersRoute>) {
        self.router = router
        self.orderOperationQueue.maxConcurrentOperationCount = 1
        self.orderOperationQueue.qualityOfService = .userInitiated
        
        self.dateFormatter.timeZone = .current
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
        self.filter = BehaviorRelay(value: OrderFilter(timeRange: nil, timeType: .year, offerIds: []))
        super.init()
        self.subscribeToNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(filterWasUpdatedSignal(notification:)), name: .updateOrderFilter, object: nil)
    }
    
    @objc private func filterWasUpdatedSignal(notification: NSNotification) {
        if let filterObject = notification.userInfo?["filterObject"] as? OrderFilter {
            updateFilter(newFilter: filterObject)
        }
    }
    
    private func updateFilter(newFilter: OrderFilter) {
        filter.accept(newFilter)
        state.accept(.firstLoad)
        getOrders(refresh: true)
        hasFilter.accept(hasActiveFilters())
    }
    
    func getOrders(refresh: Bool) {
        var numberOfOrders = 0
        orders.value.forEach { numberOfOrders += $0.count }
        let page = (refresh) ? 1 : (numberOfOrders / pageSize) + 1
        if orderOperationQueue.operations.contains(where: { return $0.name == String(page) }) {
            return
        }
        let op = BlockOperation { [weak self] in
            self?.getOrdersProcess(page: page)
        }
        op.name = String(page)
        orderOperationQueue.addOperation(op)
    }
    
    func getOrdersProcess(page: Int) {
        let semaphore = DispatchSemaphore(value: 0)
        _ = repository.getOrders(page: page, perPage: pageSize, offerIds: filter.value.offerIds, tsFrom: filter.value.timeRange?.tsFrom, tsTo: filter.value.timeRange?.tsTo, type: filter.value.type, searchText: nil).subscribe { [weak self] (result) in
            guard let element = result.element else { return }
            switch element {
            case .success(var elements):
                self?.state.accept((elements.count < self?.pageSize ?? 0) ? .allIsLoadeds : .paging )
                if page != 1 {
                    self?.orders.value.forEach {
                        elements.append($0)
                    }
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
    
    func getDefaultTimeRange() -> (tsFrom: String, tsTo: String) {
        let dateYearAgo = Calendar.current.date(byAdding: .day, value: -180, to: Date()) ?? Date()
        return (tsFrom: dateFormatter.string(from: dateYearAgo), tsTo: dateFormatter.string(from: Date()))
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
        return (state.value == OrderPageState.firstLoad) ? 1 : orders.value.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        return (state.value == OrderPageState.firstLoad) ? 10 : orders.value[section].count
    }
    
    func order(for indexPath: IndexPath) -> OrdersDataResponse? {
        if orders.value.count <= indexPath.section { return nil }
        if orders.value[indexPath.section].count > indexPath.row {
            return orders.value[indexPath.section][indexPath.row]
        }
        return nil
    }
    
    func title(for section: Int) -> String {
        if orders.value.count > section {
            return Util.convertToPresentDate(orders.value[section].first!.attributes.date)
        }
        return ""
    }
    
    func displayCell(for indexPath: IndexPath) {
        if (indexPath.section == (numberOfSections()-1) && (indexPath.row == (numberOfRows(in: indexPath.section) - 1)) && state.value == .paging) {
            getOrders(refresh: false)
        }
    }
    
    func getRouter() -> UnownedRouter<OrdersRoute> {
        return router
    }
    
    func openFilter() {
        router.trigger(.filter(filterObject: filter.value))
    }
    
    func updateTypeFilter(newType: Int?) {
        var currentFilter = filter.value
        if let newType = newType {
            currentFilter.type = (newType == 3) ? "3,4" : String(newType)
        } else {
            currentFilter.type = nil
        }
        updateFilter(newFilter: currentFilter)
    }
    
    func hasActiveFilters() -> Bool {
        return (filter.value.timeType != .year || filter.value.type != nil || filter.value.offerIds.count > 0)
    }
    
    func hasActiveCommonFilters() -> Bool {
        return (filter.value.timeType != .year || filter.value.offerIds.count > 0)
    }
    
    func cancelFilters() {
        var currentFilter = filter.value
        currentFilter.offerIds = []
        currentFilter.timeRange = nil
        currentFilter.type = nil
        currentFilter.timeType = .year
        updateFilter(newFilter: currentFilter)
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

struct OrderFilter {
    var timeRange: OrderFilterTime?
    var timeType: OrderFilterTimeType
    var offerIds: [Int]
    var type: String?
    
    func hasFilter() -> Bool {
        return (offerIds.count > 0 || timeRange != nil)
    }
}

struct OrderFilterTime {
    var tsFrom: String
    var tsTo: String
}

enum OrderFilterTimeType: Int {
    case week = 0
    case month = 1
    case year = 2
    case custom = 3
}
