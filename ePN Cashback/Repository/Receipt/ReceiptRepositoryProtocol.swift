//
//  ReceiptRepositoryProtocol.swift
//  Backit
//
//  Created by Ivan Nikitin on 28/01/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation

protocol ReceiptRepositoryProtocol: RepositoryProtocol {
    func loadShopInfo(id: Int, completion: @escaping (Result<OfflineShopInfo,NSError>)->())
    func presentSpecialOfflineOffers(isForced: Bool, completion: (([OfferOffline])->())?, failure: ((NSError)->())?)
    func presentMultyOfflineOffers(isForced: Bool, completion: (([OfferOffline])->())?, failure: ((NSError)->())?)
    func fetchOfflineOffers(byType type: ShopTypeId) -> [OfferOffline]?
    func getResultOfCheck(idOffer: Int, qrString qr: String, completion: @escaping (String?)->())
    func fetchCategories() -> [Categories]?
    func presentCategories(isForced: Bool, completion: (([Categories])->())?, failure: ((NSError)->())?)
    func presentOfflineOffersCategory(ids: [Int]) -> [OfferOffline]?
    func searchOfflineOfferBy(text: String, completion: @escaping (([OfferOffline]?)->()))
    func getCountSpecialOfflineOffers() -> Int
}
