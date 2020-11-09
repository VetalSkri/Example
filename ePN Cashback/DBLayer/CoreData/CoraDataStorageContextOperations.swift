//
//  CoraDataStorageContextOperations.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 21/11/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import Foundation
import CoreData

//MARK: Extensions to common add/update/remove in CoreData
extension CoreDataStorageContext {
    
    //TODO: - On the first iteration, we'll removeAll notes and add All new notes
    
    func add(object: Storable) {
        if let obj = object as? Store {
            addShop(object: obj)
        } else if let obj = object as? FaqCategoryes {
            addFaqCategory(object: obj)
        } else if let obj = object as? QuestionAnswer {
            _ = addFaqAnswerQuestion(object: obj)
        } else if let obj = object as? LocalNotification {
            addPushNotification(object: obj)
        } else if let obj = object as? Promocodes {
            addPromocode(object: obj)
        } else if let obj = object as? Payments {
            addPayment(object: obj)
        } else if let obj = object as? DoodlesItem {
            addDoodle(object: obj)
        }
        self.saveData()
    }
    
    func update(object: Storable) {
        if let obj = object as? Store {
            updateShop(object: obj)
        } else if let obj = object as? FaqCategoryes {
            updateFaqCategory(object: obj)
        } else if let obj = object as? QuestionAnswer {
            updateFaqAnswerQuestion(object: obj)
//        } else if let obj = object as? LocalNotification {
//            updateMessage(object: obj)
        } else if let obj = object as? Promocodes {
            updatePromocode(object: obj)
        } else if let obj = object as? Payments {
            updatePayment(object: obj)
        }
        self.saveData()
    }
    
    func delete(object: Storable) {
        if let obj = object as? Store {
            if let shop = Shop.findShop(byId: obj.id, inManagedObjectContext: context) {
                context.delete(shop)
            }
        } else if let obj = object as? FaqCategoryes {
            if let faqCategory = FaqCategory.find(byId: obj.id, inManagedObjectContext: context){
                context.delete(faqCategory)
            }
        } else if let obj = object as? QuestionAnswer {
            if let faqAnswerQuestion = FaqAnswerQuestion.find(byId: obj.id, lang: obj.lang, inManagedObjectContext: context){
                context.delete(faqAnswerQuestion)
            }
        } else if let obj = object as? Promocodes {
            if let promocode = Promocode.findPromocode(byCode: obj.code, activated: obj.activated_at, expired: obj.expire_at, inManagedObjectContext: context){
                context.delete(promocode)
            }
        } else if let obj = object as? Payments {
            if let payment = Payment.findPayments(byId: Int64(obj.id), inManagedObjectContext: context) {
                context.delete(payment)
            }
        }
        self.saveData()
    }
    
    func deleteAllPersonalDataFromCoreData() {
        Promocode.deleteEntityRequest(entity: Promocode.self, inManagedObjectContext: context)
        PushNotification.deleteEntityRequest(entity: PushNotification.self, inManagedObjectContext: context)
        FavoriteStore.deleteEntityRequest(entity: FavoriteStore.self, inManagedObjectContext: context)
        Payment.deleteEntityRequest(entity: Payment.self, inManagedObjectContext: context)
        self.saveData()
    }
}

//MARK: Extensions to add/update/remove/fetch Shop in CoreData
extension CoreDataStorageContext {
    
    func addAllShops(objects: [Store]) {
        self.removeAllShops()
        for index in 0..<objects.count {
            addShop(object: objects[index])
        }
        self.saveData()
    }
    
    func addShop(object: Store){
        let shop = Shop(context: self.context)
        shop.id = Int64(object.id)
        shop.name = object.store.name
        shop.priority = Int64(object.store.priority)
        shop.image = object.store.image
        shop.logo = object.store.logo
        shop.logo_small = object.store.logo_small
        shop.maxRate = object.store.maxRate
        shop.maxRatePretext = object.store.maxRatePretext
        shop.tag = object.store.tag
        shop.url = object.store.url
        shop.title = object.store.title
        shop.typeId = Int64(object.store.type_id)
        shop.offlineCbImage = object.store.offlineCbImage
        shop.offlineCbImageDescription = object.store.offlineCbImageDescription
        shop.linkDefault = object.store.link_default
    }

    func updateShop(object: Store) {
        if let shop = Shop.findShop(byId: object.id, inManagedObjectContext: context) {
            shop.id = Int64(object.id)
            shop.name = object.store.name
            shop.priority = Int64(object.store.priority)
            shop.image = object.store.image
            shop.logo = object.store.logo
            shop.logo_small = object.store.logo_small
            shop.maxRate = object.store.maxRate
            shop.maxRatePretext = object.store.maxRatePretext
            shop.tag = object.store.tag
            shop.url = object.store.url
            shop.title = object.store.title
            shop.typeId = Int64(object.store.type_id)
            shop.offlineCbImage = object.store.offlineCbImage
            shop.offlineCbImageDescription = object.store.offlineCbImageDescription
            shop.linkDefault = object.store.link_default
        }
    }
    
