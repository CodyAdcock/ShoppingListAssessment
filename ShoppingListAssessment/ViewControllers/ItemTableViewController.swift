//
//  ItemTableViewController.swift
//  ShoppingListAssessment
//
//  Created by Cody on 8/31/18.
//  Copyright © 2018 Cody Adcock. All rights reserved.
//

import UIKit
import CoreData

class ItemTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, ItemTableViewCellDelegate {
    
    //delegate Functions
    func textFieldChanged(cell: ItemTableViewCell, newItem: String) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        let item = fetchedResultsController.fetchedObjects?[indexPath.row]
        item?.name = newItem
    }
    
    func togglePurchased(cell: ItemTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell),
            let item = fetchedResultsController.fetchedObjects?[indexPath.row] else {return}
        ItemController.shared.togglePurchased(item: item)
    }
    
    //MARK: - Properties
    let fetchedResultsController: NSFetchedResultsController<Item> = {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    //create a fetch controller to delete, insert, move, and update the tableview
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type{
        case .delete:
            guard let indexPath = indexPath else {return}
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .insert:
            guard let newIndexPath = newIndexPath else {return}
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath,
                let newIndexPath = newIndexPath else {return}
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else {return}
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    //useful boilerplate
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedResultsController.delegate = self
        do{
            try fetchedResultsController.performFetch()
        }catch {
            print("There was an error in \(#function) \(error) \(error.localizedDescription)")
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ItemTableViewCell
        let item = fetchedResultsController.fetchedObjects?[indexPath.row]
        cell?.item = item
        cell?.delegate = self
        return cell ?? UITableViewCell()
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let item = fetchedResultsController.fetchedObjects?[indexPath.row] else {return}
            ItemController.shared.delete(item: item)
        }
    }
    
    //Alert Controller
    func presentAlertController(){
        let alertController = UIAlertController(title: "Add Item", message: "Please add an item to your shopping list", preferredStyle: .alert)
        alertController.addTextField {(itemTextField) in
            itemTextField.placeholder = "Item"
        }
        let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) {(_) in
            
            guard let itemText = alertController.textFields?[0].text else {return}
            
            Item(name: itemText)
            ItemController.shared.saveToPersistentStore()
            self.tableView.reloadData()
            }
        alertController.addAction(dismissAction)
        alertController.addAction(saveAction)
        
        present(alertController, animated: true)
    }
    
    //Add new items
    @IBAction func addItemButtonTapped(_ sender: Any) {
        presentAlertController()
    }
    
}
