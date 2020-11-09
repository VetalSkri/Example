//
//  SelectViewType.swift
//  Backit
//
//  Created by Виталий Скриганюк on 26.06.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

struct SelectView {
    var searchLable: String
    var placeholder: String
    var searchType: SearchType
}
extension SelectView: SelectViewType {}
