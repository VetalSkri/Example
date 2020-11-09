//
//  AttachSocialViewController.swift
//  Backit
//
//  Created by Александр Кузьмин on 28/01/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit
protocol AttachSocialViewControllerDelegate: class {
    func attachClicked(email: String, socialName: String, socialType: SocialType, socialToken: String)
}

class AttachSocialViewController: UIViewController {
    
    weak var delegate: AttachSocialViewControllerDelegate?
    
    @IBOutlet weak var maniContainerView: UIView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var attachButton: UIButton!
    
    //private var hasLoaded = false
    var email: String?
    var socialName: String?
    var socialType: SocialType?
    var socialToken: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .clear
        maniContainerView.backgroundColor = .zurich
        maniContainerView.cornerRadius = 10
        maniContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        mainTitleLabel.font = .bold20
        mainTitleLabel.textColor = .sydney
        mainTitleLabel.text = "\(NSLocalizedString("Bind", comment: "")) \(socialName ?? "")?"
        
        descriptionLabel.font = .medium15
        descriptionLabel.textColor = .london
        descriptionLabel.text = "\(NSLocalizedString("You have an account registered at", comment: "")) \(email ?? ""). \(NSLocalizedString("Bind your", comment: "")) \(socialName ?? "") \(NSLocalizedString("account to your Backit account?", comment: ""))"
        
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        cancelButton.setTitleColor(UIColor.sydney, for: .normal)
        cancelButton.titleLabel?.font = .semibold15
        cancelButton.backgroundColor = .paris
        cancelButton.cornerRadius = 5
        
        attachButton.setTitle(NSLocalizedString("Bind", comment: ""), for: .normal)
        attachButton.setTitleColor(UIColor.zurich, for: .normal)
        attachButton.titleLabel?.font = .semibold15
        attachButton.backgroundColor = .sydney
        attachButton.cornerRadius = 5
    }
    
    
    
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func attachButtonClicked(_ sender: Any) {
        delegate?.attachClicked(email: self.email ?? "", socialName: self.socialName ?? "", socialType: self.socialType ?? .vk, socialToken: self.socialToken ?? "")
        self.dismiss(animated: true, completion: nil)
    }
    
}
