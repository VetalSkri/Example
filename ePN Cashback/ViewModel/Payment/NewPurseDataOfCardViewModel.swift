//
//  NewPurseDataOfCardViewModel.swift
//  Backit
//
//  Created by Виталий Скриганюк on 27.06.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//
import XCoordinator
import Foundation
import RxSwift
import RxCocoa

class NewPurseDataOfCardViewModel {
    
    private let router: UnownedRouter<PaymentsRoute>
    private let loadingSubject = PublishSubject<Bool>()
    private let recipentDataSubject = PublishSubject<[RecipientDataCell]>()
    private let titleLabelSubject = PublishSubject<String>()
    private let bottomViewInfoSubject = PublishSubject<BottomViewDataType>()
    private let isLogoNededSubject = PublishSubject<Bool>()
    private let bottomIsEnableSubject = BehaviorSubject<Bool>(value: false)
    private let isProgressOnSubject = PublishSubject<Bool>()
    private let singleLogoSubject = PublishSubject<PurseType>()
    private let showAlertSubject = PublishSubject<Error>()
    
    
    var loading: Observable<Bool> {
        return loadingSubject.asObserver()
    }
    var fieldsIsFull: Observable<Bool> {
        return bottomIsEnableSubject.asObserver()
    }
    var isProgressOn: Observable<Bool> {
        return isProgressOnSubject.asObserver()
    }
    var recipentData: Observable<[RecipientDataCell]> {
        return recipentDataSubject.asObserver()
    }
    var titleLabel: Observable<String> {
        return titleLabelSubject.asObserver()
    }
    var bottomViewInfo: Observable<BottomViewDataType> {
        return bottomViewInfoSubject.asObserver()
    }
    var isLogoNeded: Observable<Bool> {
        return isLogoNededSubject.asObserver()
    }
    var singleLogo: Observable<PurseType> {
        return singleLogoSubject.asObserver()
    }
    var showAlert: Observable<Error> {
        return showAlertSubject.asObserver()
    }
    
    private let partSelected : Double
    private let isDataOfClien: Bool
    private let currentPurseType: PaymentInfoData
    private var dataOfNewPurse: DataOfNewPurse
    
    init(router: UnownedRouter<PaymentsRoute>,partSelected: Double, isDataOfClien: Bool, currentPurseType: PaymentInfoData, dataOfNewPurse: DataOfNewPurse) {
        self.isDataOfClien = isDataOfClien
        self.partSelected = partSelected
        self.router = router
        self.currentPurseType = currentPurseType
        self.dataOfNewPurse = dataOfNewPurse
    }
    
    func loadData() {
        guard currentPurseType.purseType != nil else { fatalError("PurseType")}
        isLogoNededSubject.onNext(isDataOfClien)
        unableDisableButton()
        checkCountry()
    }
    
    func getCounty() {
        router.trigger(.newCardPay(purses: [], isBackVM: self))
    }

    func setGeo(type: SearchType, geo: SearchGeoDataResponse) {
        dataOfNewPurse.chengeGeo(type: type, geo: geo)
        loadForVirtualPurse()
        unableDisableButtonVirtualPurse(fromForward: false)
    }
    
    private func checkCountry() {
        switch currentPurseType.purseType {
        case .wmz:
            loadForVirtualPurse()
        case .cardUrk, .cardpayUsd, .cardpay, .cardUrkV2:
            loadForCardsPurse()
        default: break
        }
        guard let purseType = currentPurseType.purseType else { return }
        
        singleLogoSubject.onNext(purseType)
    }
    
