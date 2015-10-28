//
//  ShoppingCartItem+CoreDataProperties.swift
//  appollo-ios
//
//  Created by Student on 10/26/15.
//  Copyright © 2015 Appollo. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ShoppingCartItem {

    @NSManaged var name: String
    @NSManaged var barCode: String?
    @NSManaged var price: NSNumber
    @NSManaged var quantity: NSNumber
    @NSManaged var image: NSData?
    @NSManaged var automatic: NSNumber
    @NSManaged var cart: ShoppingCart

}
