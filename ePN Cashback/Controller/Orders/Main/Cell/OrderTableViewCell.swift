//
//  OrderTableViewCell.swift
//  Backit
//
//  Created by Александр Кузьмин on 02/03/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    //Main container
    @IBOutlet weak var mainContainerView: UIView!
    
    //Logo image view
    @IBOutlet weak var logoImageContainerView: UIView!
    @IBOutlet weak var logoImageView: UIRemoteImageView!
    
    //Detail info labels
    @IBOutlet weak var offerNameLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(transaction: OrdersDataResponse, imageUrl: String?, offerName: String?) {
        view.backgroundColor = .clear
        selectionStyle = .none
        
        let typeId = Int(transaction.attributes.type_id ?? "1") ?? 1
        var statusId = 1
        switch LocalSymbolsAndAbbreviations.getOrderStatus(fromStatus: transaction.attributes.order_status) {
        case "completed":
            statusId = 1
            break
        case "rejected":
            statusId = 2
            break
        default:
            statusId = 3
            break
        }
        
        mainContainerView.backgroundColor = .zurich
        mainContainerView.cornerRadius = 8
        mainContainerView.borderColor = .montreal
        mainContainerView.borderWidth = 1
        
        if Int(transaction.attributes.offer_id) ?? 0 != LocalSymbolsAndAbbreviations.MULTY_OFFER_ID {
            logoImageView.loadImageUsingUrlString(urlString: imageUrl, defaultImage: UIImage())
        } else {
            logoImageView.image = UIImage(named: imageUrl ?? "")
        }
        logoImageContainerView.backgroundColor = .paris
        logoImageContainerView.cornerRadius = CommonStyle.cardCornerRadius
        logoImageView.backgroundColor = .clear
        
        offerNameLabel.font = .semibold13
        offerNameLabel.textColor = .sydney
        offerNameLabel.text = offerName ?? ""
        
        subtitleLabel.font = .medium13
        subtitleLabel.textColor = .minsk
        subtitleLabel.text = (Int(transaction.attributes.offer_id) ?? 0 != LocalSymbolsAndAbbreviations.MULTY_OFFER_ID) ? "\(NSLocalizedString("Purchase for", comment: "")) \(format(cost: transaction.attributes.revenue))\(LocalSymbolsAndAbbreviations.getSymbolOfCurrency(value: transaction.attributes.currency))\n\(NSLocalizedString("Order №", comment: "")) \(transaction.attributes.order_number)" : "\(NSLocalizedString("Order №", comment: "")) \(transaction.attributes.order_number)"
        
        if (Int(transaction.attributes.offer_id) ?? 0 != LocalSymbolsAndAbbreviations.MULTY_OFFER_ID) {   //non-multi offer
            var firstPartOfDescription = "\(transaction.attributes.commission_user)\(LocalSymbolsAndAbbreviations.getSymbolOfCurrency(value: transaction.attributes.currency))"
            firstPartOfDescription = (statusId == 1) ? "+"+firstPartOfDescription : firstPartOfDescription
            var secondPartOfDescription = ""
            if (statusId == 1) {
                secondPartOfDescription = NSLocalizedString("Transaction_accrued", comment: "")
            } else if (statusId == 2) {
                secondPartOfDescription = NSLocalizedString("Transaction_сanceled", comment: "")
            } else {
                secondPartOfDescription = NSLocalizedString("Transaction_on_hold", comment: "")
            }
            let attributedString = NSMutableAttributedString(string: firstPartOfDescription+" "+secondPartOfDescription)
            attributedString.addAttributes([NSAttributedString.Key.font: UIFont.medium20], range: NSRange(location: 0, length: firstPartOfDescription.count))
            attributedString.addAttributes([NSAttributedString.Key.font: UIFont.medium13], range: NSRange(location: firstPartOfDescription.count+1, length: secondPartOfDescription.count))
            attributedString.addAttributes([NSAttributedString.Key.foregroundColor: (statusId == 1) ? UIColor.budapest : UIColor.moscow], range: NSRange(location: 0, length: attributedString.string.count))
            descriptionLabel.attributedText = attributedString
        }
        else {  //Offline offer
            if statusId == 1 {
                descriptionLabel.attributedText = NSAttributedString(string: NSLocalizedString("Cashback found. More inside", comment: ""), attributes: [NSAttributedString.Key.foregroundColor: UIColor.budapest, NSAttributedString.Key.font : UIFont.medium13])
            } else if statusId == 2 {
                descriptionLabel.attributedText = NSAttributedString(string: NSLocalizedString("No cashback products found", comment: ""), attributes: [NSAttributedString.Key.foregroundColor: UIColor.sydney, NSAttributedString.Key.font : UIFont.medium13])
            } else {
                descriptionLabel.attributedText = NSAttributedString(string: NSLocalizedString("Looking for cashback in your check", comment: ""), attributes: [NSAttributedString.Key.foregroundColor: UIColor.moscow, NSAttributedString.Key.font : UIFont.medium13])
            }
        }
    }
    
    func format(cost: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.usesGroupingSeparator = false
        formatter.locale = Locale(identifier: "en_US")
        formatter.decimalSeparator = "."
        let costInNumber = formatter.number(from: cost)
        formatter.minimumFractionDigits = 2
        return formatter.string(from: costInNumber ??  NSNumber(floatLiteral: 0.0)) ?? "0.00"
    }
}
