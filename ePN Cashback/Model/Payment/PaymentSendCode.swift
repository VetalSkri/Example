//
//  PaymentSendCode.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 05/08/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

public struct PaymentSendCode: Codable {
    var data: PaymentSendCodeData
}

public struct PaymentSendCodeData: Codable {
    var type: String
    var attributes: PaymentSendCodeAttribute
}

public struct PaymentSendCodeAttribute: Codable {
    var method: String
    var value: String
}
