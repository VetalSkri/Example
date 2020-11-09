//
//  DeleteProfileViewModel.swift
//  Backit
//
//  Created by Ivan Nikitin on 10/03/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator

class DeleteProfileViewModel {
    private var router: UnownedRouter<ProfileRoute>!
    private let repository: ProfileRepository
    
    init(router: UnownedRouter<ProfileRoute>, profileRepository: ProfileRepository) {
        self.router = router
        self.repository = profileRepository
    }
    
    func goOnBack() {
        router.trigger(.back)
    }
    
    func showPopupDeleteProfileSuccess() {
        router.trigger(.bottomPopup(BottomPopupData(title: NSLocalizedString("Account will be finally deleted after 30 days", comment: ""), buttonTitle: NSLocalizedString("Settings_Good", comment: ""), imageName: "trash"), self))
    }
    
    func deleteAccount(secretCode: String, completion: @escaping ((Int)->())) {
        repository.deleteProfile(secretCode: secretCode) { [weak self] (error) in
            if let error = error {
                completion(error.code)
            } else {
                self?.showPopupDeleteProfileSuccess()
            }
        }
    }
    
}

extension DeleteProfileViewModel: BottomPopupVCDelegate {
    func buttonClicked() {
        PushApiClient.deleteToken { (_) in }
        Util.deleteCurrentSessionData()
        UIApplication.shared.open(URL(string: Util.signInURL)!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
    }
}