    private func loadForVirtualPurse() {
        titleLabelSubject.onNext(isDataOfClien ? NSLocalizedString("Recipient data:", comment: "") : NSLocalizedString("Wallet number", comment: ""))
        bottomViewInfoSubject.onNext(BottomViewData(part: 2, partSelected: partSelected, dismiss: false))
        if isDataOfClien {
            
            recipentDataSubject.onNext([RecipientDataCell(recipient: RecipientData(type: .first_name), purseType: nil, placeholder: NSLocalizedString("Name", comment: ""), hint: NSLocalizedString("Names hint", comment: ""),isHintNeed: !checkFieldsForVirtualPurses(value: dataOfNewPurse.first_nameField, recipient: RecipientData(type: .first_name),needReload: false), isButton: false, text:  dataOfNewPurse.first_nameField),RecipientDataCell(recipient: RecipientData(type: .last_name), purseType: nil, placeholder: NSLocalizedString("Last name", comment: ""), hint: NSLocalizedString("Names hint", comment: ""),isHintNeed: !checkFieldsForVirtualPurses(value: dataOfNewPurse.last_nameField, recipient: RecipientData(type: .last_name),needReload: false), isButton: false, text: dataOfNewPurse.last_nameField),RecipientDataCell(recipient: RecipientData(type: .birth), purseType: nil, placeholder: NSLocalizedString("Settings_DateOfBirth", comment: ""), hint: NSLocalizedString("Birth hint", comment: ""),isHintNeed: !checkFieldsForVirtualPurses(value: dataOfNewPurse.birthField, recipient: RecipientData(type: .birth),needReload: false), isButton: false, text: dataOfNewPurse.birthField), RecipientDataCell(recipient: RecipientData(type: .country), purseType: nil, placeholder: NSLocalizedString("Country_Of_Residence", comment: ""), hint: "", isHintNeed: false, isButton: true, text: dataOfNewPurse.country?.attributes?.name ?? nil)])
        } else {
            recipentDataSubject.onNext([RecipientDataCell(recipient: RecipientData(type: .account), purseType: currentPurseType.purseType!, placeholder: "ZXXXXXXXXXXXX", hint: NSLocalizedString("Card hint", comment: ""), isHintNeed: !checkFieldsForVirtualPurses(value: dataOfNewPurse.accountForView, recipient: RecipientData(type: .account),needReload: false), isButton: false,text: dataOfNewPurse.accountForView)])
        }
    }
    