    func removeAllShops() {
        let request: NSFetchRequest<Shop> = Shop.fetchRequest()
        if let shops = (try? context.fetch(request)) {
            shops.forEach {
                context.delete($0)
            }
            self.saveData()
        }
    }
    ///Unused methods
    /*
    func fetchOffers() -> [Store]? {
        if let shops = Shop.fetchShops(inManagedObjectContext: context) {
            let offers = shops.map{
                Store(id: Int($0.id), name: $0.name, title: $0.title, tag: $0.tag, image: $0.image, logo: $0.logo, logo_s: $0.logo_small, priority: Int($0.priority), maxRate: $0.maxRate, typeId: Int($0.typeId), offlineCbImage: $0.offlineCbImage, offlineCbDescription: $0.offlineCbImageDescription, linkDefault: $0.linkDefault, url: $0.url)
            }
            return offers
        } else {
            return nil
        }
    }
    
    func fetchOffersBy(typeId: ShopTypeId) -> [Store]? {
        if let shops = Shop.fetchShops(inManagedObjectContext: context,typeId: typeId.rawValue, sortDescriptor: [NSSortDescriptor(key: "priority", ascending: true), NSSortDescriptor(key: "id", ascending: true)]) {
            let offers = shops.map{
                Store(id: Int($0.id), name: $0.name, title: $0.title, tag: $0.tag, image: $0.image, logo: $0.logo, logo_s: $0.logo_small, priority: Int($0.priority), maxRate: $0.maxRate, typeId: Int($0.typeId), offlineCbImage: $0.offlineCbImage, offlineCbDescription: $0.offlineCbImageDescription, linkDefault: $0.linkDefault, url: $0.url)
            }
            return offers
        } else {
            return nil
        }
    }
    
    func fetchOffer(byId id: Int) -> Store? {
        if let shop = Shop.findShop(byId: id, inManagedObjectContext: context) {
            let offer = Store(id: Int(shop.id), name: shop.name, title: shop.title, tag: shop.tag, image: shop.image, logo: shop.logo, logo_s: shop.logo_small, priority: Int(shop.priority), maxRate: shop.maxRate, typeId: Int(shop.typeId), offlineCbImage: shop.offlineCbImage, offlineCbDescription: shop.offlineCbImageDescription, linkDefault: shop.linkDefault, url: shop.url)
            return offer
        } else {
            return nil
        }
    }
    
    func fetchAllShopsByLabel(_ id: Int) -> [Store]? {
        guard let label = Label.findLabel(byId: id, inManagedObjectContext: context) else {
            return nil
        }
        if let shops = Shop.findShops(byLabel: label, inManagedObjectContext: context) {
            let offers = shops.map{
                Store(id: Int($0.id), name: $0.name, title: $0.title, tag: $0.tag, image: $0.image, logo: $0.logo, logo_s: $0.logo_small, priority: Int($0.priority), labelId: $0.labels?.allObjects.map{ Int(($0 as! Label).id) }, maxRate: $0.maxRate, typeId: Int($0.typeId), offlineCbImage: $0.offlineCbImage, offlineCbDescription: $0.offlineCbImageDescription, linkDefault: $0.linkDefault, url: $0.url)
            }
            return offers
        } else {
            return nil
        }
    }
    
    func fetchShopsToPreview(byLabelId id: Int, limit: Int = 5) -> [Store]? {
        guard let label = Label.findLabel(byId: id, inManagedObjectContext: context) else {
            return nil
        }
        if let shops = Shop.findShopsToPreview(byLabel: label, inManagedObjectContext: context, fetchLimit: limit) {
            let offers = shops.map{
                Store(id: Int($0.id), name: $0.name, title: $0.title, tag: $0.tag, image: $0.image, logo: $0.logo, logo_s: $0.logo_small, priority: Int($0.priority), labelId: $0.labels?.allObjects.map{ Int(($0 as! Label).id) }, maxRate: $0.maxRate, typeId: Int($0.typeId), offlineCbImage: $0.offlineCbImage, offlineCbDescription: $0.offlineCbImageDescription, linkDefault: $0.linkDefault, url: $0.url)
            }
            return offers
        } else {
            return nil
        }
    }
    */
    func fetchShops(typeId: ShopTypeId?, limit: Int = 5, offSet: Int = 0, sort: [NSSortDescriptor] = [NSSortDescriptor(key: "priority", ascending: true),NSSortDescriptor(key: "id", ascending: true)]) -> [Store]? {
        let favoriteIds = fetchFavoriteIds()
        if let shops = Shop.fetchPageOfShops(inManagedObjectContext: context, typeId: typeId, fetchLimit: limit, fetchOffSet: offSet, sortDescriptor: sort) {
            let offers = shops.map{
                Store(id: Int($0.id), name: $0.name, title: $0.title, tag: $0.tag, image: $0.image, logo: $0.logo, logo_s: $0.logo_small, priority: Int($0.priority), maxRate: $0.maxRate, maxRatePretext: $0.maxRatePretext,typeId: Int($0.typeId), offlineCbImage: $0.offlineCbImage, offlineCbDescription: $0.offlineCbImageDescription, linkDefault: $0.linkDefault, url: $0.url)
            }
            favoriteIds?.forEach{ idFavorite in offers.forEach{ store in
                if store.id == idFavorite {
                    store.isFavorite = true
                }
            }}
            return offers
        } else {
            return nil
        }
    }
    
    func fetchShop(byId id: Int) -> Store? {
        if let shop = Shop.findShop(byId: id, inManagedObjectContext: context) {
            return Store(id: Int(shop.id), name: shop.name, title: shop.title, tag: shop.tag, image: shop.image, logo: shop.logo, logo_s: shop.logo_small, priority: Int(shop.priority), maxRate: shop.maxRate,maxRatePretext: shop.maxRatePretext, typeId: Int(shop.typeId), offlineCbImage: shop.offlineCbImage, offlineCbDescription: shop.offlineCbImageDescription, linkDefault: shop.linkDefault, url: shop.url)
        }
        return nil
    }
    
