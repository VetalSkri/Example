//
//  Doodle+CoreDataClass.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 16/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//
//

import Foundation
import CoreData


public class Doodle: NSManagedObject {

    class func fetchDoodles(inManagedObjectContext context: NSManagedObjectContext) -> [Doodle]? {
        let request: NSFetchRequest<Doodle> = Doodle.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "priority", ascending: true), NSSortDescriptor(key: "dateFrom", ascending: false)]
        if let doodles = (try? context.fetch(request)) {
            return doodles
        } else {
            return nil
        }
    }
    
}
