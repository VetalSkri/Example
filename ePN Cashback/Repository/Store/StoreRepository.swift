//
//  StoreRepository.swift
//  Backit
//
//  Created by Ivan Nikitin on 09/12/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//r

import Foundation

class StoreRepository: StoreRepositoryProtocol {
    
    let networkManager: OffersNetworkManager
    
    init() {
        networkManager = OffersNetworkManager()
    }
    
    func presentStores(isForced: Bool, completion: (([Store])->())?, failure: ((NSError)->())?) {
        if isForced {
            loadBlockStoresFromServer(completion: { [weak self] in
                guard let self = self else { return }
                guard let stores = self.fetchStores() else {
                    let error = NSError(domain: "Error loading data from Cache", code: 00000001, userInfo: nil)
                    failure?(error)
                    return
                }
                completion?(stores)
            })
        } else {
            if isExpiredStores() || isExpiredFavorites() {
                let storeGroup = DispatchGroup()
                if isExpiredStores() {
                    storeGroup.enter()
                    loadStores { (error) in
                        storeGroup.leave()
                    }
                }
                if isExpiredFavorites() {
                    storeGroup.enter()
                    loadFavorites { (error) in
                        storeGroup.leave()
                    }
                }
                storeGroup.notify(queue: DispatchQueue.main, execute: { [weak self] in
                    guard let self = self else { return }
                    guard let stores = self.fetchStores() else {
                        let error = NSError(domain: "Error loading data from Cache", code: 00000001, userInfo: nil)
                        failure?(error)
                        return
                    }
                    completion?(stores)
                })
            } else {
                guard let stores = fetchStores() else {
                    let error = NSError(domain: "Error loading data from Cache", code: 00000001, userInfo: nil)
                    failure?(error)
                    return
                }
                completion?(stores)
            }
        }
    }
    
    func fetchStores(offSet: Int = 0) -> [Store]? {
       guard let stores = CoreDataStorageContext.shared.fetchShops(typeId: .common, limit: Util.SIZE_OF_PAGING, offSet: offSet, sort: [NSSortDescriptor(key: "priority", ascending: true), NSSortDescriptor(key: "id", ascending: true)]) else {
            return nil
        }
        return stores
    }
    
    func searchStoresBy(text: String, offSet: Int = 0, completion: @escaping (([Store]?)->())) {
        searchStores(by: text, offSet: offSet, completion: { (stores) in
            let favoriteIds = CoreDataStorageContext.shared.fetchFavoriteIds()
            favoriteIds?.forEach{ idFavorite in stores.forEach{ store in
                if store.id == idFavorite {
                    store.isFavorite = true
                }
            }}
            completion(stores)
        }) { (error) in
            print("MYLOG: error of searching \(error)")
            guard let stores = CoreDataStorageContext.shared.fetchShopsFromSearch(by: text, offSet: offSet) else {
                completion(nil)
                return
            }
            completion(stores)
        }
    }
    
    
    
    
    
    func presentCategories(isForced: Bool, completion: (([Categories])->())?, failure: ((NSError)->())?) {
        if isForced || isExpiredCategories() {
            loadCategories { [weak self] (error) in
                if let error = error {
                    failure?(error)
                } else {
                    guard let self = self else { return }
                    guard let categories = self.fetchCategories() else {
                        let error = NSError(domain: "Error loading data from Cache", code: 00000001, userInfo: nil)
                        failure?(error)
                        return
                    }
                    completion?(categories)
                }
            }
        } else {
            guard let categories = fetchCategories() else {
                let error = NSError(domain: "Error loading data from Cache", code: 00000001, userInfo: nil)
                failure?(error)
                return
            }
            completion?(categories)
        }
    }
    
    func fetchCategories() -> [Categories]? {
        guard let categories = CoreDataStorageContext.shared.fetchShopsCategories(by: -1) else {
            return nil
        }
        return categories
    }
    
    func presentFavorites(isForced: Bool, sortBy: StatusOfSort, completion: (([Store])->())?, failure: ((NSError)->())?) {
        if isForced || isExpiredFavorites() {
            loadBlockStoresFromServer(completion: { [weak self] in
                guard let self = self else { return }
                guard let stores = self.fetchFavorites(sortBy: sortBy) else {
                    let error = NSError(domain: "Error loading data from Cache", code: 00000001, userInfo: nil)
                    failure?(error)
                    return
                }
                completion?(stores)
            })
        } else {
            guard let stores = fetchFavorites(sortBy: sortBy) else {
                let error = NSError(domain: "Error loading data from Cache", code: 00000001, userInfo: nil)
                failure?(error)
                return
            }
            completion?(stores)
        }
    }
    
    func fetchFavorites(offSet: Int = 0, sortBy: StatusOfSort) -> [Store]? {
        guard let favorites = fetchFavoriteBy(sort: sortBy, offSet: offSet) else {
            return nil
        }
        return favorites
    }
    
