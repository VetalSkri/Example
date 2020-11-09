//
//  DeleteProfileInfoVC.swift
//  Backit
//
//  Created by Ivan Nikitin on 04/03/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit
import TransitionButton
import XCoordinator

class DeleteProfileInfoVC: UIViewController {

    @IBOutlet weak var headerInfoLabel: UILabel!
    @IBOutlet weak var textInfoLabel: UILabel!
    @IBOutlet weak var nextButton: TransitionButton!
    @IBOutlet weak var topSeparatorView: UIView!
    
    private var router: UnownedRouter<ProfileRoute>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        initUIView()
    }
    
    func bindRouter(router: UnownedRouter<ProfileRoute>) {
        self.router = router
    }
    
    private func initUIView() {
        topSeparatorView.backgroundColor = .montreal
        headerInfoLabel.font = .bold20
        textInfoLabel.font = .medium15
        
        headerInfoLabel.textColor = .sydney
        textInfoLabel.textColor = .london
            
        headerInfoLabel.text = NSLocalizedString("delete_profile_title", comment: "")
        textInfoLabel.text = NSLocalizedString("delete_profile_message", comment: "")
        
        nextButton.setupButtonStyle(with: .black)
        nextButton.setTitle(NSLocalizedString("Continue", comment: ""), for: .normal)
        view.bringSubviewToFront(topSeparatorView)
    }

    @IBAction func continueTapped(_ sender: Any) {
        router.trigger(.deleteProfile)
    }
    
    private func setupNavigation() {
        title = NSLocalizedString(NSLocalizedString("delete_profile", comment: ""), comment: "")
        navigationController?.navigationBar.barTintColor = .zurich
        navigationController?.navigationBar.isTranslucent = false
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named:"back")!.withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }

    @objc func backButtonTapped() {
        router.trigger(.back)
    }
    

}
