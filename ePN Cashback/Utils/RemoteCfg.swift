//
//  RemoteCfg.swift
//  Backit
//
//  Created by Александр Кузьмин on 22/11/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig
import RxSwift

class RemoteCfg {
    
    static let shared = RemoteCfg()
    let config = RemoteConfig.remoteConfig()
    private let showLotteryKey = "LOTTERY_END_DATE"
    var remoteCfgSubject = PublishSubject<Bool>()
    
    private init() {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        config.configSettings = settings
        setupDefaults()
    }
    
    private func setupDefaults() {
        config.setDefaults(fromPlist: "RemoteConfigDefaults")
    }
    
    func isShowLottery() -> Bool {
        if let ticks = Int64(config[showLotteryKey].stringValue ?? "0") {
            let lotteryEndDate = Date(timeIntervalSince1970: TimeInterval(ticks/1000))
            print("MYLOG: \(Date().timeIntervalSince(lotteryEndDate))")
            return Date().timeIntervalSince(lotteryEndDate) < 0
        }
        return false
    }
    
    func endLotteryDateString() -> String {
        if let ticks = Int64(config[showLotteryKey].stringValue ?? "0") {
            let lotteryEndDate = Date(timeIntervalSince1970: TimeInterval(integerLiteral: ticks/1000))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            return dateFormatter.string(from: lotteryEndDate)
        }
        return ""
    }
    
    func fetch() {
        config.fetchAndActivate { [weak self] (status, error) in
            if status == .error {
              print("MYLOG: Remote Config not fetched")
              print("Error: \(error?.localizedDescription ?? "No error available.")")
            } else {
                print("MYLOG: Remote Config success fetched")
                self?.config.activate(completionHandler: { (error) in
                    self?.remoteCfgSubject.onNext(self?.isShowLottery() ?? false)
                })
            }
        }
    }
}
  
