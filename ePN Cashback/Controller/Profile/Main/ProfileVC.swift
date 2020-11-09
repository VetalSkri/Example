//
//  ProfileVC.swift
//  Backit
//
//  Created by Александр Кузьмин on 01/04/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit
import Photos
import RxSwift
import RxRelay
import Lightbox
import Lottie
import SPStorkController
import VK_ios_sdk
import FBSDKLoginKit
import GoogleSignIn

class ProfileVC: UIViewController {

    var viewModel: ProfileViewModel!
    private var headerView: ProfileHeaderView!
    private let nameCellId = "nameCellId"
    private let birthGenderCellId = "birthGenderCellId"
    private let commonCellid = "commonCellid"
    private let refreshControl = UIRefreshControl()
    private let loadAnimationView = AnimationView(name: "loader")
    private var saveBarButton: UIBarButtonItem!
    
    private var alertView = UIView()
    private var alertImageView = UIImageView()
    private var alertTitleLabel = UILabel()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadIndicatorContainerView: UIView!
    
    //Error fields
    @IBOutlet weak var errorContainerView: UIView!
    @IBOutlet weak var errorContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView = ProfileHeaderView.instanceFromNib()
        headerView.delegate = self
        setUpNavigationBar()
        setupView()
        setupSubviews()
        setupConstraints()
        setupHeader()
        bindVM()
        initVkSdk()
        initGoogleSdk()
    }
    
    private func initVkSdk() {
        let vkId = Bundle.main.object(forInfoDictionaryKey: "VK_APP_ID") as! String
        let instance = VKSdk.initialize(withAppId: vkId)
        instance?.register(self)
        instance?.uiDelegate = self
    }
    
    private func initGoogleSdk() {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().presentingViewController = self
    }
    
    private func setupSubviews() {
        alertView.addSubview(alertImageView)
        alertView.addSubview(alertTitleLabel)
        
        alertTitleLabel.font = .semibold13
        
        alertTitleLabel.textColor = .black
    
        alertTitleLabel.numberOfLines = 0
        
        alertView.cornerRadius = 12
        alertView.clipsToBounds = true
        alertView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        self.view.addSubview(alertView)
    }
    
    private func setupConstraints() {
        alertView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(-48)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        self.alertImageView.snp.makeConstraints { (make) in
            make.height.equalTo(24)
            make.width.equalTo(24)
            make.top.equalToSuperview().inset(18)
            make.left.equalToSuperview().inset(20)
        }
        self.alertTitleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(20)
            make.left.equalTo(self.alertImageView.snp.right).offset(8)
            make.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func bindVM() {
        _ = viewModel.profile.skip(1).observeOn(MainScheduler.instance).subscribe { [weak self] (event) in
            guard let self = self else { return }
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            if !(self.loadAnimationView.isHidden) {
                self.loadIndicatorContainerView.isHidden = true
                self.loadAnimationView.stop()
            }
            if (self.tableView.tableHeaderView != self.headerView) {
                self.tableView.tableHeaderView = self.headerView
            }
            self.setupHeader()
            self.tableView.reloadData()
        }
        
        _ = viewModel.progress.observeOn(MainScheduler.instance).subscribe({ [weak self] (event) in
            if let progress = event.element {
                self?.tableView.refreshControl = (progress > 0) ? nil : self!.refreshControl
                self?.headerView.changeProgress(progress: progress)
            }
        })
        
        _ =  viewModel.error.observeOn(MainScheduler.instance).subscribe({ [weak self] (event) in
            if (event.element == nil) { //Throw load profile request error
                return
            }
            guard let self = self else { return }
            if (!self.loadAnimationView.isHidden) {
                self.loadIndicatorContainerView.isHidden = true
                self.loadAnimationView.stop()
            }
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        })
        _ = viewModel.state.observeOn(MainScheduler.instance).subscribe({ [weak self] (event) in
            guard let state = event.element else { return }
            self?.setIsLoading(state == .loading)
        })
        _ = viewModel.saveState.observeOn(MainScheduler.instance).distinctUntilChanged().subscribe({ [weak self] (event) in
            guard let saveStatus = event.element else { return }
            self?.setSaveButtonIsEnable(saveStatus == .enable)
        })
        _ = viewModel.success.observeOn(MainScheduler.instance).subscribe({ [weak self] (event) in
            guard let message = event.element else { return }
            self?.showSuccess(by: message)
        })
        _ = viewModel.showCheckEmail.observeOn(MainScheduler.instance).subscribe({ [weak self] (event) in
            guard let _ = event.element else { return }
            self?.showAcceptEmailBottomView()
        })
        _ = viewModel.errorMessage.observeOn(MainScheduler.instance).subscribe({ [weak self] (event) in
            guard let errorMessage = event.element else { return }
            self?.showAlert(message: errorMessage, error: true)
        })
    }

    private func setupView() {
        tableView.register(UINib(nibName: "ProfileNameCell", bundle: nil), forCellReuseIdentifier: nameCellId)
        tableView.register(UINib(nibName: "ProfileBirthGenderCell", bundle: nil), forCellReuseIdentifier: birthGenderCellId)
        tableView.register(UINib(nibName: "ProfileCommonCell", bundle: nil), forCellReuseIdentifier: commonCellid)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 64
        tableView.tableHeaderView = headerView
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor).isActive = true
        headerView.widthAnchor.constraint(equalTo: self.tableView.widthAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: self.tableView.topAnchor).isActive = true
        
        refreshControl.tintColor = .sydney
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshControl
        
        loadAnimationView.loopMode = .loop
        loadAnimationView.contentMode = .scaleAspectFill
        loadIndicatorContainerView.addSubview(loadAnimationView)
        loadAnimationView.translatesAutoresizingMaskIntoConstraints = false
        loadAnimationView.topAnchor.constraint(equalTo: loadIndicatorContainerView.topAnchor, constant: 0).isActive = true
        loadAnimationView.bottomAnchor.constraint(equalTo: loadIndicatorContainerView.bottomAnchor, constant: 0).isActive = true
        loadAnimationView.leadingAnchor.constraint(equalTo: loadIndicatorContainerView.leadingAnchor, constant: 0).isActive = true
        loadAnimationView.trailingAnchor.constraint(equalTo: loadIndicatorContainerView.trailingAnchor, constant: 0).isActive = true
        
        loadIndicatorContainerView.isHidden = !(viewModel.profile.value == nil)
        if viewModel.profile.value == nil {
            loadAnimationView.play()
            tableView.tableHeaderView = UIView(frame: .zero)
            refresh()
        }
    }
    
    @objc private func refresh() {
        viewModel.loadProfile()
    }
    
    private func setupHeader() {
        let socialBindings = viewModel.isBindSocial()
        headerView.setup(avatarUrl: viewModel.avatarUrl(), firstUserLetter: viewModel.firstLetter(), fbBind: socialBindings.facebook, vkBind: socialBindings.vkontakte, googleBind: socialBindings.google)
    }
    
    func setUpNavigationBar() {
        title = viewModel.title()
        navigationController?.navigationBar.barTintColor = .zurich
//        navigationController?.navigationBar.shadowImage = UIImage()
        let saveButton = UIButton(type: .system)
        saveButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        saveButton.setTitle(NSLocalizedString("Done", comment: ""), for: .normal)
        saveButton.setTitleColor(UIColor.linkCustom, for: .normal)
        saveButton.titleLabel?.font = .medium15
        saveButton.isEnabled = false
        saveButton.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)

        let backButton = UIButton(type: .system)
        backButton.setTitle(NSLocalizedString("Back", comment: ""), for: .normal)
        backButton.setTitleColor(UIColor.linkCustom, for: .normal)
        backButton.titleLabel?.font = .medium15
        backButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        
        saveBarButton = UIBarButtonItem(customView: saveButton)
        
        navigationItem.rightBarButtonItem = saveBarButton
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        setSaveButtonIsEnable(false)
    }
    
    private func setSaveButtonIsEnable(_ isEnable: Bool) {
        self.saveBarButton.isEnabled = isEnable
        (self.saveBarButton.customView as? UIButton)?.setTitleColor((isEnable) ? UIColor.linkCustom : UIColor.minsk, for: .normal)
    }
    
    private func chooseAvatarLogo() {
        if viewModel.progress.value > 0.0 {
            return
        }
        let alert = UIAlertController(style: .actionSheet)
        alert.addPhotoLibraryPicker(flow: .horizontal, paging: false, selection: .single(action: { (asset) in
            guard let image = asset else { return }
            alert.dismiss(animated: true, completion: nil)
            let imageManager = PHImageManager.default()
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true
            requestOptions.deliveryMode = .highQualityFormat
            requestOptions.resizeMode = .exact
            requestOptions.isNetworkAccessAllowed = false
            imageManager.requestImageData(for: image, options: requestOptions) { (imageData, text, orientation, info) in
                guard let imageData = imageData else { return }
                var fileName: String? = nil
                var fileExtension: String? = nil
                if let info = info {
                    if info.keys.contains(NSString(string: "PHImageFileURLKey")) {
                        if let path = info[NSString(string: "PHImageFileURLKey")] as? NSURL {
                            fileName = path.lastPathComponent
                            fileExtension = path.pathExtension
                        }
                    }
                }
                if fileName == nil {
                    fileName = image.value(forKey: "filename") as? String
                }
                let file = SupportMessageFile(id: -1, file: imageData, fileName: fileName ?? "avatar.JPG", fileExtension: fileExtension ?? "JPG", messageId: -1, link: nil, size: Float(Double(imageData.count)/(1024.0*1024.0)))
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.viewModel.sendAvatar(file: file)
                }
            }
        }))
        if UIDevice.current.userInterfaceIdiom == .pad {
            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.maxY, width: 0, height: 0)
        }
        alert.addAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel)
        
        let showPhotoAction = UIAlertAction(title: NSLocalizedString("See photo", comment: ""), style: .default) { [weak self] (action) in
            self?.showAvatar()
        }
        
        let removePhotoAction = UIAlertAction(title: NSLocalizedString("Delete photo", comment: ""), style: .destructive) { [weak self] (action) in
            self?.viewModel.deleteAvatar()
        }
        
        if !viewModel.avatarUrl().isEmpty {
            alert.addAction(showPhotoAction)
            alert.addAction(removePhotoAction)
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    private func showAvatar() {
        let imageUrl = viewModel.avatarUrl()
        if imageUrl.isEmpty {
            return
        }
        guard let imageLinkUrl = URL(string: imageUrl) else { return }
        OperationQueue.main.addOperation { [weak self] in
            let images = [
                LightboxImage(imageURL: imageLinkUrl)
            ]
            let controller = LightboxController(images: images)
            controller.dynamicBackground = true
            controller.modalPresentationStyle = .fullScreen
            self?.present(controller, animated: true, completion: nil)
        }
    }
    
    private func showError(by message: String) {
        let errorText = NSLocalizedString("Error", comment: "")+":"+" "
        let attributedErrorString = NSMutableAttributedString(string: errorText+message)
        attributedErrorString.addAttributes([NSAttributedString.Key.font: UIFont.semibold13, NSAttributedString.Key.foregroundColor: UIColor.paris], range: NSRange(location: 0, length: errorText.count))
        errorLabel.attributedText = attributedErrorString
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.errorContainerHeight.constant = 75
            self?.view.layoutIfNeeded()
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+1.3) { [weak self] in
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.errorContainerHeight.constant = 0
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    private func showSuccess(by message: String) {
        let bannerView = SuccessCopyBannerView.instanceFromNib()
        bannerView.statusText = NSLocalizedString("Successfully", comment: "")
        bannerView.actionText = message
        let banner = NotificationBanner(customView: bannerView)
        let delegate = UIApplication.shared.delegate as? AppDelegate
        banner.bannerHeight = 30 + CGFloat(delegate?.window?.safeAreaInsets.top ?? 0)
        banner.show()
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
            banner.dismiss()
        }
    }
    
    private func setIsLoading(_ isLoading: Bool) {
        if isLoading {
            self.loadAnimationView.play()
        } else {
            self.loadAnimationView.stop()
        }
        self.loadIndicatorContainerView.isHidden = !isLoading
    }
    
    @objc private func saveButtonClicked() {
        view.endEditing(true)
        viewModel.updateProfile()
    }
    
    @objc private func backButtonClicked() {
        view.endEditing(true)
        viewModel.back()
    }
    
}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menuItem = viewModel.menuItem(for: indexPath)
        switch menuItem.type {
        case .name:
            let cell = tableView.dequeueReusableCell(withIdentifier: nameCellId, for: indexPath) as! ProfileNameCell
            cell.setupCell(name: viewModel.name())
            cell.delegate = self
            return cell
        case .birthDate:
            let cell = tableView.dequeueReusableCell(withIdentifier: birthGenderCellId, for: indexPath) as! ProfileBirthGenderCell
            let birthdayAndGender = viewModel.birthdayAndGender()
            cell.setupCell(birthday: birthdayAndGender.birthday, gender: birthdayAndGender.gender)
            cell.delegate = self
            return cell
        default:
            break
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: commonCellid, for: indexPath) as! ProfileCommonCell
        cell.setupCell(item: menuItem)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuItem = viewModel.menuItem(for: indexPath)
        switch menuItem.type {
        case .deleteAccount:
            viewModel.deleteAccount()
            
        case .mail:
            guard let profile = viewModel.profile.value else {
                return
            }
            
            if !profile.email.isEmpty && !(profile.isConfirmed ?? false) {
                // TODO: - change
                showAcceptEmailBottomView()
            }
            
            if profile.email.isEmpty {
                viewModel.bindEmail()
            }
            
        case .password:
            viewModel.passwordCellClicked()
            
        case .phone:
            viewModel.phoneCellSelected()
            
        case .location:
            viewModel.locationCellSelected()
            
        default:
            return
        }
    }
    
    func showAcceptEmailBottomView() {
        DispatchQueue.main.async { [weak self] in
            let acceptMailVC = AcceptMailVC.controllerFromStoryboard(.profile)
            let transitionDelegate = SPStorkTransitioningDelegate()
            transitionDelegate.swipeToDismissEnabled = true
            transitionDelegate.tapAroundToDismissEnabled = true
            transitionDelegate.customHeight = 270 + (self?.view.safeAreaInsets.bottom ?? 0)
            acceptMailVC.transitioningDelegate = transitionDelegate
            acceptMailVC.modalPresentationStyle = .custom
            acceptMailVC.modalPresentationCapturesStatusBarAppearance = true
            acceptMailVC.delegate = self
            self?.present(acceptMailVC, animated: true, completion: nil)
        }
    }
    
    private func bindVK() {
        VKSdk.forceLogout()
        if !VKSdk.isLoggedIn() {
            if VKSdk.vkAppMayExists() {
                VKSdk.authorize([VK_PER_EMAIL], with: .unlimitedToken)
            } else {
                VKSdk.authorize([VK_PER_EMAIL], with: .unlimitedToken)
            }
        } else {
            guard let token = VKSdk.accessToken().accessToken else { return }
            viewModel.bindSocial(social: .vk, socialToken: token)
        }
    }
    
    private func bindFacebook() {
        LoginManager().logOut()
        LoginManager().logIn(permissions: ["email", "public_profile"], from: self) { [weak self] (result, error) in
            if error != nil {
                print("login facebook failed: \(String(describing: error?.localizedDescription))")
                print("result facebook failed: is cancelled\(String(describing: result?.isCancelled)) token is: \(String(describing: result?.token?.tokenString))")
                guard let self = self else { return }
                self.showAlert(message: NSLocalizedString("ErrorSignInFacebook", comment: ""), error: true)
            } else {
                guard let result = result else { return }
                if !result.isCancelled && error == nil {
                    guard let token = result.token?.tokenString else { return }
                    self?.viewModel.bindSocial(social: .facebook, socialToken: token)
                } else {
                    print("To signIn into FB is canceled")
                }
            }
        }
    }
    
    private func bindGoogle() {
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().signIn()
    }
}

