//
//  CategoryTableViewController.swift
//  ToDo2
//
//  Created by Warren Macpro2 on 7/3/18.
//  Copyright © 2018 Warren Hollinger. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    //categoryArray is now a reference to our stored data
    var categoryArray = [Category]()
    
    
    //reference The Core Data DB
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set path of .plist storage area that we have created so we can retrieve and edit data we store in it
       // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        // Bring in stored array on device from last use from sandbox for this app
        loadItems()
    }


    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
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
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    
    //MARK: - Data Manipulation Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let item = categoryArray[indexPath.row]
        
        cell.textLabel?.text = item.name
        
        return cell
        
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
            
            let newItem = Category(context: self.context)
            newItem.name = catcherTextField.text!
            self.categoryArray.append(newItem)
            
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
    //below statement says default value if request is not passed is Category.fetchRequest() - this gets all the initial data on load
    //the <Category> is specifying data type - initially had below line in function below but shortened it
    //let request : NSFetchRequest<Category> = Category.fetchRequest()
    func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        
        do{
            categoryArray = try context.fetch(request)
        }catch{
            print("Error fetching data from context, \(error)")
        }
        //Reload data into tableView
        tableView.reloadData()
    }
    

    
}
