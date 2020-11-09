//
//  ShopImage+CoreDataClass.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 05/06/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//
//

import Foundation
import CoreData


public class ShopImage: NSManagedObject {

    class func findShopImage(byId shopId: Int, inManagedObjectContext context: NSManagedObjectContext) -> ShopImage? {
        let request: NSFetchRequest<ShopImage> = ShopImage.fetchRequest()
        request.predicate = NSPredicate(format: "id == %i", shopId)
        if let shopImage = (try? context.fetch(request))?.first {
            return shopImage
        } else {
            return nil
        }
    }
    
}
