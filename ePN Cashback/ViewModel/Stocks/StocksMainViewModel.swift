//
//  StocksMainViewModel.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 04/03/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator

class StocksMainViewModel: StocksMainModelType {
    
    private var stocks: [Stocks]!
    var page: Int!
    private let DEFAULT_PAGE = 1
    private let DEFAULT_SIZE = 40
    private let DEFAULT_SIZE_FOR_SEARCH = 100
    private(set) var isSearching: Bool!
    var isPaging = true
    private var sortBy: StatusOfSortStock!
    private var filterFrom: Int!
    private var filterTo: Int!
    private var typeOfResponse: TypeOfEmptyStockResponse!
    private var requestFailure = false
    private var filters = [StockFilterCategory]()
    private let requestQueue = OperationQueue()
    
    private let router: UnownedRouter<PromotionsRoute>
    
    init(router: UnownedRouter<PromotionsRoute>) {
        self.router = router
        self.requestQueue.maxConcurrentOperationCount = 1
        self.requestQueue.qualityOfService = .userInitiated
        self.buildFilters()
        self.page = DEFAULT_PAGE
        self.stocks = [Stocks]()
        self.sortBy = .New
        self.isSearching = false
        self.filterTo = 100
        self.filterFrom = 0
        self.typeOfResponse = .empty
    }
    
    deinit {
        self.requestQueue.cancelAllOperations()
    }
    
    private func buildFilters() {
        self.filters = [
        StockFilterCategory(categoryName: NSLocalizedString("Stores", comment: ""), resetName: NSLocalizedString("Reset", comment: ""), objects: [
            StockFilterObject(type: .offer, name: NSLocalizedString("All stores", comment: ""), id: 0, selected: true),
            StockFilterObject(type: .offer, name: "AliExpress", id: 1, selected: false)]),
        StockFilterCategory(categoryName: NSLocalizedString("Goods", comment: ""), resetName: NSLocalizedString("Reset", comment: ""), objects: [
            StockFilterObject(type: .product, name: NSLocalizedString("All offers", comment: ""), id: 0, selected: true),
            StockFilterObject(type: .product, name: NSLocalizedString("HotOffer", comment: ""), id: 1, selected: false),
            StockFilterObject(type: .product, name: NSLocalizedString("voting winners", comment: ""), id: 2, selected: false)])]
    }
    
    func goOnFilter(_ delegate: StockFilterVCDelegate) {
        router.trigger(.filter(delegate, filters))
    }
    
    func getSorting() -> StatusOfSortStock {
        return sortBy
    }
    
    func changeSorting(_ sort: StatusOfSortStock) {
        sortBy = sort
    }
    
    func numberOfSections() -> Int {
        return 2
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        switch section {
        case 0:
            return stocks.count > 0 ? 1 : 0
        case 1:
            return stocks.count
        default:
            return 0
        }
    }
    
    func numberOfStocks() -> Int {
        return stocks.count
    }
    
    func pageSize() -> Int {
        return DEFAULT_SIZE
    }
    
    func itemViewModel(forIndexPath indexPath: IndexPath) -> StockViewCellModelType? {
        let currentStock = stocks[indexPath.row]
        return StockCardViewCellViewModel(stocks: currentStock)
    }
    
    func headerViewModel() -> StockHeaderReusableViewModel {
        return StockHeaderReusableViewModel()
    }
    
    func setActiveSearching(_ isActive: Bool) {
        self.isSearching = isActive
        self.isPaging = !isActive
    }
    
    func setActivePaging(_ isPaging: Bool) {
        self.isPaging = isPaging
    }
    
    func getTypeOfResponse() -> TypeOfEmptyStockResponse {
        return typeOfResponse
    }
    
    func updateFilter(new filter: StockFilter) {
        self.filterFrom = filter.startRange
        self.filterTo = filter.endRange
    }
    
    func setDefaultFilter() {
        self.filterFrom = 0
        self.filterTo = 100
    }
    
    func setFilters(filters: [StockFilterCategory]) {
        self.filters = filters
    }
    
