//
//  CategoryTableViewController.swift
//  ToDo2
//
//  Created by Warren Macpro2 on 7/3/18.
//  Copyright © 2018 Warren Hollinger. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController{
    //categoryObj is now a reference to our stored data
    //var categoryObj = [Category]()
    
    //By Using Results we can use almost any data type. it is auto updating for Realm Queries
    var categoryObj : Results<Category>?
    
    //no need to worry about try/catch
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set path of .plist storage area that we have created so we can retrieve and edit data we store in it
       // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        // Bring in stored array on device from last use from sandbox for this app
        loadItems()
        
    }
    
    //MARK: - Data Manipulation Methods
    //New CocoaPod overwrite for SwipeCellKit
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //taps into super of this class
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categoryObj?[indexPath.row].name ?? "No Categories Yet"
        //change cell bkg color
        cell.backgroundColor = UIColor.randomFlat()
        
        
        return cell
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Use Nil Coalescing Operator - if categoryObj is nil then make categoryObj.count = 1
        return categoryObj?.count ?? 1
    }
    
 
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        //Grab the category that corresponds to selected cell
        if let indexPath = tableView.indexPathForSelectedRow {
            //selectedCategory - is found in ToDoListViewController.swift
            destinationVC.selectedCategory = categoryObj?[indexPath.row]
        }
    }
    
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //local Vars
        //A text field available to pass info to
        var catcherTextField = UITextField()
        
        //create an alert and pop it up
        let alert = UIAlertController(title: "Add New ToDo2 List", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add List", style: .default) { (action) in
            //what will happen once the user clicks the add button on our UI Alert
            
            let newItem = Category()
            newItem.name = catcherTextField.text!
            //no need to append array like before we just update the category Obj
            self.saveItems(category: newItem)
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
    func saveItems(category: Category){
        
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error saving context, \(error)")
        }
        
        //Reload data into tableView
        tableView.reloadData()
    }
    //make inital load of all stored data in Realm DB
    func loadItems(){
        //will pull everything out of Category table
        categoryObj = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //MARK: - Delete data from swipe
    override func updateModel(at indexPath: IndexPath) {
        
        //THis says bring in all the normal functoionality of this class
        //if this wasn't here then we would basically keep anything in that function from happening
        super.updateModel(at: indexPath)
        
        if let item = self.categoryObj?[indexPath.row] {
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




