//
//  NewPurseWebViewProtocol.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 18/09/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

protocol NewPurseWebViewProtocol {
    var title: String { get }
    func getLink(completion: ((String?)->())?)
    func cardWasAdded(id: String, type: String, value: String)
    func pop()
}
