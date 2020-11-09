//
//  MainAuthVC.swift
//  Backit
//
//  Created by Александр Кузьмин on 17/01/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit
import AuthenticationServices
import ProgressHUD
import Lottie
import VK_ios_sdk
import Toast_Swift
import SPStorkController
import GoogleSignIn
import FBSDKLoginKit

class MainAuthVC: UIViewController {

    var viewModel: MainAuthViewModel!
    private var animationPlayed = false
    
    //Main container view
    @IBOutlet weak var containerView: UIView!
    
    //Auth & reg button fields
    @IBOutlet weak var buttonsContainerView: UIView!
    @IBOutlet weak var helloTitleLabel: UILabel!
    @IBOutlet weak var createNewAccountButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var buttonsContainerViewHeightConstraint: NSLayoutConstraint!
    
    //Facebook fields
    @IBOutlet weak var facebookContainerView: UIView!
    @IBOutlet weak var facebookImageView: UIImageView!
    @IBOutlet weak var facebookBottomConstraint: NSLayoutConstraint!
    
    
    //VK fields
    @IBOutlet weak var vkContainerView: UIView!
    @IBOutlet weak var vkImageView: UIImageView!
    @IBOutlet weak var vkBottomConstraint: NSLayoutConstraint!
    
    
    //Google fields
    @IBOutlet weak var googleContainerView: UIView!
    @IBOutlet weak var googleImageView: UIImageView!
    @IBOutlet weak var googleBottomConstraint: NSLayoutConstraint!
    
    //shadow view
    @IBOutlet weak var shadowView: EPNGradientView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
        socialInit()
        self.navigationController?.navigationBar.barStyle = .black;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if viewModel.animate {
            if !animationPlayed {
                animationPlayed = true
                playAnimation(withDeadline: true)
            }
        } else {
            playAnimation(withDeadline: false)
        }
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func socialInit() {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().presentingViewController = self
        
        let vkId = Bundle.main.object(forInfoDictionaryKey: "VK_APP_ID") as! String
        let instance = VKSdk.initialize(withAppId: vkId)
        instance?.register(self)
        instance?.uiDelegate = self
    }
    
    private func setupView() {
        if #available(iOS 13.0, *) {
            setupSignInWithAppleButton()
        } else {
            let bottomConstraint = createNewAccountButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
            bottomConstraint.priority = UILayoutPriority(rawValue: 750)
            bottomConstraint.isActive = true
            let containerBottomConstrainit = createNewAccountButton.bottomAnchor.constraint(equalTo: buttonsContainerView.bottomAnchor, constant: -30)
            containerBottomConstrainit.priority = UILayoutPriority(rawValue: 500)
            containerBottomConstrainit.isActive = true
        }
        
