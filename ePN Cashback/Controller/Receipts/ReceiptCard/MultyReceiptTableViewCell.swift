//
//  MultyReceiptTableViewCell.swift
//  Backit
//
//  Created by Ivan Nikitin on 02/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class MultyReceiptTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var logoImageVIew: UIRemoteImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
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
    }

    var viewModel: OfflineCBViewCellModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            contentView.backgroundColor = .zurich
            titleLabel.text = viewModel.title
            descriptionLabel.text = viewModel.description
            logoImageVIew.loadImageUsingUrlString(urlString: viewModel.urlStringOfLogo(), defaultImage: UIImage(named: "defaultImageOffCb")!.withRenderingMode(.alwaysOriginal))
            
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