    func fetchFavoritePageShops(offSet: Int, sort: [NSSortDescriptor], limit: Int = 20) -> [Store]? {
        let favoriteIds = fetchFavoriteIds()
        if let shops = Shop.findFavoriteShopsPaging(inManagedObjectContext: context, fetchLimit: limit, fetchOffSet: offSet, sortDescriptor: sort, favoriteIds: favoriteIds) {
            let offers = shops.map{
                Store(id: Int($0.id), name: $0.name, title: $0.title, tag: $0.tag, image: $0.image, logo: $0.logo, logo_s: $0.logo_small, priority: Int($0.priority), maxRate: $0.maxRate,maxRatePretext: $0.maxRatePretext, typeId: Int($0.typeId), offlineCbImage: $0.offlineCbImage, offlineCbDescription: $0.offlineCbImageDescription, linkDefault: $0.linkDefault, url: $0.url, isFavorite: true)
            }
            return offers
        } else {
            return nil
        }
    }
    
    func fetchShopsFromSearch(by text: String, offSet: Int = 20, limit: Int = 20, typeId: ShopTypeId = .common) -> [Store]? {
        let favoriteIds = fetchFavoriteIds()
        if let shops = Shop.searchShops(by: text, fetchOffSet: offSet, fetchLimit: limit, typeId: typeId, inManagedObjectContext: context) {
            let offers = shops.map{
                Store(id: Int($0.id), name: $0.name, title: $0.title, tag: $0.tag, image: $0.image, logo: $0.logo, logo_s: $0.logo_small, priority: Int($0.priority), maxRate: $0.maxRate,maxRatePretext: $0.maxRatePretext, typeId: Int($0.typeId), offlineCbImage: $0.offlineCbImage, offlineCbDescription: $0.offlineCbImageDescription, linkDefault: $0.linkDefault, url: $0.url)
            }
            favoriteIds?.forEach{ idFavorite in offers.forEach{ store in
                if store.id == idFavorite {
                    store.isFavorite = true
                }
            }}
            return offers
        } else {
            return nil
        }
    }
}

//MARK: Extensions to add/remove/fetch Favorites in CoreData
extension CoreDataStorageContext {
    
    func addAllFavorites(ids: [Int]) {
        removeAllFavorites()
        for index in 0..<ids.count {
            addFavorite(id: ids[index])
        }
        self.saveData()
    }
    
    func addFavorite(id: Int) {
        let favorite = FavoriteStore(context: self.context)
        favorite.id = Int64(id)
    }
    
    func removeFavorite(id: Int) {
        if let favorite = FavoriteStore.findFavorite(byId: id, inManagedObjectContext: context) {
            context.delete(favorite)
        }
        self.saveData()
    }
    
    func removeAllFavorites() {
        let request: NSFetchRequest<FavoriteStore> = FavoriteStore.fetchRequest()
        if let favorites = (try? context.fetch(request)) {
            for i in 0..<favorites.count {
                context.delete(favorites[i])
            }
            self.saveData()
        }
    }
    
    func fetchFavoriteIds() -> [Int]? {
        if let ids = FavoriteStore.fetchFavoriteIds(inManagedObjectContext: context) {
            return ids
        } else {
            return nil
        }
    }
}

//MARK: Extensions to add/update/remove/fetch ShopsCategory in CoreData
extension CoreDataStorageContext {
    
    func addAllShopsCategory(objects: [Categories]) {
        removeAllShopsCategory()
        for index in 0..<objects.count {
            addShopsCategory(object: objects[index])
        }
        self.saveData()
    }
   
    func addShopsCategory(object: Categories, parentId: Int64 = -1){
        let category = ShopsCategory(context: self.context)
        category.id = Int64(object.id)
        category.name = object.name
        category.parentId = parentId
        if let tree = object.tree {
            for i in 0..<tree.count {
               addShopsCategory(object: tree[i], parentId: Int64(object.id))
            }
        }
    }
    
    func removeAllShopsCategory() {
        let request: NSFetchRequest<ShopsCategory> = ShopsCategory.fetchRequest()
        if let categories = (try? context.fetch(request)) {
            categories.forEach {
                context.delete($0)
            }
            self.saveData()
        }
    }

    func fetchShopsCategories(by id: Int) -> [Categories]? {
        if let category = ShopsCategory.fetchCategories(byParent: id, inManagedObjectContext: context) {
            let categories = category.map{ Categories(id: Int($0.id), name: $0.name, tree: nil)}
            return categories
        } else {
            return nil
        }
    }
}

//MARK: Extensions to add/update/remove/fetch TicketsCategory in CoreData
extension CoreDataStorageContext {
    
    func addAllTicketsCategory(objects: [Categories]) {
        removeAllTicketsCategory()
        for index in 0..<objects.count {
            addTicketsCategory(object: objects[index])
        }
        self.saveData()
    }
   
    func addTicketsCategory(object: Categories, parentId: Int64 = -1){
        let category = TicketsCategory(context: self.context)
        category.id = Int64(object.id)
        category.name = object.name
        category.parentId = parentId
        if let tree = object.tree {
            for i in 0..<tree.count {
               addTicketsCategory(object: tree[i], parentId: Int64(object.id))
            }
        }
    }
    
    func removeAllTicketsCategory() {
        let request: NSFetchRequest<TicketsCategory> = TicketsCategory.fetchRequest()
        if let categories = (try? context.fetch(request)) {
            categories.forEach {
                context.delete($0)
            }
            self.saveData()
        }
    }

