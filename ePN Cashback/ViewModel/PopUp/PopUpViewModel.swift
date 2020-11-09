//
//  PopUpModelView.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 07/09/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import UIKit

class PopUpViewModel: PopUpModelType {

    private var typeOfPopUp: EPNPopUp.ContentType
    private var promocode: String?
    
    init(type typeOfPopUp: EPNPopUp.ContentType) {
        self.typeOfPopUp = typeOfPopUp
    }
    
    func getType() -> EPNPopUp.ContentType {
        return typeOfPopUp
    }
    
    func tranformImageFromBase64(stringImage: String) -> UIImage? {
        var imageBase64 = stringImage
        let firstIndex = imageBase64.firstIndex(of: ",")!
        imageBase64.replaceSubrange(imageBase64.startIndex...firstIndex, with: "")
        let strBase64 = imageBase64
        let dataDecoded : Data = Data(base64Encoded: strBase64, options: NSData.Base64DecodingOptions(rawValue: 0))!
        let decodedImage = UIImage(data: dataDecoded)
        return decodedImage
    }
    
    func getHeadTitle() -> String {
        switch typeOfPopUp {
        case .promo:
            return ""
        case .info:
            return NSLocalizedString("Where can I get a promo code?", comment: "")
        default:
            return ""
        }
    }
    
    func getTitleText() -> String {
        switch typeOfPopUp {
        case .promo:
            return NSLocalizedString("Enter a promo code", comment: "")
        case .info:
            return NSLocalizedString("Promo code can be obtained from our partners or in social media: Vkontakte, Facebook, Instagram.", comment: "")
        case .hint:
            return NSLocalizedString("If you did not find the order in the list, use the order search form in the mobile version of epn.bz", comment: "")
        default:
            return ""
        }
    }
    
    func getInfoText(_ errorCode: Int = 0) -> String {
        switch typeOfPopUp {
        case .promo:
            switch errorCode {
                case 400030:
                    return NSLocalizedString("Promo code not exist", comment: "")
                case 400031:
                    return NSLocalizedString("This promo code was expired", comment: "")
                case 400032:
                    return NSLocalizedString("Promocode has not yet begun", comment: "")
                case 400033:
                    return NSLocalizedString("Number of activations for this code was exhausted!", comment: "")
                default:
                    return NSLocalizedString("Promocode not found", comment: "")
            }
        case .info:
            return ""
        default:
            return ""
        }
    }
    
    func getButtonTitle() -> String {
        switch typeOfPopUp {
        case .promo:
            return NSLocalizedString("Add", comment: "")
        case .info:
            return ""
        default:
            return ""
        }
    }
    
    func getPlaceholderText() -> String {
        switch typeOfPopUp {
        case .promo:
            return NSLocalizedString("Promo code", comment: "")
        case .info:
            return ""
        default:
            return ""
        }
    }
    
    func getPromocode() -> String {
        return self.promocode!
    }
    
    func setPromocode(promo: String) {
        self.promocode = promo
    }
    
    func sendRequestToCheckPromoCode(promo promocode: String, completion: (()->())?, failureHandle: ((Int)->())?) {
        AuthApiClient.checkPromo(prmocode: promocode) { [weak self] (result) in
            switch result {
            case .success(let response):
                self?.setPromocode(promo: promocode)
                completion?()
                break
            case .failure(let error):
                failureHandle?((error as NSError).code)
                break
            }
        }
    }
}

