//
//  PaymentsXCoordinator.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 29/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import UIKit
import XCoordinator

enum PaymentsRoute: Route {
    case main
    case newPurseType
    case newPurse(purseId: PurseType)
    case newCommonPurse(purseId: PurseType)
    case newWebViewPurse(purseId: PurseType)
    case showSuccessPaymentResult(info: PaymentOrderAttributes, isCharity: Bool)
    case back
    case popToRoot
    case closeModule
    case goToPaymentHistory
    case newCardPay(purses: [PaymentInfoData], isBackVM: ViewModelProtocol? = nil)
    case chooseCity(country: SearchGeoDataResponse, purses: [PaymentInfoData], currentPurseType: PaymentInfoData)
    case purseCountryInfo(selectCountry: SearchGeoDataResponse?,selectRegion: SearchGeoDataResponse?,partSelected: Double, purses: PaymentInfoData)
    case newPurseDataOfCard(partSelected: Double, isDataOfClien: Bool, currentPurse: PaymentInfoData,dataOfNewPurse: DataOfNewPurse)
}

class PaymentsXCoordinator: NavigationCoordinator<PaymentsRoute> {
    
    // MARK: - Init
    
    private var accountCoordinator: AccountXCoordinator!
    
    init(rootViewController: UINavigationController, parentCoordinator: AccountXCoordinator) {
        super.init(rootViewController: rootViewController, initialRoute: nil)
        self.accountCoordinator = parentCoordinator
        trigger(.main)
    }
    // MARK: - Overrides
    var main: Presentable?
    
    override func prepareTransition(for route: PaymentsRoute) -> NavigationTransition {
        switch route {
        case .main:
            let paymentsVC: PaymentsVC = PaymentsVC.controllerFromStoryboard(.payments)
            paymentsVC.hidesBottomBarWhenPushed = true
            paymentsVC.viewModel = PaymentsViewModel(router: unownedRouter)
            main = paymentsVC
            return .push(paymentsVC)
        case .newPurseType:
            let newPurseTypeVC: NewPurseTypeVC = NewPurseTypeVC.controllerFromStoryboard(.payments)
            newPurseTypeVC.viewModel = NewPurseTypeViewModel(router: unownedRouter)
            return .push(newPurseTypeVC)
        case .newPurse(let purseType):
            let newPurseVC = NewPurseVC.controllerFromStoryboard(.payments)
            newPurseVC.viewModel = NewPurseViewModel(router: unownedRouter, purseType: purseType)
            return .push(newPurseVC)
        case .newCommonPurse(let purseType):
            let newPurseVC = NewCommonPurseVC.controllerFromStoryboard(.payments)
            newPurseVC.viewModel = NewCommonPurseViewModel(router: unownedRouter, purseType: purseType)
            return .push(newPurseVC)
        case .newWebViewPurse(let purseType):
            let newPurseVC = NewPurseWebViewVC.controllerFromStoryboard(.payments)
            newPurseVC.viewModel = NewPurseWebViewViewModel(router: unownedRouter, purseType: purseType)
            return .push(newPurseVC)
        case .showSuccessPaymentResult(let info, let isCharity):
            let successVC = SuccessOrderViewController.controllerFromStoryboard(.payments)
            successVC.modalPresentationStyle = .overCurrentContext
            successVC.viewModel = SuccessOrderViewModel(router: unownedRouter, orderInfo: info, isCharity: isCharity)
            return .present(successVC)
        case .back:
            return .pop()
        case .popToRoot:
            guard let main = main else { return .multiple(.popToRoot(), accountCoordinator.deepLink(.orderPayment)) }
            return .pop(to: main)
        case .closeModule:
            return .multiple([.popToRoot(), .dismiss()])
        case .goToPaymentHistory:
            let paymentHistoryVC: PaymentsHistoryVC = PaymentsHistoryVC.controllerFromStoryboard(.account)
            paymentHistoryVC.needRefresh = true
            paymentHistoryVC.hidesBottomBarWhenPushed = true
            paymentHistoryVC.viewModel = PaymentsHistoryViewModel(router: accountCoordinator.unownedRouter)
            return .multiple([.popToRoot(), .dismiss(), .push(paymentHistoryVC)])
        case .newCardPay(let purses,let isBackVM):
            let selectCountryVC = ChooseGeoVC()
            (rootViewController as! PaymentsNavigationController).isHideBottomView(status: true)
            selectCountryVC.viewModel = ChooseGeoViewModel(router: unownedRouter, selectViewType: SelectView(searchLable: NSLocalizedString("Select country:", comment: ""), placeholder: NSLocalizedString("Settings_Country", comment: ""), searchType: .country), purseTypes: purses, isBackVM: isBackVM)
            return .push(selectCountryVC)
        case .chooseCity(let country, let purses, let currentPurseType):
            let selectCountryVC = ChooseGeoVC()
            selectCountryVC.viewModel = ChooseGeoViewModel(router: unownedRouter, selectViewType: SelectView(searchLable: NSLocalizedString("Select city:", comment: ""), placeholder: NSLocalizedString("Settings_City", comment: ""), searchType: .city), selectedCountry: country, purseTypes: purses, currentPurseType: currentPurseType)
            return .push(selectCountryVC)
        case .purseCountryInfo(let selectCountry, let selectRegion, let partSelected, let purses):
            (rootViewController as! PaymentsNavigationController).isHideBottomView(status: false)
            let purseCountryInfoVC = PurseCountryInfoVC()
            purseCountryInfoVC.viewModel = PurseCountryInfoViewModel(router: unownedRouter, country: selectCountry, regionOrCity: selectRegion, partSelected: partSelected, currentPurseType: purses)
            return .push(purseCountryInfoVC)
        case .newPurseDataOfCard(let partSelected, let isDataOfClien,let currentPurse, let dataOfNewPurse):
            (rootViewController as! PaymentsNavigationController).isHideBottomView(status: false)
            let newPurseDataOfCardVC = NewPurseDataOfCardVC()
            newPurseDataOfCardVC.viewModel = NewPurseDataOfCardViewModel(router: unownedRouter, partSelected: partSelected, isDataOfClien: isDataOfClien, currentPurseType: currentPurse, dataOfNewPurse: dataOfNewPurse)
            return .push(newPurseDataOfCardVC)
        }
    }
}
