//
//  ProfileCommonCell.swift
//  Backit
//
//  Created by Александр Кузьмин on 02/04/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit

class ProfileCommonCell: UITableViewCell {

    //MainContainer
    @IBOutlet weak var mainContainerView: UIView!
    
    //Title and subtitle
    @IBOutlet weak var menuTitleLabel: UILabel!
    @IBOutlet weak var menuSubtitleLabel: UILabel!
    @IBOutlet weak var menuSubtitleLabelHeight: NSLayoutConstraint!
    
    //Images
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    //Separator view
    @IBOutlet weak var separatorView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(item: ProfileMenuItem) {
        selectionStyle = .none
        
        menuTitleLabel.text = item.title
        menuTitleLabel.textColor = item.type == .deleteAccount ? .prague : .moscow
        menuTitleLabel.font = .medium15
        
        menuSubtitleLabel.text = item.subtitle
        menuSubtitleLabel.textColor = .minsk
        menuSubtitleLabel.font = .medium11
        menuSubtitleLabelHeight.constant = (item.subtitle?.isEmpty ?? true) ? 0 : 17
        
        arrowImageView.isHidden = !(item.status == .none)
        arrowImageView.image = UIImage(named: item.type == .deleteAccount ? "redGoArrow" : "goArrow")
        statusImageView.isHidden = (item.status == .none)
        statusImageView.image = UIImage(named: (item.status == .done) ? "doneIcon" : "warning")
        
        separatorView.backgroundColor = .montreal
    }
}
