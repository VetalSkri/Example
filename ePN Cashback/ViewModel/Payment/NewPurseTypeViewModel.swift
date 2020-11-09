//
//  NewPurseTypeViewModel.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 30/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator
import RxSwift
import RxCocoa

class NewPurseTypeViewModel: NewPurseType {
    
    private let router: UnownedRouter<PaymentsRoute>
    private var purses: [PaymentInfoData]?
    private var allPurses: [PaymentInfoData]?
    
    private let pursesSubject = PublishSubject<[PaymentInfoData]>()
    private let errorConnectionLostSubject = PublishSubject<Void>()
    
    var purse: Observable<[PaymentInfoData]> {
        return pursesSubject.asObserver().map{
            $0.filter({ (purse) -> Bool in
                return purse.attributes.isAllowedForMobile && purse.purseType != nil && purse.purseType != PurseType.cardpayUsd && purse.purseType != PurseType.cardUrk
            })
        }
    }
    
    var errorConnectionLost: Observable<Void> {
        return errorConnectionLostSubject.asObserver()
    }
    
    init(router: UnownedRouter<PaymentsRoute>) {
        self.router = router
    }
    
    var title: String {
        return NSLocalizedString("Addition of the wallet", comment: "")
    }
    
    var choseWalletTypeText: String {
        return NSLocalizedString("Choose a wallet type", comment: "")
    }
    
    func loadData(success:(()->())?, failure:(()->())?) {
        PaymentApiClient.getPaymentInfo { [weak self] (result) in
            switch result {
            case .success(var pursesResponse):
                if Util.languageOfContent() == "ru" {
                    pursesResponse.data.insert(PaymentInfoData(type: PurseType.khabensky.rawValue, id: PurseType.khabensky.rawValue, purseType: .khabensky), at: 0)
                }
                var data = pursesResponse.data
                data.enumerated().forEach{ index, elem in
                    if  Util.isCardsPursesHint  || Util.isUkrainV2PurseHint {
                        switch elem.purseType {
                        case .cardpay:
                            data[index].hintView = true
                            data[index].hintInfo = PurseHint(title: NSLocalizedString("One place", comment: ""), text: NSLocalizedString("Changed place", comment: ""))
                        case .cardUrkV2:
                            data[index].hintView = true
                            data[index].hintInfo = PurseHint(title: NSLocalizedString("UkrainV2HintTitle", comment: ""), text: NSLocalizedString("UkrainV2HintText", comment: ""))
                        default:
                            data[index].hintView = false
                        }
                    }
                }
                self?.pursesSubject.onNext(data)
                self?.allPurses = data
                self?.purses = data.filter({ (purse) -> Bool in
                    return purse.attributes.isAllowedForMobile && purse.purseType != nil && purse.purseType != PurseType.cardpayUsd  && purse.purseType != PurseType.cardUrk
                })
                success?()
                break
            case .failure(let error):
                failure?()
                if (error as NSError).code == -1001 {
                    self?.errorConnectionLostSubject.onNext(())
                } else {
                    Alert.showErrorToast(by: error)
                }
                break
            }
        }
    }
    
    func numberOfPurses() -> Int {
        return purses?.count ?? 0
    }
    
    func purse(ofIndexPath indexPath: IndexPath) -> PaymentInfoData {
        return purses![indexPath.row]
    }
    
    func addCharityPurse(complete: (()->())?) {
        PaymentApiClient.createCharityPurse(charityId: PaymentUtils.shared.charityId) { [weak self](result) in
            switch result {
            case .success(let response):
                complete?()
                NotificationCenter.default.post(name: Notification.Name("NewPurseDidAdded"), object: nil)
                self?.router.trigger(.popToRoot)
                break
            case .failure(let error):
                complete?()
                Alert.showErrorToast(by: error)
                break
            }
        }
    }
    
    func selectPurseType(withIndexPath indexPath: IndexPath) {
        let purse = purses![indexPath.row]
        switch purse.purseType! {
        case .cardUrkV2:
            router.trigger(.purseCountryInfo(selectCountry: nil, selectRegion: nil, partSelected: 1, purses: purse))
        case .cardpay:
            router.trigger(.newCardPay(purses: allPurses ?? []))
        case .wmz:
            router.trigger(.newPurseDataOfCard(partSelected: 1, isDataOfClien: false, currentPurse: purse, dataOfNewPurse: DataOfNewPurse()))
            break
        default:
            router.trigger(.newCommonPurse(purseId: purse.purseType!))
        }
        
    }
    
    func pop() {
        router.trigger(.back)
    }
    
}
