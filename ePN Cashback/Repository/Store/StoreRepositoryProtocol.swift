//
//  StoreRepositoryProtocol.swift
//  Backit
//
//  Created by Ivan Nikitin on 09/12/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

protocol StoreRepositoryProtocol: RepositoryProtocol {
    
    func presentStores(isForced: Bool, completion: (([Store])->())?, failure: ((NSError)->())?)
    func fetchStores(offSet: Int) -> [Store]?
    func presentFavorites(isForced: Bool, sortBy: StatusOfSort, completion: (([Store])->())?, failure: ((NSError)->())?)
    func fetchFavorites(offSet: Int, sortBy: StatusOfSort) -> [Store]?
    func presentDoodles(completion: (([DoodlesItem])->())?)
    func presentCategories(isForced: Bool, completion: (([Categories])->())?, failure: ((NSError)->())?)
    func presentShopsCategory(isForced: Bool, ids: [Int], sortBy: StatusOfSort, completion: (([Store])->())?, failure: ((NSError)->())?)
    func presentPageShopCategory(ids: [Int], offSet: Int, sortBy: StatusOfSort) -> [Store]?
    func loadShopInfo(id: Int, completion: ((ShopInfo)->())?, failure:((NSError)->())?)
    func searchStoresBy(text: String, offSet: Int, completion: @escaping (([Store]?)->()))
}

extension StoreRepositoryProtocol {
    
    func fetchStores(offSet: Int = 0) -> [Store]? {
        return fetchStores(offSet: offSet)
    }
    
    func fetchFavorites(offSet: Int = 0, sortBy: StatusOfSort) -> [Store]? {
        return fetchFavorites(offSet: offSet, sortBy: sortBy)
    }
    
    func searchStoresBy(text: String, offSet: Int = 0, completion: @escaping (([Store]?)->())) {
        return searchStoresBy(text: text, offSet: offSet, completion: completion)
    }
    
    func presentPageShopCategory(ids: [Int], offSet: Int = 0, sortBy: StatusOfSort) -> [Store]? {
        return presentPageShopCategory(ids: ids, offSet: offSet, sortBy: sortBy)
    }
}
