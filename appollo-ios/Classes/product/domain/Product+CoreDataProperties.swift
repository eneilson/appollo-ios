//
//  Product+CoreDataProperties.swift
//  appollo-ios
//
//  Created by Student on 11/5/15.
//  Copyright © 2015 Appollo. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Product {

    @NSManaged var barcode: String?
    @NSManaged var name: String?
    @NSManaged var image: NSData?
    @NSManaged var itemDescription: String?

}
