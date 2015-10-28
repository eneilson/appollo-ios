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
        
        let cartProperties: [String: AnyObject] = [
            "local": "Carrefour D. Pedro",
            "closed": 1
        ]
        
        let shoppingCart = ShoppingCart.create(properties: cartProperties) as! ShoppingCart
        shoppingCart.save()
        
        var items: [ShoppingCartItem] = []
        
        /*
        @NSManaged var name: String
        @NSManaged var barCode: String?
        @NSManaged var price: NSNumber
        @NSManaged var quantity: NSNumber
        @NSManaged var image: NSData?
        @NSManaged var automatic: NSNumber
        @NSManaged var cart: ShoppingCart
        */
        let rice = ShoppingCartItem.create(properties: ["name": "Uncle John Rice 2kg", "price": 8.89, "quantity": 1, "automatic": 0, "cart": shoppingCart]) as! ShoppingCartItem

        let potatoChips = ShoppingCartItem.create(properties: ["name": "Pringles 500g", "price": 5.49, "quantity": 3, "automatic": 1, "cart": shoppingCart]) as! ShoppingCartItem
        
        items.append(rice)
        items.append(potatoChips)
        
        shoppingCart.items = NSOrderedSet(array: items)
        shoppingCart.save()
        
        userDefaults.setValue(true, forKey: "dev_data_generated")
    }
    
}