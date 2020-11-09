//
//  ProfileHeaderView.swift
//  Backit
//
//  Created by Александр Кузьмин on 01/04/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit

protocol ProfileHeaderViewDelegate: class {
    func avatarClicked()
    func vkButtonTap()
    func facebookButtonTap()
    func googleButtonTap()
}

class ProfileHeaderView: UIView {

    weak var delegate: ProfileHeaderViewDelegate?
    private var isFirstLayout = true
    
    //Main container
    @IBOutlet weak var mainContainerView: UIView!
    
    //Profile avatar fields
    @IBOutlet weak var avatarContainerView: UIView!
    @IBOutlet weak var cameraImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIRemoteImageView!
    @IBOutlet weak var avatarFirstCharLabel: UILabel!
    @IBOutlet weak var ringProgressView: UIView!
    private var progressView: RingProgressView!
    @IBOutlet weak var avatarShadowView: UIView!
    
    
    //Title label
    @IBOutlet weak var titleLabel: UILabel!
    
    //Social buttons - facebook
    @IBOutlet weak var facebookButtonView: UIView!
    @IBOutlet weak var facebookImageView: UIImageView!
    @IBOutlet weak var facebookCancelWidth: NSLayoutConstraint!
    @IBOutlet weak var facebookLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var facebookCloseImageView: UIImageView!
    //Social buttons - vkontakte
    @IBOutlet weak var vkButtonView: UIView!
    @IBOutlet weak var vkImageView: UIImageView!
    @IBOutlet weak var vkCancelWidth: NSLayoutConstraint!
    @IBOutlet weak var vkLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var vkCloseImageView: UIImageView!
    //Social buttons - google
    @IBOutlet weak var googleButtonView: UIView!
    @IBOutlet weak var googleImageView: UIImageView!
    @IBOutlet weak var googleCancelWidth: NSLayoutConstraint!
    @IBOutlet weak var googleLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var googleCloseImageView: UIImageView!
    
    class func instanceFromNib() -> ProfileHeaderView {
        return UINib(nibName: "ProfileHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ProfileHeaderView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isFirstLayout {
            isFirstLayout = false
            setupView()
        }
    }
    
    private func setupView() {
        mainContainerView.backgroundColor = .paris
        
        titleLabel.font = .medium11
        titleLabel.textColor = .moscow
        titleLabel.text = NSLocalizedString("Link social networks in order to log in with one click:", comment: "")
        
        facebookButtonView.cornerRadius = 19
        vkButtonView.cornerRadius = 19
        googleButtonView.cornerRadius = 19
        
        avatarContainerView.cornerRadius = 42
        avatarContainerView.backgroundColor = .sydney
        avatarContainerView.borderColor = .minsk
        avatarContainerView.borderWidth = 2
        avatarShadowView.backgroundColor = UIColor.london.withAlphaComponent(0.5)
        avatarFirstCharLabel.textColor = .zurich
        avatarFirstCharLabel.font = .bold32
        
        progressView = RingProgressView(frame: .zero)
        ringProgressView.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.topAnchor.constraint(equalTo: ringProgressView.topAnchor, constant: 0).isActive = true
        progressView.bottomAnchor.constraint(equalTo: ringProgressView.bottomAnchor, constant: 0).isActive = true
        progressView.leadingAnchor.constraint(equalTo: ringProgressView.leadingAnchor, constant: 0).isActive = true
        progressView.trailingAnchor.constraint(equalTo: ringProgressView.trailingAnchor, constant: 0).isActive = true
        progressView.startColor = .budapest
        progressView.endColor = .budapest
        progressView.backgroundColor = .clear
        progressView.backgroundRingColor = .clear
        progressView.ringWidth = 4
        progressView.progress = 0.0
        progressView.mkShadowOpacity = 0.0
        progressView.style = .square
        progressView.isHidden = true
        
        ringProgressView.cornerRadius = 44
        
        let facebookTapGesture = UITapGestureRecognizer(target: self, action: #selector(fbTapped))
        let vkTapGesture = UITapGestureRecognizer(target: self, action: #selector(vkTapped))
        let googleTapGesture = UITapGestureRecognizer(target: self, action: #selector(googleTapped))
        facebookButtonView.addGestureRecognizer(facebookTapGesture)
        vkButtonView.addGestureRecognizer(vkTapGesture)
        googleButtonView.addGestureRecognizer( googleTapGesture)
    }
    
    func setup(avatarUrl: String, firstUserLetter: String, fbBind: Bool, vkBind: Bool, googleBind: Bool) {
        if avatarUrl.isEmpty {
            avatarImageView.image = UIImage()
            avatarFirstCharLabel.text = firstUserLetter
        } else {
            avatarImageView.loadImageUsingUrlString(urlString: avatarUrl, defaultImage: avatarImageView.image ?? UIImage())
            avatarFirstCharLabel.text = ""
        }
        setFacebookBind(fbBind)
        setGoogleBind(googleBind)
        setVkBind(vkBind)
    }
    
    func changeProgress(progress: Double) {
        if progressView == nil {
            return
        }
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.progressView.progress = progress
        }
        progressView.isHidden = progress <= 0.0
        ringProgressView.alpha = (progress <= 0.0) ? 0.0 : 0.5
        ringProgressView.backgroundColor = (progress <= 0.0) ? .clear : .white
        cameraImageView.isHidden = (progress > 0.0)
    }
    
    private func setFacebookBind(_ bind: Bool) {
        facebookButtonView.backgroundColor = bind ? .moscow : .zurich
        facebookImageView.image = UIImage(named: bind ? "fb_white" : "fb")
        facebookCloseImageView.isHidden = !bind
        facebookCancelWidth.constant = bind ? 14 : 0
        facebookLeftConstraint.constant = bind ? 9 : 0
    }
    
    private func setGoogleBind(_ bind: Bool) {
        googleButtonView.backgroundColor = bind ? .moscow : .zurich
        googleImageView.image = UIImage(named: bind ? "google_white" : "google")
        googleCloseImageView.isHidden = !bind
        googleCancelWidth.constant = bind ? 14 : 0
        googleLeftConstraint.constant = bind ? 9 : 0
    }
    
    private func setVkBind(_ bind: Bool) {
        vkButtonView.backgroundColor = bind ? .moscow : .zurich
        vkImageView.image = UIImage(named: bind ? "vk_white" : "vk")
        vkCloseImageView.isHidden = !bind
        vkCancelWidth.constant = bind ? 14 : 0
        vkLeftConstraint.constant = bind ? 9 : 0
    }
    
    @IBAction func avatarTapGesture(_ sender: Any) {
        delegate?.avatarClicked()
    }
    
    @objc func fbTapped() {
        delegate?.facebookButtonTap()
    }
    
    @objc func vkTapped() {
        delegate?.vkButtonTap()
    }
    
    @objc func googleTapped() {
        delegate?.googleButtonTap()
    }
    
}
