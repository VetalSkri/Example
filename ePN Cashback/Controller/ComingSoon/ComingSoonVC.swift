//
//  ComingSoonVC.swift
//  CashBackEPN
//
//  Created by Александр Кузьмин on 22/05/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class ComingSoonVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var goButton: EPNButton!
    var viewModel: ComingSoonModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
        setupView()
    }
    
    func setUpNavigationBar() {
        navigationController?.navigationBar.barTintColor = .zurich
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.sydney , NSAttributedString.Key.font : UIFont.semibold17]
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "back")!.withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @objc private func backButtonTapped() {
        viewModel.goOnBack()
    }
    
    private func setupView() {
        self.view.backgroundColor = .zurich
        goButton.style = .primary
        
        goButton.handler = { [weak self] (button) in
            self?.viewModel.goToPage()
        }
        title = viewModel.titleHeader
        imageView.image = viewModel.image
        descriptionLabel.text = viewModel.descriptionTitle
        descriptionLabel.font = .medium15
        descriptionLabel.textColor = .sydney
        goButton.text = viewModel.buttonTitle
    }
}
