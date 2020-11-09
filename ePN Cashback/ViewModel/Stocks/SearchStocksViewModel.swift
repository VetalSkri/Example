//
//  SearchStocksViewModel.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 05/03/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

class SearchStocksViewModel: NSObject {
    
    private var selectedIndexPath: IndexPath?
    private var stocks: [Stocks]
    private let DEFAULT_PAGE = 1
    private let DEFAULT_SIZE_FOR_SEARCH = 100
    private var typeOfResponse: TypeOfEmptyStockResponse?
    private(set) var isSearching = false
//    private var storage: StorableContext
    
    
    var getTextForEmptyPage: String {
        return NSLocalizedString("No products with increased cashback have been found. Please get back later.", comment: "")
    }
    
    var getTextForEmptySearchPage: String {
        return NSLocalizedString("No products have been found for this search. Redraft it.", comment: "")
    }
    
    var getTitleForEmptyPage: String {
        return NSLocalizedString("No products have been found", comment: "")
    }
    
    func numberOfItemsInSection() -> Int {
        return stocks.count
    }
    
    func getTypeOfResponse() -> TypeOfEmptyStockResponse {
        return typeOfResponse!
    }
    
    func clearSearchResult() {
        typeOfResponse = .loading
        self.stocks.removeAll()
    }
    
    func findStocks(byTitle title: String,filterGoods: Int?, filterOffers: String?, completion: (()->())?, failure: (()->())?) {
        typeOfResponse = .loading
       
        StockApiClient.stocks(page: DEFAULT_PAGE, perPage: DEFAULT_SIZE_FOR_SEARCH, search: title, filterGoods: filterGoods, filterOffers: filterOffers) { [weak self] (result) in
            switch result {
            case .success(let response):
                self?.typeOfResponse = .search
                if let responseData = response.data {
                    self?.stocks.removeAll()
                    self?.stocks.append(contentsOf: responseData)
                } else {
                    self?.stocks.removeAll()
                }
                completion?()
                break
            case .failure(let error):
                self?.typeOfResponse = .search
                failure?()
                Alert.showErrorAlert(by: error)
                break
            }
        }
    }
    
    func itemViewModel(forIndexPath indexPath: IndexPath) -> StockViewCellModelType? {
        let currentStock = stocks[indexPath.item]
        return StockCardViewCellViewModel(stocks: currentStock)
    }
    
    func selectItem(atIndexPath indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
    }
    
    func updateSelectedItem() -> IndexPath? {
        return self.selectedIndexPath
    }
    
    override init() {
        self.stocks = [Stocks]()
        typeOfResponse = .loading
    }
    
}
