//
//  AppMetricaAuthAnalytics.swift
//  Backit
//
//  Created by Александр Кузьмин on 20.04.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
import YandexMobileMetrica

final class AppMetricaAuthAnalytics: AppMetricaProtocol {
    
    private enum EventName: String {
        case runSocialAuth = "RunAuthSocial"
        case runMailRegister = "RunMailRegister"
        case successRegister = "SuccessRegister"
    }
    
    private enum EventParams: String {
        case deviceId = "DeviceId"
        case socialType = "SocialType"
        case isMailAuthType = "IsMailAuthType"
    }
    
    class func runSocialAuth(socialType: SocialType) {
        let params : [String : Any] = [EventParams.deviceId.rawValue: Util.getDeviceId(), EventParams.socialType.rawValue: socialType.rawValue]
        reportToAppMetrica(params: params, eventName: EventName.runSocialAuth.rawValue)
    }
    
    class func runMailRegister() {
        reportToAppMetrica(params: [EventParams.deviceId.rawValue: Util.getDeviceId()], eventName: EventName.runMailRegister.rawValue)
    }
    
    class func successRegister(socialType: SocialType?) {
        var params : [String : Any] = [EventParams.deviceId.rawValue: Util.getDeviceId()]
        if let socialType = socialType {
            params.add([EventParams.socialType.rawValue: socialType.rawValue])
        } else {
            params.add([EventParams.isMailAuthType.rawValue: true])
        }
        reportToAppMetrica(params: params, eventName: EventName.successRegister.rawValue)
    }

}
