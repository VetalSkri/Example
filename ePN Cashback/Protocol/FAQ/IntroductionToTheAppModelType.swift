//
//  IntroductionToTheAppModelType.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 01/08/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

protocol IntroductionToTheAppModelType {
    func type() -> IntroductionToTheAppType
    func numberOfFragments() -> Int
    func fragment(forRow: Int) -> FaqCollectionViewFragment
    func skipButtonTitle() -> String
    func lastButtonText() -> String
    
    func goOnBack()
    func goOnAuth()
    func goOnMain()
    
}
