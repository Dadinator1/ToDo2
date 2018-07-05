//
//  ToDoListViewController.swift
//  ToDo2
//
//  Created by Warren Macpro2 on 7/2/18.
//  Copyright © 2018 Warren Hollinger. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: SwipeTableViewController {
    
    //itemObj is now a reference to our stored data
    var itemObj : Results<StoredItems>?
    let realm = try! Realm()
    
    
    //Optional Category - will have no value first time this app used
    var selectedCategory : Category? {
        //if there is data we load it. didSet only executes if true
        didSet{
            //Bring in stored array on device from last use from sandbox for this app
            loadItems()
        }
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //set path of .plist storage area that we have created so we can retrieve and edit data we store in it
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    
    //MARK: TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //taps into super of this class
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        if let item = itemObj?[indexPath.row] {
            cell.textLabel?.text = item.title
            print("item Value is \(item.title)")
            //use Ternary operator Just like Javascript
            cell.accessoryType = item.done ? .checkmark : .none
            
        }else{
            cell.textLabel?.text = "No Items Added"
            print("No Item Added")
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemObj?.count ?? 1
    }
    
    
    //MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //add checkmark if newly tapped or take it away when tapped again
        if let item = itemObj?[indexPath.row] {
            do {
                try realm.write {
                    //Would delete item if clicked on
                    //realm.delete(item)
                    //Updates done value
                    item.done = !item.done
                }
            }catch{
                print("Error saving done Status, \(error)")
            }
            
        }
        tableView.reloadData()
        
        //animate cell on click - not leave it gray
        tableView.deselectRow(at: indexPath, animated: true)
 
    }

    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //local Vars
        //A text field available to pass info to. Kind of like a hidden form element
        var catcherTextField = UITextField()
        
      //create an alert and pop it up
        let alert = UIAlertController(title: "Add New ToDo2 Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the add button on our UI Alert
            
            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write {
                        let newItem = StoredItems()
                        newItem.title = catcherTextField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("Error saving new Items. \(error)")
                }
                
                
            }
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

    //make inital load of all stored data in Realm
    func loadItems(){
        
        itemObj = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        //Reload data into tableView
        tableView.reloadData()
    }
    
    //MARK: - Delete data from swipe
    override func updateModel(at indexPath: IndexPath) {
        
        //This says bring in all the normal functoionality of this class
        //if this wasn't here then we would basically keep anything in that function from happening
        super.updateModel(at: indexPath)
        
        if let item = self.itemObj?[indexPath.row] {
            do {
                try self.realm.write {
                    //Would delete item if clicked on
                    self.realm.delete(item)
                }
            }catch{
                print("Error Deleting Category, \(error)")
            }
        }
        
    }
    
}

//MARK: Searchbar methods
extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Query DB
        itemObj = itemObj?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        //Reload data into tableView
        tableView.reloadData()
    }
    //every letter that is typed into search this is called
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //bring back all results and get rid of keyboard
        if searchBar.text?.count == 0 {
            loadItems()
            
            //this function assigns projects to different threads - prevents GUI from freezing up while it done
            DispatchQueue.main.async {
                //get rid of searchbar
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}


