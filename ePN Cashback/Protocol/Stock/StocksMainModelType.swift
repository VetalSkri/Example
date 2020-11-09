//
//  StocksMainModelType.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 29/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

protocol StocksMainModelType: SyncClosure {
    var isPaging: Bool { get }
    var percentSort: String { get }
    var newDateSort: String { get }
    var costSort: String { get }
    var getTextForEmptyPage: String { get }
    var getTextForEmptySearchPage: String { get }
    var getTitleForEmptyPage: String { get }
    
    func setDefaultFilter()
    func updateFilter(new filter: StockFilter)
    func hasActiveFilters() -> Bool
//    func getFilterViewModel() -> StockFilterViewModel
    func changeSorting(_ sort: StatusOfSortStock)
    func getSorting() -> StatusOfSortStock
    func loadListOfStocks(completion: (()->())?, failure: (()->())?)
    func numberOfSections() -> Int
    func numberOfItemsInSection(section: Int) -> Int
    func numberOfStocks() -> Int
    func getTypeOfResponse() -> TypeOfEmptyStockResponse
    func itemViewModel(forIndexPath indexPath: IndexPath) -> StockViewCellModelType?
    func headerViewModel() -> StockHeaderReusableViewModel
    func canPagingForItem(at indexPath: IndexPath) -> Bool
    func pagingListOfStocks(completion: ((Int, Int)->())?, failure: (()->())?)
    func getGoodFilter() -> Int?
    func getOffersFilter() -> String?
    func setFilters(filters: [StockFilterCategory])
    func sizeForLoadingFooter() -> Int
    
    func goOnFilter(_ delegate: StockFilterVCDelegate)
}

extension StocksMainModelType {
    var percentSort: String {
        return NSLocalizedString("by cashback rate", comment: "")
    }
    
    var newDateSort: String {
        return NSLocalizedString("by novelty", comment: "")
    }
    
    var costSort: String {
        return NSLocalizedString("by product price", comment: "")
    }
    
    var getTextForEmptyPage: String {
        return NSLocalizedString("No products with increased cashback have been found. Please get back later.", comment: "")
    }
    
    var getTextForEmptySearchPage: String {
        return NSLocalizedString("No products have been found for this search. Redraft it.", comment: "")
    }
    
    var getTitleForEmptyPage: String {
        return NSLocalizedString("No products have been found", comment: "")
    }
    
}
