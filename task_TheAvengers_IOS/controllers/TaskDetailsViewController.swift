//
//  TaskDetailsViewController.swift
//  task_TheAvengers_IOS
//
//  Created by Litson Thomas on 2022-01-21.
//

import UIKit
import CoreData

class TaskDetailsViewController: UIViewController {
    
    //outlets
    @IBOutlet weak var taskDesc: UILabel!
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskCreatedDate: UILabel!
    @IBOutlet weak var taskImg: UIImageView!
    
    @IBOutlet weak var subTaskTV: UITableView!
    @IBOutlet weak var addSubTask: UITextField!
    

    //subTask
    var subTasks = [SubTask]()
    var taskTit: String!
    var selectedTodo: SubTask?
    var taskContext: NSManagedObjectContext!
    
    var selectedTask : Task?{
        didSet{
          //loadSubTasks()
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpTableView()
    
        initializeCoreData()
      
        
        
    }
    
    @IBAction func goBack(_ sender: Any) {
        
        performSegue(withIdentifier: "goBack", sender: self)
        
    }
    
    
    @IBAction func addSubTask(_ sender: Any) {
        if(checkTitle()){
            let folderName = self.subTasks.map{$0.title?.lowercased()}
            //prevent the user to add identical names
            guard !folderName.contains(addSubTask.text?.lowercased()) else { self.showAlert(); return}
            let newFolder = SubTask(context: self.taskContext)
            newFolder.title = addSubTask.text!
        
            initializeCoreData()
            subTaskTV.reloadData()
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
   


    //    method to check weather title is empty or not
        func checkTitle() -> Bool {
            if (addSubTask.text?.isEmpty ?? true) {
                let alert = UIAlertController(title: "Enter the Sub Task to Add!", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return false
            }
            else {
                return true
            }
        }
}

//MARK: core data methods implemented
extension TaskDetailsViewController {
    
    
    func initializeCoreData() {
        print("initialized")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        taskContext = appDelegate.persistentContainer.viewContext
        
        fetchCategoryData()
        
    }
    
//    Initializes a default archived folder
    func firstTimeSetup() {
        let subTaskNames = self.subTasks.map {$0.title}
        guard !subTaskNames.contains("Archived") else {return}
        let newSubTask = SubTask(context: self.taskContext)
        newSubTask.title = "Archived"
        self.subTasks.append(newSubTask)
        do {
            try taskContext.save()
            subTaskTV.reloadData()
        } catch {
            print("Error saving categories \(error.localizedDescription)")
        }
    }
    
    
    func fetchCategoryData() {
//        request
        let request: NSFetchRequest<SubTask> = SubTask.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//        initialize
        request.sortDescriptors = [sortDescriptor]
        do {
            subTasks = try taskContext.fetch(request)
        } catch {
            print("Error loading categories: \(error.localizedDescription)")
        }
//        data fetched
        subTaskTV.reloadData()
        
    }
    
    func addNewSubTask() {
        
        let subTaskNames = self.subTasks.map {$0.title}
        guard !subTaskNames.contains(addSubTask.text) else {self.showAlert(); return}
        let newSubTask = SubTask(context: self.taskContext)
        newSubTask.title = addSubTask.text!
        self.subTasks.append(newSubTask)
        do {
            try taskContext.save()
            subTaskTV.reloadData()
        } catch {
            print("Error saving categories \(error.localizedDescription)")
        }
        
    }
    
//    to be shown if user enters existing category name
    func showAlert() {
        let alert = UIAlertController(title: "Category with same name already Exists!", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
   
    /*
    func deleteSubTaskFromList(){
          taskContext.delete(selectedTodo!)
          subTasks.removeAll{(SubTask) -> Bool in
              SubTask == selectedTodo!
              
          }
          subTaskTV.reloadData()
      }
      */
    
}

extension TaskDetailsViewController: UITableViewDelegate,UITableViewDataSource{
   
    
    //initialize table view
    func setUpTableView(){
        subTaskTV.delegate = self
        subTaskTV.dataSource = self
        
        //setup for auto size of cell
        subTaskTV.estimatedRowHeight = 35
        subTaskTV.rowHeight = UITableView.automaticDimension
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "sub_task_cell", for: indexPath)
        let task = subTasks[indexPath.row]
        cell.textLabel?.text = task.title
        
        if task.status == false{
           
            cell.imageView?.image = UIImage(systemName: "circle.fill")
            
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [self] (action, view, completion) in
            self.taskContext.delete(self.subTasks[indexPath.row])
            self.subTasks.remove(at: indexPath.row)
            //self.selectedTodo = subTasks[indexPath.row]
           // deleteSubTaskFromList()
           //addNewCategory()
            tableView.deleteRows(at: [indexPath], with: .fade)
           
            completion(true)
        }
        delete.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0, blue: 0.01171393025, alpha: 1)
        delete.image = UIImage(systemName: "trash.fill")
        return UISwipeActionsConfiguration(actions: [delete])
       
    }
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTodo = subTasks[indexPath.row]
        
    }
    
}
