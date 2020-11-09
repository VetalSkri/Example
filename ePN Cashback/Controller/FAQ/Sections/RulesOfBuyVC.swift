//
//  RulesOfBuyVC.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 30/04/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class RulesOfBuyVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    private let HEIGHT_WIDTH_IMAGE_SIZE = CGFloat(40)
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationBar()
        setUpMainInfo()
        
    }
    
    func setUpNavigationBar() {
        title = NSLocalizedString("FAQ_rules", comment: "")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.sydney,
            NSAttributedString.Key.font : UIFont.semibold17
        ]
        navigationController?.navigationBar.backgroundColor = .zurich
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named:"back")!.withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    func setUpMainInfo() {
        self.view.backgroundColor = .zurich
        
        let mainContainer = UIView()
        let image1 = UIImageView()
        let image2 = UIImageView()
        
        let image4 = UIImageView()
        let headTitle1 = UILabel()
        let headTitle2 = UILabel()
        let headTitle4 = UILabel()
        let mainTextTitle1 = UILabel()
        let mainTextTitle2 = UILabel()
        let mainTextTitle4 = UILabel()
        
        mainContainer.backgroundColor = .clear
        mainContainer.translatesAutoresizingMaskIntoConstraints = false
        image1.translatesAutoresizingMaskIntoConstraints = false
        image2.translatesAutoresizingMaskIntoConstraints = false
        image4.translatesAutoresizingMaskIntoConstraints = false
        headTitle1.translatesAutoresizingMaskIntoConstraints = false
        headTitle2.translatesAutoresizingMaskIntoConstraints = false
        headTitle4.translatesAutoresizingMaskIntoConstraints = false
        mainTextTitle1.translatesAutoresizingMaskIntoConstraints = false
        mainTextTitle2.translatesAutoresizingMaskIntoConstraints = false
        mainTextTitle4.translatesAutoresizingMaskIntoConstraints = false
        
        image1.image = UIImage(named: "clearBag")
        image2.image = UIImage(named: "offAds")
        image4.image = UIImage(named: "buyOnSite")
        image1.contentMode = .scaleAspectFit
        image2.contentMode = .scaleAspectFit
        image4.contentMode = .scaleAspectFit
        
        headTitle1.text = NSLocalizedString("FAQ_Rules_head1", comment: "")
        headTitle2.text = NSLocalizedString("FAQ_Rules_head2", comment: "")
        headTitle4.text = NSLocalizedString("FAQ_Rules_head4", comment: "")
        headTitle1.numberOfLines = 0
        headTitle2.numberOfLines = 0
        headTitle4.numberOfLines = 0
        headTitle1.textAlignment = .left
        headTitle2.textAlignment = .left
        headTitle4.textAlignment = .left
        headTitle1.textColor = .sydney
        headTitle2.textColor = .sydney
        headTitle4.textColor = .sydney
        headTitle1.font = .bold17
        headTitle2.font = .bold17
        headTitle4.font = .bold17
        
        mainTextTitle1.text = NSLocalizedString("FAQ_Rules_main1", comment: "")
        mainTextTitle2.text = NSLocalizedString("FAQ_Rules_main2", comment: "")
        mainTextTitle4.text = NSLocalizedString("FAQ_Rules_main4", comment: "")
        mainTextTitle1.numberOfLines = 0
        mainTextTitle2.numberOfLines = 0
        mainTextTitle4.numberOfLines = 0
        mainTextTitle1.textAlignment = .left
        mainTextTitle2.textAlignment = .left
        mainTextTitle4.textAlignment = .left
        mainTextTitle1.textColor = .sydney
        mainTextTitle2.textColor = .sydney
        mainTextTitle4.textColor = .sydney
        mainTextTitle1.font = .medium15
        mainTextTitle2.font = .medium15
        mainTextTitle4.font = .medium15
        
        scrollView.addSubview(mainContainer)
        mainContainer.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        mainContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
        mainContainer.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        mainContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0).isActive = true
        
        mainContainer.addSubview(image1)
        image1.topAnchor.constraint(equalTo: mainContainer.topAnchor, constant: 20).isActive = true
        image1.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor, constant: 20).isActive = true
        image1.heightAnchor.constraint(equalToConstant: HEIGHT_WIDTH_IMAGE_SIZE).isActive = true
        image1.widthAnchor.constraint(equalToConstant: HEIGHT_WIDTH_IMAGE_SIZE).isActive = true
        
        mainContainer.addSubview(headTitle1)
        headTitle1.leadingAnchor.constraint(equalTo: image1.trailingAnchor, constant: 16).isActive = true
        headTitle1.centerYAnchor.constraint(equalTo: image1.centerYAnchor, constant: 0).isActive = true
        headTitle1.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor, constant: -20).isActive = true
        mainContainer.addSubview(mainTextTitle1)
        mainTextTitle1.topAnchor.constraint(equalTo: image1.bottomAnchor, constant: 10).isActive = true
        mainTextTitle1.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor, constant: 20).isActive = true
        mainTextTitle1.centerXAnchor.constraint(equalTo: mainContainer.centerXAnchor, constant: 0).isActive = true
        
        mainContainer.addSubview(image2)
        image2.heightAnchor.constraint(equalToConstant: HEIGHT_WIDTH_IMAGE_SIZE).isActive = true
        image2.widthAnchor.constraint(equalToConstant: HEIGHT_WIDTH_IMAGE_SIZE).isActive = true
        image2.topAnchor.constraint(equalTo: mainTextTitle1.bottomAnchor, constant: 30).isActive = true
        image2.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor, constant: 20).isActive = true
        mainContainer.addSubview(headTitle2)
        headTitle2.leadingAnchor.constraint(equalTo: image2.trailingAnchor, constant: 16).isActive = true
        headTitle2.centerYAnchor.constraint(equalTo: image2.centerYAnchor, constant: 0).isActive = true
        headTitle2.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor, constant: -20).isActive = true
        mainContainer.addSubview(mainTextTitle2)
        mainTextTitle2.topAnchor.constraint(equalTo: headTitle2.bottomAnchor, constant: 10).isActive = true
        mainTextTitle2.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor, constant: 20).isActive = true
        mainTextTitle2.centerXAnchor.constraint(equalTo: mainContainer.centerXAnchor, constant: 0).isActive = true
        
        mainContainer.addSubview(image4)
        image4.heightAnchor.constraint(equalToConstant: HEIGHT_WIDTH_IMAGE_SIZE).isActive = true
        image4.widthAnchor.constraint(equalToConstant: HEIGHT_WIDTH_IMAGE_SIZE).isActive = true
        image4.topAnchor.constraint(equalTo: mainTextTitle2.bottomAnchor, constant: 30).isActive = true
        image4.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor, constant: 20).isActive = true
        mainContainer.addSubview(headTitle4)
        headTitle4.leadingAnchor.constraint(equalTo: image4.trailingAnchor, constant: 16).isActive = true
        headTitle4.centerYAnchor.constraint(equalTo: image4.centerYAnchor, constant: 0).isActive = true
        headTitle4.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor, constant: -20).isActive = true
        mainContainer.addSubview(mainTextTitle4)
        mainTextTitle4.topAnchor.constraint(equalTo: headTitle4.bottomAnchor, constant: 10).isActive = true
        mainTextTitle4.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor, constant: 20).isActive = true
        mainTextTitle4.centerXAnchor.constraint(equalTo: mainContainer.centerXAnchor, constant: 0).isActive = true
        mainTextTitle4.bottomAnchor.constraint(equalTo: mainContainer.bottomAnchor, constant: -30).isActive = true
        
    }
}
