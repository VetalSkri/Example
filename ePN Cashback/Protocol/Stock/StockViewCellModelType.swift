//
//  StockViewCellModelType.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 09/03/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

protocol StockViewCellModelType: class, DownloaderImagesProtocol, RedirectLinkProtocol {
    var stock: Stocks { get }
    func urlStringOfImage() -> String?
    func urlToOpen() -> URL?
    var title: String { get }
    var costTitle: String { get }
    var cashbackTitle: String { get }
    func costOfStock() -> String
    func percent() -> String
    func cashback() -> String
    func currencyOfGood() -> String
    
    func openStore(completion: ((URL)->())?, failure: ((Int)->())?)
    func getLinkOnShop(completion: ((LinkGenerateDataResponse)->())?, failure: ((Int)->())?)
}

extension StockViewCellModelType {
    
    func openStore(completion: ((URL)->())?, failure: ((Int)->())?) {
        getLinkOnShop(completion: { [weak self] (result) in
            self?.checkCorrectLink(result) { (link) in
                completion?(link)
            }
            }) { (errorCode) in
            failure?(errorCode)
        }
    }
    
    func getLinkOnShop(completion: ((LinkGenerateDataResponse)->())?, failure: ((Int)->())?) {
        LinkGenerateApiClient.generate(offerId: self.stock.offer_id, link: self.stock.direct_url) { (result) in
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
}
