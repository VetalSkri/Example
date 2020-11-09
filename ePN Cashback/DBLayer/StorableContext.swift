//
//  StorableContext.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 21/11/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import Foundation

protocol StorableContext {
    
    //MARK: Save an object
    func add(object: Storable)
    
    func addAllShops(objects: [Store])
    func addAllShopsCategory(objects: [Categories])
    func addAllTicketsCategory(objects: [Categories])
    func addAllFaqCategoryes(objects: [FaqCategoryes])
    func addAllFaqAnswerQuestions(objects: [QuestionAnswer])
    func addAllPromocodes(objects: [Promocodes])
    func addAllDoodles(objects: [DoodlesItem])
    func addListOfflineShops(objects: [OfferOffline], type: Int)
    func addAllIdCategoriesToStore(objects: [StoreCategoryIds])
    
    //MARK: Update an object
    func update(object: Storable)
    
    //MARK: delete an object
    func delete(object: Storable)
    
    //MARK: fetch an objects
    
    func fetchLogoUrlStringByOffer(id: Int) -> String?
    func fetchFavoritePageShops(offSet: Int, sort: [NSSortDescriptor], limit: Int) -> [Store]?
    func fetchStoreByCategories(ids: [Int], typeId: ShopTypeId?, limit: Int, offSet: Int, sort: [NSSortDescriptor]) -> [Store]?
    func fetchShops(typeId: ShopTypeId?, limit: Int, offSet: Int, sort: [NSSortDescriptor]) -> [Store]?
    func fetchShopsFromSearch(by text: String, offSet: Int, limit: Int, typeId: ShopTypeId) -> [Store]?
    func fetchFavoriteIds() -> [Int]?
    
    func addAllIdCategoriesToOffline(objects: [StoreCategoryIds])
    func fetchOfflineOffersByCategories(ids: [Int], type typeId: Int) -> [OfferOffline]?
    
    func fetchDoodles() -> [DoodlesItem]
    func fetchFaqCategoryes(lang: String) -> [FaqCategoryes]?
    func fetchFaqCategoryes(lang: String, searchText: String) -> [FaqCategoryes]?
    func fetchFaqAnswerQuestions() -> [QuestionAnswer]?
    
    func fetchPushNotifications(sort: [NSSortDescriptor]) -> [LocalNotification]?
    func fetchPushNotifications(limit: Int, offSet: Int, sort: [NSSortDescriptor]) -> [LocalNotification]?
    func fetchPushNotificationsFromSearch(searchText text: String) -> [LocalNotification]?
    
    func fetchShopsCategories(by id: Int) -> [Categories]?
    func fetchTicketsCategories(by id: Int) -> [Categories]?
    
    func fetchPromocodes() -> [Promocodes]?
    func fetchPromocodes(limit: Int, offSet: Int, sort: [NSSortDescriptor]) -> [Promocodes]?
    
    func fetchOffersFromSearch(byTypeId typeId: Int?, searchText text: String) -> [OfferOffline]?
    func fetchOffers(byTypeId typeId: Int) -> [OfferOffline]?
    func fetchOfflineOffer(byId id: Int) -> OfferOffline?
    
    func insertOrUpdateShopImage(shopId: Int, imageUrl: String)
    func insertOrUpdateAllShopImages(objects: [OffersByOrders])
    func fetchShopImage(byId id: Int) -> String?
    
    //MARK: delete full entities after log out
    func removeAllPushNotifications()
    func removeAllShops()
    func removeAllPromocodes()
    func removeAllShopsCategory()
    func removeAllTicketsCategory()
    func removeAllFaqAnswerQuestions()
    func removeAllFaqCategoryes()
    func removeAllOfflineOffers()
    
    func deleteAllPersonalDataFromCoreData()
    
    //MARK: support message methods
    func addMessage(message: SupportMessage)
    func getMessages(forDialogId dialogId: Int) -> [SupportMessage]?
    func removeMessage(messageId: Int)
    func updateMessageFileLink(messageFile: SupportMessageFile)
}

extension StorableContext {
    
    func fetchShops(typeId: ShopTypeId?, limit: Int = 5, offSet: Int = 0, sort: [NSSortDescriptor] = [NSSortDescriptor(key: "priority", ascending: true)]) -> [Store]? {
        return fetchShops(typeId: typeId, limit: limit, offSet: offSet, sort: sort)
    }
    
    func fetchFavoritePageShops(offSet: Int, sort: [NSSortDescriptor], limit: Int = 20) -> [Store]? {
        return fetchFavoritePageShops(offSet: offSet, sort: sort, limit: limit)
    }

    func fetchStoreByCategories(ids: [Int], typeId: ShopTypeId?, limit: Int = 5, offSet: Int = 0, sort: [NSSortDescriptor] = [NSSortDescriptor(key: "priority", ascending: true),NSSortDescriptor(key: "id", ascending: true)]) -> [Store]? {
        return fetchStoreByCategories(ids: ids, typeId: typeId, limit: limit, offSet: offSet, sort: sort)
    }
        
    func fetchPushNotifications(sort: [NSSortDescriptor] = [NSSortDescriptor(key: "date", ascending: false)]) -> [LocalNotification]? {
        return fetchPushNotifications(sort: sort)
    }
    
    func fetchPushNotifications(limit: Int = 20, offSet: Int = 0, sort: [NSSortDescriptor] = [NSSortDescriptor(key: "date", ascending: false)]) -> [LocalNotification]? {
        return fetchPushNotifications(limit: limit, offSet: offSet, sort: sort)
    }
    
    func fetchPromocodes(limit: Int, offSet: Int, sort: [NSSortDescriptor]) -> [Promocodes]? {
        return fetchPromocodes(limit: limit, offSet: offSet, sort: sort)
    }
    
    func fetchShopsFromSearch(by text: String, offSet: Int = 20, limit: Int = 20, typeId: ShopTypeId = .common) -> [Store]? {
        return fetchShopsFromSearch(by: text, offSet: offSet, limit: limit, typeId: typeId)
    }
    
}
