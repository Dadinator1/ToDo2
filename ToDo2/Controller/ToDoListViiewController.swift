//
//  ToDoListViewController.swift
//  ToDo2
//
//  Created by Warren Macpro2 on 7/2/18.
//  Copyright © 2018 Warren Hollinger. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    //itemArray is now a reference to our stored data
    var itemArray = [StoredItems]()
    
    //Optional Category - will have no value first time this app used
    var selectedCategory : Category? {
        //if there is data we load it. didSet only executes if true
        didSet{
            //Bring in stored array on device from last use from sandbox for this app
            loadItems()
        }
    }
    
    //reference The Core Data DB
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //set path of .plist storage area that we have created so we can retrieve and edit data we store in it
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
    }
    
    //MARK: TableView Datasource Methods
    
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
    
    //MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        //add checkmark if newly tapped or take it away when tapped again
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
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
            
            let newItem = StoredItems(context: self.context)
            newItem.title = catcherTextField.text!
            newItem.done = false
            //Specify Parent category since their is a parent table to this table
            newItem.parentCategory = self.selectedCategory
            
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
    
    //Store Data and commits everything in "context" to the DB
    func saveItems(){
        
        do{
            try context.save()
        }catch{
            print("Error saving context, \(error)")
        }
        
        //Reload data into tableView
        tableView.reloadData()
    }
    //make inital load of all stored data in Core Data - or basically the SQLite DB
    //with request will use "request" as local var
    //below statement says default value if request is not passed in is StoredItems.fetchRequest() - this gets all the initial data on load
    //Basically request and predicate are optional values to be passed in
    //the <StoredItems> is specifying data type - initially had below line in function below but shortened it
    //let request : NSFetchRequest<StoredItems> = StoredItems.fetchRequest()
    func loadItems(with request: NSFetchRequest<StoredItems> = StoredItems.fetchRequest(), predicate: NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            //create compound query (predicate) if we recieve a predicate
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else{
            //otherwise predicate is just the basic load of data
           request.predicate = categoryPredicate
        }
        
        
        do{
           itemArray = try context.fetch(request)
        }catch{
           print("Error fetching data from context, \(error)")
        }
        //Reload data into tableView
        tableView.reloadData()
    }
    
    
}

//MARK: Searchbar methods
extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Query DB
        let request : NSFetchRequest<StoredItems> = StoredItems.fetchRequest()
        //search the title row of the DB for any string that contains what is in the searchbar text [cd] means case insensitive. Using SQL formatting
       let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //sort
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
       
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


