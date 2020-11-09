//
//  ShopDetailViewModel.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 22/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator

public enum FavoriteState {
    case favorite
    case notFavorite
    case inProgress
}

class ShopDetailViewModel: NSObject, ShopModelType, RedirectLinkProtocol {
    
    // MARK: - ErrorConstants
    
    private enum ErrorConstants {
        static let offerDisabledCode = 422001
        static let offerDisabledMessage = NSLocalizedString("Offer is disabled", comment: "")
    }
    
    private let source: ShopDetailSource!
    private var inFavoriteProcess = false
    private var conditionFaqHidden = true
    private let offer: Store!
    private var shopInfo: ShopInfo?
    private var faqConditions = [
        ShopDetailConditionFaqItem(imageName: "clearBag", title: NSLocalizedString("Empty cart in store", comment: ""), description: NSLocalizedString("Before activating the cashback, be sure to empty the cart", comment: "")),
        ShopDetailConditionFaqItem(imageName: "offAds", title: NSLocalizedString("Disable ad blockers", comment: ""), description: NSLocalizedString("In case when you follow the AliExpress application error 404 appears", comment: "")),
        ShopDetailConditionFaqItem(imageName: "buyOnSite", title: NSLocalizedString("Buy on the sites of stores", comment: ""), description: NSLocalizedString("Mobile applications of all stores, except Aliexpress", comment: ""))
    ]
    private let router: UnownedRouter<ShopsRoute>
    private let repository: StoreRepositoryProtocol
    
    init(router: UnownedRouter<ShopsRoute>, storeRepository: StoreRepositoryProtocol, shop: Store, source: ShopDetailSource) {
        self.router = router
        self.repository = storeRepository
        self.shopInfo = nil
        self.offer = shop
        self.source = source
        super.init()
    }
    
    // MARK: - AliExpress link checker banner
    
    var isAliExpressShop: Bool {
        return self.offer.id == 1
    }
    
    var linkCheckerTitle: String {
        return NSLocalizedString("AliExpress link checker title", comment: "")
    }
    
    var linkCheckerDescription: String {
        return NSLocalizedString("AliExpress link checker description", comment: "")
    }
    
    var lickCheckerButtonTitle: String {
        return NSLocalizedString("AliExpress link checker button title", comment: "")
    }
    
    func openCheckLink() {
        router.trigger(.verifyLink)
    }
    
    func loadShopInfo(completion: (()->())?, failure:((String)->())?) {
        repository.loadShopInfo(id: offer.id, completion: { [weak self] (shopDetail) in
            self?.shopInfo = shopDetail
            completion?()
        }, failure: { (error) in
            if error.code == ErrorConstants.offerDisabledCode {
                failure?(ErrorConstants.offerDisabledMessage)
            } else {
                failure?(Alert.getMessage(by: error))
            }
        })
    }
    
    func sendOpenPageAnalytics() {
        OnlineOfferAnalytics.openOnlineOfferWith(id: offer.id, fromPage: source)
    }
    
    func goOnBack() {
        router.trigger(.back)
    }
    
    func shopLogoUrl() -> String {
        return shopInfo?.image ?? ""
    }
    
    func logoSmall() -> String {
        return shopInfo?.logoSmall ?? ""
    }
    
    func confirmTitleText() -> String {
        return NSLocalizedString("Average waiting time for cashback", comment: "")
    }
    
    func confirmTime() -> String {
        return shopInfo?.confirmTime ?? ""
    }
    
    func hasBanner() -> Bool {
        return false
        //!!!Uncomment under lines for apply banner!!!
//        if let shopInfo = shopInfo {
//            return shopInfo.banner != nil
//        }
//        return false
    }
    
    func bannerTitle() -> String {
        return "Тестовый захардкоженный заголовок"
    }
    
    func bannerSubtitle() -> String {
        return "Тестовое захардкоженное описание"
    }
    
    func bannerBackground() -> String {
        return shopInfo!.banner!.background
    }
    
    func bannerMainImage() -> String {
        return shopInfo!.banner!.image
    }
    
    func bannerShopLogo() -> String {
        return shopInfo!.image  //!!!!!!FIX IT, WHEN API WILL NORMAL!!!!!!!
    }
    
    func numberOfRates() -> Int {
        return shopInfo?.rates?.count ?? 0
    }
    
    func rate(forIndexPath indexPath: IndexPath) -> ShopInfoRates {
        return shopInfo!.rates![indexPath.row]
    }
 
    func numberOfFaqConditions() -> Int {
        return conditionFaqHidden ? 1 : faqConditions.count
    }
    
    func faqCondition(forIndexPath indexPath: IndexPath) -> ShopDetailConditionFaqItem {
        return faqConditions[indexPath.row]
    }
    
    func switchConditionHiddenFlag() {
        self.conditionFaqHidden = !self.conditionFaqHidden
    }
    
    func isFaqConditionHidden() -> Bool {
        return conditionFaqHidden
    }
    
    func conditionDescription() -> String {
        return self.shopInfo?.ratesDesc ?? ""
    }
    
    func favoriteState() -> FavoriteState {
        if inFavoriteProcess {
            return .inProgress
        }
        return offer.isFavorite ? .favorite : .notFavorite
    }
    
    func startFavoriteLoad() {
        self.inFavoriteProcess = true
    }
    
    func title() -> String {
        if let shopInfo = shopInfo {
            return shopInfo.title
        }
        return offer.store.title
    }
    
    func openStore(completion: ((URL)->())?, failure: ((Int)->())?) {
        OnlineOfferAnalytics.clickOnBuyWithCB(offerID: offer.id)
        
        getLinkOnShop(completion: { [weak self] (result) in
            self?.checkCorrectLink(result) { (link) in
                completion?(link)
            }
            }) { (errorCode) in
            failure?(errorCode)
        }
    }
    
    func getLinkOnShop(completion: ((LinkGenerateDataResponse)->())?, failure: ((Int)->())?) {
        LinkGenerateApiClient.generate(offerId: offer.id) { (result) in
            switch result {
            case .success(let response):
                guard let result = response.data.first else {
                    //TODO: add text for this situation
                    failure?(000005)//can't generate link
                    return
                }
                completion?(result)
                break
            case .failure(let error):
                failure?((error as NSError).code)
                break
            }
        }
    }
    
    func changeFavouriteStatus(to like: Bool, completion: @escaping (()->())) {
        if like {
            addToFavorite(store: offer) { [weak self] (store) in
                guard let changedStore = store else {
                    self?.inFavoriteProcess = false
                    completion()
                    return
                }
                self?.inFavoriteProcess = false
                self?.offer.isFavorite = changedStore.isFavorite
                completion()
                NotificationCenter.default.post(name: .changedFavouriteStatusShop, object: changedStore)
            }
        } else {
            deleteFromFavorite(store: offer) { [weak self] (store) in
                guard let changedStore = store else {
                    self?.inFavoriteProcess = false
                    completion()
                    return
                }
                self?.inFavoriteProcess = false
                self?.offer.isFavorite = changedStore.isFavorite
                completion()
                NotificationCenter.default.post(name: .changedFavouriteStatusShop, object: changedStore)
            }
        }
    }
    
    func actionText() -> String? {
        if let action = shopInfo?.action {
            return action.description
        }
        return nil
    }
    
    func shopDescription() -> String? {
        if let description = shopInfo?.description {
            return description
        }
        return nil
    }
}

public struct ShopDetailConditionFaqItem {
    var imageName: String
    var title: String
    var description: String
}
