//
//  LinkGenerateResponse.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 06/12/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import Foundation

struct LinkGenerateResponse: Decodable {
    
    var data: [LinkGenerateDataResponse]
    var result: Bool
    
    init(data: [LinkGenerateDataResponse], result: Bool) {
        self.data = data
        self.result = result
    }
    
}

public struct LinkGenerateDataResponse: Decodable {
    
    var type: String
    var id: Int
    var attributes: Link
    
}

struct Link: Decodable {
    var cashbackDefault: String
    var cashbackPackage: CashbackPackage?
}

struct CashbackPackage: Decodable {
    var link: String
    var schema: String?
    var name: String?
}
