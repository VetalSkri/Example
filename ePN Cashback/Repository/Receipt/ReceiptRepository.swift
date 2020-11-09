//
//  ReceiptRepository.swift
//  Backit
//
//  Created by Ivan Nikitin on 28/01/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation

class ReceiptRepository: ReceiptRepositoryProtocol {
    
    let networkManager: OfflineNetworkManager
    
    init() {
        networkManager = OfflineNetworkManager()
    }
    
    func loadShopInfo(id: Int, completion: @escaping (Result<OfflineShopInfo,NSError>)->()) {
        networkManager.loadShopInfo(offerId: id) { (result) in
            switch result {
            case .success(let shopInfo):
                DispatchQueue.main.async {
                    completion(.success(shopInfo))
                }
            case .failure(let error):
                DispatchQueue.main.async { completion(.failure(error as NSError)) }
            }
        }
    }
    
    func presentSpecialOfflineOffers(isForced: Bool, completion: (([OfferOffline])->())?, failure: ((NSError)->())?) {
        if isForced || isExpiredOfflineOffers() {
            loadOffers(completion: { [weak self] (error) in
                guard let stores = self?.fetchOfflineOffers(byType: .offlineSingle) else {
                    if error != nil {
                        failure?(error!)
                        return
                    } else {
                        let error = NSError(domain: "Error loading data from Cache", code: 00000001, userInfo: nil)
                        failure?(error)
                        return
                    }
                }
                completion?(stores)
            })
        } else {
            guard let stores = fetchOfflineOffers(byType: .offlineSingle) else {
                let error = NSError(domain: "Error loading data from Cache", code: 00000001, userInfo: nil)
                failure?(error)
                return
            }
            completion?(stores)
        }
    }
    
    func presentMultyOfflineOffers(isForced: Bool, completion: (([OfferOffline])->())?, failure: ((NSError)->())?) {
        if isForced || isExpiredOfflineOffers() {
            loadOffers(completion: { [weak self] (error) in
                guard let stores = self?.fetchOfflineOffers(byType: .offlineMulty) else {
                    if error != nil {
                        failure?(error!)
                        return
                    } else {
                        let error = NSError(domain: "Error loading data from Cache", code: 00000001, userInfo: nil)
                        failure?(error)
                        return
                    }
                }
                completion?(stores)
            })
        } else {
            guard let stores = fetchOfflineOffers(byType: .offlineMulty) else {
                let error = NSError(domain: "Error loading data from Cache", code: 00000001, userInfo: nil)
                failure?(error)
                return
            }
            completion?(stores)
        }
    }
    
    func searchOfflineOfferBy(text: String, completion: @escaping (([OfferOffline]?)->())) {
        guard let offline = CoreDataStorageContext.shared.fetchOffersFromSearch(byTypeId: ShopTypeId.offlineMulty.rawValue, searchText: text) else {
            completion(nil)
            return
        }
        completion(offline)
    }
    
    func fetchOfflineOffers(byType type: ShopTypeId) -> [OfferOffline]? {
        let offers = CoreDataStorageContext.shared.fetchOffers(byTypeId: type.rawValue)
        return offers
    }
    
    //TODO: need to delete this method
    func getCountSpecialOfflineOffers() -> Int {
        let countSpecialOffers = CoreDataStorageContext.shared.fetchOffers(byTypeId: ShopTypeId.offlineSingle.rawValue)?.count ?? 0
        return countSpecialOffers
    }
    
    func presentOfflineOffersCategory(ids: [Int]) -> [OfferOffline]? {
        guard let stores = CoreDataStorageContext.shared.fetchOfflineOffersByCategories(ids: ids, type: ShopTypeId.offlineMulty.rawValue) else {
            return nil
        }
        return stores
    }
    
