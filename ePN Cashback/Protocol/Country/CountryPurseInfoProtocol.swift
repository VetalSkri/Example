//
//  CountryPurseInfoProtocol.swift
//  Backit
//
//  Created by Виталий Скриганюк on 26.06.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//
import UIKit

protocol CountryPurseInfoProtocol {
    var title: String { get set }
    var info: String { get set }
    var logo: AssetPurseLogo { get set }
}

