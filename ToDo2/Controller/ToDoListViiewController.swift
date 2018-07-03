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
    
    //set path of .plist storage area that we have created so we can retrieve and edit data we store in it
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("StoredItems.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // Bring in stored array on device from last use from sandbox for this app
        loadItems()
        
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
        
        saveItems()
        
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
            
            self.saveItems()
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
    
    //Store Data into .plist storage area in app sandbox
    func saveItems(){
        
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        }catch{
            print("Error encoding item array, \(error)")
        }
        
        //Reload data into tableView
        tableView.reloadData()
    }
    //make inital load of all stored data in sandbox plist
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([StoredItems].self, from: data)
            }catch{
                print("Error decoding item array, \(error)")
            }
            
        }
    }
    
}