    func fetchTicketsCategories(by id: Int) -> [Categories]? {
        if let category = TicketsCategory.fetchCategories(byParent: id, inManagedObjectContext: context) {
            let categories = category.map{ Categories(id: Int($0.id), name: $0.name, tree: nil)}
            return categories
        } else {
            return nil
        }
    }
}

//MARK: CategoryIds with Stores
extension CoreDataStorageContext {
    
    func addAllIdCategoriesToStore(objects: [StoreCategoryIds]) {
        removeAllIdsCategoriesToStore()
        for index in 0..<objects.count {
            if let categoryIds = objects[index].categoryIds {
                for categoryIndex in 0..<categoryIds.count {
                    let categoryOffer = CategoryOffers(context: self.context)
                    categoryOffer.idStore = Int64(objects[index].id)
                    categoryOffer.idCategory = Int64(categoryIds[categoryIndex])
                }
            }
        }
        self.saveData()
    }
    
    func fetchStoreByCategories(ids: [Int], typeId: ShopTypeId?, limit: Int = 5, offSet: Int = 0, sort: [NSSortDescriptor] = [NSSortDescriptor(key: "priority", ascending: true),NSSortDescriptor(key: "id", ascending: true)]) -> [Store]? {
        guard let idsStore = CategoryOffers.fetchStoreIds(byCategories: ids, inManagedObjectContext: context) else {
            return nil
        }
        guard let stores = Shop.fetchPageOfShopsByCategory(ids: idsStore, inManagedObjectContext: context, typeId: typeId, fetchLimit: limit, fetchOffSet: offSet, sortDescriptor: sort) else { return nil }
        let favoriteIds = fetchFavoriteIds()
        let offers = stores.map{
            Store(id: Int($0.id), name: $0.name, title: $0.title, tag: $0.tag, image: $0.image, logo: $0.logo, logo_s: $0.logo_small, priority: Int($0.priority), maxRate: $0.maxRate,maxRatePretext: $0.maxRatePretext, typeId: Int($0.typeId), offlineCbImage: $0.offlineCbImage, offlineCbDescription: $0.offlineCbImageDescription, linkDefault: $0.linkDefault, url: $0.url)
        }
        favoriteIds?.forEach{ idFavorite in offers.forEach{ store in
            if store.id == idFavorite {
                store.isFavorite = true
            }
        }}
        return offers
    }
    
    func removeAllIdsCategoriesToStore() {
        let request: NSFetchRequest<CategoryOffers> = CategoryOffers.fetchRequest()
        if let ids = (try? context.fetch(request)) {
            ids.forEach {
                context.delete($0)
            }
            self.saveData()
        }
    }
}

//MARK: CategoryIds with OfflineOffers
extension CoreDataStorageContext {
    
    func addAllIdCategoriesToOffline(objects: [StoreCategoryIds]) {
        removeAllIdsCategoriesToOffline()
        for index in 0..<objects.count {
            if let categoryIds = objects[index].categoryIds {
                for categoryIndex in 0..<categoryIds.count {
                    let categoryOffer = CategoryOffline(context: self.context)
                    categoryOffer.idOffline = Int64(objects[index].id)
                    categoryOffer.idCategory = Int64(categoryIds[categoryIndex])
                }
            }
        }
        self.saveData()
    }
    
    func fetchOfflineOffersByCategories(ids: [Int], type typeId: Int) -> [OfferOffline]? {
        guard let idsOffline = CategoryOffline.fetchOfflineIds(byCategories: ids, inManagedObjectContext: context) else {
            return nil
        }
        if let offline = OfflineOffer.fetchOfflineOffersByCategory(ids: idsOffline, inManagedObjectContext: context, typeId: typeId) {
            let offlineOffers = offline.map{
                OfferOffline(id: Int($0.id), title: $0.title, description: $0.descript, priority: Int($0.priority), image: $0.image, tag: $0.tag, url: $0.url, typeId: Int($0.typeId), type: Int($0.type))
            }
            return offlineOffers
        } else {
            return nil
        }
    }
    
    func removeAllIdsCategoriesToOffline() {
        let request: NSFetchRequest<CategoryOffline> = CategoryOffline.fetchRequest()
        if let ids = (try? context.fetch(request)) {
            ids.forEach {
                context.delete($0)
            }
            self.saveData()
        }
    }
    
    func fetchOfflineOffer(id: Int) -> OfferOffline? {
        guard let offlineOffer = OfflineOffer.findOfflineOffer(byId: id, inManagedObjectContext: context) else { return nil }
        return OfferOffline(id: Int(offlineOffer.id), title: offlineOffer.title, description: offlineOffer.descript, priority: Int(offlineOffer.priority), image: offlineOffer.image, tag: offlineOffer.tag, url: offlineOffer.url, typeId: Int(offlineOffer.typeId), type: Int(offlineOffer.type))
    }
}

//MARK: Extensions to add/update/remove/fetch Promocode in CoreData
extension CoreDataStorageContext {
    
    func addAllPromocodes(objects: [Promocodes]) {
        removeAllPromocodes()
        for i in 0 ..< objects.count {
            addPromocode(object: objects[i])
        }
        self.saveData()
    }
    
    func addPromocode(object: Promocodes) {
        let promocode = Promocode(context: self.context)
        promocode.id = Promocode.getTheMostIdentifier(inManagedObjectContext: context) + 1
        promocode.code = object.code
        promocode.activatedAt = object.activated_at
        promocode.expiredAt = object.expire_at
        promocode.status = object.status
    }
    
