//
//  ProfileXCoordinator.swift
//  Backit
//
//  Created by Ivan Nikitin on 04/03/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import XCoordinator

enum ProfileRoute: Route {
    case main
    case deleteProfileInfo
    case deleteProfile
    case bottomPopup(BottomPopupData, DeleteProfileViewModel)
    case bindEmail(delegate: ProfileBindEmailVCDelegate)
    case changePassword(delegate: ChangePasswordDelegate)
    case setPassword(delegate: ChangePasswordDelegate)
    case location(step: LocationStep, data: LocationData? = nil)
    case shouldAcceptEmailAlert
    case shouldAddEmailAlert
    case addPhoneNumber
    case enterCode(step: EnterCodeStep)
    case dismiss
    case back
    case backToEditProfile
    case shouldCheckEmailAlert
    case dismissAndAddPhoneNumber
    case backToProfileAndShouldCheckEmailAlert
    case checkAccessToCurrentPhone
    case editPhone(access: AccessToCurrentNumber)
}

class ProfileXCoordinator: NavigationCoordinator<ProfileRoute> {
    
    // MARK: - Init
    
    init(rootViewController: UINavigationController) {
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(.main)
    }
    
    // MARK: - Overrides
    
    var childCoordinator: Presentable?
    var main: Presentable!
    
    override func prepareTransition(for route: ProfileRoute) -> NavigationTransition {
        if let coordinator = childCoordinator {
            removeChild(coordinator)
        }
        switch route {
        case .main:
            let profileVC: ProfileVC = ProfileVC.controllerFromStoryboard(.profile)
            profileVC.viewModel = ProfileViewModel(router: unownedRouter)
            main = profileVC
            return .push(profileVC)
        case .deleteProfileInfo:
            let deleteProfileInfoVC: DeleteProfileInfoVC = DeleteProfileInfoVC.controllerFromStoryboard(.profile)
            deleteProfileInfoVC.hidesBottomBarWhenPushed = true
            deleteProfileInfoVC.bindRouter(router: unownedRouter)
            return .push(deleteProfileInfoVC)
        case .deleteProfile:
            let deleteProfileVC = DeleteProfileVC.controllerFromStoryboard(.profile)
            deleteProfileVC.viewModel = DeleteProfileViewModel(router: unownedRouter, profileRepository: ProfileRepository.shared)
            return .push(deleteProfileVC)
        case .bottomPopup(let data, let deleteVM):
            let successVC = BottomPopupVC.controllerFromStoryboard(.authorization)
            successVC.configureView(data: data)
            successVC.delegate = deleteVM
            successVC.modalPresentationStyle = .overCurrentContext
            successVC.modalTransitionStyle = .crossDissolve
            return .present(successVC)
        case .bindEmail(let delegate):
            let bindEmailVC = ProfileBindEmailVC.controllerFromStoryboard(.profile)
            let bindEmailViewModel = ProfileBindEmailViewModel(router: unownedRouter)
            bindEmailViewModel.delegate = delegate
            bindEmailVC.viewModel = bindEmailViewModel
            return .push(bindEmailVC)
        case .changePassword(let delegate):
            let changePasswordVC = ChangePasswordVC.controllerFromStoryboard(.profile)
            changePasswordVC.viewModel = ChangePasswordViewModel(router: unownedRouter, delegate: delegate)
            return .push(changePasswordVC)
        case .setPassword(let delegate):
            let setPasswordVC = SetPasswordVC.controllerFromStoryboard(.profile)
            setPasswordVC.viewModel = SetPasswordViewModel(router: unownedRouter, delegate: delegate)
            return .push(setPasswordVC)
        case .location(let step, let data):
            let locationViewController = LocationViewController()
            locationViewController.viewModel = LocationViewModel(router: unownedRouter, repository: ProfileRepository.shared, step: step, data: data)
            return .push(locationViewController)
        case .shouldAcceptEmailAlert:
            let acceptEmailViewController = PopUpAlertViewController()
            acceptEmailViewController.viewModel = AcceptEmailViewModel(router: unownedRouter,
                                                                       delegate: main as! AcceptMailVCDelegate)
            acceptEmailViewController.modalPresentationStyle = .overFullScreen
            acceptEmailViewController.modalTransitionStyle = .crossDissolve
            return .present(acceptEmailViewController)
        case .shouldAddEmailAlert:
            let addEmailViewController = PopUpAlertViewController()
            addEmailViewController.viewModel = AddEmailViewModel(router: unownedRouter,
                                                                 delegate: (main as! ProfileVC).viewModel)
            addEmailViewController.modalPresentationStyle = .overFullScreen
            addEmailViewController.modalTransitionStyle = .crossDissolve
            return .present(addEmailViewController)
        case .shouldCheckEmailAlert:
            let checkEmailViewController = PopUpAlertViewController()
            checkEmailViewController.delegate = (main as! ProfileVC)
            checkEmailViewController.viewModel = CheckEmailViewModel(router: unownedRouter)
            checkEmailViewController.modalPresentationStyle = .overFullScreen
            checkEmailViewController.modalTransitionStyle = .crossDissolve
            return .present(checkEmailViewController)
        case .addPhoneNumber:
            let addPhoneNumberViewController = AddPhoneNumberViewController()
            addPhoneNumberViewController.viewModel = AddPhoneNumberViewModel(router: unownedRouter)
            return .push(addPhoneNumberViewController)
        case .enterCode(let step):
            let enterCodeViewController = EnterCodeViewController()
            enterCodeViewController.viewModel = EnterCodeViewModel(router: unownedRouter, step: step)
            return .push(enterCodeViewController)
        case .checkAccessToCurrentPhone:
            let checkAccessToPhoneViewController = CheckAccessToPhoneViewController()
            checkAccessToPhoneViewController.viewModel = CheckAccessToPhoneViewModel(router: unownedRouter)
            checkAccessToPhoneViewController.modalPresentationStyle = .overFullScreen
            checkAccessToPhoneViewController.modalTransitionStyle = .crossDissolve
            return .present(checkAccessToPhoneViewController)
        case .editPhone(let access):
            let editPhoneNumberViewController = EditPhoneNumberViewController()
            editPhoneNumberViewController.viewModel = EditPhoneNumberViewModel(router: unownedRouter, access: access)
            return .multiple(.dismiss(), .push(editPhoneNumberViewController))
        case .back:
            return .pop()
        case .dismiss:
            return .dismiss()
        case .backToEditProfile:
            (main as? ProfileVC)?.viewModel.loadProfile()
            return .pop(to: main)
        case .dismissAndAddPhoneNumber:
            let addPhoneNumberViewController = AddPhoneNumberViewController()
            addPhoneNumberViewController.viewModel = AddPhoneNumberViewModel(router: unownedRouter)
            return .multiple(.dismiss(), .push(addPhoneNumberViewController))
        case .backToProfileAndShouldCheckEmailAlert:
            let checkEmailViewController = PopUpAlertViewController()
            checkEmailViewController.viewModel = CheckEmailViewModel(router: unownedRouter)
            checkEmailViewController.modalPresentationStyle = .overFullScreen
            checkEmailViewController.modalTransitionStyle = .crossDissolve
            (main as? ProfileVC)?.viewModel.loadProfile()
            return .multiple(.pop(to: main), .present(checkEmailViewController))
        }
    }
}
