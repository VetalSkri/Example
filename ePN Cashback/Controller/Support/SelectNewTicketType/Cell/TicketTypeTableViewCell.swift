//
//  TicketTypeTableViewCell.swift
//  Backit
//
//  Created by Александр Кузьмин on 12/11/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class TicketTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    private var ticketType: SupportTopicAttributes?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupCell(type: SupportTopicAttributes, isSelected: Bool) {
        selectionStyle = .none
        backgroundColor = .clear
        view.backgroundColor = .clear
        
        containerView.cornerRadius = 5
        containerView.backgroundColor = isSelected ? .budapest : .paris
        
        nameLabel.font = .medium15
        nameLabel.textColor = (isSelected) ? .zurich : .moscow
        nameLabel.text = type.name
        
        ticketType = type
    }
    
}
