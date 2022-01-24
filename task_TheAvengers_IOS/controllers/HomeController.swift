//
//  HomeController.swift
//  task_TheAvengers_IOS
//
//  Created by Litson Thomas on 2022-01-20.
//

import UIKit

class HomeController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let items = ["Item 1", "Item2", "Item3", "Item4"]
    
    var tasks = [Task]()
    
    //context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskTableViewCell")
    }
    
    @IBAction func goToCategories(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddCategoryController") as! AddCategoryController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let destination = segue.destination as! TaskDetailsViewController
        if let indexPath = tableView.indexPathForSelectedRow{
           
        }
        
    }
  

}
