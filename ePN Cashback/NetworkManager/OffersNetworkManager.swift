//
//  OffersNetworkManager.swift
//  Backit
//
//  Created by Ivan Nikitin on 15/11/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

class OffersNetworkManager {
    
    func loadShopInfo(id: Int, completion: @escaping (Result<ShopInfo,Error>)->()) {
        ShopApiClient.shopInfo(forShopId: id) { (result) in
            switch result {
            case .success(let shopInfo):
                completion(.success(shopInfo.data.attributes))
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        }
    }
    
    func loadFavoritesFromServer(completion: @escaping (Result<[Int],Error>)->()) {
        ShopApiClient.favorites { (result) in
            switch result {
            case .success(let response):
                let favorites = response.data.map { $0.id }
                completion(.success(favorites))
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        }
    }
    
    func searchStoresBy(text: String, offSet: Int, completion: @escaping (Result<[Store],Error>)->()) {
        ShopApiClient.offers(search: text, limit: Util.SIZE_OF_PAGING, offset: offSet, typeId: ShopTypeId.common.rawValue) { (result) in
            switch result {
            case .success(let response):
                guard let offers = response.data?.elements else {
                    let error = NSError(domain: "Error find data from server", code: 000006, userInfo: nil)
                    completion(.failure(error))
                    return
                }
                let currentStores = offers.map { Store(id: $0.id, offer: $0.attributes) }
                completion(.success(currentStores))
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        }
    }
    
    func loadStores(completion: @escaping (Result<[Store],Error>)->()) {
        ShopApiClient.offers(limit: Util.MAX_SIZE_OF_SHOPS_FROM_SERVER) { (result) in
            switch result {
            case .success(let response):
                guard let offers = response.data?.elements else {
                    let error = NSError(domain: "Error find data from server", code: 000006, userInfo: nil)
                    completion(.failure(error))
                    return
                }
                let currentStores = offers.map { Store(id: $0.id, offer: $0.attributes) }
                completion(.success(currentStores))
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        }
    }
    
    func loadDoodles(completion: @escaping (Result<[DoodlesItem],Error>)->()) {
        DoodlesApiClient.getDoodles(completion: { (result) in
            switch result {
            case .success(let serealizedObject):
                var items = [DoodlesItem]()
                serealizedObject.data?.forEach{ (doodleData) in
                    var item = doodleData.attributes
                    item.id = doodleData.id
                    items.append(item)
                }
                completion(.success(items))
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        })
    }
    
    func loadCategories(completion: @escaping (Result<[Categories],Error>)->()) {
        ShopApiClient.category(shopTypeID: .common) { (result) in
            switch result {
            case .success(let response):
                guard let data = response.data.first else {
                    let error = NSError(domain: "Error find data from server", code: 000006, userInfo: nil)
                    completion(.failure(error))
                    return
                }
                let allCategoryTree = data.attributes.tree
                completion(.success(allCategoryTree))
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        }
    }
    
    func loadCategoriesByOffers(completion: @escaping (Result<[StoreCategoryIds],Error>)->()) {
        ShopApiClient.categoryOffers { (result) in
            switch result {
            case .success(let response):
                guard let offers = response.data?.elements else {
                    let error = NSError(domain: "Error find data from server", code: 000006, userInfo: nil)
                    completion(.failure(error))
                    return
                }
                let currentStores = offers.map { StoreCategoryIds(id: $0.id, categoryIds: $0.attributes.categoryIds) }
                completion(.success(currentStores))
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        }
    }
}
