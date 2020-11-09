//
//  NewCommonPurseProtocol.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 06/08/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

protocol NewCommonPurseProtocol: PurseProtocol {
    var title: String { get }
    var addText: String { get }
    var enterTheDataText: String  { get }
    func setPurseValue(value: String?)
    func addButtonEnabled() -> Bool
    func addButtonClicked(failure: (()->())?)
    func pop()
}