extension ProfileVC: ProfileHeaderViewDelegate {
    func avatarClicked() {
        chooseAvatarLogo()
    }
    
    func vkButtonTap() {
        if !viewModel.canChangeSocialNetworks() { return }
        if viewModel.isBindSocial().vkontakte {
            viewModel.unbindSocial(social: .vk)
        } else {
            bindVK()
        }
    }
    
    func facebookButtonTap() {
        if !viewModel.canChangeSocialNetworks() { return }
        if viewModel.isBindSocial().facebook {
            viewModel.unbindSocial(social: .facebook)
        } else {
            bindFacebook()
        }
    }
    
    func googleButtonTap() {
        if !viewModel.canChangeSocialNetworks() { return }
        if viewModel.isBindSocial().google {
            viewModel.unbindSocial(social: .google)
        } else {
            bindGoogle()
        }
    }
}

extension ProfileVC: ProfileNameCellDelegate {
    func textDidChanged(newText: String) {
        viewModel.changeName(newName: newText)
    }
}

extension ProfileVC: ProfileBirthGenderCellDelegate {
    func birthdayChanged(newBirthDate: String) {
        viewModel.changeBirthday(newBirthday: newBirthDate)
    }
    
    func genderChange(newGender: Gender) {
        viewModel.changeGender(newGender: newGender)
    }
}