    func addPromocode(object: Promocodes, id: Int64) {
        let promocode = Promocode(context: self.context)
        promocode.id = id
        promocode.code = object.code
        promocode.activatedAt = object.activated_at
        promocode.expiredAt = object.expire_at
        promocode.status = object.status
    }
    
    func updatePromocode(object: Promocodes) {
        if let promocode = Promocode.findPromocode(byCode: object.code, activated: object.activated_at, expired: object.expire_at, inManagedObjectContext: context) {
            promocode.code = object.code
            promocode.activatedAt = object.activated_at
            promocode.expiredAt = object.expire_at
            promocode.status = object.status
        }
    }
    
    func removeAllPromocodes(){
        let request: NSFetchRequest<Promocode> = Promocode.fetchRequest()
        if let promocodes = (try? context.fetch(request)) {
            promocodes.forEach {
                context.delete($0)
            }
            self.saveData()
        }
    }
    
    func fetchPromocodes() -> [Promocodes]? {
        if let promocode = Promocode.fetchPromocodes(inManagedObjectContext: context) {
            let promocodes = promocode.map{ Promocodes(code: $0.code, activated_at: $0.activatedAt, expire_at: $0.expiredAt, status: $0.status)}
            return promocodes
        } else {
            return nil
        }
    }
    
    func fetchPromocodes(limit: Int = 20, offSet: Int = 0, sort: [NSSortDescriptor] = [NSSortDescriptor(key: "id", ascending: true)]) -> [Promocodes]? {
        if let promocode = Promocode.fetchPromocodes(inManagedObjectContext: context, fetchLimit: limit, fetchOffSet: offSet, sortDescriptor: sort) {
            let promocodes = promocode.map{ Promocodes(code: $0.code, activated_at: $0.activatedAt, expire_at: $0.expiredAt, status: $0.status)}
            return promocodes
        } else {
            return nil
        }
        
    }
}

//MARK: Extensions to add/update/remove/fetch Payment in CoreData
extension CoreDataStorageContext {

    func addAllPayments(objects: [Payments]) {
        removeAllPayments()
        for i in 0 ..< objects.count {
            addPayment(object: objects[i])
        }
        self.saveData()
    }
    
    func addPayment(object: Payments) {
        let payment = Payment(context: self.context)
        payment.id = Int64(object.id)
        payment.status = object.payment.status
        payment.purseType = object.payment.purse_type
        payment.amount = object.payment.amount
        payment.currency = object.payment.currency
        payment.created_at = object.payment.created_at
        payment.isCharity = object.payment.isCharity
        payment.brand = object.payment.purse.brand
        payment.number = object.payment.purse.number
        payment.account = object.payment.purse.account
    }
    
    func updatePayment(object: Payments) {
        if let payment = Payment.findPayments(byId: Int64(object.id), inManagedObjectContext: context) {
            payment.status = object.payment.status
            payment.purseType = object.payment.purse_type
            payment.amount = object.payment.amount
            payment.currency = object.payment.currency
            payment.created_at = object.payment.created_at
            payment.isCharity = object.payment.isCharity
            payment.brand = object.payment.purse.brand
            payment.number = object.payment.purse.number
            payment.account = object.payment.purse.account
        }
    }
    
    func removeAllPayments() {
        let request: NSFetchRequest<Payment> = Payment.fetchRequest()
        if let payments = (try? context.fetch(request)) {
            payments.forEach {
                context.delete($0)
            }
            self.saveData()
        }
    }
    
    func fetchPayments() -> [Payments]? {
        if let payments = Payment.fetchPayments(inManagedObjectContext: context) {
            let paymentsResult = payments.map { Payments(id: Int($0.id), payment: PaymentAttributes(status: $0.status, purse_type: $0.purseType, purse: Purse(brand: $0.brand, number: $0.number, account: $0.account), amount: $0.amount, currency: $0.currency, created_at: $0.created_at, isCharity: $0.isCharity)) }
            return paymentsResult
        } else {
            return nil
        }
    }

}

//MARK: Extensions to add/update/remove/fetch Doodle in CoreData
extension CoreDataStorageContext {
    
    func addAllDoodles(objects: [DoodlesItem]) {
        removeAllDoodles()
        for i in 0..<objects.count {
            addDoodle(object: objects[i])
        }
    }
    
    func addDoodle(object: DoodlesItem) {
        let doodle = Doodle(context: self.context)
        doodle.id = Int64(object.id ?? 0)
        doodle.name = object.name
        doodle.dateTo = object.dateTo
        doodle.dateFrom = object.dateFrom
        doodle.offerLogo = object.offerLogo
        doodle.backgroundImage = object.backgroundImage
        doodle.backgroundColor = object.backgroundColor
        doodle.image = object.image
        doodle.priority = Int32(object.priority)
        doodle.status = object.status
        doodle.title = object.title
        doodle.subTitle = object.subTitle
        doodle.textButton = object.textButton
        doodle.link = object.link
        doodle.offerID = Int64(object.offerID ?? 0)
        doodle.offerTypeID = Int64(object.offerTypeID ?? 0)
        doodle.goToStore = object.goToStore
    }
    
    func removeAllDoodles() {
        let request: NSFetchRequest<Doodle> = Doodle.fetchRequest()
        if let doodles = (try? context.fetch(request)) {
            for i in 0..<doodles.count {
                context.delete(doodles[i])
            }
        }
        self.saveData()
    }
    
