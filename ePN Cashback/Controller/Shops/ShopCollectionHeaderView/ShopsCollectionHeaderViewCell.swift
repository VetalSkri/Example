//
//  ShopsCollectionHeaderViewCell.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 16/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import Kingfisher
import FSPagerView

class ShopsCollectionHeaderViewCell: FSPagerViewCell {

    @IBOutlet weak var backgroudImageView: UIRemoteImageView!
    @IBOutlet weak var mainImageView: UIRemoteImageView!
    @IBOutlet weak var storeImageView: UIRemoteImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupCellWithDoodle(doodle: DoodlesItem) {
        if let backgroundImage = doodle.backgroundImage, let _ = URL(string: backgroundImage) {
            guard let defaultImage = UIImage().imageWith(filledColor: UIColor.doodleDefault) else {
                fatalError()
            }
            
            backgroudImageView.loadImageUsingUrlString(urlString: backgroundImage,
                                                       defaultImage: defaultImage)
        } else if let backgroundColor = doodle.backgroundColor {
            let color = UIColor.init(hex: backgroundColor) ?? UIColor.doodleDefault
            let backgroundImage = UIImage().imageWith(filledColor: color)
            
            backgroudImageView.image = backgroundImage
        } else {
            let backgroundImage = UIImage().imageWith(filledColor: UIColor.doodleDefault)
            
            backgroudImageView.image = backgroundImage
        }
        
        mainImageView.loadImageUsingUrlString(urlString: doodle.image, defaultImage: UIImage())
        storeImageView.loadImageUsingUrlString(urlString: doodle.offerLogo, defaultImage: UIImage())
        titleLabel.text = doodle.title
        subtitleLabel.text = doodle.subTitle
        
        if UIScreen.main.bounds.width >= 414 {
            titleLabel.font = UIFont(name: "SFCompactText-Bold", size: 14)!
            subtitleLabel.font = UIFont(name: "SFCompactText-Bold", size: 12)!
        } else {
            titleLabel.font = UIFont(name: "SFCompactText-Bold", size: 13)!
            subtitleLabel.font = UIFont(name: "SFCompactText-Bold", size: 11)!
        }
    }
    
}
