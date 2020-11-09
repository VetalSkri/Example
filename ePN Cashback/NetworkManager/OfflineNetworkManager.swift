//
//  networkManagerOffline.swift
//  Backit
//
//  Created by Ivan Nikitin on 10/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

class OfflineNetworkManager {
    
    func loadCategories(completion: @escaping (Result<[Categories],Error>)->()) {
        ShopApiClient.category(shopTypeID: .offlineMulty) { (result) in
            switch result {
            case .success(let response):
                guard let data = response.data.first else {
                    let error = NSError(domain: "Error find data from server", code: 000006, userInfo: nil)
                    completion(.failure(error))
                    return
                }
                let allCategoriesTree = data.attributes.tree
                completion(.success(allCategoriesTree))
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        }
    }
    
    func loadShopInfo(offerId id: Int, completion: @escaping (Result<OfflineShopInfo,Error>)->()) {
        ShopApiClient.offlineShopInfo(forShopId: id) { (result) in
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
    
    func loadOfflineOffers(completion: @escaping (Result<[Store],Error>)->()) {
        ShopApiClient.offers(limit: Util.MAX_SIZE_OF_SHOPS_FROM_SERVER, typeId: ShopTypeId.offlineMulty.rawValue) { (result) in
            switch result {
            case .success(let response):
                guard let offers = response.data?.elements else {
                    let error = NSError(domain: "Error find data from server", code: 000006, userInfo: nil)
                    completion(.failure(error))
                    return
                }
                let offlineOffers = offers.map { Store(id: $0.id, offer: $0.attributes) }
                completion(.success(offlineOffers))
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        }
    }
    
    func loadMultyOfferList(completion: @escaping (Result<Set<Int?>,Error>)->()) {
        let url = URL(string: Util.offlineAppLink)!
        OfflineCashbackApiClient.multiOffers(url: url) { (result) in
            switch result {
            case .success(let response):
                let setMultyOfferIds = Set(response.offers.map{Int($0.id)})
                completion(.success(setMultyOfferIds))
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        }
    }
    
    func loadCategoriesByOfflineOffers(completion: @escaping (Result<[StoreCategoryIds],Error>)->()) {
        ShopApiClient.categoryOfflineOffers { (result) in
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
    
    func generateQRLink(link: String, completion: @escaping (Result<String,Error>)->()) {
        guard let url = URL(string: link) else {
            let error = NSError(domain: NSLocalizedString("An unexpected error has occurred.", comment: ""), code: 000007, userInfo: nil)
            completion(.failure(error))
            return
        }
        OfflineCashbackApiClient.redirectUrl(url: url) { (result) in
            switch result {
            case .success(let response):
                completion(.success(response.redirect_url))
                break
            case .failure(_):
                let error = NSError(domain: NSLocalizedString("An unexpected error has occurred.", comment: ""), code: 000007, userInfo: nil)
                completion(.failure(error))
                break
            }
        }
    }
    
    func getActivePromotions(completion: @escaping (Result<[OfferPromotions],Error>)->()) {
        OfflineCashbackApiClient.activePromotions { (result) in
            switch result {
            case .success(let response):
                let promotions = response.data.map({ $0.attributes })
                completion(.success(promotions))
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        }
    }
    
    func getPersonalPromotions(completion: @escaping (Result<[IndividualOfferPromotions],Error>)->()) {
        OfflineCashbackApiClient.personalPromotions { (result) in
            switch result {
            case .success(let response):
                let personalPromotions = response.data.map({ $0.attributes })
                completion(.success(personalPromotions))
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        }
    }
    
    func getAffiliateLink(id idShop: Int, completion: @escaping (Result<String,Error>)->()) {
        OfflineCashbackApiClient.affiliateLink(id: idShop) { (result) in
            switch result {
            case .success(let response):
                guard let link = response.data.first?.attributes.cashbackPackage?.link else {
                    let error = NSError(domain: NSLocalizedString("An unexpected error has occurred.", comment: ""), code: 000007, userInfo: nil)
                    completion(.failure(error))
                    return
                }
                completion(.success(link))
                break
            case .failure(_):
                let error = NSError(domain: NSLocalizedString("An unexpected error has occurred.", comment: ""), code: 000007, userInfo: nil)
                completion(.failure(error))
                break
            }
        }
    }
    
    func checkResult(redirectLink link: String, qr qrData: String, completion: @escaping (Result<String,Error>)->()) {
        guard let urlSourse = URL(string: link) else {
            let error = NSError(domain: NSLocalizedString("An unexpected error has occurred.", comment: ""), code: 000007, userInfo: nil)
            completion(.failure(error))
            return
        }
        let url = urlSourse.appending("qrdata", value: qrData).appending("response", value: "json")
        
        OfflineCashbackApiClient.checkResult(url: url) { (result) in
            switch result {
            case .success(let response):
                if response.type == "success" {
                    completion(.success("success"))
                } else {
                    guard let type = TypeOfStatusOfflineCheck(rawValue: response.status) else {
                        let error = NSError(domain: NSLocalizedString("An unexpected error has occurred.", comment: ""), code: 000007, userInfo: nil)
                        completion(.failure(error))
                        return
                    }
                    var failureString: String
                    switch type {
                    case .none:
                        failureString = NSLocalizedString("noneCB", comment: "")
                    case .off:
                        failureString = NSLocalizedString("offCB", comment: "")
                    case .on_duplicate:
                        failureString = NSLocalizedString("on_duplicateCB", comment: "")
                    case .on_duplicate_2:
                        failureString = NSLocalizedString("on_duplicate2CB", comment: "")
                    case .on_incompat_1:
                        failureString = NSLocalizedString("on_incompat_1CB", comment: "")
                    case .on_incompat_2:
                        failureString = NSLocalizedString("on_incompat_2CB", comment: "")
                    case .on_invalid:
                        failureString = NSLocalizedString("on_invalidCB", comment: "")
                    case .on_limited:
                        failureString = NSLocalizedString("on_limitedCB", comment: "")
                    }
                    let error = NSError(domain: failureString, code: 000007, userInfo: nil)
                    completion(.failure(error))
                    return
                }
                break
            case .failure(_):
                let error = NSError(domain: NSLocalizedString("An unexpected error has occurred.", comment: ""), code: 000007, userInfo: nil)
                completion(.failure(error))
                break
            }
        }
    }
}
