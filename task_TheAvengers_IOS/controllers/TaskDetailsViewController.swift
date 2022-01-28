//
//  TaskDetailsViewController.swift
//  task_TheAvengers_IOS
//
//  Created by Litson Thomas on 2022-01-21.
//

import UIKit
import CoreData
import AVFAudio

class TaskDetailsViewController: UIViewController, AVAudioPlayerDelegate {
    
    var soundplayer : AVAudioPlayer?
    //outlets
    @IBOutlet weak var taskDesc: UILabel!
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskCreatedDate: UILabel!
    @IBOutlet weak var taskImg: UIImageView!
    @IBOutlet weak var playAudio: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subTaskTxt: UITextField!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var play_button: UIButton!
    @IBOutlet weak var prev_button: UIButton!
    @IBOutlet weak var next_button: UIButton!
    
    //subTask
    var subTasksArray = [SubTask]()
    var taskTit: String!
    var selectedSubTask: SubTask?
    var imageArray = [UIImage]()
    var selectedTask : Task?
    var image_index = 0;
    
    //context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        taskName?.text = selectedTask?.title
        taskDesc?.text = selectedTask?.desc
        taskCreatedDate?.text = selectedTask?.createDate?.formatted()
        categoryName?.text = selectedTask?.title
        for task in selectedTask?.subTasks ?? []{
            subTasksArray.append(task as! SubTask)
        }
        
        tableView.register(UINib(nibName: "SubTaskViewController", bundle: nil), forCellReuseIdentifier: "SubTaskViewController")
        tableView.delegate = self
        tableView.dataSource = self
        
        //setup for auto size of cell
        tableView.estimatedRowHeight = 35
        tableView.rowHeight = UITableView.automaticDimension
    
        prepareImages()
    }
    
    var images = [Image]()
    func prepareImages(){
        let myFetch:NSFetchRequest<Image> = Image.fetchRequest()
        let myPredicate = NSPredicate(format: "parentTask.title == %@", (selectedTask?.title!)!)
        myFetch.predicate = myPredicate
        do {
            images = try context.fetch(myFetch)
            print(images.count)
            for img in images{
                imageArray.append(UIImage(data: img.data!)!)
            }
            if(imageArray.count > 0){
                taskImg.image = imageArray[image_index]
            }
            
        }catch{
            print(error)
        }
    }
    
    @IBAction func change_image(_ sender: UIButton) {
        print(sender.tag)
        print(image_index)
        if(sender.tag == 0){
            if(image_index > 0){
                image_index -= 1
                taskImg.image = imageArray[image_index]
            }
        }
        if(sender.tag == 1){
            if(image_index >= 0 && image_index < (imageArray.count - 1)){
                image_index += 1
                taskImg.image = imageArray[image_index]
            }
        }
    }
    
    
    @IBAction func play_audio(_ sender: UIButton) {
        let btn_string = sender.titleLabel?.text
        if(btn_string == "    Play Audio"){
            preparePlayer()
            soundplayer?.play()
            sender.setTitle("    Stop Audio", for: .normal)
            sender.setImage(UIImage(systemName: "stop.fill"), for: .normal)
        }
        if(btn_string == "    Stop Audio"){
            soundplayer?.stop()
            sender.setTitle("    Play Audio", for: .normal)
            sender.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    
    func preparePlayer(){
        do{
            soundplayer=try AVAudioPlayer(data: (selectedTask?.audio)!)
            soundplayer?.delegate = self
            soundplayer?.prepareToPlay()
            soundplayer?.volume=5.0
            
        }catch{
            print(error.localizedDescription)
            
        }
        
    }
    
    
    //perform back action
    @IBAction func goBack(_ sender: Any) {
        
        performSegue(withIdentifier: "goBack", sender: self)
        
    }
    
    //adding subtask
    @IBAction func addSubTask(_ sender: Any) {
        if(checkTitle()){
            let folderName = self.subTasksArray.map{$0.title?.lowercased()}
            //prevent the user to add identical names
            guard !folderName.contains(subTaskTxt.text?.lowercased()) else { self.showAlert(); return}
            let newSubTask = SubTask(context: self.context)
            newSubTask.title = subTaskTxt.text!
            newSubTask.status = false
            selectedTask?.addToSubTasks(newSubTask)
            self.saveTodos()
//            self.updateNotes(with: newSubTask.title!)
//            self.subTasksArray.append(newSubTask)
            tableView.reloadData()
        }
    }
    
    //   to be shown if user enters existing category name
        func showAlert() {
            let alert = UIAlertController(title: "Category with same name already Exists!", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)

        }
   


    //    method to check weather title is empty or not
        func checkTitle() -> Bool {
            if (subTaskTxt.text?.isEmpty ?? true) {
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
        
        let folderPredicate = NSPredicate(format: "parentTask.title=%@", selectedTask!.title!)
     
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        request.predicate = folderPredicate
        
        do{
            subTasksArray = try context.fetch(request)
        }catch{
            print("Error loading notes...\(error.localizedDescription)")
            
        }
        
        tableView.reloadData()
      
    }

    func deleteNote(note: SubTask){
        context.delete(note)
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateNotes(with title: String){
        subTasksArray = []
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
        selectedSubTask = nil
    }
    
}



//MARK: Table view implementation
extension TaskDetailsViewController: UITableViewDelegate,UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subTasksArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubTaskViewController", for: indexPath) as! SubTaskViewController
        
        let task = subTasksArray[indexPath.row]
        cell.label?.text = task.title
        if(task.status == true){
            cell.status_btn.tintColor = UIColor(named: "success")
        }
        if(task.status == false){
            cell.status_btn.tintColor = UIColor(named: "light-grey")
        }
       
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
           let delete = UIContextualAction(style: .destructive, title: "Delete") { [self] (action, view, completion) in
               self.context.delete(self.subTasksArray[indexPath.row])
               self.subTasksArray.remove(at: indexPath.row)
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
        selectedSubTask = subTasksArray[indexPath.row]
        context.delete(selectedSubTask!)
        subTasksArray.removeAll{(SubTask) -> Bool in
                      SubTask == selectedSubTask!
                     
                  }
        saveTodos()
                  tableView.reloadData()
        let alert = UIAlertController(title: "Task Completed", message: "", preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
               self.present(alert, animated: true, completion: nil)
      
    }
    
}
