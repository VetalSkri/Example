//
//  UIRemoteImageView.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 09/03/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import Kingfisher

class UIRemoteImageView: UIImageView {

    var imageUrlString: String?
    
    func loadImageUsingUrlString(urlString stringUrl: String?, defaultImage: UIImage) {
        
        //layer.minificationFilter = kCAFilterTrilinear
        
        imageUrlString = stringUrl
        
        if let urlString = stringUrl, !urlString.isEmpty {
            
            let url = URL(string: urlString)
            kf.setImage(
                with: url,
                placeholder: defaultImage,
                options: nil)
        } else {
            image = defaultImage
        }
    }
    


}
