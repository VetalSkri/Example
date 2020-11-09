//
//  ProgressView.swift
//  Backit
//
//  Created by Виталий Скриганюк on 26.06.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//
import UIKit
import SnapKit
import TransitionButton

class BottomPaymentView: UIView {
    
    // Containers View's
    private let containerView = UIView()
    private let infoStack = UIStackView()
    private let progressContainerView = UIView()
    private var businesView = UIView()
    // Content View's
    private let infoLabel = UILabel()
    private var forwardButton = EPNButton(style: .primary, size: .small)
    private let progressView = UIView()
    
    weak var delegate: BottomPaymentViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
        self.view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        self.addSubview(containerView)
        
        infoStack.addSubview(infoLabel)
        infoStack.addSubview(progressContainerView)
        
        infoLabel.font = .semibold15
        
        progressContainerView.addSubview(progressView)
        progressContainerView.layer.cornerRadius = 6
        progressContainerView.layer.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1).cgColor
        
        progressView.layer.cornerRadius = 6
        progressView.backgroundColor = .vilnius
        
        businesView.addSubview(forwardButton)
        
        forwardButton.handler = {[weak self] button in
            self?.continueAction()
        }
    
        forwardButton.text = NSLocalizedString("Continue", comment: "")
        
        containerView.addSubview(infoStack)
        containerView.addSubview(businesView)
    }
    
    private func continueAction() {
        delegate?.forward()
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        infoStack.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        businesView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
            make.left.equalTo(infoStack.snp.right)
            make.bottom.equalToSuperview().inset(16)
        }
        forwardButton.cornerRadius = 2
        forwardButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        infoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview()
        }
        progressContainerView.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(8)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(10)
            make.left.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
        progressView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(0)
            make.bottom.equalToSuperview()
        }
    }
    
    func updateProgress(status: Bool) {
        forwardButton.style = status ? .primary : .disabled
    }
    
    func progressAnimate(status: Bool) {
        if status {
            forwardButton.getTransionButton.startAnimation()
        } else {
            forwardButton.getTransionButton.stopAnimation(animationStyle: .normal, revertAfterDelay: 0.0, completion: nil)
        }
    }
    
    func setupView(data: BottomViewDataType, delegate: BottomPaymentViewDelegate) {
        self.delegate = delegate
        self.infoLabel.text = "\(Int(data.partSelected)) / \(Int(data.part)) " + NSLocalizedString("Part", comment: "")
        UIView.animate(withDuration: 0.5) {
            self.progressView.snp.updateConstraints{ make in
                make.width.equalTo(self.progressContainerView.frame.width * CGFloat(data.partSelected/data.part))
            }
            self.view.layoutIfNeeded()
        }
    }
}


