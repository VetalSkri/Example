//
//  HowToBuyModelType.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 01/08/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

protocol HowToBuyModelType {
    func numberOfFragments() -> Int
    func fragment(forRow: Int) -> FaqCollectionViewFragment
    
    func goOnBack()
}
