//
//  ComingSoonModelType.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 25/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

protocol ComingSoonModelType {
    var titleHeader: String { get }
    var image: UIImage? { get }
    var descriptionTitle: String { get }
    var buttonTitle: String { get }
    func goToPage()
    func goOnBack()
}
