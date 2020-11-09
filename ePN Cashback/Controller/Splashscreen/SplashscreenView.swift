//
//  SplashscreenView.swift
//  Backit
//
//  Created by Александр Кузьмин on 15/01/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit
import Lottie

class SplashscreenView: UIView {
    
    var isFirstLayout = true
    var complete: (()->())?
    @IBOutlet weak var logoImageView: UIImageView!
    
    override func layoutSubviews() {
        if isFirstLayout {
            isFirstLayout = false
            setupView()
        }
    }
    
    func setupView() {
        let launchInstructor = LaunchInstructor.configure()
        switch launchInstructor {
        case .auth:
            let animationView = AnimationView(name: "nachaloLogin")
            animationView.loopMode = .playOnce
            animationView.contentMode = .scaleAspectFill
            addSubview(animationView)
            animationView.translatesAutoresizingMaskIntoConstraints = false
            animationView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
            animationView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
            animationView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
            animationView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
            layoutSubviews()
            animationView.play { [weak self] _ in
                self?.complete?()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.41) { [weak self] in
                self?.backgroundColor = .clear
                self?.logoImageView.isHidden = true
            }
            break
        default:
            let animationView = AnimationView(name: (Util.languageOfContent() == "ru") ? "nachalo" : "nachaloEn")
            animationView.loopMode = .playOnce
            animationView.contentMode = .scaleAspectFill
            addSubview(animationView)
            view.bringSubviewToFront(logoImageView)
            animationView.translatesAutoresizingMaskIntoConstraints = false
            animationView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
            animationView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
            animationView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
            animationView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
            layoutSubviews()
            animationView.play { [weak self] _ in
                self?.complete?()
            }
            break
        }
    }
    
}
