//
//  OfflineCBViewCellViewModel.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 26/02/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class OfflineCBViewCellViewModel: OfflineCBViewCellModelType {
 
    private var offer: OfferOffline
    
    var title: String {
        return offer.title
    }
    
    var description: String {
        return offer.description ?? ""
    }
    
    func urlStringOfLogo() -> String? {
        return self.offer.image
    }
    
    init(offer: OfferOffline) {
        self.offer = offer
    }
    
    var idOffer: Int {
        return self.offer.id
    }
}