    func fetchDoodles() -> [DoodlesItem] {
        if let doodles = Doodle.fetchDoodles(inManagedObjectContext: context) {
            let doodleItems = doodles.map {
                DoodlesItem(id: Int($0.id), name: $0.name, dateTo: $0.dateTo as Date?, dateFrom: $0.dateFrom as Date?, offerLogo: $0.offerLogo, backgroundImage: $0.backgroundImage, backgroundColor: $0.backgroundColor, image: $0.image, priority: Int($0.priority), status: $0.status, title: $0.title, subTitle: $0.subTitle, textButton: $0.textButton, link: $0.link, offerID: Int($0.offerID), offerTypeID: Int($0.offerTypeID), goToStore: $0.goToStore)
            }
            return doodleItems
        }
        return [DoodlesItem]()
    }
}

//MARK: Extensions to add/update/remove/fetch PushNotification in CoreData
extension CoreDataStorageContext {
    
    func addPushNotification(object: LocalNotification) {
        let notification = PushNotification(context: self.context)
        notification.id = object.id
        notification.title = object.title
        notification.body = object.body
        notification.date = object.date
        notification.isRead = object.isRead
    }
    
    func removeAllPushNotifications(){
        let request: NSFetchRequest<PushNotification> = PushNotification.fetchRequest()
        if let pushNotifications = (try? context.fetch(request)) {
            pushNotifications.forEach {
                context.delete($0)
            }
            self.saveData()
        }
    }
    
    func fetchPushNotifications(sort: [NSSortDescriptor] = [NSSortDescriptor(key: "date", ascending: false)]) -> [LocalNotification]? {
        if let pushNotifications = PushNotification.fetchPushNotifications(inManagedObjectContext: context, sortDescriptor: sort) {
            let notifications = pushNotifications.map{ LocalNotification(id: $0.id, title: $0.title, body: $0.body, date: $0.date, isRead: $0.isRead) }
            return notifications
        } else {
            return nil
        }
    }
    
    func fetchPushNotifications(limit: Int = 20, offSet: Int = 0, sort: [NSSortDescriptor] = [NSSortDescriptor(key: "date", ascending: false)]) -> [LocalNotification]? {
        if let pushNotifications = PushNotification.fetchPushNotifications(inManagedObjectContext: context, fetchLimit: limit, fetchOffSet: offSet, sortDescriptor: sort) {
            let notifications = pushNotifications.map{ LocalNotification(id: $0.id, title: $0.title, body: $0.body, date: $0.date, isRead: $0.isRead)}
            return notifications
        } else {
            return nil
        }
        
    }

    func fetchPushNotificationsFromSearch(searchText text: String) -> [LocalNotification]? {
        if let notification = PushNotification.searchPushNotification(byTitle: text, inManagedObjectContext: context) {
            let notifications = notification.map{ LocalNotification(id: $0.id, title: $0.title, body: $0.body, date: $0.date, isRead: $0.isRead) }
            return notifications
        } else {
            return nil
        }
    }
    
    func markReadMessage(withId: Int) {
        if let notification = PushNotification.findMessage(byId: withId, inManagedObjectContext: context) {
            notification.isRead = true
        }
        self.saveData()
    }
    
    func hasUnreadMessage() -> Bool {
        return PushNotification.hasUnreadMessage(inManagedObjectContext: context)
    }
    
    func getPushNotificationAutoincrementedId() -> Int64 {
         return PushNotification.getTheMostIdentifier(inManagedObjectContext: context) + 1
    }
}

//MARK: Extensions to add/update/remove/fetch FAQ in CoreData
extension CoreDataStorageContext {
    func addFaqCategory(object: FaqCategoryes){
        let category = FaqCategory(context: self.context)
        category.id = object.id
        category.priority = Int64(object.priority)
        category.title = object.title
        for index in 0..<object.list.count {
            category.addToAnswerQuestions(addFaqAnswerQuestion(object: object.list[index]))
        }
    }
    
    func addAllFaqCategoryes(objects: [FaqCategoryes]) {
        self.removeAllFaqCategoryes()
        for index in 0..<objects.count {
            addFaqCategory(object: objects[index])
        }
        self.saveData()
    }
    
    func updateFaqCategory(object: FaqCategoryes) {
        if let faqCategory = FaqCategory.find(byId: object.id, inManagedObjectContext: context) {
            faqCategory.id = object.id
            faqCategory.priority = Int64(object.priority)
            faqCategory.title = object.title
            
            if let answerQuestion = faqCategory.answerQuestions {
                faqCategory.removeFromAnswerQuestions(answerQuestion)
            }
            for index in 0..<object.list.count {
                faqCategory.addToAnswerQuestions(addFaqAnswerQuestion(object: object.list[index]))
            }
        }
    }
    
    func addFaqAnswerQuestion(object: QuestionAnswer) -> FaqAnswerQuestion{
        let faqQuestionAnswer = FaqAnswerQuestion(context: self.context)
        faqQuestionAnswer.questionAnswerId = Int64(object.id)
        faqQuestionAnswer.question = object.question
        faqQuestionAnswer.answer = object.answer
        faqQuestionAnswer.lang = object.lang
        return faqQuestionAnswer
    }
    
    func addAllFaqAnswerQuestions(objects: [QuestionAnswer]) {
        self.removeAllFaqAnswerQuestions()
        for index in 0..<objects.count {
            let _ = addFaqAnswerQuestion(object: objects[index])
        }
        self.saveData()
    }
    
    func updateFaqAnswerQuestion(object: QuestionAnswer) {
        if let faqAnswerQuestion = FaqAnswerQuestion.find(byId: object.id, lang: object.lang, inManagedObjectContext: context) {
            faqAnswerQuestion.questionAnswerId = Int64(object.id)
            faqAnswerQuestion.lang = object.lang
            faqAnswerQuestion.answer = object.answer
            faqAnswerQuestion.question = object.question
        }
    }
    
