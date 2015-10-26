//
//  ShoppingCart+CoreDataProperties.swift
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

extension ShoppingCart {

    @NSManaged var dateCreated: NSDate
    @NSManaged var local: String?
    @NSManaged var closed: NSNumber
    @NSManaged var items: NSOrderedSet?

}
