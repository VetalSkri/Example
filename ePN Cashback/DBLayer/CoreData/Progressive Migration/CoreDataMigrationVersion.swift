//
//  CoreDataMigrationVersion.swift
//  Backit
//
//  Created by Elina Batyrova on 10.08.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation

enum CoreDataMigrationVersion: String, CaseIterable {
    
    // MARK: - Nested Types
    
    case version1 = "EPN_Cashback"
    case version2 = "EPN_Cashback v2"
    case version3 = "EPN_Cashback v3"
    case version4 = "EPN_Backit v4"
    case version5 = "EPN_Backit v5"
    case version6 = "EPN_Backit v6"
    case version10 = "EPN_Backit v10"
    case version11 = "EPN_Backit v11"

    // MARK: - Type Properties

    static var current: CoreDataMigrationVersion {
        guard let current = allCases.last else {
            fatalError("No model versions found.")
        }

        return current
    }

    // MARK: - Type Methods

    func nextVersion() -> CoreDataMigrationVersion? {
        switch self {
        case .version1, .version2, .version3, .version5:
            return .version6
            
        case .version4:
            return .version5
            
        case .version6:
            return .version10
            
        case .version10:
            return .version11
        case .version11:
            return nil
        }
    }
}