    private func fetchFavoriteBy(sort: StatusOfSort, offSet: Int = 0) -> [Store]? {
        switch sort {
        case .Alpha:
            return prepareFavoritesToDisplay(offSet: offSet, sortDescriptor: [NSSortDescriptor(key: "title", ascending: true)]) // failure("not found shops from CoreData by title")
        case .New:
            return prepareFavoritesToDisplay(offSet: offSet, sortDescriptor: [NSSortDescriptor(key: "id", ascending: false)]) // failure("not found shops from CoreData by id")
        case .Priority:
            return prepareFavoritesToDisplay(offSet: offSet, sortDescriptor: [NSSortDescriptor(key: "priority", ascending: true), NSSortDescriptor(key: "id", ascending: true)]) // failure("not found shops from CoreData by priority")
        }
    }
    
    private func prepareFavoritesToDisplay(offSet: Int = 0, sortDescriptor: [NSSortDescriptor]) -> [Store]? {
        guard let firstShops = CoreDataStorageContext.shared.fetchFavoritePageShops(offSet: offSet, sort: sortDescriptor, limit: Util.SIZE_OF_PAGING) else {
            return nil
        }
        return firstShops
    }
    
    func presentShopsCategory(isForced: Bool, ids: [Int], sortBy: StatusOfSort, completion: (([Store])->())?, failure: ((NSError)->())?) {
        if isForced {
            loadBlockCategoryAndStores(completion: { [weak self] in
                guard let self = self else { return }
                guard let stores = self.presentPageShopCategory(ids: ids, sortBy: sortBy) else {
                    let error = NSError(domain: "Error loading data from Cache", code: 00000001, userInfo: nil)
                    failure?(error)
                    return
                }
                completion?(stores)
            })
        } else {
            if isExpiredCategories() || isExpiredStoresCategories() {
                let categoryGroup = DispatchGroup()
                if isExpiredCategories() {
                    categoryGroup.enter()
                    loadCategories { (error) in
                        if let error = error {
                            print("MYSHOPS: Error loading categories \(error.code) \(error.domain)")
                        }
                        categoryGroup.leave()
                    }
                }
                if isExpiredStoresCategories() {
                    categoryGroup.enter()
                    loadStoreCategoryIds { (error) in
                        if let error = error {
                            print("MYSHOPS: Error loading StoreCategoriesIds \(error.code) \(error.domain)")
                        }
                        categoryGroup.leave()
                    }
                }
                categoryGroup.notify(queue: DispatchQueue.main, execute: { [weak self] in
                    guard let self = self else { return }
                    guard let stores = self.presentPageShopCategory(ids: ids, sortBy: sortBy) else {
                        let error = NSError(domain: "Error loading data from Cache", code: 00000001, userInfo: nil)
                        failure?(error)
                        return
                    }
                    completion?(stores)
                })
            } else {
                guard let stores = presentPageShopCategory(ids: ids, sortBy: sortBy) else {
                    let error = NSError(domain: "Error loading data from Cache", code: 00000001, userInfo: nil)
                    failure?(error)
                    return
                }
                completion?(stores)
            }
        }
    }
    
    func presentPageShopCategory(ids: [Int], offSet: Int = 0, sortBy: StatusOfSort) -> [Store]? {
        guard let stores = fetchShopByCategory(ids: ids, sort: sortBy, offSet: offSet) else {
            return nil
        }
        return stores
    }
    
    private func fetchShopByCategory(ids: [Int], sort: StatusOfSort, offSet: Int = 0) -> [Store]? {
        switch sort {
        case .Alpha:
            return prepareShopByCategoryToDisplay(ids: ids, offSet: offSet, sortDescriptor: [NSSortDescriptor(key: "title", ascending: true)]) // failure("not found shops from CoreData by title")
        case .New:
            return prepareShopByCategoryToDisplay(ids: ids, offSet: offSet, sortDescriptor: [NSSortDescriptor(key: "id", ascending: false)]) // failure("not found shops from CoreData by id")
        case .Priority:
            return prepareShopByCategoryToDisplay(ids: ids, offSet: offSet, sortDescriptor: [NSSortDescriptor(key: "priority", ascending: true), NSSortDescriptor(key: "id", ascending: true)]) // failure("not found shops from CoreData by priority")
        }
    }
    
    private func prepareShopByCategoryToDisplay(ids: [Int], offSet: Int = 0, sortDescriptor: [NSSortDescriptor]) -> [Store]? {
        guard let firstShops = CoreDataStorageContext.shared.fetchStoreByCategories(ids: ids, typeId: .common, limit: Util.SIZE_OF_PAGING, offSet: offSet, sort: sortDescriptor) else {
            return nil
        }
        return firstShops
    }

