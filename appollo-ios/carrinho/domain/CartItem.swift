//
//  ItemCarrinho.swift
//  appollo-ios
//
//  Created by Student on 10/23/15.
//  Copyright © 2015 Appollo. All rights reserved.
//

import Foundation

class CartItem: NSObject {
    
    var name: String
    var price: Float
    var photo: CGImage?
    var quantity: Float
    
    init(name: String, price: Float, quantity: Float) {
        self.name = name
        self.price = price
        self.quantity = quantity
    }
    
    convenience init(name: String, price: Float, quantity: Float, photo: CGImage) {
        self.init(name: name, price: price, quantity: quantity)
        self.photo = photo
    }
    
    func total() -> Float {
        return quantity * price
    }
    
}