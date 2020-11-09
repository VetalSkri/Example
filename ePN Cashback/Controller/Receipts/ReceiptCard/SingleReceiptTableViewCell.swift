//
//  SingleReceiptTableViewCell.swift
//  Backit
//
//  Created by Ivan Nikitin on 05/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

protocol SingleReceiptCellDelegate {
    func scanButtonClicked(id: Int)
}
class SingleReceiptTableViewCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var logoImageVIew: UIRemoteImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scanButton: UIButton!
    var delegate: SingleReceiptCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cardView.backgroundColor = .zurich
        cardView.borderColor = .montreal
        cardView.borderWidth = 1
        cardView.layer.masksToBounds = true
        cardView.cornerRadius = CommonStyle.newCornerRadius
        
        descriptionLabel.font = .semibold15
        descriptionLabel.textColor = .sydney
        titleLabel.font = .medium15
        titleLabel.textColor = .london
        scanButton.cornerRadius = 5
        scanButton.borderWidth = 1
        scanButton.borderColor = .sydney
        scanButton.backgroundColor = .zurich
        scanButton.setTitle(NSLocalizedString("ScanReceipt", comment: ""), for: .normal)
        scanButton.setTitleColor(.sydney, for: .normal)
        
    }
    
    @IBAction func goToScann(_ sender: UIButton) {
        guard let viewModel = viewModel as? OfflineCBViewCellViewModel else { return }
        delegate?.scanButtonClicked(id: viewModel.idOffer)
    }
    
    var viewModel: OfflineCBViewCellModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            contentView.backgroundColor = .zurich
            titleLabel.text = viewModel.title
            descriptionLabel.text = viewModel.description
            titleLabel.sizeToFit()
            logoImageVIew.loadImageUsingUrlString(urlString: viewModel.urlStringOfLogo(), defaultImage: UIImage(named: "defaultImageOffCb")!.withRenderingMode(.alwaysOriginal))
            
        }
    }
}
