//
//  TaskDetailsViewController.swift
//  task_TheAvengers_IOS
//
//  Created by Litson Thomas on 2022-01-21.
//

import UIKit
import CoreData

class TaskDetailsViewController: UIViewController {
    
    @IBOutlet weak var taskDesc: UILabel!
    @IBOutlet weak var tasktitle: UILabel!
    
    @IBOutlet weak var taskCreatedDate: UILabel!
    
    @IBOutlet weak var taskImg: UIImageView!
    //context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    //notes
    var subTasks = [SubTask]()
    
    var selectedFolder : Category?{
        didSet{
           loadCategories()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func goBack(_ sender: Any) {
        
        performSegue(withIdentifier: "goBack", sender: self)
        
    }
    
    
    @IBAction func addSubTask(_ sender: Any) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK: Core data methods
    private func loadCategories(){
        let request : NSFetchRequest<SubTask> = SubTask.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentTask.name=%@", selectedFolder!.name!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        request.predicate = categoryPredicate
        
        do{
            subTasks = try context.fetch(request)
        }catch{
            print("Error loading notes...\(error.localizedDescription)")
            
        }
        //tableView.reloadData()
    }
}
