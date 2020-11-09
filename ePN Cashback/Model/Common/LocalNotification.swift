//
//  File.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 10/06/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

class LocalNotification {
    internal var id: Int64
    internal var title: String?
    internal var body: String?
    internal var date: Date
    internal var isRead: Bool
    init(id: Int64, title: String?, body: String?, date: Date, isRead: Bool) {
        self.id = id
        self.title = title
        self.body = body
        self.date = date
        self.isRead = isRead
    }
    
}
