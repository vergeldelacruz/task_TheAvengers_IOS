//
//  HomeController.swift
//  task_TheAvengers_IOS
//
//  Created by Litson Thomas on 2022-01-20.
//

import UIKit

class HomeController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var items = [Task]()
    
    var tasks = [Task]()
    
    //context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskTableViewCell")
        fetchtasks()
    }
    
    func fetchtasks() {
        do {
            self.items = try context.fetch(Task.fetchRequest())
            for itm in items{
                print(itm.title)
                print(itm.desc)
            }
        }
        catch {
            print(error)
        }
    }

    
    @IBAction func goToCategories(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddCategoryController") as! AddCategoryController
        self.present(nextViewController, animated:true, completion:nil)
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
//    }
  

}

