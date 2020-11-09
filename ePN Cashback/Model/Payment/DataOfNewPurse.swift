//
//  DataOfNewPurse.swift
//  Backit
//
//  Created by Виталий Скриганюк on 30.06.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
struct DataOfNewPurse {
    var account: String = ""
    
    // Для хранения данных с маской
    var accountForView: String = ""
    var cardValidDate: String = ""
    var exp_monthField: String = ""
    var exp_yearField: String = ""
    var first_nameField: String = ""
    var cardHolder_nameField: String = ""
    var last_nameField: String = ""
    var birthField: String = ""
    
    var exp_month : String = ""
    var exp_year: String = ""
    var first_name: String = ""
    var cardHolder_name: String = ""
    var last_Name: String = ""
    var birth: String = ""
    var address: String = ""
    var country: SearchGeoDataResponse? = nil
    var city: SearchGeoDataResponse? = nil
    
    mutating func chengeGeo(type: SearchType,geo: SearchGeoDataResponse) {
        switch type {
        case .country:
            self.country = geo
        case .city:
            self.city = geo
        }
    }
}
