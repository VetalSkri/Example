//
//  AccountMenuHeaderReusableViewMode.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 28/01/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import XCoordinator

class AccountMenuHeaderReusableViewModel: DownloaderImagesProtocol {
    
    
    private var balance: [BalanceDataResponse]?
    private let router: UnownedRouter<AccountRoute>
    
    
    func userName() -> String? {
        if let fullName = UserDefaults.standard.string(forKey: LocalSymbolsAndAbbreviations.KEY_FULLNAME), !fullName.isEmpty {
            return fullName
        } else {
            let email = UserDefaults.standard.string(forKey: LocalSymbolsAndAbbreviations.KEY_EMAIL)
            return email
        }
    }
    
    func defaultUserLogo() -> UIImage {
        return UIImage(named: "defaultUserPhoto")!
    }
    
    func urlStringOfLogo() -> String? {
        return UserDefaults.standard.string(forKey: LocalSymbolsAndAbbreviations.KEY_PROFILEIMAGE)
    }
    
    func numberOfAvailableBalance() -> Int? {
        return balance?.count
    }
    
    func errorInfoText() -> String {
        return NSLocalizedString("ErrorInfoBalance", comment: "")
    }
    func infoText() -> String {
        return NSLocalizedString("InfoNoBalance", comment: "")
    }
    
    func navigatorButtonText() -> String {
        return NSLocalizedString("Let's go shopping!", comment: "")
    }
    
    func buttonText() -> String {
        return NSLocalizedString("Order Payment", comment: "")
    }
    
    func buttonTryAgainText() -> String {
        return NSLocalizedString("Try again", comment: "")
    }
    
    func getTitleOfAvailableBalance(_ index: Int) -> String {
        guard let currentBalance = balance else { return "" }
        return String(describing: "\(String(format:"%.2f", currentBalance[index].attributes.availableAmount)) \(LocalSymbolsAndAbbreviations.getSymbolOfCurrency(value: currentBalance[index].id))")
    }
    
    func getAvailableBalance(_ index: Int) -> Double {
        guard let currentBalance = balance else { return 0 }
        return currentBalance[index].attributes.availableAmount
    }
    
    func availableBalanceTitle() ->String {
        return NSLocalizedString("Available", comment: "")
    }
    
    func holdBalanceTitle() ->String {
        return NSLocalizedString("In Hold", comment: "")
    }
    
    func getTitleOfHoldBalance(_ index: Int) -> String {
        guard let currentBalance = balance else { return "" }
        return String(describing: "\(String(format:"%.2f", currentBalance[index].attributes.holdAmount)) \(LocalSymbolsAndAbbreviations.getSymbolOfCurrency(value: currentBalance[index].id))")
    }
    
    func loadUserData(completion: (()->())?, failure: (()->())?) {
        
        ProfileApiClient.profile { (result) in
            switch result {
            case .success(let response):
                OperationQueue.main.addOperation {
                    Util.saveProfileData(profile: response.data.attributes)
                }
                break
            case .failure(let error):
                failure?()
                Alert.showErrorAlert(by: error)
                break
            }
        }
        
        BalanceApiClient.balance { [weak self] (result) in
            switch result {
            case .success(let response):
                OperationQueue.main.addOperation {
                    Util.saveBalance(allBalance: response.data)
                }
                self?.balance?.removeAll()
                self?.balance?.append(contentsOf: response.data.filter({$0.attributes.existBalance == 1}))
                completion?()
                break
            case .failure(let error):
                failure?()
                Alert.showErrorAlert(by: error)
                break
            }
        }
    }
    /*
    func loadUserBalance(completion: (()->())?, behaviourHandle: ((FailureBehaviourProtocol)->())?, failure: ((String)->())?) {
        let balanceOperation = BalanceOperation()
        balanceOperation.start()
        
        balanceOperation.success = { (balanceResponse) in
            Util.saveBalance(allBalance: balanceResponse)
            completion?()
        }
        
        balanceOperation.failure = { [weak weakSelf = self] (errorResponse, error) in
            if errorResponse != nil {
                ErrorValidator.chooseActionAfterResponse(errorResponse: errorResponse as! ErrorInfo, success: { () in
                    weakSelf?.loadUserBalance(completion: completion, behaviourHandle: behaviourHandle, failure: failure)
                }, failureBehaviour: { (behaviour) in
                    behaviourHandle?(behaviour)
                } , failure: { (errorMessage) in
                    failure?(errorMessage)
                })
            } else {
                failure?(error.localizedDescription)
            }
        }
    }
*/
    init(router: UnownedRouter<AccountRoute>) {
        self.router = router
        balance = Util.fetchAllBalance?.filter({$0.attributes.existBalance == 1})
    }
    
    func goOnOrderPayment() {
        router.trigger(.orderPayment)
    }
    
}
