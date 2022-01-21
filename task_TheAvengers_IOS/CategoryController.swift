//
//  CategoryController.swift
//  task_TheAvengers_IOS
//
//  Created by user209721 on 1/21/22.
//

import UIKit
import CoreData

class CategoryController: UIViewController {

    @IBOutlet weak var txvCaregoryName: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var btnAddCategory: UIButton!
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
        let categoryName = txvCaregoryName.text
        if ((categoryName?.isEmpty) != nil) {
            addCategory(name: txvCaregoryName.text ?? "")
            txvCaregoryName.text = ""
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
            print(error		)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CategoryController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = 	tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category =  self.items![indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") 	{ action, view, completionHandler	in
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
        var saveButton = UIAlertAction(title: "Save", style: .default) {
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
