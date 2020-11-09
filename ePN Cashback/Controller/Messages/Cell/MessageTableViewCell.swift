//
//  MessageTableViewCell.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 14/06/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var conteinerView: UIView!
    @IBOutlet weak var messageTitleLabel: UILabel!
    @IBOutlet weak var messageBodyLabel: UILabel!
    @IBOutlet weak var bodyLabelTopSpaceConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(title: String, body: String, isRead: Bool) {
        self.conteinerView.backgroundColor = isRead ? .paris : .montreal
        self.messageBodyLabel.text = body
        self.bodyLabelTopSpaceConstraint.constant = title.isEmpty ? 0 : 10
        self.messageTitleLabel.text = title
        conteinerView.cornerRadius = CommonStyle.cornerRadius
        self.messageBodyLabel.textColor = .sydney
        self.messageBodyLabel.font = .semibold17
        self.messageTitleLabel.textColor = .sydney
        self.messageTitleLabel.font = .bold17
    }

}
