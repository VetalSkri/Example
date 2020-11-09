//
//  IncorrectAuthBehaviour.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 19/09/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import Foundation

class IncorrectAuthBehaviour: FailureBehaviourProtocol {
    
    private var errorInfo: ErrorInfo
    
    init(info error: ErrorInfo) {
        self.errorInfo = error
    }
    
    func showErrorInfo() -> ErrorInfo {
        return self.errorInfo
    }
}
