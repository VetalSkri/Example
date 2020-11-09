//
//  TicketTableViewCell.swift
//  Backit
//
//  Created by Александр Кузьмин on 02/12/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class TicketTableViewCell: UITableViewCell {

    //Rounded container view
    @IBOutlet weak var containerView: UIView!
    
    //Subject of message
    @IBOutlet weak var subjectLabel: UILabel!
    
    //Dot mark of unread messages
    @IBOutlet weak var unreadMarkView: UIView!
    
    //Author of last message and last message
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    
    //Last message date
    @IBOutlet weak var lastMessageDataLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupView(ticket: SupportDialogsAttributes) {
        setupStyle(unread: !ticket.isRead && (ticket.lastUserRole == "support" || ticket.lastUserRole == "admin"))
        subjectLabel.text = ticket.subject
        authorLabel.text = "\(ticket.lastFromSupport ? ticket.lastFullName : NSLocalizedString("You", comment: "")):"
        lastMessageLabel.text = ticket.message
        
        if let updatedDate = ticket.updatedAt {
            let formatter = DateFormatter()
            formatter.locale = .current
            formatter.timeZone = .current
            formatter.dateFormat = "E, dd MMM yyyy"
            if Calendar.current.isDateInToday(updatedDate) {
                formatter.dateFormat = "HH:mm"
                lastMessageDataLabel.text = "\(NSLocalizedString("TodaySmall", comment: "")), \(formatter.string(from: updatedDate))"
            } else if Calendar.current.isDateInYesterday(updatedDate) {
                formatter.dateFormat = "HH:mm"
                lastMessageDataLabel.text = "\(NSLocalizedString("YesterdaySmall", comment: "")), \(formatter.string(from: updatedDate))"
            } else {
                lastMessageDataLabel.text = formatter.string(from: updatedDate)
            }
        } else {
            lastMessageDataLabel.text = ""
        }
        layoutIfNeeded()
    }
    
    private func setupStyle(unread: Bool) {
        selectionStyle = .none
        
        containerView.backgroundColor = .zurich
        containerView.cornerRadius = CommonStyle.newCornerRadius
        containerView.borderWidth = 1
        containerView.borderColor = .montreal
        
        subjectLabel.font = .semibold17
        subjectLabel.textColor = .moscow
        
        unreadMarkView.backgroundColor = .budapest
        unreadMarkView.isHidden = !unread
        
        authorLabel.font = unread ? .semibold13 : .medium13
        authorLabel.textColor = .london
        
        lastMessageLabel.font = unread ? .semibold13 : .medium13
        lastMessageLabel.textColor = unread ? .budapest : .london
        
        lastMessageDataLabel.font = .medium11
        lastMessageDataLabel.textColor = .minsk
    }

}
