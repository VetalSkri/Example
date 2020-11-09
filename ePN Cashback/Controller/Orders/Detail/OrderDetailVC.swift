//
//  OrderDetailVC.swift
//  Backit
//
//  Created by Александр Кузьмин on 24/03/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit
import ProgressHUD

class OrderDetailVC: UIViewController {

    var viewModel: OrderDetailViewModel!
    var shapeLayer = CAShapeLayer()
    
    //Main container scroll view
    @IBOutlet weak var scrollView: UIScrollView!
    //Main container view in scroll
    @IBOutlet weak var mainContainerView: UIView!
    
    //Top dashed view
    @IBOutlet weak var topDashedView: UIView!
    //Title and subtitle
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    //Offer image logo fields
    @IBOutlet weak var offerLogoContainerView: UIView!
    @IBOutlet weak var offerLogoImageView: UIRemoteImageView!
    //Offer info fields
    @IBOutlet weak var offerNameLabel: UILabel!
    @IBOutlet weak var offerDetailLabel: UILabel!
    //Order number button
    @IBOutlet weak var orderNumberContainerView: UIView!
    @IBOutlet weak var orderNumberLabel: UILabel!
    
    //Bottom view
    @IBOutlet weak var bottomContainerView: UIView!
    //Status description fields
    @IBOutlet weak var statusDescriptionLabel: UILabel!
    @IBOutlet weak var statusDescriptionImageView: UIImageView!
    
    //Button fields
    @IBOutlet weak var buttonContainerView: UIView!
    @IBOutlet weak var buttonContainerViewHeight: NSLayoutConstraint!
    var actionButton = EPNButton(style: .primary, size: .large1)
    
    //Product name fields
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productNameLabelTopConstraint: NSLayoutConstraint!
    
    //Help arrow imageview
    @IBOutlet weak var helpArrowImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstrainst()
        setUpNavigationBar()
        setupView()
    }

    private func setupSubviews() {
        buttonContainerView.addSubview(actionButton)
    }
    
    private func setupConstrainst() {
        actionButton.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.top.equalToSuperview().inset(10)
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        ProgressHUD.dismiss()
    }
    
    private func setUpNavigationBar() {
        title = viewModel.title()
        setLargeTitleDisplayMode(.never)
        navigationController?.navigationBar.barTintColor = .zurich
        navigationItem.hidesSearchBarWhenScrolling = false
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"back")!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    private func setupView() {
        setupTopContainer()
        setupBottomContainer()
        redrawDashed()
    }
    
    private func setupTopContainer() {
        scrollView.backgroundColor = .zurich
        
        mainTitleLabel.font = .semibold17
        mainTitleLabel.textColor = (viewModel.orderStatus() == OrderStatus.confirmed) ? .budapest : .sydney
        mainTitleLabel.text = viewModel.status()
        
        subtitleLabel.font = viewModel.isMultiOffer() ? .medium13 : .medium34
        if viewModel.isMultiOffer() {
            subtitleLabel.textColor = .london
        } else {
            subtitleLabel.textColor = (viewModel.orderStatus() == OrderStatus.confirmed) ? .budapest : .sydney
        }
        subtitleLabel.text = viewModel.subtitleText()
        
        offerLogoContainerView.backgroundColor = .paris
        offerLogoContainerView.cornerRadius = CommonStyle.cardCornerRadius
        if viewModel.isMultiOffer() {
            offerLogoImageView.image = UIImage(named: viewModel.offerLogoImage())
        } else {
            offerLogoImageView.loadImageUsingUrlString(urlString: viewModel.offerLogoImage(), defaultImage: UIImage())
        }
        
        offerNameLabel.text = viewModel.offerFirstDetail()
        offerNameLabel.textColor = .minsk
        offerNameLabel.font = .medium11
        
        offerDetailLabel.text = viewModel.offerDetail()
        offerDetailLabel.textColor = .minsk
        offerDetailLabel.font = .medium11
        
        orderNumberContainerView.backgroundColor = .zurich
        orderNumberContainerView.cornerRadius = CommonStyle.buttonCornerRadius
        orderNumberContainerView.borderColor = .montreal
        orderNumberContainerView.borderWidth = CommonStyle.borderWidth
        orderNumberLabel.text = viewModel.offerNumber()
        orderNumberLabel.font = .semibold13
        orderNumberLabel.textColor = .sydney
        
        helpArrowImageView.isHidden = !viewModel.showHelpArrow()
    }
    
    private func setupBottomContainer() {
        bottomContainerView.backgroundColor = .ottawa
        bottomContainerView.cornerRadius = CommonStyle.cardCornerRadius
        
        statusDescriptionLabel.text = viewModel.descriptionText()
        statusDescriptionLabel.textColor = .london
        statusDescriptionLabel.font = .medium13
        
        statusDescriptionImageView.image = UIImage(named: viewModel.statusImageName())
        
        productNameLabel.text = viewModel.productNameText()
        productNameLabel.textColor = .london
        productNameLabel.font = .medium13
        productNameLabelTopConstraint.constant = (productNameLabel.text?.count ?? 0 > 0) ? 16 : 0
        
        buttonContainerView.backgroundColor = .zurich
        buttonContainerViewHeight.constant = (viewModel.isShowActionButton()) ? 80 : 0
        buttonContainerView.isHidden = !viewModel.isShowActionButton()
        actionButton.isHidden = !viewModel.isShowActionButton()
        actionButton.text = viewModel.actionButtonText()
        actionButton.handler = {[weak self] button in
            self?.actionButtonClicked()
        }
    
    }
    
    private func redrawDashed() {
        topDashedView.subviews.forEach { (subview) in
            subview.layoutIfNeeded()
        }
        topDashedView.setNeedsLayout()
        topDashedView.layoutIfNeeded()
        shapeLayer.removeFromSuperlayer()
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [4, 4]
        shapeLayer.strokeColor = UIColor.minsk.cgColor
        shapeLayer.frame = topDashedView.bounds
        shapeLayer.fillColor = nil
        shapeLayer.path = UIBezierPath(roundedRect: topDashedView.bounds, cornerRadius: CommonStyle.cardCornerRadius).cgPath
        topDashedView.layer.addSublayer(shapeLayer)
        print("MYLOG: \(topDashedView.bounds)")
    }
    
    @objc func backButtonTapped() {
        viewModel.back()
    }

    @IBAction func orderNumberCopyButtonClicked(_ sender: Any) {
        self.orderNumberContainerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.orderNumberContainerView.transform = CGAffineTransform.identity
        }
        viewModel.copyOrderNumberToClipboard()
        let bannerView = SuccessCopyBannerView.instanceFromNib()
        bannerView.statusText = NSLocalizedString("Successfully", comment: "")
        bannerView.actionText = NSLocalizedString("Copied", comment: "")
        let banner = NotificationBanner(customView: bannerView)
        let delegate = UIApplication.shared.delegate as? AppDelegate
        banner.bannerHeight = 30 + CGFloat(delegate?.window?.safeAreaInsets.top ?? 0)
        banner.show()
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
            banner.dismiss()
        }
    }
    
    private func actionButtonClicked() {
        if viewModel.shouldLoadData {
            ProgressHUD.show()
            viewModel.actionButtonClicked(completion: {
                ProgressHUD.dismiss()
            })
        } else {
            viewModel.actionButtonClicked()
        }
    }
}