extension ProfileVC: AcceptMailVCDelegate {
    func emailIsSend() {
        showSuccess(by: NSLocalizedString("Email is sent!", comment: ""))
    }
}

extension ProfileVC: VKSdkDelegate, VKSdkUIDelegate {
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError) {
        print("vkSdkNeedCaptchaEnter")
        print(captchaError)
    }
    
    func vkSdkTokenHasExpired(expiredToken: VKAccessToken) {
        print("vkSdkTokenHasExpired")
    }
    
    func vkSdkUserDeniedAccess(authorizationError: VKError) {
        print("vkSdkUserDeniedAccess")
    }
    
    func vkSdkReceivedNewToken(newToken: VKAccessToken) {
        print("vkSdkReceivedNewToken")
        print(newToken)
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if result.error != nil {    //Cancel clicked
            return
        } else {
            guard let token = result.token.accessToken else { return }
            viewModel.bindSocial(social: .vk, socialToken: token)
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        print("vkSdkUserAuthorizationFailed")
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        print("vkSdkShouldPresent")
        present(controller, animated: true, completion: nil)
    }
}

extension ProfileVC: GIDSignInDelegate {
    
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
        // myActivityIndicator.stopAnimating()
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        dismiss(animated: true, completion: nil)
    }
    
    //completed sign In
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if (error == nil) {
            // Perform any operations on signed in user here.
            let socialAccessToken = user.authentication.accessToken // Safe to send to the server
            print("accessToken \(String(describing: socialAccessToken))")
            guard let accessToken = socialAccessToken else { return }
            viewModel.bindSocial(social: .google, socialToken: accessToken)
        } else {
            print("Failed to log into google \(error.localizedDescription)")
        }
    }
}

