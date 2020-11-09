//
//  FaqTableViewCell.swift
//  CashBackEPN
//
//  Created by Александр on 13/05/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class FaqTableViewCell: UITableViewCell {

    @IBOutlet weak var questionTitleLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var answerLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var roundedContentView: UIView!
    @IBOutlet weak var questionContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        roundedContentView.clipsToBounds = true
        roundedContentView.backgroundColor = .zurich
        //questionContainerView.backgroundColor = .mainBg
        contentView.backgroundColor = .zurich       
        roundedContentView.layer.cornerRadius = CommonStyle.cornerRadius
        roundedContentView.borderWidth = CommonStyle.borderWidth
        roundedContentView.borderColor = .montreal
    }
    
    var viewModel: FAQCellViewModel? {
        willSet(viewModel){
            guard let viewModel = viewModel else { return }
            
            questionTitleLabel.text = viewModel.titleOfQuestion()
            arrowImageView.image = UIImage(named:"down")
            answerLabel.text = (viewModel.openned()) ? viewModel.titleOfAnswer() : ""
            questionTitleLabel.numberOfLines = (viewModel.openned()) ? 0 : 2
            questionTitleLabel.layoutIfNeeded()
            answerLabelTopConstraint.constant = (viewModel.openned()) ? 10 : 0
            
            questionTitleLabel.font = .medium15
            questionTitleLabel.textColor = .sydney
            answerLabel.font = .medium15
            answerLabel.textColor = .london
            
        }
    }
    
}