    private func loadOffers(completion: @escaping (NSError?)->()) {
        networkManager.loadOfflineOffers { [weak self] (result) in
            switch result {
            case .success(let offlineOffers):
                self?.networkManager.loadMultyOfferList { (result) in
                    switch result {
                    case .success(let setMulty):
                        let multyArray = offlineOffers.filter{ setMulty.contains($0.id) }.map{ OfferOffline(id: $0.id, title: $0.store.title, description: $0.store.offlineCbImageDescription, priority: $0.store.priority, image: $0.store.offlineCbImage, tag: $0.store.tag, url: $0.store.url, typeId: $0.store.type_id, type: ShopTypeId.offlineMulty.rawValue)}
                        let singleArray = offlineOffers.filter{ !setMulty.contains($0.id) }.map{ OfferOffline(id: $0.id, title: $0.store.title, description: $0.store.offlineCbImageDescription, priority: $0.store.priority, image: $0.store.offlineCbImage, tag: $0.store.tag, url: $0.store.url, typeId: $0.store.type_id, type: ShopTypeId.offlineSingle.rawValue)}
                        DispatchQueue.main.async {
                            Session.shared.timeOfTableReceipt = Date()
                            CoreDataStorageContext.shared.removeAllOfflineOffers()
                            CoreDataStorageContext.shared.addListOfflineShops(objects: multyArray, type: ShopTypeId.offlineMulty.rawValue)
                            CoreDataStorageContext.shared.addListOfflineShops(objects: singleArray, type: ShopTypeId.offlineSingle.rawValue)
                            SpotlightManager.setupSpotlight(shops: multyArray, domainIdentifier: .OfflineStore)
                            completion(nil)
                        }
                    case .failure(let error):
                        DispatchQueue.main.async { completion(error as NSError) }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async { completion(error as NSError) }
            }
        }
    }
    
    func presentCategories(isForced: Bool, completion: (([Categories])->())?, failure: ((NSError)->())?) {
        if isForced || isExpiredCategories() {
            //ToDo: Add method which will load Categories and categoriesIdsByOffline
            commonLoadCategories { [weak self] (error) in
                if let error = error {
                    failure?(error)
                } else {
                    guard let categories = self?.fetchCategories() else {
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
        guard let categories = CoreDataStorageContext.shared.fetchTicketsCategories(by: -1) else {
            return nil
        }
        return categories
    }
    
    private func commonLoadCategories(completion: @escaping (NSError?)->()) {
        loadCategories { [weak self] (error) in
            self?.loadCategoriesByOffline(completion: { (error) in
                completion(error)
            })
        }
    }
    
    private func loadCategories(completion: @escaping (NSError?)->() ) {
        networkManager.loadCategories { (result) in
            switch result {
            case .success(let categories):
                DispatchQueue.main.async {
                    CoreDataStorageContext.shared.addAllTicketsCategory(objects: categories)
                    Session.shared.timeOfTableCategoryes = Date()
                    completion(nil)
                }
            case .failure(let error):
                DispatchQueue.main.async { completion(error as NSError) }
            }
        }
    }
    
    private func loadCategoriesByOffline(completion: @escaping (NSError?)->() ) {
        networkManager.loadCategoriesByOfflineOffers { (result) in
            switch result {
            case .success(let categories):
                DispatchQueue.main.async {
                    CoreDataStorageContext.shared.addAllIdCategoriesToOffline(objects: categories)
                    completion(nil)
                }
            case .failure(let error):
                DispatchQueue.main.async { completion(error as NSError) }
            }
        }
    }
    
    func getResultOfCheck(idOffer: Int, qrString qr: String, completion: @escaping (String?)->()) {
        networkManager.getAffiliateLink(id: idOffer) { [weak self] (result) in
            switch result {
            case .success(let linkResult):
                self?.networkManager.generateQRLink(link: linkResult) { [weak self] (result) in
                    switch result {
                    case .success(let redirectLink):
                        self?.networkManager.checkResult(redirectLink: redirectLink, qr: qr) { (result) in
                            switch result {
                            case .success(_):
                                DispatchQueue.main.async {
                                    completion(nil)
                                }
                            case .failure(let error):
                                DispatchQueue.main.async { completion((error as NSError).domain) }
                            }
                        }
                    case .failure(let error):
                        DispatchQueue.main.async { completion((error as NSError).domain) }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async { completion((error as NSError).domain) }
            }
        }
    }
}
