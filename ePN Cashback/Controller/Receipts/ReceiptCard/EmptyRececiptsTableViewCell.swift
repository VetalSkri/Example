//
//  EmptyRececiptsTableViewCell.swift
//  Backit
//
//  Created by Ivan Nikitin on 19/02/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit

class EmptyRececiptsTableViewCell: UITableViewCell {

    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = NSLocalizedString("Nothing here yet", comment: "")
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        titleLabel.font = .bold17
        titleLabel.textColor = .sydney
        
    }
    
}
