//
//  WhatToDoAfterVC.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 30/04/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class WhatToDoAfterVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    private let HEIGHT_WIDTH_IMAGE_SIZE = CGFloat(100)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        //setUpMainInfo()
        setupView()
    }
    
    func setUpNavigationBar() {
        title = NSLocalizedString("FAQ_whatToDoAfterBuy", comment: "")
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.sydney,
            NSAttributedString.Key.font : UIFont.semibold17
        ]
        navigationController?.navigationBar.backgroundColor = .zurich
        navigationController?.navigationBar.isTranslucent = false
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named:"back")!.withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupView() {
        self.view.backgroundColor = .zurich
        
        self.firstLabel.font = .medium15
        self.firstLabel.textColor = .sydney
        self.firstLabel.text = NSLocalizedString("FAQ_WhatToDo_main1", comment: "")
        
        self.secondLabel.font = .medium15
        self.secondLabel.textColor = .sydney
        self.secondLabel.text = NSLocalizedString("FAQ_WhatToDo_main2", comment: "")
        
        self.thirdLabel.font = .medium15
        self.thirdLabel.textColor = .sydney
        self.thirdLabel.text = NSLocalizedString("FAQ_WhatToDo_main3", comment: "")
    }
    
    //func setUpMainInfo() {
//        self.view.backgroundColor = .mainBg
//        let mainContainer = UIView()
//        let mainTextTitle1 = UILabel()
//        let mainTextTitle2 = UILabel()
//        let mainTextTitle3 = UILabel()
//
//        let image1 = UIImageView()
//        let image2 = UIImageView()
//        let image3 = UIImageView()
//
//        mainContainer.backgroundColor = .clear
//        mainContainer.translatesAutoresizingMaskIntoConstraints = false
//        image1.translatesAutoresizingMaskIntoConstraints = false
//        image2.translatesAutoresizingMaskIntoConstraints = false
//        image3.translatesAutoresizingMaskIntoConstraints = false
//        mainTextTitle1.translatesAutoresizingMaskIntoConstraints = false
//        mainTextTitle2.translatesAutoresizingMaskIntoConstraints = false
//        mainTextTitle3.translatesAutoresizingMaskIntoConstraints = false
//
//        image1.image = UIImage(named: "illustration3.1")
//        image2.image = UIImage(named: "illustration3.2")
//        image3.image = UIImage(named: "illustration3.3")
//        image1.contentMode = .scaleAspectFit
//        image2.contentMode = .scaleAspectFit
//        image3.contentMode = .scaleAspectFit
//
//
//        mainTextTitle1.text = NSLocalizedString("FAQ_WhatToDo_main1", comment: "")
//        mainTextTitle2.text = NSLocalizedString("FAQ_WhatToDo_main2", comment: "")
//        mainTextTitle3.text = NSLocalizedString("FAQ_WhatToDo_main3", comment: "")
//
//        mainTextTitle1.numberOfLines = 0
//        mainTextTitle2.numberOfLines = 0
//        mainTextTitle3.numberOfLines = 0
//
//        mainTextTitle1.textAlignment = .center
//        mainTextTitle2.textAlignment = .center
//        mainTextTitle3.textAlignment = .center
//
//        mainTextTitle1.textColor = .main
//        mainTextTitle2.textColor = .main
//        mainTextTitle3.textColor = .main
//
//        mainTextTitle1.font = .medium15
//        mainTextTitle2.font = .medium15
//        mainTextTitle3.font = .medium15
//
//        scrollView.addSubview(mainContainer)
//        mainContainer.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
//        mainContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
//        mainContainer.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
//        mainContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0).isActive = true
//
//        mainContainer.addSubview(image1)
//        image1.topAnchor.constraint(equalTo: mainContainer.topAnchor, constant: 10).isActive = true
//        image1.centerXAnchor.constraint(equalTo: mainContainer.centerXAnchor, constant: 0).isActive = true
//        image1.heightAnchor.constraint(equalToConstant: HEIGHT_WIDTH_IMAGE_SIZE).isActive = true
//        image1.widthAnchor.constraint(equalToConstant: HEIGHT_WIDTH_IMAGE_SIZE).isActive = true
//
//
//        mainContainer.addSubview(mainTextTitle1)
//        mainTextTitle1.topAnchor.constraint(equalTo: image1.bottomAnchor, constant: 10).isActive = true
//        mainTextTitle1.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor, constant: 30).isActive = true
//        mainTextTitle1.centerXAnchor.constraint(equalTo: mainContainer.centerXAnchor, constant: 0).isActive = true
//
//        mainContainer.addSubview(image2)
//        image2.topAnchor.constraint(equalTo: mainTextTitle1.bottomAnchor, constant: 30).isActive = true
//        image2.centerXAnchor.constraint(equalTo: mainContainer.centerXAnchor, constant: 0).isActive = true
//        image2.heightAnchor.constraint(equalToConstant: HEIGHT_WIDTH_IMAGE_SIZE).isActive = true
//        image2.widthAnchor.constraint(equalToConstant: HEIGHT_WIDTH_IMAGE_SIZE).isActive = true
//
//        mainContainer.addSubview(mainTextTitle2)
//        mainTextTitle2.topAnchor.constraint(equalTo: image2.bottomAnchor, constant: 10).isActive = true
//        mainTextTitle2.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor, constant: 30).isActive = true
//        mainTextTitle2.centerXAnchor.constraint(equalTo: mainContainer.centerXAnchor, constant: 0).isActive = true
//
//        mainContainer.addSubview(image3)
//        image3.topAnchor.constraint(equalTo: mainTextTitle2.bottomAnchor, constant: 30).isActive = true
//        image3.centerXAnchor.constraint(equalTo: mainContainer.centerXAnchor, constant: 0).isActive = true
//        image3.heightAnchor.constraint(equalToConstant: HEIGHT_WIDTH_IMAGE_SIZE).isActive = true
//        image3.widthAnchor.constraint(equalToConstant: HEIGHT_WIDTH_IMAGE_SIZE).isActive = true
//
//        mainContainer.addSubview(mainTextTitle3)
//        mainTextTitle3.topAnchor.constraint(equalTo: image3.bottomAnchor, constant: 10).isActive = true
//        mainTextTitle3.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor, constant: 30).isActive = true
//        mainTextTitle3.centerXAnchor.constraint(equalTo: mainContainer.centerXAnchor, constant: 0).isActive = true
//        mainTextTitle3.bottomAnchor.constraint(equalTo: mainContainer.bottomAnchor, constant: -30).isActive = true
//
//    }
    
}
