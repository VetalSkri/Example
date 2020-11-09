//
//  SupportDialogStatus.swift
//  Backit
//
//  Created by Elina Batyrova on 31.07.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation

public struct SupportDialogStatus: Decodable {
    var result: Bool
    var request: SupportDialogRequest
}

public struct SupportDialogRequest: Decodable {
    var dialogID: Int
    var status: DialogStatus?
    var description: String?
    var rating: Int?
    
    enum CodingKeys: String, CodingKey {
        case dialogID = "dialog_id"
        case status
        case description
        case rating
    }
    
    public init (from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dialogID = try container.decode(Int.self, forKey: .dialogID)
        
        let statusString = try? container.decode(String.self, forKey: .status)
        
        switch statusString {
        case DialogStatus.open.rawValue:
            status = .open
        
        case DialogStatus.closed.rawValue:
            status = .closed
            
        case DialogStatus.notify.rawValue:
            status = .notify
            
        default:
            return
        }
        
        description = try? container.decode(String.self, forKey: .description)
        rating = try? container.decode(Int.self, forKey: .rating)
    }
}
