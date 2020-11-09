//
//  BottomViewDataType.swift
//  Backit
//
//  Created by Виталий Скриганюк on 28.06.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation

protocol BottomViewDataType {
    var part: Double { get set }
    var partSelected: Double { get set }
    var dismiss: Bool { get set }
}