    func removeAllFaqCategoryes(){
        let request: NSFetchRequest<FaqCategory> = FaqCategory.fetchRequest()
        if let faqCategory = (try? context.fetch(request)) {
            faqCategory.forEach {
                context.delete($0)
            }
            self.saveData()
        }
    }
    
    func removeAllFaqAnswerQuestions(){
        let request: NSFetchRequest<FaqAnswerQuestion> = FaqAnswerQuestion.fetchRequest()
        if let faqAnswerQuestion = (try? context.fetch(request)) {
            faqAnswerQuestion.forEach {
                context.delete($0)
            }
            self.saveData()
        }
    }
    
    func fetchFaqCategoryes(lang: String) -> [FaqCategoryes]? {
        if let faqCategoryes = FaqCategory.fetchFaqCategoryes(inManagedObjectContext: context) {
            let categoryes = faqCategoryes.map{
                FaqCategoryes(id: $0.id, title: $0.title, priority: Int($0.priority), faq: $0.answerQuestions?.allObjects.map{
                    QuestionAnswer(id: Int(($0 as! FaqAnswerQuestion).questionAnswerId), question: ($0 as! FaqAnswerQuestion).question, answer: ($0 as! FaqAnswerQuestion).answer, lang: ($0 as! FaqAnswerQuestion).lang)
                    }.filter{return $0.lang == lang} ?? [])
                }.filter { $0.list.count>0 }
            return categoryes
        } else {
            return nil
        }
    }
    
    func fetchFaqCategoryes(lang: String, searchText: String) -> [FaqCategoryes]? {
        if let faqCategoryes = FaqCategory.fetchFaqCategoryes(inManagedObjectContext: context) {
            let categoryes = faqCategoryes.map{
                FaqCategoryes(id: $0.id, title: $0.title, priority: Int($0.priority), faq: $0.answerQuestions?.allObjects.map{
                    QuestionAnswer(id: Int(($0 as! FaqAnswerQuestion).questionAnswerId), question: ($0 as! FaqAnswerQuestion).question, answer: ($0 as! FaqAnswerQuestion).answer, lang: ($0 as! FaqAnswerQuestion).lang)
                    }.filter{return $0.lang == lang && ($0.question.lowercased().contains(searchText.lowercased()) || $0.answer.lowercased().contains(searchText.lowercased()) ) } ?? [])
                }.filter{ return $0.list.count>0 }
            return categoryes
        } else {
            return nil
        }
    }
    
    func fetchFaqCategory(byId id:Int64) -> FaqCategoryes?{
        if let faqCategory = FaqCategory.find(byId: id, inManagedObjectContext: context){
            let category = FaqCategoryes(id: faqCategory.id, title: faqCategory.title, priority: Int(faqCategory.priority), faq: faqCategory.answerQuestions?.allObjects.map{
                QuestionAnswer(id: Int(($0 as! FaqAnswerQuestion).questionAnswerId), question: ($0 as! FaqAnswerQuestion).question, answer: ($0 as! FaqAnswerQuestion).answer, lang: ($0 as! FaqAnswerQuestion).lang)
                } ?? [])
            return category
        } else{
            return nil
        }
    }
    
    func fetchFaqAnswerQuestions() -> [QuestionAnswer]? {
        if let faqAnswerQuestions = FaqAnswerQuestion.fetchFaqAnswerQuestion(inManagedObjectContext: context){
            let questionAnswers = faqAnswerQuestions.map{
                QuestionAnswer(id: Int($0.id), question: $0.question, answer: $0.answer, lang: $0.lang)
            }
            return questionAnswers
        } else{
            return nil
        }
    }
    
    func fetchFaqAnswerQuestion(byId id:Int, lang: String) -> QuestionAnswer? {
        if let faqAnswerQuestion = FaqAnswerQuestion.find(byId: id, lang: lang, inManagedObjectContext: context){
            let questionAnswer = QuestionAnswer(id: Int(faqAnswerQuestion.questionAnswerId), question: faqAnswerQuestion.question, answer: faqAnswerQuestion.answer, lang: faqAnswerQuestion.lang)
            return questionAnswer
        } else{
            return nil
        }
    }
}

//MARK: Extensions to add/update/remove/fetch OfflineOffer in CoreData
extension CoreDataStorageContext {
    
    func addListOfflineShops(objects: [OfferOffline], type: Int) {
        for index in 0..<objects.count {
            addOfflineOffers(object: objects[index], type: type)
        }
        self.saveData()
    }
    
    func removeAllOfflineOffers() {
        if let offline = OfflineOffer.fetchOfflineOffers(inManagedObjectContext: context) {
            for i in 0..<offline.count {
                context.delete(offline[i])
            }
        }
        self.saveData()
    }

    func addOfflineOffers(object: OfferOffline, type: Int) {
        let offline = OfflineOffer(context: self.context)
        offline.id = Int64(object.id)
        offline.priority = Int64(object.priority)
        offline.image = object.image
        offline.tag = object.tag
        offline.url = object.url
        offline.title = object.title
        offline.typeId = Int64(object.typeId)
        offline.descript = object.description
        offline.type = Int64(type)
    }
    