    private func loadForCardsPurse() {
        titleLabelSubject.onNext(isDataOfClien ? NSLocalizedString("Recipient data:", comment: "") : NSLocalizedString("Card Data:", comment: ""))
        
        guard let countryCode = dataOfNewPurse.country?.attributes?.countryCode else {
            
            bottomViewInfoSubject.onNext(BottomViewData(part: 2, partSelected: partSelected, dismiss: false))
            
            recipentDataSubject.onNext([RecipientDataCell(recipient: RecipientData(type: .account),purseType: currentPurseType.purseType!, placeholder: nil, hint: NSLocalizedString("Card hint", comment: ""),isHintNeed: !checkFieldsForCardsPurses(value: dataOfNewPurse.accountForView, recipient: RecipientData(type: .account),needReload: false), isButton: false, text: dataOfNewPurse.accountForView),RecipientDataCell(recipient: RecipientData(type: .exp_year),purseType: nil, placeholder: "MM-YY", hint: NSLocalizedString("The card date hint", comment: ""),isHintNeed: !checkFieldsForCardsPurses(value: dataOfNewPurse.exp_monthField, recipient: RecipientData(type: .exp_year),needReload: false), isButton: false, text: dataOfNewPurse.cardValidDate ,mask: "[00]{-}[00]"),RecipientDataCell(recipient: RecipientData(type: .cardHolder_name), purseType: nil, placeholder: "IVANOV IVAN", hint: NSLocalizedString("Names hint", comment: ""),isHintNeed: !checkFieldsForCardsPurses(value: dataOfNewPurse.cardHolder_nameField, recipient: RecipientData(type: .cardHolder_name),needReload: false), isButton: false, text:  dataOfNewPurse.cardHolder_nameField)])
            
            return
        }
        
        switch CountryType(rawValue: countryCode) {
        case .ru:
            bottomViewInfoSubject.onNext(BottomViewData(part: 2, partSelected: partSelected, dismiss: false))
            recipentDataSubject.onNext([RecipientDataCell(recipient: RecipientData(type: .account),purseType: currentPurseType.purseType!, placeholder: nil, hint: NSLocalizedString("Card hint", comment: ""),isHintNeed: !checkFieldsForCardsPurses(value: dataOfNewPurse.accountForView, recipient: RecipientData(type: .account),needReload: false), isButton: false, text: dataOfNewPurse.accountForView),RecipientDataCell(recipient: RecipientData(type: .exp_year),purseType: nil, placeholder: "MM-YY", hint: NSLocalizedString("The card date hint", comment: ""),isHintNeed: !checkFieldsForCardsPurses(value: dataOfNewPurse.exp_monthField, recipient: RecipientData(type: .exp_year),needReload: false), isButton: false, text: dataOfNewPurse.cardValidDate ,mask: "[00]{-}[00]"),RecipientDataCell(recipient: RecipientData(type: .cardHolder_name), purseType: nil, placeholder: "IVANOV IVAN", hint: NSLocalizedString("Names hint", comment: ""),isHintNeed: !checkFieldsForCardsPurses(value: dataOfNewPurse.cardHolder_nameField, recipient: RecipientData(type: .cardHolder_name),needReload: false), isButton: false, text:  dataOfNewPurse.cardHolder_nameField)])
        default:
            bottomViewInfoSubject.onNext(BottomViewData(part: 3, partSelected: partSelected, dismiss: false))
            if isDataOfClien {
                recipentDataSubject.onNext([RecipientDataCell(recipient: RecipientData(type: .first_name), purseType: nil, placeholder: NSLocalizedString("Name on the card", comment: ""), hint: NSLocalizedString("Names hint", comment: ""),isHintNeed: !checkFieldsForCardsPurses(value: dataOfNewPurse.first_nameField, recipient: RecipientData(type: .first_name),needReload: false), isButton: false, text: dataOfNewPurse.first_nameField),RecipientDataCell(recipient: RecipientData(type: .last_name), purseType: nil, placeholder: NSLocalizedString("Last name on the card", comment: ""), hint: NSLocalizedString("Names hint", comment: ""),isHintNeed: !checkFieldsForCardsPurses(value: dataOfNewPurse.last_nameField, recipient: RecipientData(type: .last_name),needReload: false), isButton: false, text:  dataOfNewPurse.last_nameField),RecipientDataCell(recipient: RecipientData(type: .birth),purseType: nil, placeholder: NSLocalizedString("Settings_DateOfBirth", comment: ""), hint: NSLocalizedString("Birth hint", comment: ""),isHintNeed: !checkFieldsForCardsPurses(value: dataOfNewPurse.birthField, recipient: RecipientData(type: .birth),needReload: false), isButton: false, text:  dataOfNewPurse.birthField),RecipientDataCell(recipient: RecipientData(type: .address),purseType: nil, placeholder: NSLocalizedString("Address of recipient", comment: ""), hint: "Is nod valid",isHintNeed: !checkFieldsForCardsPurses(value: dataOfNewPurse.address, recipient: RecipientData(type: .address),needReload: false), isButton: false, text: dataOfNewPurse.address)])
            } else {
                recipentDataSubject.onNext([RecipientDataCell(recipient: RecipientData(type: .account), purseType: currentPurseType.purseType!, placeholder: nil, hint: NSLocalizedString("Card hint", comment: ""),isHintNeed: !checkFieldsForCardsPurses(value: dataOfNewPurse.accountForView, recipient: RecipientData(type: .account),needReload: false), isButton: false,text:  dataOfNewPurse.accountForView),RecipientDataCell(recipient: RecipientData(type: .exp_year),purseType: nil, placeholder: "MM-YY", hint: NSLocalizedString("The card date hint", comment: ""),isHintNeed: !checkFieldsForCardsPurses(value: dataOfNewPurse.exp_monthField, recipient: RecipientData(type: .exp_year),needReload: false), isButton: false, text: dataOfNewPurse.cardValidDate ,mask: "[00]{-}[00]")])
            }
        }
    }
    
    func pop() {
        router.trigger(.back)
    }
    
    // MARK: Network request
    func createPurse(dict: Dictionary<String, Any>) {
        PaymentApiClient.createPurse(purseType: currentPurseType.purseType!.rawValue, purseValue: nil, purseDicdt: dict) { [weak self] (result) in
            self?.isProgressOnSubject.onNext(false)
            switch result {
            case .success(let response):
                PaymentUtils.shared.saveNewPurse(purse: response)
                PaymentUtils.shared.saveRotatedPurse(forPurseId: response.data.id, rotated: true)
                NotificationCenter.default.post(name: Notification.Name("NewPurseDidAdded"), object: nil)
                if let self = self, let purseType = self.currentPurseType.purseType {
                    self.bottomViewInfoSubject.onNext(BottomViewData(part: 0, partSelected: 0, dismiss: true))
                    Analytics.sendEventAddPurse(purseType: purseType)
                }
                self?.router.trigger(.popToRoot)
            case .failure(let error):
                self?.showAlertSubject.onNext(error)
                print(error.localizedDescription)
            }
        }
    }

