//
//  CdnUploadFileResponse.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 05/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

public struct CdnUploadFileResponse: Decodable {
    
    var data: [CdnUploadFileData]
    
}

public struct CdnUploadFileData: Decodable {
    
    var id: String
    var type: String
    var attributes: CdnUploadFileAttribute?
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case attributes
    }
    
    public init (from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.type = try container.decode(String.self, forKey: .type)
        if container.contains(.attributes) {
            self.attributes = try container.decode(CdnUploadFileAttribute.self, forKey: .attributes)
        } else {
            self.attributes = nil
        }
        
    }
    
}

public struct CdnUploadFileAttribute: Decodable {
    var url: String
}
