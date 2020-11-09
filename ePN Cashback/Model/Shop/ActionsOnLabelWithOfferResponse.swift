//
//  AddLabelToOfferResponse.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 12/10/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import Foundation

struct ActionsOnLabelWithOfferResponse: Decodable {
    
    var result: Bool
    
    init(result: Bool) {
        self.result = result
    }
    
}
