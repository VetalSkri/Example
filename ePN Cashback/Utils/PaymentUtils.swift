//
//  PaymentUtils.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 04/08/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import Repeat

public class PaymentUtils {
    
    static let shared = PaymentUtils()
    
    private var purseTimers = Dictionary<Int, Repeater>()
    private let newPurseConfirmKey = "kPurseConfirmData"
    public let charityId = 2
    
    func saveNewPurse(purse: CreatedUserPurse) {
        let type = (purse.data.attributes.method.lowercased() == "send email") ? NewPurseConfirmType.email : NewPurseConfirmType.phone
        var dict = UserDefaults.standard.object(Dictionary<String, NewPurseConfirm>.self, with: newPurseConfirmKey)
        if dict == nil {
            dict = Dictionary<String, NewPurseConfirm>()
        }
        dict?[String(purse.data.id)] = NewPurseConfirm(type: type, value: purse.data.attributes.value)
        UserDefaults.standard.set(object: dict, forKey: newPurseConfirmKey)
    }
    
    func saveNewPurse(purse: NewPurseConfirm, purseId: Int) {
        var dict = UserDefaults.standard.object(Dictionary<String, NewPurseConfirm>.self, with: newPurseConfirmKey)
        if dict == nil {
            dict = Dictionary<String, NewPurseConfirm>()
        }
        dict?[String(purseId)] = purse
        UserDefaults.standard.set(object: dict, forKey: newPurseConfirmKey)
    }
    
    func saveRotatedPurse(forPurseId: Int, rotated: Bool) {
        var object = UserDefaults.standard.object(RotatedPurses.self, with: "RotatedPurses")
        if object == nil {
            object = RotatedPurses(purses: [forPurseId : rotated])
        } else {
            object?.purses[forPurseId] = rotated
        }
        UserDefaults.standard.set(object: object, forKey: "RotatedPurses")
        if rotated {
            setTimer(forPurseId: forPurseId, seconds: 60)
        }
    }
    
    func disableAllRotatedPurse() {
        if var object = UserDefaults.standard.object(RotatedPurses.self, with: "RotatedPurses")  {
            for purse in object.purses {
                object.purses[purse.key] = false
            }
            UserDefaults.standard.set(object: object, forKey: "RotatedPurses")
        }
    }
    
    func getNewPurseConfirmData(forPurseId: String) -> NewPurseConfirm? {
        if let dict = UserDefaults.standard.object(Dictionary<String, NewPurseConfirm>.self, with: newPurseConfirmKey) {
            return dict[forPurseId]
        }
        return nil
    }
    
    func getRotatedPurseId(forPurseId: Int) -> Bool {
        if let dict = UserDefaults.standard.object(RotatedPurses.self, with: "RotatedPurses")  {
            return dict.purses[forPurseId] ?? false
        } else {
            return false
        }
    }
    
    func setTimer(forPurseId: Int, seconds: Int) -> Repeater {
        var timer = purseTimers[forPurseId]
        if timer == nil {
            timer = Repeater.every(.seconds(1), count: seconds) { _ in  }
            timer?.start()
        } else {
            timer!.reset(.seconds(1), restart: true)
        }
        purseTimers[forPurseId] = timer
        return timer!
    }
    
    func getTimer(forPurseId: Int) -> Repeater? {
        return purseTimers[forPurseId]
    }
}

public struct NewPurseConfirm: Codable {
    var type: NewPurseConfirmType
    var value: String
    
    private enum CodingKeys: String, CodingKey {
        case type = "type"
        case value = "value"
    }
}

public enum NewPurseConfirmType: Int, Codable {
    case phone, email
}

public struct RotatedPurses: Codable {
    var purses: [Int: Bool]
}
