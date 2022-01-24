//
//  AddTaskViewController.swift
//  task_TheAvengers_IOS
//
//  Created by Litson Thomas on 2022-01-21.
//


import UIKit
import MobileCoreServices
import CoreData

class AddTaskViewController: UIViewController ,UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "test"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    
    var items = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var catPV: UIPickerView!
 
    @IBOutlet weak var heading: UITextField!
    @IBOutlet weak var desc: UITextView!
    @IBOutlet weak var imagee: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        catPV.delegate = self
        catPV.dataSource = self
        
      fetchCategories()
    }
    
    @IBAction func add(_ sender: Any) {
        let alert=UIAlertController(title: "Choose Image For your Task", message: nil, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "Take a photo", style: .default, handler: {action in
            self.openCam()
            
        }))
        alert.addAction(UIAlertAction(title: "Choose from Gallary", style: .default, handler: {action in
            self.openGal()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(handler)in
            
        }))
        present(alert, animated: true)
    }
    
    @IBAction func addtask(_ sender: Any) {
        
        let newtask = Task(context: self.context)
        newtask.createDate = Date()
        newtask.title = heading.text
       // newtask.description = desc.text
        
    }
    
    
  
    @IBAction func recordAudio(_ sender: Any) {
    }
    
    @IBOutlet weak var AudioOutlet: UIButton!
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func openGal()
    {
        let picker=UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        
        picker.allowsEditing=true
        present(picker, animated: true)
        
        
        
    }
    
    func openCam()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            
        let picker=UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        
        picker.allowsEditing=true
        present(picker, animated: true)
        }
        
        
    }
}

extension AddTaskViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image=info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
            return
        }
        
        imagee.image = image    }
  
    func fetchCategories() {
        do {
            self.items = try context.fetch(Category.fetchRequest())
            DispatchQueue.main.async {
                
            }
        }
        catch {
            print(error)
        }
    }
    
    
}
