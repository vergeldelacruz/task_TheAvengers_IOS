//
//  AddTaskViewController.swift
//  task_TheAvengers_IOS
//
//  Created by user213744 on 1/21/22.
//

import UIKit
import MobileCoreServices

class AddTaskViewController: UIViewController {

    @IBOutlet weak var imagee: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    
    
}