    private func loadBlockStoresFromServer(completion: @escaping (()->())) {
        let storeDispatchGroup = DispatchGroup()
        storeDispatchGroup.enter()
        loadStores { (error) in
            if let error = error {
                print("MYSHOPS: Error loading stores \(error.code) \(error.domain)")
            }
            storeDispatchGroup.leave()
        }
        storeDispatchGroup.enter()
        loadFavorites { (error) in
            if let error = error {
                print("MYSHOPS: Error loading favorites \(error.code) \(error.domain)")
            }
            storeDispatchGroup.leave()
        }
    
        loadCategories { (error) in
            if let error = error {
                print("MYSHOPS: Error loading categories \(error.code) \(error.domain)")
            }
            
        }
        loadStoreCategoryIds { (error) in
            if let error = error {
                print("MYSHOPS: Error loading StoreCategoriesIds \(error.code) \(error.domain)")
            }
        }
        
        storeDispatchGroup.notify(queue: DispatchQueue.main) {
            completion()
        }
    }
    
    private func loadBlockCategoryAndStores(completion: @escaping (()->())) {
        let categoryDG = DispatchGroup()
        categoryDG.enter()
        loadCategories { (error) in
            categoryDG.leave()
            if let error = error {
                print("MYSHOPS: Error loading categories \(error.code) \(error.domain)")
            }
        }
        categoryDG.enter()
        loadStoreCategoryIds { (error) in
            categoryDG.leave()
            if let error = error {
                print("MYSHOPS: Error loading StoreCategoriesIds \(error.code) \(error.domain)")
            }
        }
        
        categoryDG.notify(queue: .main) {
            completion()
        }
    }

    private func searchStores(by title: String, offSet: Int, completion: (([Store])->())?, failure: ((NSError)->())?) {
        networkManager.searchStoresBy(text: title, offSet: offSet) { (result) in
            switch result {
            case .success(let stores):
                completion?(stores)
            case .failure(let error):
                failure?(error as NSError)
            }
        }
    }
    
    private func loadStores(completion: @escaping (NSError?)->() ) {
        networkManager.loadStores { (result) in
            switch result {
            case .success(let stores):
                DispatchQueue.main.async {
                    CoreDataStorageContext.shared.addAllShops(objects: stores)
                    if let onlineStores = CoreDataStorageContext.shared.fetchShops(typeId: .common, limit: 100000, offSet: 0) {
                        SpotlightManager.setupSpotlight(shops: onlineStores, domainIdentifier: .OnlineStore)
                    }
                    Session.shared.timeOfTableShops = Date()
                    completion(nil)
                }
            case .failure(let error):
                DispatchQueue.main.async { completion(error as NSError) }
            }
        }
    }
    
    private func loadFavorites(completion: @escaping (NSError?)->() ) {
        networkManager.loadFavoritesFromServer { (result) in
            switch result {
            case .success(let favoriteIds):
                DispatchQueue.main.async {
                    CoreDataStorageContext.shared.addAllFavorites(ids: favoriteIds)
                    Session.shared.timeOfTableFavorites = Date()
                    completion(nil)
                }
            case .failure(let error):
                DispatchQueue.main.async { completion(error as NSError) }
            }
        }
    }
    
    func loadShopInfo(id: Int, completion: ((ShopInfo)->())?, failure:((NSError)->())?) {
        networkManager.loadShopInfo(id: id) { (result) in
            switch result {
            case .success(let shopInfo):
                DispatchQueue.main.async {
                    completion?(shopInfo)
                }
            case .failure(let error):
                DispatchQueue.main.async { failure?(error as NSError) }
            }
        }
    }
    
    private func loadCategories(completion: @escaping (NSError?)->() ) {
        networkManager.loadCategories { (result) in
            switch result {
            case .success(let categories):
                DispatchQueue.main.async {
                    CoreDataStorageContext.shared.addAllShopsCategory(objects: categories)
                    Session.shared.timeOfTableCategoryes = Date()
                    completion(nil)
                }
            case .failure(let error):
                DispatchQueue.main.async { completion(error as NSError) }
            }
        }
    }
    
    private func loadStoreCategoryIds(completion: @escaping (NSError?)->() ) {
        networkManager.loadCategoriesByOffers { (result) in
            switch result {
            case .success(let idCategories):
                DispatchQueue.main.async {
                    CoreDataStorageContext.shared.addAllIdCategoriesToStore(objects: idCategories)
                    Session.shared.timeOfTableStoreCategoryes = Date()
                    completion(nil)
                }
            case .failure(let error):
                DispatchQueue.main.async { completion(error as NSError) }
            }
        }
    }
    
    private func loadDoodles(completion: (()->())?, failure: ((NSError)->())?) {
        networkManager.loadDoodles { (result) in
            switch result {
            case .success(let doodles):
                DispatchQueue.main.async {
                    CoreDataStorageContext.shared.addAllDoodles(objects: doodles)
                    completion?()
                }
            case .failure(let error):
                DispatchQueue.main.async { failure?(error as NSError) }
            }
        }
    }
    
    func presentDoodles(completion: (([DoodlesItem])->())?) {
        loadDoodles(completion: {
            completion?(CoreDataStorageContext.shared.fetchDoodles())
        }) { (error) in
            //TODO: Change error layer
            //FIXME: add
            return
        }
    }
}