        shadowView.verticalMode = true
        shadowView.startColor = .clear
        shadowView.endColor = .loginStartGradientColor
        
        
        let animationView = AnimationView(name: "nachaloLogin")
        animationView.currentTime = 1.7
        animationView.loopMode = .playOnce
        animationView.contentMode = .scaleAspectFill
        self.containerView.insertSubview(animationView, belowSubview: shadowView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
        animationView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0).isActive = true
        animationView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true
        animationView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0).isActive = true
        
        buttonsContainerView.backgroundColor = .zurich
        buttonsContainerView.cornerRadius = CommonStyle.newCornerRadius
        buttonsContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        facebookContainerView.cornerRadius = 24
        facebookContainerView.backgroundColor = .paris
        vkContainerView.cornerRadius = 24
        vkContainerView.backgroundColor = .paris
        googleContainerView.cornerRadius = 24
        googleContainerView.backgroundColor = .paris
        
        helloTitleLabel.font = .black34
        helloTitleLabel.textColor = .sydney
        helloTitleLabel.text = NSLocalizedString("Hello friend", comment: "")
        
        createNewAccountButton.backgroundColor = .paris
        createNewAccountButton.setTitleColor(.sydney, for: .normal)
        createNewAccountButton.titleLabel?.font = .semibold15
        createNewAccountButton.cornerRadius = 5
        createNewAccountButton.setTitle(NSLocalizedString("Create account", comment: ""), for: .normal)
        loginButton.backgroundColor = .paris
        loginButton.setTitleColor(.sydney, for: .normal)
        loginButton.titleLabel?.font = .semibold15
        loginButton.cornerRadius = 5
        loginButton.setTitle(NSLocalizedString("Log in to Backit", comment: ""), for: .normal)
        
    }
    
    private func playAnimation(withDeadline: Bool) {
        let delay = 0.8
        DispatchQueue.main.asyncAfter(deadline: withDeadline ? (.now() + delay) : .now()) { [weak self] in
            UIView.animate(withDuration: 0.4) { [weak self] in
                if let buttonsContainerViewHeightConstraint = self?.buttonsContainerViewHeightConstraint {
                    buttonsContainerViewHeightConstraint.isActive = false
                }
                self?.shadowView.alpha = 1.0
                self?.view.layoutIfNeeded()
            }
        }
        UIView.animate(withDuration: 0.3, delay: withDeadline ? delay + 0.4 : 0.4, usingSpringWithDamping: 0.5, initialSpringVelocity: 10.0, options: .curveEaseInOut, animations: { [weak self] in
            self?.facebookBottomConstraint.constant = 31
            self?.view.layoutIfNeeded()
        })
        UIView.animate(withDuration: 0.3, delay: withDeadline ? delay + 0.55 : 0.55, usingSpringWithDamping: 0.5, initialSpringVelocity: 10.0, options: .curveEaseInOut, animations: { [weak self] in
            self?.vkBottomConstraint.constant = 31
            self?.view.layoutIfNeeded()
        })
        UIView.animate(withDuration: 0.3, delay: withDeadline ? delay + 0.7 : 0.7, usingSpringWithDamping: 0.5, initialSpringVelocity: 10.0, options: .curveEaseInOut, animations: { [weak self] in
            self?.googleBottomConstraint.constant = 31
            self?.view.layoutIfNeeded()
        })
        
    }
    
    @available(iOS 13.0, *)
    private func setupSignInWithAppleButton() {
        let authorizationButton = ASAuthorizationAppleIDButton(authorizationButtonType: .default, authorizationButtonStyle: .black)
        authorizationButton.addTarget(self, action: #selector(handleLogInWithAppleIDButtonPress), for: .touchUpInside)
        authorizationButton.translatesAutoresizingMaskIntoConstraints = false
        buttonsContainerView.addSubview(authorizationButton)
        authorizationButton.topAnchor.constraint(equalTo: createNewAccountButton.bottomAnchor, constant: 13).isActive = true
        authorizationButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        authorizationButton.leadingAnchor.constraint(equalTo: buttonsContainerView.leadingAnchor, constant: 16).isActive = true
        authorizationButton.trailingAnchor.constraint(equalTo: buttonsContainerView.trailingAnchor, constant: -16).isActive = true
        let bottomConstraint = authorizationButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        bottomConstraint.priority = UILayoutPriority(rawValue: 750)
        bottomConstraint.isActive = true
        let containerBottomConstrainit = authorizationButton.bottomAnchor.constraint(equalTo: buttonsContainerView.bottomAnchor, constant: -30)
        containerBottomConstrainit.priority = UILayoutPriority(rawValue: 500)
        containerBottomConstrainit.isActive = true
        
    }
    
    @available(iOS 13.0, *)
    @objc private func handleLogInWithAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func socialAuth(type: SocialType, token: String, email: String?, appleId: String? = nil, firstName: String? = nil, lastName: String? = nil) {
        OperationQueue.main.addOperation { [weak self] in
            ProgressHUD.show()
            self?.viewModel.socialAuth(token: token, email: email, appleId: appleId, firstName: firstName, lastName: lastName, type: type, complete: {
                ProgressHUD.dismiss()
            }, needAttachEmail: { [weak self] (socialType, email) in
                AuthAnalytics.open(page: .BindEmailPopup)
                ProgressHUD.dismiss()
                let attachSocialVC = AttachSocialViewController.controllerFromStoryboard(.authorization)
                attachSocialVC.email = email
                attachSocialVC.socialType = socialType
                attachSocialVC.socialToken = token
                switch socialType {
                case .apple:
                    attachSocialVC.socialName = "Apple"
                    break
                case .fb:
                    attachSocialVC.socialName = "Facebook"
                    break
                case .google:
                    attachSocialVC.socialName = "Google"
                    break
                case .vk:
                    attachSocialVC.socialName = "VKontakte"
                    break
                }
                let transitionDelegate = SPStorkTransitioningDelegate()
                transitionDelegate.swipeToDismissEnabled = true
                transitionDelegate.tapAroundToDismissEnabled = true
                let sizeLabel =  UILabel(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width - (16 * 2)), height: .greatestFiniteMagnitude))
                sizeLabel.numberOfLines = 0
                sizeLabel.font = .medium15
                sizeLabel.text = "\(NSLocalizedString("You have an account registered at", comment: "")) \(email). \(NSLocalizedString("Bind your", comment: "")) \(attachSocialVC.socialName ?? "") \(NSLocalizedString("account to your Backit account?", comment: ""))"
                sizeLabel.sizeToFit()
                transitionDelegate.customHeight = sizeLabel.frame.height + 260 + (self?.view.safeAreaInsets.bottom ?? 0)
                attachSocialVC.transitioningDelegate = transitionDelegate
                attachSocialVC.modalPresentationStyle = .custom
                attachSocialVC.modalPresentationCapturesStatusBarAppearance = true
                attachSocialVC.delegate = self
                self?.present(attachSocialVC, animated: true, completion: nil)
            })
        }
    }
    
    @IBAction func createNewAccountButtonClicked(_ sender: Any) {
        viewModel.register()
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        viewModel.login()
    }

    @IBAction func vkButtonClicked(_ sender: Any) {
        VKSdk.forceLogout()
        if !VKSdk.isLoggedIn() {
            if VKSdk.vkAppMayExists() {
                VKSdk.authorize([VK_PER_EMAIL], with: .unlimitedToken)
            } else {
                VKSdk.authorize([VK_PER_EMAIL], with: .unlimitedToken)
            }
        } else {
            guard let token = VKSdk.accessToken().accessToken else { return }
            let email = VKSdk.accessToken()?.email
            socialAuth(type: .vk, token: token, email: email)
        }
    }
    
    @IBAction func facebookButtonClicked(_ sender: Any) {
        LoginManager().logOut()
        LoginManager().logIn(permissions: ["email", "public_profile"], from: self) { [weak self] (result, error) in
            if error != nil {
                print("login facebook failed: \(String(describing: error?.localizedDescription))")
                print("result facebook failed: is cancelled\(String(describing: result?.isCancelled)) token is: \(String(describing: result?.token?.tokenString))")
                guard let self = self else { return }
                Alert.showErrorAlert(by: 111000, message: NSLocalizedString("ErrorSignInFacebook", comment: ""), on: self)
            } else {
                guard let result = result else { return }
                if !result.isCancelled && error == nil {
                    guard let token = result.token?.tokenString else { return }
                    self?.fetchProfileFromFB(token)
                } else {
                    print("To signIn into FB is canceled")
                }
            }
        }
    }
    
    @IBAction func googleButtonClicked(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().signIn()
    }
    
    func fetchProfileFromFB(_ token: String) {
        print("The token of Facebook is \(token)")
        let parametrs = ["fields": "email, first_name, last_name"]
        GraphRequest(graphPath: "me", parameters: parametrs).start { [weak self] (connection, result, error) in
            if error != nil {
                self?.socialAuth(type: .fb, token: token, email: nil)
                return
            }
            guard let result = result as? NSDictionary else {
                self?.socialAuth(type: .fb, token: token, email: nil)
                return
            }
            guard let email = result["email"] as? String else {
                self?.socialAuth(type: .fb, token: token, email: nil)
                return
            }
            self?.socialAuth(type: .fb, token: token, email: email)
        }
    }
    
}






