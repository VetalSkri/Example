//
//  SetPasswordViewModel.swift
//  Backit
//
//  Created by Александр Кузьмин on 14.04.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator
import RxRelay

class SetPasswordViewModel: NSObject {
    
    private let router: UnownedRouter<ProfileRoute>
    private let repository = ProfileRepository.shared
    private weak var delegate: ChangePasswordDelegate?
    private var inProcess = false
    var passwordError = PublishRelay<String>()
    
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
    
    func setPassword(newPassword: String, completion: @escaping ()->()) {
        if inProcess {
            return
        }
        inProcess = true
        ProfileApiClient.changePassword(currentPassword: "", newPassword: newPassword) { [weak self] (result) in
            switch result {
            case .success(_):
                self?.router.trigger(.back, completion: { [weak self] in
                    self?.delegate?.changePassword()
                })
                return
            case .failure(let error):
                if ((error as NSError).code == 422001) {
                    self?.passwordError.accept(NSLocalizedString("Wrong new password format", comment: ""))
                } else {
                    Alert.showErrorToast(by: error)
                }
                completion()
                break
            }
            self?.inProcess = false
        }
    }
}
