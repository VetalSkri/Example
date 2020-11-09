//
//  LruFileCache.swift
//  Backit
//
//  Created by Александр Кузьмин on 16/12/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import ISDiskCache

public class LruFileCache {
    //Initializer access level change now
    private init() {
        ISDiskCache.shared()?.limitOfSize = 50 * 1024 * 1024; // 50MB
    }
    static let shared = LruFileCache()
    
    func add(file: Data, forKey: String) {
        ISDiskCache.shared()?.setObject(file as NSCoding, forKey: forKey as NSCoding)
    }
    
    func exist(forKey: String) -> Bool {
        return ISDiskCache.shared()?.hasObject(forKey: forKey as NSCoding) ?? false
    }
    
    func file(forKey: String, dataResult: ((Data?)->())?) {
        DispatchQueue.global().async {
            let data = ISDiskCache.shared()?.object(forKey: forKey as NSCoding) as? Data ?? nil
            dataResult?(data)
        }
    }
    
    func filePath(forKey: String) -> String? {
        return ISDiskCache.shared()?.filePath(forKey: (forKey as NSCoding))
    }
    
}


public class FileData: NSCoding {
    var name: String
    var fileExtension: String
    var file: Data
    
    required public init?(coder aDecoder: NSCoder)
    {
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.fileExtension = aDecoder.decodeObject(forKey: "fileExtension") as! String
        self.file = aDecoder.decodeObject(forKey: "file") as! Data
    }
    
    public func encode(with aCoder: NSCoder)
    {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.fileExtension, forKey: "fileExtension")
        aCoder.encode(self.file, forKey: "file")
    }
}