    // Проверка карты на валидность "Алгоритм Луна"
    private func algorithmMoon(value: [Int]) -> Bool {
        var evenArray:[Int] = []
        var oddArray: [Int] = []
        value.enumerated().forEach{ index, elem in
            if (index + 1) % 2 == 0 {
                evenArray.append(elem)
            } else {
                oddArray.append(elem * 2)
            }
        }
        oddArray.forEach{ elem in
            if elem > 9 {
                evenArray.append((elem % 10) + (elem / 10))
            } else {
                evenArray.append(elem)
            }
        }
        if evenArray.reduce(0,+) % 10 == 0 {
            return true
        } else {
            return false
        }
    }
    
    func checkFieldsForCardsPurses(value: String, recipient: RecipientData, needReload: Bool = true) -> Bool {
        if value.isEmpty { return true }
        switch recipient.type {
        case .account:
            dataOfNewPurse.accountForView = value
            let accountNumber: [Int] = value.compactMap{
                if $0 != "-" {
                    return ("\($0)" as NSString).integerValue
                } else {
                    return nil
                }
            }
            if algorithmMoon(value: accountNumber) && accountNumber.count > 12 {
                dataOfNewPurse.account = value.filter{$0 != "-"}
                dataOfNewPurse.accountForView = value
                defer {
                    if needReload {
                        loadData()
                    }
                }
                return true
            } else {
                dataOfNewPurse.account = "check"
                return false
            }
        case .address:
            dataOfNewPurse.address = value
            defer {
                if needReload {
                    loadData()
                }
            }
            return true
        case .birth:
            dataOfNewPurse.birthField = value
            if checkBirth(value: value) {
                dataOfNewPurse.birth = value
                return true
            } else {
                dataOfNewPurse.birth = "check"
                return false
            }
        case .exp_year:
            if value.count == 5 {
                let month = (value.split(separator: "-")[0] as NSString).integerValue
                let year = (value.split(separator: "-")[1] as NSString).integerValue
                dataOfNewPurse.exp_monthField = value
                guard month <= 12
                    && month > 0
                    && (( month >= getDate(currentDate: .month)
                    && (year >= (getDate(currentDate: .year) % 100)))
                    || year > (getDate(currentDate: .year) % 100)) else {
                    dataOfNewPurse.exp_month = "check"
                    dataOfNewPurse.exp_year = "check"
                    return false
                }
                
                dataOfNewPurse.exp_month = String(value.split(separator: "-")[0])
                dataOfNewPurse.exp_year = String(value.split(separator: "-")[1])
                dataOfNewPurse.cardValidDate = value
                defer {
                    if needReload {
                        loadData()
                    }
                }
                return true
            } else {
                dataOfNewPurse.exp_month = "check"
                dataOfNewPurse.exp_year = "check"
                return false
            }
        case .first_name:
            dataOfNewPurse.first_nameField = value
            if checkNames(value: value) {
                dataOfNewPurse.first_name = value
                defer {
                    if needReload {
                        loadData()
                    }
                }
                return true
            } else {
                dataOfNewPurse.first_name = "check"
                return false
            }
        case .last_name:
            dataOfNewPurse.last_nameField = value
            if checkNames(value: value) {
                dataOfNewPurse.last_Name = value
                defer {
                    if needReload {
                        loadData()
                    }
                }
                return true
            } else {
                dataOfNewPurse.last_Name = "check"
                return false
            }
        case .exp_month: return false
        case .cardHolder_name:
            dataOfNewPurse.cardHolder_nameField = value
            if checkNames(value: value) {
                dataOfNewPurse.cardHolder_name = value
                defer {
                    if needReload {
                        loadData()
                    }
                }
                return true
            } else {
                dataOfNewPurse.cardHolder_name = "check"
                return false
            }
            return true
        case .country:
            return true
        }
    }
    
