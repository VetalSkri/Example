//
//  AppMetricaProtocol.swift
//  Backit
//
//  Created by Александр Кузьмин on 20.04.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
import YandexMobileMetrica

protocol AppMetricaProtocol { }

extension AppMetricaProtocol {
    static func reportToAppMetrica(params: [String: Any], eventName: String) {
        YMMYandexMetrica.reportEvent(eventName, parameters: params, onFailure: { (error) in
            print("MYLOG: DID FAIL YANEX METRICA EVENT: \(error.localizedDescription)")
        })
    }
}
