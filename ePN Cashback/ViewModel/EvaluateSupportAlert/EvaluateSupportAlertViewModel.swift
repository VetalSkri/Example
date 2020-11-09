//
//  EvaluateSupportAlertViewModel.swift
//  Backit
//
//  Created by Elina Batyrova on 03.08.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator

class EvaluateSupportAlertViewModel {
    
    // MARK: - Instance Properties
    
    private let router: UnownedRouter<SupportRoute>
    private let dialogID: Int
    
    // MARK: -
    
    var alertTitle: String {
        NSLocalizedString("Evaluate Technical Support", comment: "")
    }
    
    var buttonTitle: String {
        NSLocalizedString("Evaluate", comment: "")
    }
    
    var textViewPlaceholder: String {
        NSLocalizedString("Comment", comment: "")
    }
    
    // MARK: - Initializers
    
    init(router: UnownedRouter<SupportRoute>, dialogID: Int) {
        self.router = router
        self.dialogID = dialogID
    }
    
    // MARK: - Instance Methods
    
    func evaluateSupport(starCount: Int, comment: String, onSuccess: @escaping (() -> Void), onFailure: @escaping ((Error) -> Void)) {
        let comment = comment.isEmpty ? nil : comment
        
        SupportApiClient.evaluateSupport(dialogID: dialogID, starCount: starCount, comment: comment) { result in
            switch result {
            case .success:
                onSuccess()
                
            case .failure(let error):
                onFailure(error)
            }
        }
    }
    
    func closeController() {
        router.trigger(.dismiss)
    }
}