    private func checkNames(value: String) -> Bool {
        if value.isEmpty { return false }
        guard value.rangeOfCharacter(from: CharacterSet.decimalDigits) == nil else {
            return false
        }
        return true
    }
    
    private func checkBirth(value: String) -> Bool {
        if value.count != 10  { return false }
        
        let month = (value.split(separator: "-")[1] as NSString).integerValue
        let year = (value.split(separator: "-")[0] as NSString).integerValue
        
        guard month <= 12 && month < getDate(currentDate: .month) && year == getDate(currentDate: .year) || year < getDate(currentDate: .year) else { return false }
        return true
        
    }
    
    func checkFieldsForVirtualPurses(value: String, recipient: RecipientData, needReload: Bool) -> Bool {
        if value.isEmpty { return true }
        switch recipient.type {
        case .account:
            dataOfNewPurse.accountForView = value
            if value.count == 13 {
                dataOfNewPurse.account = value
                dataOfNewPurse.accountForView = value
                defer {
                    if needReload {
                        if needReload {
                            loadData()
                        }
                    }
                }
                return true
            } else {
                dataOfNewPurse.account = "check"
                return false
            }
        case .exp_month:
            return true
        case .exp_year:
            return true
        case .first_name:
            dataOfNewPurse.first_nameField = value
            if checkNames(value: value) {
                dataOfNewPurse.first_name = value
                defer {
                    if needReload {
                        loadData()
                    }
                }
                return true
            } else {
                dataOfNewPurse.first_name = "check"
                return false
            }
        case .last_name:
            dataOfNewPurse.last_nameField = value
            if checkNames(value: value) {
                dataOfNewPurse.last_Name = value
                defer {
                    if needReload {
                        loadData()
                    }
                }
                return true
            } else {
                dataOfNewPurse.last_Name = "check"
                return false
            }
        case .birth:
            dataOfNewPurse.birthField = value
            if checkBirth(value: value) {
                dataOfNewPurse.birth = value
                return true
            } else {
                dataOfNewPurse.birth = "check"
                return false
            }
        case .address:
            return true
        case .cardHolder_name:
            return false
        case .country:
            return true
        }
    }
    // MARK: Check Fields
    func checkFields(value: String, type: RecipientData) -> Bool {
        switch currentPurseType.purseType {
        case .wmz:
            return checkFieldsForVirtualPurses(value: value, recipient: type, needReload: true)
        case .cardpay, .cardUrk, .cardpayUsd, .cardUrkV2:
            return checkFieldsForCardsPurses(value: value, recipient: type)
        default:
            return false
        }
    }
    
    func setFields(value: String, recipient: RecipientData) {
        switch recipient.type {
        case .account:
            dataOfNewPurse.account = "check"
        case .address:
            dataOfNewPurse.address = "check"
        case .birth:
                dataOfNewPurse.birth = "check"
        case .exp_year:
            dataOfNewPurse.exp_month = "check"
            dataOfNewPurse.exp_year = "check"
        case .first_name:
            dataOfNewPurse.first_name = "check"
        case .last_name:
            dataOfNewPurse.last_Name = "check"
        case .exp_month:
            break
        case .cardHolder_name:                dataOfNewPurse.cardHolder_name = "check"
        case .country:
            break
        }
    }
    
    // Получение настоящего времени в ( Месяц, Год, День )
    private func getDate(currentDate: Calendar.Component) -> Int {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = format.string(from: date)
        let calendar = Calendar.current
        let dateValue = calendar.component(currentDate, from: date)
        return dateValue
    }
    
    // Активность кнопки
    func unableDisableButton() {
        switch currentPurseType.purseType {
        case .wmz: unableDisableButtonVirtualPurse(fromForward: false)
        case .cardpay, .cardUrk, .cardpayUsd, .cardUrkV2:
            unableDisableButtonCards(fromForward: false)
        default: break
        }
    }
    
