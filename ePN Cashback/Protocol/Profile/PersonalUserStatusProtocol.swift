//
//  PersonalUserStatusProtocol.swift
//  Backit
//
//  Created by Ivan Nikitin on 20/03/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation

protocol PersonalUserStatusProtocol {
    func defaultMainTitle() -> String
    func imageStatusName() -> String
    func subTitle() -> String?
}
