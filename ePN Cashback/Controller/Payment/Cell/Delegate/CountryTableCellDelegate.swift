//
//  CountryTableCell.swift
//  Backit
//
//  Created by Виталий Скриганюк on 26.06.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation

protocol CountryTableCellDelegate: AnyObject {
    func selected(geo:SearchGeoDataResponse)
}
