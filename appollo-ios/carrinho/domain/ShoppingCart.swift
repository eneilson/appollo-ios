//
//  Carrinho.swift
//  appollo-ios
//
//  Created by Student on 10/23/15.
//  Copyright © 2015 Appollo. All rights reserved.
//

import Foundation

class ShoppingCart: NSObject {
    
    var items: [CartItem] = []
    var dateCreated: NSDate
    var local: String // nome do supermercado
    
    init(local: String) {
        self.local = local
        dateCreated = NSDate()
    }
    
    func total() -> Double {
        var total: Double = 0
        for item in items {
            total += Double(item.total())
        }
        
        return total
    }
    
}