//
//  AddCategoryViewController.swift
//  task_TheAvengers_IOS
//
//  Created by Litson Thomas on 2022-01-21.
//
//  Updated by Vergel dela Cruz on 2022-01-22.
//  Description: Add featured to add/edit/delete category

import UIKit
import CoreData

class AddCategoryController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var txvCategoryName: UITextField!
    //var items : [Category]?
    var items = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        //addCategory(name: "School")
        fetchCategories()
    }
    
    @IBAction func onAddCategory(_ sender: Any) {
        let categoryName = txvCategoryName.text
        if categoryName != "" {
            let catNames = self.items.map {$0.name?.lowercased()}
            guard !catNames.contains(categoryName?.lowercased()) else {showAlert(title: "Add Category" , message: "This name already exists. Please choose another name."); return}
            addCategory(name: txvCategoryName.text ?? "")
            txvCategoryName.text = ""
            fetchCategories()
        } else {
            showAlert(title:"Add Category", message: "Name can't be blank. Please enter another name.")
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default) {
            (action) in
            print("Category name is blank.")
        }
        alert.addAction(okButton)
        self.present(alert,animated: true,completion: nil)
    }
    func addCategory(name:String) {
        let newCategory = Category(context: self.context)
        newCategory.name = name
        print("Add " + name)
        do {
            try self.context.save()
        } catch {
            print(error        )
        }
        tableView.reloadData()
    }
    
    func fetchCategories() {
        do {
            self.items = try context.fetch(Category.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            print(error)
        }
    }
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true) {}
    }
}

extension AddCategoryController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let category =  self.items[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete")     { action, view, completionHandler    in
            let categoryToRemove = self.items[indexPath.row]
            self.context.delete(categoryToRemove)
            do {
                try self.context.save()
            } catch {
                print(error)
            }
            self.fetchCategories()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = self.items[indexPath.row]
        let alert = UIAlertController(title: "Edit Category", message: "Edit Name", preferredStyle: .alert)
        alert.addTextField()
        let textField = alert.textFields![0]
        textField.text = category.name
        let saveButton = UIAlertAction(title: "Save", style: .default) {
            (action) in
            let textField = alert.textFields![0]
            category.name = textField.text
            //let catNames = self.items.map {$0.name?.lowercased()}
            //guard !catNames.contains(textField.text?.lowercased()) else {self.showAlert(title:"Edit Category",message: "This name already exists. Please choose another name."); return}
           
            do {
                try self.context.save()
            } catch {
                print(error)
            }
            self.fetchCategories()
        }
        alert.addAction(saveButton)
        self.present(alert,animated: true,completion: nil)
    }
}
