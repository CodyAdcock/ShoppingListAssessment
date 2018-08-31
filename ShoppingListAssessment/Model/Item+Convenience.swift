//
//  Item+Convenience.swift
//  ShoppingListAssessment
//
//  Created by Cody on 8/31/18.
//  Copyright © 2018 Cody Adcock. All rights reserved.
//

import Foundation
import CoreData

extension Item{
    //gets rid of an error we get later
    @discardableResult
    convenience init(name: String, isPurchased: Bool = false, context: NSManagedObjectContext = CoreDataStack.context){
        self.init(context: context)
        self.name = name
        self.isPurchased = isPurchased
    }
}
