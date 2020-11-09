//
//  PaymentsViewModel.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 29/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator
import Repeat
import RxSwift
import RxCocoa

class PaymentsViewModel: PaymentsModelType {
    
    private let router: UnownedRouter<PaymentsRoute>
    private var ballance: BalanceResponse? = nil
    private var purses: [UserPurseData]?
    private var paymentInfo: [PaymentInfoData]?
    private var selectedBallanceIndex: Int? = nil
    private var selectedPurseIndex: Int? = nil
    private var rotatedPurseIds = [Int: Bool]()
    
    private var isCountingSubject: PublishSubject<Bool> = PublishSubject()
    
    var isCounting: Observable<Bool> {
        return isCountingSubject.asObserver()
    }
    
    init(router: UnownedRouter<PaymentsRoute>) {
        self.router = router
        updateProfileIfNeeded()
    }
    
    var title: String {
        return NSLocalizedString("Payout order", comment: "")
    }
    
    var offerLink: String {
        return "https://backit.me/cashback-assets/static/OFFER_TO_DONATION_AGREEMENT.pdf"
    }
    
    private func updateProfileIfNeeded() {
        if emailIsConfirmed() { return }
        ProfileApiClient.profile { (result) in
            switch result {
            case .success(let response):
                OperationQueue.main.addOperation {
                    Util.saveProfileData(profile: response.data.attributes)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    func loadBallance(success:(()->())?, failure:(()->())?) {
        PaymentApiClient.ballance { [weak self] (result) in
            switch result {
            case .success(let ballance):
                self?.ballance = ballance
                self?.ballance?.data = ballance.data.filter({ (ballanceData) -> Bool in
                    return ballanceData.attributes.availableAmount > 0
                })
                success?()
                break
            case .failure(let error):
                Alert.showErrorToast(by: error)
                failure?()
                break
            }
        }
    }
    
    func loadPurses(success: (()->())?, failure: (()->())?) {
        PaymentApiClient.getUserPurses { [weak self] (result) in
            switch result {
            case .success(let purses):
                PaymentApiClient.getPaymentInfo(completion: { [weak self] (result) in
                    switch result {
                    case .success(let info):
                        if let self = self {
                            self.paymentInfo = info.data
                            self.purses = purses.data
                            self.purses = self.purses?.filter({ (purse) -> Bool in
                                return purse.attributes.purseType != nil || purse.attributes.isCharity
                            })
                            self.purses?.forEach({ (purse) in
                                let rotatedPurse = PaymentUtils.shared.getRotatedPurseId(forPurseId: purse.id)
                                    self.rotatedPurseIds[purse.id] = rotatedPurse
                                    
                            })
                            if Util.languageOfContent() != "ru" {
                                self.purses = self.purses?.filter({ (purse) -> Bool in
                                    return !purse.attributes.isCharity
                                })
                            }
                        }
                        success?()
                        break
                    case .failure(let error):
                        Alert.showErrorToast(by: error)
                        failure?()
                        break
                    }
                })
                break;
            case .failure(let error):
                Alert.showErrorToast(by: error)
                failure?()
                break
            }
        }
    }
    
    func deletePurse(purseId: Int, success: (()->())?, failure: (()->())?) {
        PaymentApiClient.removeUserPurse(purseId: String(purseId)) { (result) in
            switch result {
            case .success(_):
                self.purses?.removeAll(where: { (purseData) -> Bool in
                    return purseData.id == purseId
                })
                self.selectedPurseIndex = nil
                success?()
                break
            case .failure(let error):
                Alert.showErrorAlert(by: error)
                failure?()
                break
            }
        }
    }
    
    func countOfBallances() -> Int {
        return ballance?.data.count ?? 0
    }
    
    func ballance(forIndexPath indexPath: IndexPath) -> BalanceDataResponse {
        return ballance!.data[indexPath.row]
    }
    
    func chooseBallanceTitle() -> String {
        return NSLocalizedString("Chose a balance", comment: "")
    }
    
    func choosePurseTitle() -> String {
        return NSLocalizedString("Choose a wallet", comment: "")
    }
    
    func addAWalletTitle() -> String {
        return NSLocalizedString("Add a wallet", comment: "")
    }
    
    func addAWalletDescription() -> String {
        return NSLocalizedString("Add a wallet to withdraw your cashback", comment: "")
    }
    
    func selectBallance(index: Int) {
        selectedBallanceIndex = index
    }
    
    func selectedBallanceRow() -> Int? {
        return selectedBallanceIndex
    }
    
    func selectPurse(index: Int?) {
        guard let index = index else {
            self.selectedPurseIndex = nil
            return
        }
        if let purses = self.purses, purses.count > index, purses[index].attributes.isConfirm {
            self.selectedPurseIndex = index
        }
    }
    
    func selectedPurseRow() -> Int? {
        return selectedPurseIndex
    }
    
    func createNewPurse() {
        router.trigger(.newPurseType)
    }
    
    func countOfPurses() -> Int {
        return self.purses?.count ?? 0
    }
    
    func purse(forIndexPath indexPath: IndexPath) -> UserPurseObject {
        self.paymentInfo?.forEach{ payment in
            if payment.id == self.purses![indexPath.row].attributes.type {
                self.purses![indexPath.row].attributes.name = payment.attributes.name
            }
        }
        return self.purses![indexPath.row].attributes
    }
    
    func purse(forId id: Int) -> UserPurseObject? {
        return self.purses!.first { $0.id == id }?.attributes
    }
    
    func purseId(forIndexPath indexPath: IndexPath) -> Int {
        return self.purses![indexPath.row].id
    }
    
    func rotatePurseCard(purseId: Int) {
        let findedPurse = self.purses!.first {$0.id == purseId}
        guard let purse = findedPurse else {
            return
        }
    }
    
    func purseCardIsRotated(forIndexPath indexPath: IndexPath) -> Bool {
        let purse = self.purses![indexPath.row]
        
        return rotatedPurseIds[purse.id] ?? false
    }
    
    func updateRotatedState(forPurseId: Int, rotated: Bool) {
        rotatedPurseIds[forPurseId] = rotated
    }
    
    func confirmType(forPurseId: Int) -> NewPurseConfirmType? {
        return PaymentUtils.shared.getNewPurseConfirmData(forPurseId: String(forPurseId))?.type
    }
    
    func confirmValue(forPurseId: Int) -> String? {
        return PaymentUtils.shared.getNewPurseConfirmData(forPurseId: String(forPurseId))?.value
    }
    
    func resendCode(forPurseId: Int, completion:((String?, NewPurseConfirm?)->())?) {
        updateRotatedState(forPurseId: forPurseId, rotated: true)
        PaymentApiClient.sendCode(purseId: String(forPurseId)) { (result) in
            switch result {
            case .success(let response):
                let purseObject = NewPurseConfirm(type: response.data.attributes.method == "send email" ? NewPurseConfirmType.email : NewPurseConfirmType.phone, value: response.data.attributes.value)
                PaymentUtils.shared.saveNewPurse(purse: purseObject, purseId: forPurseId)
                PaymentUtils.shared.saveRotatedPurse(forPurseId: forPurseId, rotated: true)
                self.updateRotatedState(forPurseId: forPurseId, rotated: true)
                completion?(nil, purseObject)
                break
            case .failure(let error):
                completion?(Alert.getMessage(by: error), nil)
                break
            }
        }
    }
    
    func createNewTimer(forPurseId: Int) -> Repeater  {
        return PaymentUtils.shared.setTimer(forPurseId: forPurseId, seconds: 60)
    }
    
    func timer(purseId: Int) -> Repeater? {
        return PaymentUtils.shared.getTimer(forPurseId: purseId)
    }
    
    func sendConfirmCode(purseId: Int, code: String, success:(()->())?, failure:((String)->())?) {
        PaymentApiClient.confirmPurse(purseId: purseId, code: code) { (result) in
            switch result {
            case .success(let response):
                success?()
                break
            case .failure(let error):
                failure?(Alert.getMessage(by: error))
                break
            }
        }
    }
    
    func setConfirmPurse(with id: Int) {
        for i in 0..<(purses?.count ?? 0) {
            if purses![i].id == id {
                purses![i].attributes.isConfirm = true
            }
        }
    }
    
    ///Return TRUE, if limit is exceeded
    ///Return FALSE, if limit not exceeded
    ///Second paramether - min summa to payment
    ///Third paramether - currency
    ///Fourth paramether - enable withdraw button
    func checkPurseLimit() -> (Bool, Double, String, Bool) {
        let searchResult = searchCurrencyInfoForSelectedBallanceAndPurse()
        if let infoCurrencyAttribute = searchResult.0, let ballance = searchResult.1, let purse = searchResult.2 {
            if purse.attributes.isCharity {
                return (false, 0.0, LocalSymbolsAndAbbreviations.getSymbolOfCurrency(value: infoCurrencyAttribute.currency), true)
            }
            if ballance.attributes.availableAmount.rounded(toPlaces: 2) < Double(infoCurrencyAttribute.min).rounded(toPlaces: 2) {
                return (true, infoCurrencyAttribute.min, LocalSymbolsAndAbbreviations.getSymbolOfCurrency(value: infoCurrencyAttribute.currency), false)
            } else {
                return (false, 0, "", true)
            }
        }
        return (false, 0, "", false)
    }
    
    func checkPurseLimit(amount: Double) -> (Bool, Double, String, Bool) {
        let searchResult = searchCurrencyInfoForSelectedBallanceAndPurse()
        if let infoCurrencyAttribute = searchResult.0, let purse = searchResult.2 {
            if purse.attributes.isCharity {
                return (false, 0.0, LocalSymbolsAndAbbreviations.getSymbolOfCurrency(value: infoCurrencyAttribute.currency), true)
            }
            if amount.rounded(toPlaces: 2) < infoCurrencyAttribute.min.rounded(toPlaces: 2) {
                return (true, infoCurrencyAttribute.min, LocalSymbolsAndAbbreviations.getSymbolOfCurrency(value: infoCurrencyAttribute.currency), false)
            } else {
                return (false, 0, "", true)
            }
        }
        return (false, 0, "", false)
    }
    
    ///First paramether - comission percent
    ///Second paramether - fix comission
    ///Third paramether - currency
    func comission() -> (Float?, Float?, String?) {
        let searchResult = searchCurrencyInfoForSelectedBallanceAndPurse()
        if let infoCurrencyAttribute = searchResult.0 {
            return (infoCurrencyAttribute.commissionPercent, infoCurrencyAttribute.commissionPercent, LocalSymbolsAndAbbreviations.getSymbolOfCurrency(value: infoCurrencyAttribute.currency))
        }
        return (nil, nil, nil)
    }
    
    func getCurrencyForSelectedBallance() -> String {
        if let ballance = ballance, let selectedBallanceIndex = selectedBallanceIndex {
            return LocalSymbolsAndAbbreviations.getSymbolOfCurrency(value: ballance.data[selectedBallanceIndex].id)
        }
        return ""
    }
    
    ///First returned paramether - PaymentInfoAttributesInfo
    ///Second returned paramether - selected BalanceDataResponse
    ///Third returned paramether - selected UserPurseData
    private func searchCurrencyInfoForSelectedBallanceAndPurse() -> (PaymentInfoAttributesInfo?, BalanceDataResponse?, UserPurseData?) {
        if let selectedBallanceIndex = selectedBallanceIndex, let selectedPurseIndex = selectedPurseIndex, let paymentInfo = paymentInfo {
            //Check if ballance and purse exist in array
            if let ballance = ballance?.data[selectedBallanceIndex], let purse = purses?[selectedPurseIndex] {
                //Try to find payment info for selected purse TYPE
                if let info = paymentInfo.first(where: { (paymentInfoData) -> Bool in
                    return paymentInfoData.purseType == purse.attributes.purseType
                }) {
                    //Try to find payment info for selected ballance CURRENCY
                    return (info.attributes.info?.first(where: { (infoAttribute) -> Bool in
                        return infoAttribute.currency == ballance.id
                    }),ballance, purse)
                }
            }
        }
        return (nil, nil, nil)
    }
    
    func getAvailableAmount() -> Double? {
        if let ballance = self.ballance, let selectedBallanceIndex = self.selectedBallanceIndex, ballance.data.count > selectedBallanceIndex {
            return ballance.data[selectedBallanceIndex].attributes.availableAmount
        }
        return nil
    }
    
    func withdraw(amount: Double, success:(()->())?, failure:(()->())?) {
        Analytics.sendEventOrderWithdrawl()
        if let purseSelectedIndex = self.selectedPurseIndex, let purses = self.purses, purses.count > purseSelectedIndex, let ballanceSelectedId = self.selectedBallanceIndex, let ballance = self.ballance, ballance.data.count > ballanceSelectedId {
            let purse = purses[purseSelectedIndex]
            let selectedBallance = ballance.data[ballanceSelectedId]
            PaymentApiClient.paymentOrder(currency: selectedBallance.id, purseId: purse.id, amount: amount.rounded(toPlaces: 2)) { [weak self] (result) in
                switch result {
                case .success(let response):
                    success?()
                    if let info = response.data.first?.attributes {
                        NotificationCenter.default.post(name: Notification.Name("NeedToUpdateUserData"), object: nil)
                        Analytics.sendEventSuccessOrderWithdrawl()
                        self?.router.trigger(.showSuccessPaymentResult(info: info, isCharity: purse.attributes.isCharity))
                    }
                    break
                case .failure(let error):
                    Alert.showErrorAlert(by: error)
                    failure?()
                }
            }
        }
    }
    
    func pop() {
        router.trigger(.back)
    }
    
    func emailIsConfirmed() -> Bool {
        return Util.fetchProfile()?.isConfirmed ?? false
    }
}
