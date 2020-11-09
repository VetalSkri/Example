//
//  AboutAppVC.swift
//  CashBackEPN
//
//  Created by Александр on 14/05/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class AboutAppVC: UIViewController {

    @IBOutlet var viewModel: AboutAppViewModel!
    @IBOutlet weak var officialSiteLabel: UILabel!
    @IBOutlet weak var joinUsLabel: UILabel!
    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var dashedView: UIView!

    //dev instance fields
    @IBOutlet weak var devInstanceLabel: UILabel!
    @IBOutlet weak var devInstanceTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .zurich
        
        setUpNavigationBar()
        setupView()
    }
    
    private func setupView(){
        officialSiteLabel.text = viewModel.officialSite
        joinUsLabel.text = viewModel.joinUs
        appVersionLabel.text = viewModel.version
        officialSiteLabel.font = .semibold17
        joinUsLabel.font = .semibold17
        appVersionLabel.font = .medium13
        linkLabel.font = .semibold13
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.minsk.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [4, 4]

        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0), CGPoint(x: dashedView.frame.size.width, y: 0)])
        shapeLayer.path = path
        dashedView.layer.addSublayer(shapeLayer)
        
        officialSiteLabel.textColor = .sydney
        
        devInstanceLabel.font = .medium15
        devInstanceLabel.textColor = .sydney
        devInstanceTextField.font = .medium15
        devInstanceTextField.textColor = .sydney
        devInstanceTextField.text = Session.shared.dev_instance ?? ""
        
        #if DEBUG
        devInstanceTextField.isHidden = false
        devInstanceLabel.isHidden = false
        #else
        devInstanceTextField.isHidden = true
        devInstanceLabel.isHidden = true
        #endif
        officialSiteLabel.textColor = .sydney
        joinUsLabel.textColor = .sydney
        appVersionLabel.textColor = .minsk
        linkLabel.textColor = .sydney
        linkLabel.backgroundColor = .clear
    }
    
    func setUpNavigationBar() {
        title = viewModel.title
        navigationController?.navigationBar.barTintColor = .zurich
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.sydney , NSAttributedString.Key.font : UIFont.semibold17]
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "back")!.withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func epnLinkClicked(_ sender: Any) {
        viewModel.openEpnSite()
    }
    
    @IBAction func vkLinkClicked(_ sender: Any) {
        viewModel.openVk()
    }
    
    @IBAction func facebookLinkClicked(_ sender: Any) {
        viewModel.openFacebook()
    }
    
    @IBAction func telegramLinkClicked(_ sender: Any) {
        viewModel.openTelegram()
    }
    
    @IBAction func youtubeLinkClicked(_ sender: Any) {
        viewModel.openYoutube()
    }
    
    @IBAction func instagramLinkClicked(_ sender: Any) {
        viewModel.openInstagram()
    }
    
    @IBAction func devInstanceTextFieldEndEditing(_ sender: Any) {
        Session.shared.dev_instance = devInstanceTextField.text
    }
    
    
}
