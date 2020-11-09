//
//  BaseShopsListModelType.swift
//  
//
//  Created by Ivan Nikitin on 28/10/2019.
//

import Foundation

protocol BaseShopsListModelType: SyncClosure {
    var getTextForEmptyPage: String { get }
    var getTitleForEmptyPage: String { get }
    var isPaging: Bool { get set }
    var DEFAULT_SET: Int { get }
    var DEFAULT_SIZE: Int { get }
    var requestFailure: Bool { get set }
    
    func showShopDetailPage(at index: Int)
    func shop(at index: Int) -> Store
    func itemViewModel(at index: Int) -> StoreCardViewCellModelType?
    func numberOfItems() -> Int
    func sizeForLoadingFooter() -> Int
    func canPagingForItem(at indexPath: IndexPath) -> Bool
    func presentShops(isForced: Bool, completion: (()->())?, failure: ((Int)->())?)
    func presentPage(completion: @escaping (((Int,Int)?)->()))
    func getPageSize() -> Int
    func setActivePaging(_ isPaging: Bool)
    func getActivePaging() -> Bool
}

extension BaseShopsListModelType {
    
    var DEFAULT_SET: Int {
        return 0
    }
    
    var DEFAULT_SIZE: Int {
        return 20
    }
    
    var getTextForEmptyPage: String {
        return NSLocalizedString("No stores found on this request. Please select other filters or enter other title of store.", comment: "")
    }
    
    var getTitleForEmptyPage: String {
        return NSLocalizedString("No stores found", comment: "")
    }
    
    func presentShops(isForced: Bool = false, completion: (()->())?, failure: ((Int)->())?) {
        return presentShops(isForced: isForced, completion: completion, failure: failure)
    }
    
    func sizeForLoadingFooter() -> Int {
        return (getActivePaging() && numberOfItems() >= getPageSize() && !requestFailure) ? 50 : 0
    }
    
    func getPageSize() -> Int {
        return DEFAULT_SIZE
    }
    
    func canPagingForItem(at indexPath: IndexPath) -> Bool {
        guard numberOfItems() > 0 else { return false }
        if (indexPath.row == numberOfItems() - 1) && getActivePaging()  {
            return true
        } else {
            return false
        }
    }
    
    func getActivePaging() -> Bool {
        return self.isPaging
    }

    
}
