//
//  CdnGetDownloadUrlResponse.swift
//  Backit
//
//  Created by Александр Кузьмин on 18/12/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

struct CdnGetDownloadUrlResponse: Decodable {
    
    var data: CdnGetDownloadUrlResponseData
    
}

struct CdnGetDownloadUrlResponseData: Decodable {
    
    var attributes: CdnGetDownloadUrlResponseAttributes
    
}

struct CdnGetDownloadUrlResponseAttributes: Decodable {
    
    var url : String
    
}
