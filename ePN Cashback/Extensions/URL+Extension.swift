//
//  URL+Extension.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 20/06/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
extension URL {
    
    func appending(_ queryItem: String, value: String?) -> URL {
        
        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }
        
        // Create array of existing query items
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        
        // Create query item
        let queryItem = URLQueryItem(name: queryItem, value: value)
        
        // Append the new query item in the existing query items array
        queryItems.append(queryItem)
        
        // Append updated query items array in the url component object
        urlComponents.queryItems = queryItems
        
        // Returns the url from new url components
        return urlComponents.url!
    }
    
    func params() -> [String:Any] {
      var dict = [String:Any]()

      if let components = URLComponents(url: self, resolvingAgainstBaseURL: false) {
        if let queryItems = components.queryItems {
          for item in queryItems {
            dict[item.name] = item.value!
          }
        }
        return dict
      } else {
        return [:]
      }
    }
}
