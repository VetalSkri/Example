//
//  OfflineCBViewCellModelType.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 28/02/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

protocol OfflineCBViewCellModelType: class, DownloaderImagesProtocol {
    
    var title: String { get }
    
    var description: String { get }
    
}
