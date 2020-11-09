//
//  DoodleAnalytics.swift
//  Backit
//
//  Created by Elina Batyrova on 10.07.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation

final class DoodleAnalytics: AppMetricaProtocol, FirebaseProtocol {
    
    private enum EventName: String {
        case openDoodle = "OpenDoodle"
    }
    
    private enum EventParams: String {
        case doodleID = "doodleId"
    }
    
    class func openDoodleWith(id doodleID: Int) {
        let params = [EventParams.doodleID.rawValue: doodleID]
        let eventName = EventName.openDoodle.rawValue
        
        reportToAppMetrica(params: params, eventName: eventName)
        reportToFirebase(params: params, eventName: eventName)
    }
}
