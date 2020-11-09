//
//  RecipientDataCell.swift
//  Backit
//
//  Created by Виталий Скриганюк on 30.06.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation

struct RecipientDataCell {
    var recipient: RecipientData
    var purseType: PurseType?
    var placeholder: String?
    var hint: String
    var isHintNeed: Bool
    var isButton: Bool
    var text: String? = nil
    var mask: String? = nil
}
