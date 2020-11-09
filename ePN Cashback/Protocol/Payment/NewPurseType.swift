//
//  NewPurseType.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 30/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol NewPurseType {
    
    var purse: Observable<[PaymentInfoData]> { get }
    var errorConnectionLost: Observable<Void> { get }
    
    var title: String { get }
    var choseWalletTypeText: String { get }
    func loadData(success:(()->())?, failure:(()->())?)
    func numberOfPurses() -> Int
    func purse(ofIndexPath indexPath: IndexPath) -> PaymentInfoData
    func addCharityPurse(complete: (()->())?)
    func selectPurseType(withIndexPath indexPath: IndexPath)
    func pop()
}
