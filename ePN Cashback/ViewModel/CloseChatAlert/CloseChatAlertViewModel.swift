//
//  CloseChatAlertViewModel.swift
//  Backit
//
//  Created by Elina Batyrova on 30.07.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator

class CloseChatAlertViewModel {
    
    // MARK: - Instance Properties
    
    private let router: UnownedRouter<SupportRoute>
    private let dialogID: Int
    
    // MARK: -
    
    var alertTitle: String {
        NSLocalizedString("Finish conversation", comment: "")
    }
    
    var alertDescription: String {
        NSLocalizedString("Your question will go to the tab Closed", comment: "")
    }
    
    var alertLeftButtonTitle: String {
        NSLocalizedString("Cancel", comment: "")
    }
    
    var alertRightButtonTitle: String {
        NSLocalizedString("Complete", comment: "")
    }
    
    // MARK: - Initializers
    
    init(router: UnownedRouter<SupportRoute>, dialogID: Int) {
        self.router = router
        self.dialogID = dialogID
    }
    
    // MARK: - Instance Methods
    
    func closeController() {
        router.trigger(.dismiss)
    }
    
    func returnToChatList() {
        router.trigger(.backToSupportVCFrom(dialogID: self.dialogID))
    }
    
    func closeChat(onSuccess: @escaping (() -> Void), onFailure: @escaping ((Error) -> Void)) {
        SupportApiClient.closeDialog(id: dialogID, completion: { result in
            switch result {
            case .success:
                onSuccess()
                
            case .failure(let error):
                onFailure(error)
            }
        })
    }
}
