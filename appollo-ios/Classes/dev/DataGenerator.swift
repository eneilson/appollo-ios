//
//  DataGenerator.swift
//  appollo-ios
//
//  Created by Francisco Ramos da Silva on 10/27/15.
//  Copyright © 2015 Appollo. All rights reserved.
//

import Foundation

class DataGenerator {
    
    class func generate(cleanup: Bool = false) {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if cleanup {
            // clean the databases
            ShoppingCart.deleteAll()
            ShoppingCartItem.deleteAll()
            
            userDefaults.setValue(false, forKey: "dev_data_generated")
        }
        
        if let alreadyGenerated = userDefaults.valueForKey("dev_data_generated") as? Bool {
            if alreadyGenerated {
                return
            }
        }
        
        // current shopping cart
        let currentCart: [String: AnyObject] = [
            "local": "Carrefour D. Pedro",
            "dateCreated": NSDate(),
            "closed": 0
        ]
        
        let shoppingCart = ShoppingCart.create(properties: currentCart) as! ShoppingCart
        shoppingCart.save()
        
        var items: [ShoppingCartItem] = []
        
        let rice = ShoppingCartItem.create(properties: ["name": "Uncle John Rice 2kg", "price": 8.89, "quantity": 1, "automatic": 0, "cart": shoppingCart]) as! ShoppingCartItem
        let potatoChips = ShoppingCartItem.create(properties: ["name": "Pringles 500g", "price": 5.49, "quantity": 3, "automatic": 1, "cart": shoppingCart]) as! ShoppingCartItem
        
        items.append(rice)
        items.append(potatoChips)
        
        shoppingCart.items = NSOrderedSet(array: items)
        shoppingCart.save()
        
        
        // two history shopping carts
        let propsHistoryCart1: [String: AnyObject] = [
            "local": "Extra Abolição",
            "dateCreated": NSDate(),
            "closed": 1
        ]
        let historyCart1 = ShoppingCart.create(properties: propsHistoryCart1) as! ShoppingCart
        
        var historyItems1: [ShoppingCartItem] = []
        let cheese = ShoppingCartItem.create(properties: ["name": "Premium Swiss Cheese", "price": 38.89, "quantity": 1, "automatic": 0, "cart": historyCart1]) as! ShoppingCartItem
        let redBull = ShoppingCartItem.create(properties: ["name": "Red Bull", "price": 6.49, "quantity": 12, "automatic": 0, "cart": historyCart1]) as! ShoppingCartItem
        historyItems1.append(cheese)
        historyItems1.append(redBull)
        
        historyCart1.items = NSOrderedSet(array: historyItems1)
        historyCart1.save()
        
        
        let propsHistoryCart2: [String: AnyObject] = [
            "local": "Good Bom Supermercados",
            "dateCreated": NSDate(),
            "closed": 1
        ]
        let historyCart2 = ShoppingCart.create(properties: propsHistoryCart2) as! ShoppingCart
        
        var historyItems2: [ShoppingCartItem] = []
        let milk = ShoppingCartItem.create(properties: ["name": "Milk", "price": 0.99, "quantity": 2, "automatic": 0, "cart": historyCart2]) as! ShoppingCartItem
        let cookie = ShoppingCartItem.create(properties: ["name": "Chocolate Cookies", "price": 3.29, "quantity": 1, "automatic": 0, "cart": historyCart2]) as! ShoppingCartItem
        historyItems2.append(milk)
        historyItems2.append(cookie)
        historyCart2.items = NSOrderedSet(array: historyItems2)
        historyCart2.save()
        
        userDefaults.setValue(true, forKey: "dev_data_generated")
    }
    
}