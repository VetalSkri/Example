//
//  ProfileViewModel.swift
//  Backit
//
//  Created by Александр Кузьмин on 01/04/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator
import RxRelay
import Kingfisher

protocol ProfileViewModelDelegate {
    func bindEmail()
}

class ProfileViewModel: NSObject {
    
    private let router: UnownedRouter<ProfileRoute>
    private let repository = ProfileRepository.shared
    private var menuItems: [ProfileMenuItem]!
    var profile: BehaviorRelay<Profile?>
    var progress = BehaviorRelay<Double>(value: 0.0)
    var error = PublishRelay<Error>()
    var success = PublishRelay<String>()
    var errorMessage = PublishRelay<String>()
    var state = BehaviorRelay<ProfileState>(value: .defaul)
    var saveState = PublishRelay<ProfileSaveState>()
    var showCheckEmail = PublishRelay<Bool>()
    var tempName: String
    var tempBirthday: String
    var tempGender: String
    var inSocialProcess = false
    
    init(router: UnownedRouter<ProfileRoute>) {
        self.router = router
        self.profile = BehaviorRelay<Profile?>(value: Util.fetchProfile())
        self.tempName = self.profile.value?.fullName ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: self.profile.value?.birthday ?? "") {
            dateFormatter.dateFormat = "dd.MM.yyyy"
            tempBirthday = dateFormatter.string(from: date)
        } else {
            tempBirthday = ""
        }
        self.tempGender = self.profile.value?.gender ?? ""
        super.init()
        self.buildMenuItems()
    }
    
    private func buildMenuItems() {
        let nameItem = ProfileMenuItem(type: .name, title: nil, subtitle: nil, status: .none)
        let birthdayAndGenderItem = ProfileMenuItem(type: .birthDate, title: nil, subtitle: nil, status: .none)
        var emailTitle = profile.value?.email ?? ""
        var emailSubtitle = ""
        var emailStatus = ProfileMenuItemStatus.none
        if !emailTitle.isEmpty {
            if !(profile.value?.isConfirmed ?? false) {
                emailSubtitle = NSLocalizedString("You haven't confirmed email", comment: "")
                emailStatus = .warning
            } else {
                emailStatus = .done
            }
        }
        emailTitle = emailTitle.isEmpty ? NSLocalizedString("Add mail address", comment: "") : emailTitle
        let mailItem = ProfileMenuItem(type: .mail, title: emailTitle, subtitle: emailSubtitle, status: emailStatus)
        var phoneTitle = profile.value?.phone ?? ""
        var phoneSubtitle = ""
        var phoneStatus = ProfileMenuItemStatus.none
        if !phoneTitle.isEmpty {
            if profile.value?.phoneConfirmationState != .confirmedByEmail { //phone is confirmed
                phoneSubtitle = NSLocalizedString("Phone isn't confirmed", comment: "")
                phoneStatus = .warning
            } else {
                phoneStatus = .done
                phoneSubtitle = NSLocalizedString("Settings_ChangeNumber", comment: "")
            }
        }
        phoneTitle = phoneTitle.isEmpty ? NSLocalizedString("Add mobile number", comment: "") : phoneTitle
        if !(profile.value?.phone.isEmpty ?? true) && profile.value?.phoneConfirmed == "waiting" {
            phoneTitle =  NSLocalizedString("Add mobile number", comment: "")
            phoneSubtitle = ""
            phoneStatus = ProfileMenuItemStatus.none
        }
        let phoneItem  = ProfileMenuItem(type: .phone, title: phoneTitle, subtitle: phoneSubtitle, status: phoneStatus)
        
        var locationTitle = NSLocalizedString("Location", comment: "")
        if let locationInfo = profile.value?.geo, !locationInfo.country_name.isEmpty {
            locationTitle = locationInfo.country_name
            
            if !locationInfo.city_name.isEmpty {
                locationTitle += ", \(locationInfo.city_name)"
            }
        }
        
        let locationItem = ProfileMenuItem(type: .location, title: locationTitle, subtitle: nil, status: .none)
        let passwordTitle = (profile.value?.isPasswordSet ?? false) ? NSLocalizedString("Change your password", comment: "") : NSLocalizedString("Add password", comment: "")
        let passwordItem = ProfileMenuItem(type: .password, title: passwordTitle, subtitle: nil, status: .none)
        let deleteAccountItem = ProfileMenuItem(type: .deleteAccount, title: NSLocalizedString("Delete account", comment: ""), subtitle: nil, status: .none)
        menuItems = [nameItem, birthdayAndGenderItem, mailItem, phoneItem, locationItem, passwordItem, deleteAccountItem]
    }

    func back() {
        router.trigger(.back)
    }
    
    func numberOfRows() -> Int {
        return (profile.value != nil) ? menuItems.count : 0
    }
    
    func menuItem(for indexPath: IndexPath) -> ProfileMenuItem {
        return menuItems[indexPath.row]
    }
    
    func title() -> String {
        return NSLocalizedString("Profile", comment: "")
    }
    
    func avatarUrl() -> String {
        return profile.value?.profileImage ?? ""
    }
    
    func isBindSocial() -> (vkontakte: Bool, facebook: Bool, google: Bool) {
        let isVkBind = profile.value?.socialNetworks?.contains(ProfileSocial.vk.rawValue) ?? false
        let isFacebookBind = profile.value?.socialNetworks?.contains(ProfileSocial.facebook.rawValue) ?? false
        let isGoogleBind = profile.value?.socialNetworks?.contains(ProfileSocial.google.rawValue) ?? false
        return (isVkBind, isFacebookBind, isGoogleBind)
    }
    
    func firstLetter() -> String {
        if let name = profile.value?.userName, name.count > 0 {
            return name.substring(to: 1).uppercased()
        }
        if let fullName = profile.value?.fullName, fullName.count > 0 {
            return fullName.substring(to: 1).uppercased()
        }
        if let email = profile.value?.email, email.count > 0 {
            return email.substring(to: 1).uppercased()
        }
        return ""
    }
    
    func sendAvatar(file: SupportMessageFile) {
        self.progress.accept(0.01)
        repository.sendAvatar(file: file, changeProgress: { [weak self] (progress) in
            self?.progress.accept(progress)
        }) { [weak self] (result) in
            switch result {
            case .success(let avatarUrl):
                if let self = self {
                    if let profile = self.profile.value {
                        ImageCache.default.storeToDisk(file.file, forKey: avatarUrl)
                        profile.profileImage = avatarUrl
                        ImageCache.default.storeToDisk(file.file, forKey: avatarUrl, processorIdentifier: "safeAvatarToCacheProgessor", expiration: nil, callbackQueue: CallbackQueue.mainAsync) { [weak self] (result) in
                            self?.profile.accept(profile)
                        }
                        Util.saveProfileData(profile: profile)
                        self.progress.accept(0.0)
                        self.profile.accept(profile)
                    }
                }
                break
            case .failure(let error):
                self?.progress.accept(0.0)
                Alert.showErrorToast(by: error)
                break
            }
        }
    }
    
    func deleteAvatar() {
        repository.deleteAvatar { [weak self] (result) in
            switch result {
            case .success(_):
                if let self = self {
                    if let profile = self.profile.value {
                        profile.profileImage = ""
                        Util.saveProfileData(profile: profile)
                        self.profile.accept(profile)
                    }
                }
                break
            case .failure(let error):
                Alert.showErrorToast(by: error)
                break
            }
        }
    }
    
    func loadProfile() {
        repository.loadProfile { [weak self] (result) in
            switch result {
            case .success(let response):
                guard let self = self else { return }
                let firstLoad = (self.profile.value == nil)
                Util.saveProfileData(profile: response.data.attributes)
                self.profile.accept(response.data.attributes)
                self.buildMenuItems()
                if firstLoad {
                    self.tempName = self.profile.value?.fullName ?? ""
                    self.tempBirthday = self.getBirthdayInLocalFormat(fromString: self.profile.value?.birthday ?? "")
                    self.tempGender = self.profile.value?.gender ?? ""
                }
                break
            case .failure(let error):
                Alert.showErrorToast(by: error)
                self?.error.accept(error)
                break
            }
        }
    }
    
    func name() -> String {
        return tempName
    }
    
    func changeName(newName: String) {
        tempName = newName
        changed()
    }
    
    func changeBirthday(newBirthday: String) {
        tempBirthday = newBirthday
        changed()
    }
    
    func changeGender(newGender: Gender) {
        tempGender = newGender.rawValue
        changed()
    }
    
    func updateProfile() {
        guard let profile = self.profile.value else { return }
        if state.value == .loading { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        var birthdayInServerFormat = ""
        if let date = dateFormatter.date(from: tempBirthday) {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            birthdayInServerFormat = dateFormatter.string(from: date)
        }
        state.accept(.loading)
        saveState.accept(.disable)
        let savedProfile = Profile(email: profile.email, isConfirmed: profile.isConfirmed, userName: profile.userName, fullName: tempName, profileImage: profile.profileImage, lastLoginAt: profile.lastLoginAt, firstLogin: profile.firstLogin, subscriptions: profile.subscriptions, phone: profile.phone, phoneConfirmed: profile.phoneConfirmed, birthday: birthdayInServerFormat, gender: tempGender, language: profile.language, isPasswordSet: profile.isPasswordSet, geo: profile.geo, socialNetworks: profile.socialNetworks)
        repository.saveProfile(savedProfile) { [weak self] (result) in
            self?.state.accept(.defaul)
            switch result {
            case .success(_):
                Util.saveProfileData(profile: savedProfile)
                self?.profile.accept(savedProfile)
                self?.success.accept(NSLocalizedString("Renewed", comment: ""))
                break
            case .failure(let error):
                self?.saveState.accept(.enable)
                Alert.showErrorToast(by: error)
                break
            }
        }
    }
    
    func changed() {
        guard let profile = profile.value else { return }
        if tempName.isEmpty {
            saveState.accept(.disable)
            return
        }
        let hasChange = !(profile.fullName == tempName && getBirthdayInLocalFormat(fromString: profile.birthday) == tempBirthday && profile.gender == tempGender)
        saveState.accept((hasChange) ? .enable : .disable)
    }
    
    func birthdayAndGender() -> (birthday: String, gender: Gender?) {
        let gender = Gender(rawValue: tempGender)
        return (tempBirthday, gender)
    }
    
    func getBirthdayInLocalFormat(fromString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: self.profile.value?.birthday ?? "") {
            dateFormatter.dateFormat = "dd.MM.yyyy"
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    func getBirthdayInServerFormat(fromString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        if let date = dateFormatter.date(from: self.profile.value?.birthday ?? "") {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    func deleteAccount() {
        router.trigger(.deleteProfileInfo)
    }
    
    func canChangeSocialNetworks() -> Bool {
        if !((profile.value?.isConfirmed ?? false) == true && (profile.value?.isPasswordSet ?? false) == true) {
            errorMessage.accept(NSLocalizedString("First of all, confirm the e-mail address and set a password", comment: ""))
            return false
        }
        return true
    }
    
    func unbindSocial(social: ProfileSocial) {
        if inSocialProcess {
            return
        }
        inSocialProcess = true
        ProfileApiClient.unlinkSocial(social: social) { [weak self] (result) in
            switch result {
            case .success(_):
                if let self = self, let changedProfile = self.profile.value {
                    changedProfile.socialNetworks?.removeAll(social.rawValue)
                    Util.saveProfileData(profile: changedProfile)
                    self.profile.accept(changedProfile)
                    self.success.accept(NSLocalizedString("social network is deleted", comment: ""))
                }
                break
            case .failure(let error):
                self?.errorMessage.accept(Alert.getMessage(by: error))
                break
            }
            self?.inSocialProcess = false
        }
    }
    
    func bindSocial(social: ProfileSocial, socialToken: String) {
        if inSocialProcess {
            return
        }
        inSocialProcess = true
        ProfileApiClient.linkSocial(social: social, socialToken: socialToken) { [weak self] (result) in
            switch result {
            case .success(_):
                if let self = self, let changedProfile = self.profile.value {
                    if (changedProfile.socialNetworks != nil) {
                        changedProfile.socialNetworks!.append(social.rawValue)
                    } else {
                        changedProfile.socialNetworks = [social.rawValue]
                    }
                    Util.saveProfileData(profile: changedProfile)
                    self.profile.accept(changedProfile)
                    self.success.accept(NSLocalizedString("social network account is bound", comment: ""))
                }
                break
            case .failure(let error):
                self?.errorMessage.accept(Alert.getMessage(by: error))
                break
            }
            self?.inSocialProcess = false
        }
    }
    
    func passwordCellClicked() {
        if profile.value?.isPasswordSet ?? false {
            router.trigger(.changePassword(delegate: self))
        } else {
            router.trigger(.setPassword(delegate: self))
        }
    }
    
    func locationCellSelected() {
        router.trigger(.location(step: .country))
    }
    
    func phoneCellSelected() {
        guard let profile = profile.value else {
            return
        }

        if profile.phone.isEmpty || profile.phoneConfirmed == "waiting"{
            // User should provide email before adding phone number
            if profile.email.isEmpty {
                router.trigger(.shouldAddEmailAlert)
            } else if !(profile.isConfirmed ?? false) {
                router.trigger(.shouldAcceptEmailAlert)
            } else {
                router.trigger(.addPhoneNumber)
            }
        } else {
            if profile.phoneConfirmationState != .confirmedByEmail {
                router.trigger(.shouldCheckEmailAlert)
            } else {
                router.trigger(.checkAccessToCurrentPhone)
            }
        }
    }
}

extension ProfileViewModel: ProfileViewModelDelegate {
    func bindEmail() {
        router.trigger(.bindEmail(delegate: self))
    }
}

extension ProfileViewModel: ProfileBindEmailVCDelegate {
    func successBindEmail(email: String) {
        if let updatedProfile = profile.value {
            updatedProfile.email = email
            Util.saveProfileData(profile: updatedProfile)
            self.buildMenuItems()
            profile.accept(updatedProfile)
            showCheckEmail.accept(true)
        }
    }
}

extension ProfileViewModel: ChangePasswordDelegate {
    func changePassword() {
        guard let profileChanged = profile.value else { return }
        if !profileChanged.isPasswordSet {
            profileChanged.isPasswordSet = true
            Util.saveProfileData(profile: profileChanged)
            buildMenuItems()
            profile.accept(profileChanged)
        }
        success.accept(NSLocalizedString("Changes have been saved", comment: ""))
    }
}

struct ProfileMenuItem {
    var type: ProfileMenuType
    var title: String?
    var subtitle: String?
    var status: ProfileMenuItemStatus
}

enum ProfileMenuItemStatus {
    case none
    case done
    case warning
}

enum ProfileMenuType {
    case name
    case birthDate
    case mail
    case phone
    case location
    case password
    case deleteAccount
}

enum ProfileState {
    case defaul
    case loading
}

enum ProfileSaveState {
    case disable
    case enable
}

enum Gender: String {
    case male = "man"
    case female = "woman"
}
