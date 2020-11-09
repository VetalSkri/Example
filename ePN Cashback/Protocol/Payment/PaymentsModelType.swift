//
//  PaymentsModelType.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 29/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Repeat

protocol PaymentsModelType: AnyObject {
    
    var isCounting: Observable<Bool> { get }
    
    var title: String { get }
    var offerLink: String { get }
    func loadBallance(success:(()->())?, failure:(()->())?)
    func loadPurses(success: (()->())?, failure: (()->())?)
    func deletePurse(purseId: Int, success: (()->())?, failure: (()->())?)
    func countOfBallances() -> Int
    func ballance(forIndexPath indexPath: IndexPath) -> BalanceDataResponse
    func chooseBallanceTitle() -> String
    func choosePurseTitle() -> String
    func selectBallance(index: Int)
    func selectedBallanceRow() -> Int?
    func selectPurse(index: Int?)
    func selectedPurseRow() -> Int?
    func addAWalletTitle() -> String
    func addAWalletDescription() -> String
    func createNewPurse()
    func countOfPurses() -> Int
    func purse(forIndexPath indexPath: IndexPath) -> UserPurseObject
    func purse(forId id: Int) -> UserPurseObject?
    func purseId(forIndexPath indexPath: IndexPath) -> Int
    func rotatePurseCard(purseId: Int)
    func purseCardIsRotated(forIndexPath indexPath: IndexPath) -> Bool
    func confirmType(forPurseId: Int) -> NewPurseConfirmType?
    func confirmValue(forPurseId: Int) -> String?
    func updateRotatedState(forPurseId: Int, rotated: Bool)
    func resendCode(forPurseId: Int, completion:((String?, NewPurseConfirm?)->())?)
    func createNewTimer(forPurseId: Int) -> Repeater
    func timer(purseId: Int) -> Repeater?
    func sendConfirmCode(purseId: Int, code: String, success:(()->())?, failure:((String)->())?)
    func setConfirmPurse(with id: Int)
    func checkPurseLimit() -> (Bool, Double, String, Bool)
    func checkPurseLimit(amount: Double) -> (Bool, Double, String, Bool)
    func getCurrencyForSelectedBallance() -> String
    func comission() -> (Float?, Float?, String?)
    func getAvailableAmount() -> Double?
    func withdraw(amount: Double, success:(()->())?, failure:(()->())?)
    func emailIsConfirmed() -> Bool
    func pop()
}
