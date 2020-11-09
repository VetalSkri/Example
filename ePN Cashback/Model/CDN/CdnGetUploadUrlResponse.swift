//
//  CdnImageUploadOperation.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 04/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

struct CdnGetUploadUrlResponse: Decodable {
    
    var data: CdnGetUploadUrlData
    
}

struct CdnGetUploadUrlData: Decodable {
    
    var attributes: CdnGetUploadUrlAttributes
    
}

struct CdnGetUploadUrlAttributes: Decodable {
    
    var token : String
    var uploadUrl: String
    
}
