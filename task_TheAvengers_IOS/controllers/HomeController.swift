//
//  HomeController.swift
//  task_TheAvengers_IOS
//
//  Created by Litson Thomas on 2022-01-20.
//

import UIKit
import CoreData

class HomeController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var search_field: UITextField!
    
    var sort_details = ["Sort by date - ASC", "Sort by date - DESC", "Sort by Title - ASC", "Sort by Title - DESC", "Show Completed"]
    var selected_sort = "Sort by date - ASC"
    var if_sort_select_active: Bool = false
    var tasks = [Task]()
    var categories = [Category]()
    var selectedTask: Task?
    var selected_category = Category()
    var got_selected_category: Bool = false
    var category_picker = UIPickerView()
    var sort_picker = UIPickerView()
    var toolBar = UIToolbar()
    @IBOutlet weak var category_select_button: UIButton!
    @IBOutlet weak var sort_button: UIButton!
    
    //context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        fetchtasks()
        fetchCategories()
        search_field.delegate = self
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//        let destination = segue.destination as! TaskDetailsViewController
//        if let indexPath = tableView.indexPathForSelectedRow{
//            destination.selectedTask = tasks[indexPath.row]
//        }
//
//
//
//    }

  
    func fetchtasks() {
        do {
            let request: NSFetchRequest<Task> = Task.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "createDate", ascending: false)]
            self.tasks = try context.fetch(request)
        }
        catch {
            print(error)
        }
    }
    
    // METHOD TO SEARCH
    @IBAction func search_tasks(_ sender: UITextField) {
        let query = sender.text!
        print(query)
        if(!query.isEmpty){
            let request: NSFetchRequest<Task> = Task.fetchRequest()
            let searchPredicate = NSPredicate(format: "title = %@", query)
            request.predicate = searchPredicate
            do {
                tasks = try context.fetch(request)
            } catch {
                print("Error loading tasks \(error.localizedDescription)")
            }
            tableView.reloadData()
        }
        else{
            fetchtasks()
            tableView.reloadData()
        }
    }
    
    // METHOD TO SELECT CATEGORY
    @IBAction func select_category(_ sender: Any) {
        if_sort_select_active = false
        got_selected_category = false
        category_picker = UIPickerView.init()
        category_picker.delegate = self
        category_picker.dataSource = self
        category_picker.backgroundColor = UIColor.white
        category_picker.setValue(UIColor.black, forKey: "textColor")
        category_picker.autoresizingMask = .flexibleWidth
        category_picker.contentMode = .center
        category_picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(category_picker)
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.tintColor = UIColor(named: "primary")
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        self.view.addSubview(toolBar)
        
    }
    
    @objc func onDoneButtonTapped() {
        print("done")
        toolBar.removeFromSuperview()
        category_picker.removeFromSuperview()
        
        if(got_selected_category == true){
            // get the tasks based on the category
            let request: NSFetchRequest<Task> = Task.fetchRequest()
            let categoryPredicate = NSPredicate(format: "category = %@", selected_category)
            request.predicate = categoryPredicate
            do {
                tasks = try context.fetch(request)
            } catch {
                print("Error loading tasks \(error.localizedDescription)")
            }
            tableView.reloadData()
        }
        else{
            fetchtasks()
        }
        
        if_sort_select_active = true
    }
    
    
    @IBAction func goToCategories(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddCategoryController") as! AddCategoryController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    // METHOD TO SELECT SORT
    @IBAction func select_sort(_ sender: Any) {
        if_sort_select_active = true
        selected_sort.removeAll()
        sort_picker = UIPickerView.init()
        sort_picker.delegate = self
        sort_picker.dataSource = self
        sort_picker.backgroundColor = UIColor.white
        sort_picker.setValue(UIColor.black, forKey: "textColor")
        sort_picker.autoresizingMask = .flexibleWidth
        sort_picker.contentMode = .center
        sort_picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(sort_picker)
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.tintColor = UIColor(named: "primary")
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onSortDoneButtonTapped))]
        self.view.addSubview(toolBar)
    }
    
    @objc func onSortDoneButtonTapped() {
//        print("done sort")
//        print(selected_sort.isEmpty)
        toolBar.removeFromSuperview()
        sort_picker.removeFromSuperview()
        if(selected_sort.isEmpty){
            selected_sort = "Sort by date - ASC"
        }
//        print(selected_sort)
        // get the tasks based on the category
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        let statusPredicate = NSPredicate(format: "status = %d", true)
        if(selected_sort == "Sort by date - ASC"){
            request.sortDescriptors = [NSSortDescriptor(key: "createDate", ascending: true)]
        }
        if(selected_sort == "Sort by date - DESC"){
            request.sortDescriptors = [NSSortDescriptor(key: "createDate", ascending: false)]
        }
        if(selected_sort == "Sort by Title - ASC"){
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        }
        if(selected_sort == "Sort by Title - DESC"){
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: false)]
        }
        if(selected_sort == "Show Completed"){
            request.predicate = statusPredicate
        }
        do {
            tasks = try context.fetch(request)
        } catch {
            print("Error loading tasks \(error.localizedDescription)")
        }
        tableView.reloadData()
        
        if_sort_select_active = false
    }

    
}

// CATEGORY PICKER
extension HomeController: UIPickerViewDelegate,UIPickerViewDataSource{
    
    // method to get the categories
    func fetchCategories() {
        do {
            self.categories = try context.fetch(Category.fetchRequest())
        }
        catch {
            print(error)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(!if_sort_select_active){
            return categories.count
        }
        return sort_details.count
    }
        
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(!if_sort_select_active){
            return categories[row].name
        }
        return sort_details[row]
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if(!if_sort_select_active){
            selected_category = categories[row]
            got_selected_category = true
        }
        else{
            selected_sort = sort_details[row]
        }
    }
}

extension HomeController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == search_field {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
}

extension HomeController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
        let task =  self.tasks[indexPath.row]
        
        cell.title.text = task.title
        cell.desc.text = task.desc
        cell.created_date.text = task.createDate?.formatted()
        
        if(task.status == true){
            cell.status.tintColor = UIColor(named: "success")
        }
        else{
            cell.status.tintColor = UIColor(named: "light-grey")
        }
        
        //cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10
        //cell.clipsToBounds = true
        cell.contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTask = tasks[indexPath.row]
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TaskDetailsViewController") as! TaskDetailsViewController
        nextViewController.selectedTask = selectedTask
        self.present(nextViewController, animated:true, completion:nil)
    }
    
}
