//
//  AddCategoryViewController.swift
//  task_TheAvengers_IOS
//
//  Created by Litson Thomas on 2022-01-21.
//

import UIKit
import CoreData

class AddCategoryController: UIViewController {
    @IBOutlet weak var txvCategoryName: UITextField!
 
    @IBOutlet weak var tableView: UITableView!
    var items : [Category]?
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
        if ((categoryName?.isEmpty) != nil) {
            addCategory(name: txvCategoryName.text ?? "")
            txvCategoryName.text = ""
            fetchCategories()
        } else {
            print("Category name is empty")
        }
    }
    func addCategory(name:String) {
        let newCategory = Category(context: self.context)
        newCategory.name = name
            
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
}

extension AddCategoryController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =     tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category =  self.items![indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete")     { action, view, completionHandler    in
            let categoryToRemove = self.items![indexPath.row]
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
        let category = self.items![indexPath.row]
        let alert = UIAlertController(title: "Edit Category", message: "Edit Name", preferredStyle: .alert)
        alert.addTextField()
        let textField = alert.textFields![0]
        textField.text = category.name
        let saveButton = UIAlertAction(title: "Save", style: .default) {
            (action) in
            let textField = alert.textFields![0]
            category.name = textField.text
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