    func loadListOfStocks(completion: (()->())?, failure: (()->())?) {
        requestQueue.cancelAllOperations()
        synced(self) {
            requestFailure = false
            typeOfResponse = .loading
            page = DEFAULT_PAGE
            
            let goodFilter = self.getGoodFilter()
            let offersFilter = self.getOffersFilter()
            
            StockApiClient.stocks(page: page, perPage: DEFAULT_SIZE, order: self.sortBy.rawValue, filterFrom: filterFrom, filterTo: filterTo, filterGoods: goodFilter, filterOffers: offersFilter) { [weak self] (result) in
                switch result {
                case .success(let response):
                    self?.typeOfResponse = .empty
                    if let responseData = response.data {
                        self?.stocks.removeAll()
                        self?.stocks.append(contentsOf: responseData)
                        if let next = response.meta?.hasNext, next {
                            self?.isPaging = true
                            self?.page += 1
                        } else {
                            self?.isPaging = false
                        }
                    } else {
                        self?.stocks.removeAll()
                        self?.isPaging = false
                    }
                    completion?()
                    break
                case .failure(let error):
                    self?.requestFailure = true
                    self?.typeOfResponse = .empty
                    self?.isPaging = false
                    failure?()
                    Alert.showErrorAlert(by: error)
                    break
                }
            }
        }
    }
    
    func getGoodFilter() -> Int? {
        let selectedGoodFilter = self.filters[1].objects.first { $0.selected }
        if(selectedGoodFilter == nil || selectedGoodFilter?.id == 0) {
            return nil
        }
        return selectedGoodFilter?.id
    }
    
    func getOffersFilter() -> String? {
        let selectedOffersFilter = self.filters[0].objects.filter { $0.selected }
        if(selectedOffersFilter.count <= 0 || selectedOffersFilter.first?.id == 0){
            return nil
        }
        var filters = ""
        for i in 0 ..< selectedOffersFilter.count {
            filters.append(contentsOf: String(selectedOffersFilter[i].id))
            if (i != selectedOffersFilter.count - 1) {
                filters.append(",")
            }
        }
        return filters
    }
    
    func pagingListOfStocks(completion: ((Int, Int)->())?, failure: (()->())?) {
        synced(self) {
            requestFailure = false
            typeOfResponse = .loading
            
            let goodFilter = self.getGoodFilter()
            let offersFilter = self.getOffersFilter()
            
            StockApiClient.stocks(page: page, perPage: DEFAULT_SIZE, order: self.sortBy.rawValue, filterFrom: filterFrom, filterTo: filterTo, filterGoods: goodFilter, filterOffers: offersFilter) { [weak self] (result) in
                switch result {
                case .success(let response):
                    self?.typeOfResponse = .empty
                    if let self = self {
                        let start = self.stocks.count
                        var size = 0
                        if let responseData = response.data {
                            size = responseData.count
                            self.stocks.append(contentsOf: responseData)
                            if let next = response.meta?.hasNext, next {
                                self.isPaging = true
                                self.page += 1
                            } else {
                                self.isPaging = false
                            }
                        }
                        completion?(start,size)
                    }
                    break
                case .failure(let error):
                    self?.typeOfResponse = .empty
                    self?.requestFailure = true
                    failure?()
                    break
                }
            }
        }
    }
    
    func sizeForLoadingFooter() -> Int {
        return (isPaging && numberOfStocks() >= pageSize() && !requestFailure) ? 50 : 0
    }
    
    func hasActiveFilters() -> Bool {
        return getOffersFilter() != nil || getGoodFilter() != nil
    }
    
    func addOperationToQueue(operation: Operation) {
        operation.qualityOfService = .userInitiated
        operation.name = String(describing: page)
        if (!requestQueue.operations.contains { (operation) -> Bool in
            guard let name = operation.name, let currentOperationName = operation.name else {
                print("MYLOG: load new page operation alredy exist in queue. load page number: \(String(describing: operation.name))")
                return false
            }
            return name == currentOperationName
            }) {
            requestQueue.addOperation(operation)
            print("MYLOG: added operation in Queue, current number of operation: \(requestQueue.operationCount)")
        }
    }
    
    func canPagingForItem(at indexPath: IndexPath) -> Bool {
        guard stocks.count > 0 else { return false }
        if (indexPath.row == stocks.count - 1 && indexPath.section == 1) && isPaging {
            return true
        } else {
            return false
        }
    }
    
}

//MARK: - status of sorting stocks
public enum StatusOfSortStock: String {
    case New = "newDate", Percent = "percent", Orders = "orders"
}

public enum TypeOfEmptyStockResponse {
    case search, empty, loading
}
