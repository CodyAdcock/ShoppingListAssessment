//
//  ItemController.swift
//  ShoppingListAssessment
//
//  Created by Cody on 8/31/18.
//  Copyright © 2018 Cody Adcock. All rights reserved.
//

import Foundation
import CoreData

class ItemController{
    
    static let shared = ItemController()
    
    //Save data
    func saveToPersistentStore(){
        do{
            try CoreDataStack.context.save()
        }catch {
            print("There was an error in \(#function) \(error) \(error.localizedDescription)")
        }
    }
    
    //delete
    func delete(item: Item) {
        CoreDataStack.context.delete(item)
        saveToPersistentStore()
    }
    
    //toggle isPurchased
    func togglePurchased(item: Item){
        item.isPurchased = !item.isPurchased
        saveToPersistentStore()
    }
    
    //Load data
    private func fetchItems() -> [Item] {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        return (try? CoreDataStack.context.fetch(request)) ?? []
    }
}
