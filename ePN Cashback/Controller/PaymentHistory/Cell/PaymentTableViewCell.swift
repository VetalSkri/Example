//
//  PaymentTableViewCell.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 04/02/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class PaymentTableViewCell: UITableViewCell {

    @IBOutlet weak var paymentCard: EPNPaymentCard!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    var viewModel: PaymentViewCellViewModelType? {
        willSet(viewModel){
            guard let viewModel = viewModel else { return }
            viewModel.image.bind{ [unowned self] in
                guard let image = $0 else { return }
                self.paymentCard.setImage(image)
            }
            viewModel.image.value = viewModel.getPurseTypeLogo()
            self.backgroundColor = .zurich
            self.view.backgroundColor = .zurich
            paymentCard.style = viewModel.typeOfPaymentStatus
            paymentCard.headerText = viewModel.titleOfStatus()
            paymentCard.paymentText = viewModel.purseNumber()
            paymentCard.costText = viewModel.paymentText()
            paymentCard.costValueText = viewModel.costText()
            
        }
    }
    
   
}
