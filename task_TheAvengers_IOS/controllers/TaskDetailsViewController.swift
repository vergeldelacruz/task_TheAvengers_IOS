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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addSubTask: UITextField!
    

    //subTask
    var subTasks = [SubTask]()
    var taskTit: String!
    var selectedTodo: SubTask?
    var taskContext: NSManagedObjectContext!
    
    var selectedTask : Task?{
        didSet{
          loadNotes()
        }
        
    }
    //context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
            
        loadNotes()
        setUpTableView()

        
        
    }
    
    @IBAction func goBack(_ sender: Any) {
        
        performSegue(withIdentifier: "goBack", sender: self)
        
    }
    
    
    @IBAction func addSubTask(_ sender: Any) {
        if(checkTitle()){
            let folderName = self.subTasks.map{$0.title?.lowercased()}
            //prevent the user to add identical names
            guard !folderName.contains(addSubTask.text?.lowercased()) else { self.showAlert(); return}
            let newFolder = SubTask(context: self.context)
            newFolder.title = addSubTask.text!
            self.saveTodos()
            self.updateNotes(with: newFolder.title!)
            //self.subTasks.append(newFolder)
           
            tableView.reloadData()
        }
    }
    
    //   to be shown if user enters existing category name
        func showAlert() {
            let alert = UIAlertController(title: "Category with same name already Exists!", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)

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
    
    
    //MARK: Core Data Implementation
    private func loadNotes(){
        let request : NSFetchRequest<SubTask> = SubTask.fetchRequest()
        
         //let folderPredicate = NSPredicate(format: "parentTask.title=%@", //selectedTask!.title!)
        let folderPredicate = NSPredicate(format: "parentTask.title=%@", "")
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        request.predicate = folderPredicate
        
        do{
            subTasks = try context.fetch(request)
        }catch{
            print("Error loading notes...\(error.localizedDescription)")
            
        }
        
//        tableView.reloadData()
      
          }

    func deleteNote(note: SubTask){
        context.delete(note)
    }
    
    func updateNotes(with title: String){
        subTasks = []
        let newTask = SubTask(context: context)
        newTask.title = title
        newTask.parentTask = selectedTask
        saveTodos()
        loadNotes()
        
    }
    
    func saveTodos() {
        do {
            try context.save()
            
        } catch {
            print("Error saving the context \(error.localizedDescription)")
        }
        loadNotes()
    }
    override func viewWillAppear(_ animated: Bool) {
        selectedTodo = nil
    }
    
}



//MARK: Table view implementation
extension TaskDetailsViewController: UITableViewDelegate,UITableViewDataSource{
   
    
    //initialize table view
    func setUpTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        
        //setup for auto size of cell
        tableView.estimatedRowHeight = 35
        tableView.rowHeight = UITableView.automaticDimension
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "sub_task_cell", for: indexPath)
        let task = subTasks[indexPath.row]
        cell.textLabel?.text = task.title
        cell.imageView?.image = UIImage(systemName: "circle.fill")
       
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
           let delete = UIContextualAction(style: .destructive, title: "Delete") { [self] (action, view, completion) in
               self.context.delete(self.subTasks[indexPath.row])
               self.subTasks.remove(at: indexPath.row)
               do {
                   try self.context.save()
               } catch {
                   print(error)
               }
               self.loadNotes()
               tableView.deleteRows(at: [indexPath], with: .fade)
              
               completion(true)
           }
           
           delete.image = UIImage(systemName: "trash.fill")
           return UISwipeActionsConfiguration(actions: [delete])
          
       }

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTodo = subTasks[indexPath.row]
        context.delete(selectedTodo!)
                  subTasks.removeAll{(SubTask) -> Bool in
                      SubTask == selectedTodo!
                     
                  }
        saveTodos()
                  tableView.reloadData()
        let alert = UIAlertController(title: "Task Completed", message: "", preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
               self.present(alert, animated: true, completion: nil)
      
    }
    
}
