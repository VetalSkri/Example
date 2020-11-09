//
//  NSString+Extention.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 06/08/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

extension String {
    public var withoutHtml: String {
        do {
            let regex = try NSRegularExpression(pattern: "<[^>]*>", options: .caseInsensitive)
            let stringWithoutHtml = regex.stringByReplacingMatches(in: self, options: .reportCompletion, range: NSMakeRange(0, self.count), withTemplate: "")
            return stringWithoutHtml
        } catch {
            return self
        }
    }
}
