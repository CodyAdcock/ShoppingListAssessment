//
//  CoreDataStack.swift
//  ShoppingListAssessment
//
//  Created by Cody on 8/31/18.
//  Copyright © 2018 Cody Adcock. All rights reserved.
//

import Foundation
import CoreData

enum CoreDataStack{
    
    //create Container
    static let container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ShoppingListAssessment")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error{
                fatalError("Failed load from CoreDataStack \(error) \(error.localizedDescription)")
            }
        })
        return container
    }()
    
    //create context
    static var context: NSManagedObjectContext {
        return container.viewContext
    }
}
