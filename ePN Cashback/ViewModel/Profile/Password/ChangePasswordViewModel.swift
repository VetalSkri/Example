//
//  ChangePasswordViewModel.swift
//  Backit
//
//  Created by Александр Кузьмин on 13.04.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator
import RxRelay

protocol ChangePasswordDelegate: class {
    func changePassword()
}

class ChangePasswordViewModel: NSObject {
    
    private let router: UnownedRouter<ProfileRoute>
    private let repository = ProfileRepository.shared
    private weak var delegate: ChangePasswordDelegate?
    private var inProcess = false
    var newPasswordError = PublishRelay<String>()
    var oldPasswordError = PublishRelay<String>()
    
    init(router: UnownedRouter<ProfileRoute>, delegate: ChangePasswordDelegate?) {
        self.router = router
        self.delegate = delegate
        super.init()
    }
    
    func back() {
        router.trigger(.back)
    }
    
    func title() -> String {
        return NSLocalizedString("New password", comment: "")
    }
    
    func changePassword(oldPassword: String, newPassword: String, completion: @escaping ()->()) {
        if inProcess {
            return
        }
        inProcess = true
        ProfileApiClient.changePassword(currentPassword: oldPassword, newPassword: newPassword) { [weak self] (result) in
            switch result {
            case .success(_):
                self?.router.trigger(.back, completion: { [weak self] in
                    self?.delegate?.changePassword()
                })
                return
            case .failure(let error):
                print("TESTLOG: error code is: \((error as NSError).code)")
                if ((error as NSError).code == 422001) {
                    self?.newPasswordError.accept(NSLocalizedString("Wrong new password format", comment: ""))
                } else if ((error as NSError).code == 500101) {
                    self?.oldPasswordError.accept(NSLocalizedString("Current password not correct", comment: ""))
                }
                else {
                    Alert.showErrorToast(by: error)
                }
                completion()
                break
            }
            self?.inProcess = false
        }
    }
    
}
