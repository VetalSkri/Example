//
//  ChatSectionTableViewCell.swift
//  Backit
//
//  Created by Александр Кузьмин on 19/12/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class ChatSectionTableViewCell: UITableViewCell {

    
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupCell(text: String) {
        self.backgroundColor = .clear
        self.containerView.backgroundColor = .clear
        
        sectionTitleLabel.font = .medium15
        sectionTitleLabel.textColor = .london
        sectionTitleLabel.text = text
    }
}
