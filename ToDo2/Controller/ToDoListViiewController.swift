//
//  ToDoListViewController.swift
//  ToDo2
//
//  Created by Warren Macpro2 on 7/2/18.
//  Copyright © 2018 Warren Hollinger. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    
    var itemArray = [StoredItems]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let newItem = StoredItems()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = StoredItems()
        newItem2.title = "Find Mike2"
        itemArray.append(newItem2)
        
        let newItem3 = StoredItems()
        newItem3.title = "Find Mike3"
        itemArray.append(newItem3)
        
        // Bring in stored array on device from last use from sandbox for this app
        if let items = defaults.array(forKey: "TodoListArray") as? [StoredItems] {
            itemArray = items
        }
        
    }
    
    //MARK TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //use Ternary operator Just like Javascript
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell        

    }
    
    //MARK TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //add checkmark if newly tapped or take it away when tapped again
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //reload Table
        tableView.reloadData()
        
        //animate cell on click - not leave it gray
        tableView.deselectRow(at: indexPath, animated: true)
 
    }

    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //local Vars
        //A text field available to pass info to
        var catcherTextField = UITextField()
        
      //create an alert and pop it up
        let alert = UIAlertController(title: "Add New ToDo2 Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the add button on our UI Alert
            
            let newItem = StoredItems()
            newItem.title = catcherTextField.text!
            self.itemArray.append(newItem)
            
            //store data into the apps storage area defined as defaults. It will be stored as TodoListArray[]
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            //Reload data into tableView
            self.tableView.reloadData()
        }
        //add input text field
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "create new item"
            //pass value of textfield to local var
            catcherTextField = alertTextfield
        }
        //pop up alert with addAaction "action" parameters set above
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
}

