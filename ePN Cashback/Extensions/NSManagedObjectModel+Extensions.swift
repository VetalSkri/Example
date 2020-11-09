//
//  NSManagedObjectModel+Extensions.swift
//  Backit
//
//  Created by Elina Batyrova on 10.08.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectModel {
    
    // MARK: - Resource
    
    static func managedObjectModel(forResource resource: String) -> NSManagedObjectModel {
        let mainBundle = Bundle.main
        let subdirectory = "EPN_Cashback.momd"
        
        var omoURL: URL?
        
        if #available(iOS 11, *) {
            omoURL = mainBundle.url(forResource: resource, withExtension: "omo", subdirectory: subdirectory) // optimized model file
        }
        
        let momURL = mainBundle.url(forResource: resource, withExtension: "mom", subdirectory: subdirectory)
        
        guard let url = omoURL ?? momURL else {
            fatalError("Unable to find model in bundle.")
        }
        
        guard let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Unable to load model in bundle.")
        }
        
        return model
    }
    
    // MARK: - Compatible
    
    static func compatibleModelForStoreMetadata(_ metadata: [String: Any]) -> NSManagedObjectModel? {
        let mainBundle = Bundle.main
        
        return NSManagedObjectModel.mergedModel(from: [mainBundle], forStoreMetadata: metadata)
    }
}
