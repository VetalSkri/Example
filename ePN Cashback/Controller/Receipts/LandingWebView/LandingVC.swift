//
//  LandingVC.swift
//  Backit
//
//  Created by Александр Кузьмин on 20/11/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import WebKit

class LandingVC: UIViewController {

    var viewModel: LandingViewModel!
    var webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = .zurich
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func setUpNavigationBar() {
        title = NSLocalizedString("Lottery", comment: "")
        navigationController?.navigationItem.hidesSearchBarWhenScrolling = true
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.barTintColor = .zurich
        navigationController?.navigationBar.isTranslucent = false
        
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"back")!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc func backButtonTapped() {
        viewModel.back()
    }
    
    private func setupView() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(webView)
        webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        if let url = viewModel.getUrl() {
            webView.load(URLRequest(url: url))
        }
    }
}
