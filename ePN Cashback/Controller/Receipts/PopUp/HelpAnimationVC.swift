//
//  HelpAnimationVC.swift
//  Backit
//
//  Created by Александр Кузьмин on 11/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import Lottie

class HelpAnimationVC: UIViewController {

    var viewModel: HelpAnimationViewModel!
    
    private var animationView: AnimationView!
    private var isFirstLayout = true
    private var isPlaying = false
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerCenterYConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var animationContainerView: UIView!
    @IBOutlet weak var closeButtonView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        switch viewModel.getType() {
        case .multi:
            Analytics.showEventAnimationPopUpMulty()
        case .scpecial:
            Analytics.showEventAnimationPopUpSpec()
        }
    }
    
    override func viewWillLayoutSubviews() {
        if isFirstLayout {
            isFirstLayout = false
            moveUpAnimation()
        }
    }
    
    private func setupView() {
        
        animationView = AnimationView(name: viewModel.illustrationName)
        animationView.loopMode = .playOnce
        animationView.contentMode = .scaleAspectFit
        animationContainerView.clipsToBounds = false
        animationContainerView.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.topAnchor.constraint(equalTo: animationContainerView.topAnchor, constant: 0).isActive = true
        animationView.bottomAnchor.constraint(equalTo: animationContainerView.bottomAnchor, constant: 0).isActive = true
        animationView.leadingAnchor.constraint(equalTo: animationContainerView.leadingAnchor, constant: 0).isActive = true
        animationView.trailingAnchor.constraint(equalTo: animationContainerView.trailingAnchor, constant: 0).isActive = true
        
        playAnimation()
        
        titleLabel.font = .bold17
        titleLabel.textColor = .sydney
        titleLabel.text = viewModel.title
        
        subtitleLabel.font = .semibold13
        subtitleLabel.textColor = .sydney
        subtitleLabel.text = viewModel.subtitle
        
        self.view.layoutSubviews()
    }
    
    private func moveUpAnimation() {
        self.containerCenterYConstraint.constant = self.view.frame.height
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: { [weak self] in
            self?.containerCenterYConstraint.constant = 0
            self?.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        viewModel.close()
    }
    
    @IBAction func replayClicked(_ sender: Any) {
        playAnimation()
    }
    
    
    private func playAnimation() {
        if !isPlaying {
            isPlaying = true
            animationView.play() { [weak self] (completed) in
                self?.isPlaying = false
            }
        }
    }
}
