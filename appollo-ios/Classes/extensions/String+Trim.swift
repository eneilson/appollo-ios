//
//  String+Trim.swift
//  appollo-ios
//
//  Created by Francisco Ramos da Silva on 11/4/15.
//  Copyright © 2015 Appollo. All rights reserved.
//

import Foundation

extension String {
    
    func stringByRemovingAllWhitespaces() -> String {
        return self.stringByReplacingOccurrencesOfString("\\s", withString: "", options: .RegularExpressionSearch, range: nil)
    }
    
}