//
//  OfflineCashbackApiClient.swift
//  Backit
//
//  Created by Александр Кузьмин on 28/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import Alamofire

class OfflineCashbackApiClient: BaseApiClient {

    static func multiOffers(url: URL, completion:@escaping (Result<MultyOfferResponse, Error>)->Void) {
        performRequest(router: OfflineCashbackApiRouter.multiOffers(url: url), completion: completion)
    }
    
    static func checkResult(url: URL, completion:@escaping (Result<CheckResultOfflineCBResponse, Error>)->Void) {
        performRequest(router: OfflineCashbackApiRouter.checkResult(url: url), completion: completion)
    }
    
    static func affiliateLink(id: Int, completion:@escaping (Result<LinkGenerateResponse, Error>)->Void) {
        performRequest(router: OfflineCashbackApiRouter.affiliateLink(id: id), completion: completion)
    }
    
    static func redirectUrl(url: URL, completion:@escaping (Result<RedirectLinkResponse, Error>)->Void) {
        performRequest(router: OfflineCashbackApiRouter.redirectUrl(url: url), completion: completion)
    }
    
    static func activePromotions(completion:@escaping (Result<OffersPromotionResponse, Error>)->Void) {
        performRequest(router: OfflineCashbackApiRouter.activePromotions, completion: completion)
    }
    
    static func personalPromotions(completion:@escaping (Result<IndividualOffersPromotionResponse, Error>)->Void) {
        performRequest(router: OfflineCashbackApiRouter.personalPromotions, completion: completion)
    }
    
}
