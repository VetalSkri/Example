//
//  NewPurseWebViewVCViewController.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 18/09/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import WebKit
import Lottie

class NewPurseWebViewVC: UIViewController {

    var viewModel: NewPurseWebViewProtocol!
    
    private var webView: WKWebView!
    private var animationView = AnimationView(name: "loader")
    private var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        clearCookies { [weak self] in
            self?.setupView()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        showLoadAnimation()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func showLoadAnimation() {
        
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        
        view.addSubview(animationView)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        
        view.layoutIfNeeded()
        
        animationView.play()
    }
    
    private func setupNavigationBar() {
        title = viewModel.title
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .zurich
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.sydney , NSAttributedString.Key.font : UIFont.semibold17]
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backButtonClicked))
    }
    
    private func setupView() {
        
        let config = WKWebViewConfiguration()
        let userController = WKUserContentController()
        
        userController.add(self, name: "result")
        config.userContentController = userController
        
        webView = WKWebView(frame: UIScreen.main.bounds, configuration: config)
        webView.navigationDelegate = self
        
        self.view.addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        
        bottomConstraint = webView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        bottomConstraint.isActive = true
        
        webView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        webView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        
        loadPage()
        
        errorLabel.font = .bold20
        errorLabel.textColor = .sydney
        errorLabel.text = NSLocalizedString("Failed to load page", comment: "")
        
        errorButton.setTitle(NSLocalizedString("Repeat", comment: ""), for: .normal)
        errorButton.setTitleColor(.zurich, for: .normal)
        errorButton.titleLabel?.font = .semibold15
        errorButton.backgroundColor = .sydney
        errorButton.cornerRadius = 5
        
        view.bringSubviewToFront(errorLabel)
        view.bringSubviewToFront(errorButton)
        
        webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        view.bringSubviewToFront(animationView)
    }
    
    private func clearCookies(completion:(()->())?) {
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: records) {
                completion?()
            }
        }
    }
    
    private func loadPage() {
        errorButton.isHidden = true
        errorLabel.isHidden = true
        viewModel.getLink { [weak self] (link) in
            if let link = link, let fileUrl = URL(string: link) {
                var request = URLRequest(url: fileUrl)
                request.headers.add(name: "ACCEPT-LANGUAGE", value: Util.languageOfContent())
                self?.webView.load(request)
            } else {
                self?.errorButton.isHidden = false
                self?.errorLabel.isHidden = false
            }
        }
    }
    
    @objc private func backButtonClicked() {
        viewModel.pop()
    }

    @objc func keyboardWillShow(notification:NSNotification){
        
        if self.view.frame.height <= 570 {
            return
        }
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            bottomConstraint.constant = keyboardHeight * -1
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.view.layoutIfNeeded()
            }
        }
        
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {

        if self.view.frame.height <= 570 {
            return
        }
        
        bottomConstraint.constant = 0
        
    }
    
    @IBAction func repeatButtonClicked(_ sender: Any) {
        loadPage()
    }
    
    private func disableLoadAnimation() {
        if animationView.isHidden {
            return
        }
        animationView.isHidden = true
        animationView.stop()
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
      if keyPath == #keyPath(WKWebView.url) {
        if let url = self.webView.url {
            if let params = url.params()["params"] as? String {
                if let data = params.data(using: .utf8, allowLossyConversion: false) {
                    let paramsDict = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                    if let method = paramsDict?["method"] as? String, let value = paramsDict?["value"] as? String, let id = paramsDict?["id"] as? String {
                        viewModel.cardWasAdded(id: id, type: method, value: value)
                    }
                }
            }
         }
      }
   }
}

extension NewPurseWebViewVC: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("MYLOG: \(message.body)")
    }
}

extension NewPurseWebViewVC: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void)
    {
        if(navigationAction.navigationType == .other)
        {
            if let redirectUrl = navigationAction.request.url
            {
                if redirectUrl.path.isEmpty {
                    disableLoadAnimation()
                }
            }
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        disableLoadAnimation()
    }
    
}