//MARK: ASAuthorizationControllerDelegate
@available(iOS 13.0, *)
extension MainAuthVC: ASAuthorizationControllerDelegate {
    // ASAuthorizationControllerDelegate function for authorization failed
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
    
    // ASAuthorizationControllerDelegate function for successful authorization
      
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
      
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Create an account as per your requirement

            let appleId = appleIDCredential.user
            let appleUserFirstName = appleIDCredential.fullName?.givenName
            let appleUserLastName = appleIDCredential.fullName?.familyName
            let appleUserEmail = appleIDCredential.email
            
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: appleId) { (credentialState, error) in
                switch credentialState {
                case .authorized:
                    print(" The Apple ID credential is valid. Show Home UI Here")
                    break
                case .revoked:
                    print(" The Apple ID credential is revoked. Show SignIn UI Here.")
                    break
                case .notFound:
                    print(" No credential was found. Show SignIn UI Here.")
                    break
                default:
                    break
                }
            }
            
            
            
            guard let dataToken = appleIDCredential.authorizationCode else { return }
            guard let authToken = String(data: dataToken, encoding: .utf8) else { return }
            print("MyLOG: authorizationCode token is \(authToken)")
            socialAuth(type: .apple, token: authToken, email: appleUserEmail, appleId: appleId, firstName: appleUserFirstName, lastName: appleUserLastName)
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            let appleUsername = passwordCredential.user
            let applePassword = passwordCredential.password
            print("MYLOG: The ASPasswordCredential is appleUsername-\(appleUsername) applePassword-\(applePassword)")
        }
    }
}


@available(iOS 13.0, *)
extension MainAuthVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}


extension MainAuthVC: VKSdkDelegate, VKSdkUIDelegate {
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
            let email = result.token.email
            socialAuth(type: .vk, token: token, email: email)
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


extension MainAuthVC: AttachSocialViewControllerDelegate {
    func attachClicked(email: String, socialName: String, socialType: SocialType, socialToken: String) {
        viewModel.attach(email: email, socialName: socialName, socialType: socialType, socialToken: socialToken)
    }
}


extension MainAuthVC: GIDSignInDelegate {
    
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
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let socialAccessToken = user.authentication.accessToken // Safe to send to the server
            let email = user.profile.email
            print("The result here)")
            print("userID \(String(describing: userId))")
            print("idToken \(String(describing: idToken))")
            print("accessToken \(String(describing: socialAccessToken))")
            print("email \(String(describing: email))")
            guard let accessToken = socialAccessToken else { return }
            socialAuth(type: .google, token: accessToken, email: email)
        } else {
            print("Failed to log into google \(error.localizedDescription)")
        }
    }
}
