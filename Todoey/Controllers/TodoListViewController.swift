//
//  ViewController.swift
//  Todoey
//
//  Created by Daniel Garcia on 2/28/18.
//  Copyright © 2018 Daniel Garcia. All rights reserved.
//

import UIKit
import CoreData


class TodoListViewController: UITableViewController {
    
    // MARK: Properties
    var itemArray = [Item]()
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    //MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        // Ternary operator
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = itemArray[indexPath.row]
        item.done = !item.done
        
        // For deletes
        // context.delete(itemArray[indexPath.row])
        // itemArray.remove(at: indexPath.row)
        
        
        self.saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "new item"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // Get context from AppDelegat object
            // UIApplication.shared is the singleton app instance
            // At the timepoint when the app is running live, this object corresponds to live appication object
            // Inside this object is the delegate for the app object... need to cast it as "AppDelegate"
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            // Add write to file
            self.saveItems()
            
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    //MARK: - Save and Load from context
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving item, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(_ request: NSFetchRequest<Item> = Item.fetchRequest(), _ predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let receivedPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, receivedPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
}

//MARK: - Search Bar Methods

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(request, predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}