    private func unableDisableButtonVirtualPurse(fromForward: Bool) -> Bool {
        switch currentPurseType.purseType! {
        case .wmz:
            if isDataOfClien {
                if fromForward {
                    bottomIsEnableSubject.onNext( dataOfNewPurse.birth != "check" && dataOfNewPurse.first_name != "check" && dataOfNewPurse.last_Name != "check" && dataOfNewPurse.country != nil)
                    return dataOfNewPurse.birth != "check" && dataOfNewPurse.first_name != "check" && dataOfNewPurse.last_Name != "check" && dataOfNewPurse.country != nil
                } else {
                    bottomIsEnableSubject.onNext( dataOfNewPurse.birth != "" && dataOfNewPurse.first_name != "" && dataOfNewPurse.last_Name != "" && dataOfNewPurse.country != nil)
                    return dataOfNewPurse.birth != "" && dataOfNewPurse.first_name != "" && dataOfNewPurse.last_Name != "" && dataOfNewPurse.country != nil
                }
            } else {
                if fromForward {
                    bottomIsEnableSubject.onNext(dataOfNewPurse.account != "check")
                    return dataOfNewPurse.account != "check"
                } else {
                    bottomIsEnableSubject.onNext(dataOfNewPurse.account != "")
                    return dataOfNewPurse.account != ""
                }
            }
        default:
            return false
        }
    }
    
    private func unableDisableButtonCards(fromForward: Bool) -> Bool {
        guard let countryCode = dataOfNewPurse.country?.attributes?.countryCode else {
            switch currentPurseType.purseType  {
            case .cardUrkV2:
                if fromForward {
                    bottomIsEnableSubject.onNext(dataOfNewPurse.account != "check" && dataOfNewPurse.exp_year != "check" && dataOfNewPurse.exp_month != "check" && dataOfNewPurse.cardHolder_name != "check")
                    return dataOfNewPurse.account != "check" && dataOfNewPurse.exp_year != "check" && dataOfNewPurse.exp_month != "check" && dataOfNewPurse.cardHolder_name != "check"
                } else {
                    bottomIsEnableSubject.onNext(dataOfNewPurse.account != "" && dataOfNewPurse.exp_year != "" && dataOfNewPurse.exp_month != "" && dataOfNewPurse.cardHolder_name != "")
                    return dataOfNewPurse.account != "" && dataOfNewPurse.exp_year != "" && dataOfNewPurse.exp_month != "" && dataOfNewPurse.cardHolder_name != ""
                }
            default:
                return false
            }
        }
        switch CountryType(rawValue: countryCode){
        case .ru:
            if fromForward {
                bottomIsEnableSubject.onNext(dataOfNewPurse.account != "check" && dataOfNewPurse.exp_year != "check" && dataOfNewPurse.exp_month != "check" && dataOfNewPurse.cardHolder_name != "check")
                return dataOfNewPurse.account != "check" && dataOfNewPurse.exp_year != "check" && dataOfNewPurse.exp_month != "check" && dataOfNewPurse.cardHolder_name != "check"
            } else {
                bottomIsEnableSubject.onNext(dataOfNewPurse.account != "" && dataOfNewPurse.exp_year != "" && dataOfNewPurse.exp_month != "" && dataOfNewPurse.cardHolder_name != "")
                return dataOfNewPurse.account != "" && dataOfNewPurse.exp_year != "" && dataOfNewPurse.exp_month != "" && dataOfNewPurse.cardHolder_name != ""
            }
        default:
            if isDataOfClien {
                if fromForward {
                    bottomIsEnableSubject.onNext(dataOfNewPurse.address != "check" && dataOfNewPurse.birth != "check" && dataOfNewPurse.first_name != "check" && dataOfNewPurse.last_Name != "check")
                    return dataOfNewPurse.address != "check" && dataOfNewPurse.birth != "check" && dataOfNewPurse.first_name != "check" && dataOfNewPurse.last_Name != "check"
                } else {
                    bottomIsEnableSubject.onNext(dataOfNewPurse.address != "" && dataOfNewPurse.birth != "" && dataOfNewPurse.first_name != "" && dataOfNewPurse.last_Name != "")
                    return dataOfNewPurse.address != "" && dataOfNewPurse.birth != "" && dataOfNewPurse.first_name != "" && dataOfNewPurse.last_Name != ""
                }
            } else {
                if fromForward {
                    bottomIsEnableSubject.onNext(dataOfNewPurse.account != "check" && dataOfNewPurse.exp_year != "check" && dataOfNewPurse.exp_month != "check")
                    return dataOfNewPurse.account != "check" && dataOfNewPurse.exp_year != "check" && dataOfNewPurse.exp_month != "check"
                } else {
                    bottomIsEnableSubject.onNext(dataOfNewPurse.account != "" && dataOfNewPurse.exp_year != "" && dataOfNewPurse.exp_month != "")
                    return dataOfNewPurse.account != "" && dataOfNewPurse.exp_year != "" && dataOfNewPurse.exp_month != ""
                }
            }
        }
    }
    
