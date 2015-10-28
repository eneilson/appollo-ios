//
//  ShoppingCartItem.swift
//  appollo-ios
//
//  Created by Student on 10/26/15.
//  Copyright © 2015 Appollo. All rights reserved.
//

import Foundation
import CoreData

@objc(ShoppingCartItem)
class ShoppingCartItem: NSManagedObject {

    func total() -> Float {
        //if let qtd = self.quantity, let prc = self.price {
        return Float(self.quantity) * Float(self.price)
        //}
        //return 0
    }

    var photo: UIImage {
        if let img = image {
            return UIImage(data: img)!
        }
        return UIImage(named: "Product")!
    }
    
}
