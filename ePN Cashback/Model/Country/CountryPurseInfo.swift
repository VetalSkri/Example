//
//  CountryPurseInfo.swift
//  Backit
//
//  Created by Виталий Скриганюк on 26.06.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//
import UIKit

struct CountryPurseInfo {
    var title: String
    var info: String
    var logo: AssetPurseLogo
}
extension CountryPurseInfo: CountryPurseInfoProtocol {}