extension ProfileVC: PopUpAlertDelegate{
    func showAlert(message: String, error: Bool) {
        print(message)
        let image = error ? UIImage(named: "error") : UIImage(named: "done")
        let tintImage = image!.withRenderingMode(.alwaysTemplate)
        
        alertImageView.image = tintImage
        alertImageView.tintColor = error ? .white : .black
        
        alertView.backgroundColor = error ? .black : .vilnius
        
        alertTitleLabel.textColor = error ? .white : .black
        
        alertImageView.contentMode = .scaleAspectFit
        if error {
            let boldText  = NSLocalizedString("Error", comment: "") + ": "
            let attrs = [NSAttributedString.Key.font : UIFont.semibold13]
            let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)
            
            let normalText = message
            let attrsText = [NSAttributedString.Key.font : UIFont.medium13]
            let normalString =
                NSMutableAttributedString(string:normalText, attributes: attrsText)
            
            attributedString.append(normalString)
            alertTitleLabel.text = attributedString.string
        } else {
            alertTitleLabel.text = message
        }
        
        self.alertImageView.snp.remakeConstraints { (make) in
            make.height.equalTo(24)
            make.width.equalTo(24)
            make.top.equalToSuperview().inset(error ? 18 : 8)
            make.left.equalToSuperview().inset(error ? 20 : 58)
        }
        self.alertTitleLabel.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().inset(error ? 20 : 12)
            make.left.equalTo(self.alertImageView.snp.right).offset(8)
            make.bottom.equalToSuperview().inset(error ? 20 : 16)
            make.right.equalToSuperview().inset(error ? 20 : 16)
        }
        
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .allowAnimatedContent, animations: {
            self.view.layoutIfNeeded()
            self.alertView.snp.remakeConstraints { (make) in
                make.top.equalTo(self.navigationController!.navigationBar.snp.bottom)
                make.left.equalToSuperview()
                make.right.equalToSuperview()
            }
            self.view.layoutIfNeeded()
        }) { (result) in
            UIView.animate(withDuration: 1, delay: 2,options:  .curveEaseOut ,animations: {
                self.alertView.snp.remakeConstraints { (make) in
                    make.top.equalToSuperview().inset(-100)
                    make.left.equalToSuperview()
                    make.right.equalToSuperview()
                }
                self.view.layoutIfNeeded()
            })
        }
    }
}
