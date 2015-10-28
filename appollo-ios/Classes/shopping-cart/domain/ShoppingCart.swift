//
//  ShoppingCart.swift
//  appollo-ios
//
//  Created by Student on 10/26/15.
//  Copyright © 2015 Appollo. All rights reserved.
//

import Foundation
import CoreData

@objc(ShoppingCart)
class ShoppingCart: NSManagedObject {

    func total() -> Float {
        var total: Float = 0
        if let _items = items {
            for item in _items {
                total = total + item.total()
            }
        }
        
        return total
    }
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        
        dateCreated = NSDate()
    }
    
}
