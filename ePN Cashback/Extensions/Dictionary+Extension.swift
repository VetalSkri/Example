//
//  Dictionary+Extension.swift
//  Backit
//
//  Created by Ivan Nikitin on 16/09/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

extension Dictionary {
    
    /**
     An extension that add the elements of one dictionary to another
     */
    public mutating func add(_ dictionary: [Key : Value]) {
        for (key, value) in dictionary {
            self[key] = value
        }
    }
}