    // Routing
    func forward() {
        switch currentPurseType.purseType {
        case .wmz:
            if unableDisableButtonVirtualPurse(fromForward: true) {
                forwardVirtualPurses()
            }
        case .cardpay, .cardUrk, .cardpayUsd, .cardUrkV2:
            if unableDisableButtonCards(fromForward: true) {
                forwardCardsPurses()
            }
        default: break
        }
        
    }
    
    private func forwardVirtualPurses() {
        switch currentPurseType.purseType {
        case .wmz:
            if isDataOfClien {
                guard dataOfNewPurse.birth != "" && dataOfNewPurse.first_name != "" && dataOfNewPurse.last_Name != "" &&  dataOfNewPurse.account != "" else { return }
                isProgressOnSubject.onNext(true)
                createPurse(dict: ["account": dataOfNewPurse.account, "first_name": dataOfNewPurse.first_name,"last_name":dataOfNewPurse.last_Name, "birth":dataOfNewPurse.birth,  "country": dataOfNewPurse.country!.attributes!.countryCode!])
            } else {
                router.trigger(.newPurseDataOfCard(partSelected: 2, isDataOfClien: true, currentPurse: currentPurseType, dataOfNewPurse: dataOfNewPurse))                
            }
        default:
            break
        }
    }
    
    // MARK: Forward
    private func forwardCardsPurses() {
        guard let countryCode = dataOfNewPurse.country?.attributes?.countryCode else {
            switch currentPurseType.purseType {
            case .cardUrkV2:
                guard  dataOfNewPurse.account != "" && dataOfNewPurse.exp_year != "" && dataOfNewPurse.exp_month != "" && dataOfNewPurse.cardHolder_name != "" else { return }
                isProgressOnSubject.onNext(true)
                createPurse(dict: ["account": dataOfNewPurse.account,
                "exp_month":dataOfNewPurse.exp_month,
                "exp_year": dataOfNewPurse.exp_year,
                "cardholder_name":dataOfNewPurse.cardHolder_name])
            default:
                break
            }
            return
        }
        if CountryType(rawValue: dataOfNewPurse.country!.attributes!.countryCode!) == .ru {
            guard  dataOfNewPurse.account != "" && dataOfNewPurse.exp_year != "" && dataOfNewPurse.exp_month != "" && dataOfNewPurse.cardHolder_name != "" else { return }
            isProgressOnSubject.onNext(true)
            createPurse(dict: ["account": dataOfNewPurse.account,
            "exp_month":dataOfNewPurse.exp_month,
            "exp_year": dataOfNewPurse.exp_year,
            "cardholder_name":dataOfNewPurse.cardHolder_name])
        } else {
            if isDataOfClien {
                guard dataOfNewPurse.address != "" && dataOfNewPurse.birth != "" && dataOfNewPurse.first_name != "" && dataOfNewPurse.last_Name != "" else { return }
                isProgressOnSubject.onNext(true)
                createPurse(dict: ["account": dataOfNewPurse.account,"exp_month":dataOfNewPurse.exp_month, "exp_year": dataOfNewPurse.exp_year, "first_name": dataOfNewPurse.first_name,"last_name":dataOfNewPurse.last_Name, "birth":dataOfNewPurse.birth, "address": dataOfNewPurse.address, "country": dataOfNewPurse.country!.attributes!.countryCode!, "city": dataOfNewPurse.city!.attributes!.name!])
            } else {
                router.trigger(.newPurseDataOfCard(partSelected: 3, isDataOfClien: true, currentPurse: currentPurseType, dataOfNewPurse: dataOfNewPurse))
            }
        }
    }
}

extension NewPurseDataOfCardViewModel: NewPurseDataOfCardType{}



