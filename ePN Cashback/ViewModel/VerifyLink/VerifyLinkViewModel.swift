//
//  VerifyLinkViewModel.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 22/03/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import XCoordinator

class VerifyLinkViewModel: VerifyLinkModelType {

    private var linkString: String?
    private var offerInfo: OfferLinkInfo?
    
    private let router: UnownedRouter<VerifyLinkRoute>
    
    init(router: UnownedRouter<VerifyLinkRoute>) {
        self.router = router
    }
    
    func goOnResultOfVerifyLink() {
        guard let link = linkString, let info = offerInfo else { return }
        router.trigger(.result(link, info))
    }
    
    func goOnIncorrectLinkResult() {
        router.trigger(.incorrectLink)
    }
    
    func goOnBack() {
        router.trigger(.back)
    }
    
    func setLink(urlLink: String?) {
        self.linkString = urlLink
    }
    
    func verifyTheLink(completion: (()->())?, failure: ((Int)->())?) {
        VerifyLinkApiClient.verifyLink(link: linkString ?? "") { [weak self] (result) in
            switch result {
            case .success(let response):
                self?.offerInfo = response.data.attributes
                completion?()
                break
            case .failure(let error):
                failure?((error as NSError).code)
                break
            }
        }
    }
}