    func fetchOffersFromSearch(byTypeId typeId: Int?, searchText text: String) -> [OfferOffline]? {
        if let offline = OfflineOffer.searchOfflineOffer(byTypeId: typeId, byTitle: text, inManagedObjectContext: context) {
            let offlineOffers = offline.map{
                OfferOffline(id: Int($0.id), title: $0.title, description: $0.descript, priority: Int($0.priority), image: $0.image, tag: $0.tag, url: $0.url, typeId: Int($0.typeId), type: Int($0.type))
            }
            return offlineOffers
        } else {
            return nil
        }
    }
    
    func fetchOffers(byTypeId typeId: Int) -> [OfferOffline]? {
        if let offline = OfflineOffer.fetchOfflineOffers(byType: typeId, inManagedObjectContext: context) {
            let offlineOffers = offline.map{
                OfferOffline(id: Int($0.id), title: $0.title, description: $0.descript, priority: Int($0.priority), image: $0.image, tag: $0.tag, url: $0.url, typeId: Int($0.typeId), type: Int($0.type))
            }
            return offlineOffers
        } else {
            return nil
        }
    }
    
    func fetchOfflineOffer(byId id: Int) -> OfferOffline? {
        if let offline = OfflineOffer.findOfflineOffer(byId: id, inManagedObjectContext: context) {
            let offlineOffers = OfferOffline(id: Int(offline.id), title: offline.title, description: offline.descript, priority: Int(offline.priority), image: offline.image, tag: offline.tag, url: offline.url, typeId: Int(offline.typeId), type: Int(offline.type))
            return offlineOffers
        } else {
            return nil
        }
    }
}

//MARK: Extensions to work with logo shop address in CoreData
extension CoreDataStorageContext {

    func fetchLogoUrlStringByOffer(id: Int) -> String? {
        if let urlString = Shop.findLogoUrlString(byId: id, inManagedObjectContext: context) {
            return urlString
        } else {
            return nil
        }
    }
    
    func insertOrUpdateShopImage(shopId: Int, imageUrl: String) {
        if let shopImage = ShopImage.findShopImage(byId: shopId, inManagedObjectContext: context) {
            shopImage.imageUrl = imageUrl
            return
        }
        let shopImage = ShopImage(context: self.context)
        shopImage.id = Int32(shopId)
        shopImage.imageUrl = imageUrl
    }
    
    func insertOrUpdateAllShopImages(objects: [OffersByOrders]) {
        for i in 0..<objects.count {
            if let imageUrl = objects[i].offer.logo_small {
                insertOrUpdateShopImage(shopId: objects[i].id, imageUrl: imageUrl)
            }
        }
        self.saveData()
    }
    
    func fetchShopImage(byId id: Int) -> String? {
        if let shopImage = ShopImage.findShopImage(byId: id, inManagedObjectContext: context) {
            return shopImage.imageUrl
        } else {
            return nil
        }
    }
}

//MARK: Support file methods
extension CoreDataStorageContext {
    
    func addMessage(message: SupportMessage) {
        let storageMessage = Message(context: self.context)
        storageMessage.id = getMessageAutoincrementedId()
        message.id = Int(storageMessage.id)
        storageMessage.subject = message.subject
        storageMessage.message = message.message
        storageMessage.replyToId = Int64(message.replyToId)
        storageMessage.createdAt = message.createdAt
        for index in 0 ..< (message.files?.count ?? 0) {
            let messageFile = message.files![index]
            let storageMessageFile = MessageFile(context: self.context)
            storageMessageFile.id = getMessageFileAutoincrementedId()
            message.files![index].id = Int(storageMessageFile.id)
            storageMessageFile.file = messageFile.file
            storageMessageFile.fileName = messageFile.fileName
            storageMessageFile.fileExtension = messageFile.fileExtension
            storageMessageFile.messageId = Int64(messageFile.messageId)
            storageMessageFile.link = messageFile.link
            storageMessageFile.size = messageFile.size
            storageMessage.addToFiles(storageMessageFile)
        }
        self.saveData()
    }
    
    func getMessages(forDialogId dialogId: Int) -> [SupportMessage]? {
        if let messages = Message.find(byTicketId: Int64(dialogId), inManagedObjectContext: self.context) {
            let supportMessages = messages.map {
                SupportMessage(id: Int($0.id), subject: $0.subject, message: $0.message ?? "", replyToId: Int($0.replyToId), createdAt: $0.createdAt, files: $0.files?.allObjects.map {
                    SupportMessageFile(id: Int(($0 as! MessageFile).id), file: ($0 as! MessageFile).file ?? Data(), fileName: ($0 as! MessageFile).fileName ?? "file", fileExtension: ($0 as! MessageFile).fileExtension ?? "png", messageId: Int(($0 as! MessageFile).messageId), link: ($0 as! MessageFile).link, size: ($0 as! MessageFile).size)
                    } )
            }
            return supportMessages
        }
        return nil
    }
    
    func removeMessage(messageId: Int) {
        if let message = Message.find(byId: Int64(messageId), inManagedObjectContext: self.context) {
            context.delete(message)
            self.saveData()
        }
    }
    
    func updateMessageFileLink(messageFile: SupportMessageFile) {
        if let storageMessageFile = MessageFile.find(byId: Int64(messageFile.id), inManagedObjectContext: self.context) {
            storageMessageFile.link = messageFile.link
            return
        }
        self.saveData()
    }
    
    func getMessageAutoincrementedId() -> Int64 {
         return Message.getTheMostIdentifier(inManagedObjectContext: context) + 1
    }
    
    func getMessageFileAutoincrementedId() -> Int64 {
         return MessageFile.getTheMostIdentifier(inManagedObjectContext: context) + 1
    }
}
