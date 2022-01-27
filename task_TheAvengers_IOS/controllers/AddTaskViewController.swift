//
//  AddTaskViewController.swift
//  task_TheAvengers_IOS
//
//  Created by Litson Thomas on 2022-01-21.
//


import UIKit
import MobileCoreServices
import CoreData
import PhotosUI
import AVFoundation

class AddTaskViewController: UIViewController ,UIPickerViewDelegate,UIPickerViewDataSource,PHPickerViewControllerDelegate,AVAudioRecorderDelegate{
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
    
    var soundrecorder :  AVAudioRecorder?
    var items = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var filename="testAudio.m4a"
    
    @IBOutlet weak var catPV: UIPickerView!
 
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var heading: UITextField!
    @IBOutlet weak var desc: UITextView!
    @IBOutlet weak var imagee: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        catPV.delegate = self
        catPV.dataSource = self
        setupRecorder()
      fetchCategories()
    }
    
    @IBAction func add(_ sender: Any) {
        let alert=UIAlertController(title: "Choose Image For your Task", message: nil, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "Take a photo", style: .default, handler: {action in
            self.openCam()
            
        }))
        alert.addAction(UIAlertAction(title: "Choose from Gallary", style: .default, handler: {action in
            //self.openGal()
            self.multiplePics()
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
    
    //MARK: Audio Func:
  
    @IBAction func recordAudio(_ sender: UIButton) {
        if sender.titleLabel?.text == "Record Audio"{
            soundrecorder?.record()
            sender.setTitle("Stop Recording", for: .normal)
        }else{
            soundrecorder?.stop()
            sender.setTitle("Record Audio", for: .normal)
        }
    
    }
    
    @IBOutlet weak var AudioOutlet: UIButton!

    
    func setupRecorder()
    {
        let recordsetting = [AVFormatIDKey: kAudioFormatAppleLossless,
                 AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
                      AVEncoderBitRateKey: 320000,
                    AVNumberOfChannelsKey: 2,
                           AVSampleRateKey: 44100.0 ] as [String : Any]
       
        do{
        soundrecorder = try AVAudioRecorder(url: getFileURL() as URL, settings: recordsetting)
        }catch{
            
        return
        }
        soundrecorder?.delegate=self
        soundrecorder?.prepareToRecord()
        
    }
    func getcacheDir() -> String{
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        return paths[0]
    }
    func getFileURL() -> NSURL{
        let path = getcacheDir().appendingFormat(filename)
        let filepath = NSURL(fileURLWithPath: path)
        return filepath
    }
    
    
    
  //MARK: Photos Functions

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
    func multiplePics()
    {
        var config = PHPickerConfiguration()
        config.selectionLimit = 4
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true,completion: nil)
        
        
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        self.imagee.image = nil
        self.image2.image = nil
        self.image3.image = nil
        self.image4.image = nil
        for i in 0..<results.count
        {
            let provider = results[i].itemProvider
            if provider.canLoadObject(ofClass: UIImage.self) {
                    provider.loadObject(ofClass: UIImage.self) { image, error in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            if i == 0 {
                                DispatchQueue.main.async {
                                    self.imagee.image = image as? UIImage
                                    picker.dismiss(animated: true, completion: nil)
                                }
                            } else
                            if i == 1 {
                                DispatchQueue.main.async {
                                    self.image2.image = image as? UIImage
                                    picker.dismiss(animated: true, completion: nil)
                                }
                            } else
                            if i == 2 {
                                DispatchQueue.main.async {
                                    self.image3.image = image as? UIImage
                                    picker.dismiss(animated: true, completion: nil)
                                }
                            } else
                            if i == 3 {
                                DispatchQueue.main.async {
                                    self.image4.image = image as? UIImage
                                    picker.dismiss(animated: true, completion: nil)
                                }
                            }
                        }
                }
            }
        }
    }
    /*
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if let itemprovider = results.first?.itemProvider, itemprovider.canLoadObject(ofClass: UIImage.self)
        { itemprovider.loadObject(ofClass: UIImage.self)
            { [weak self] image, error in
                DispatchQueue.main.async {
                    guard let self = self else{return}
                    if let image=image as? UIImage
                    {
                        self.imagee.image=image
                        picker.dismiss(animated: true, completion: nil)
                    }}}}
        
        
    
        
        
        if let itemprovider = results.first?.itemProvider, itemprovider.canLoadObject(ofClass: UIImage.self)
        { itemprovider.loadObject(ofClass: UIImage.self)
            { [weak self] image, error in
                DispatchQueue.main.async {
                    guard let self = self else{return}
                    if let image=image as? UIImage
                    {
                        self.image2.image=image
                        picker.dismiss(animated: true, completion: nil)
                    }}}}
                
        if let itemprovider = results.first?.itemProvider, itemprovider.canLoadObject(ofClass: UIImage.self)
        { itemprovider.loadObject(ofClass: UIImage.self)
            { [weak self] image, error in
                DispatchQueue.main.async {
                    guard let self = self else{return}
                    if let image=image as? UIImage
                    {
                        self.image3.image=image
                        picker.dismiss(animated: true, completion: nil)
                    }}}}
        if let itemprovider = results.last?.itemProvider, itemprovider.canLoadObject(ofClass: UIImage.self)
        { itemprovider.loadObject(ofClass: UIImage.self)
            { [weak self] image, error in
                DispatchQueue.main.async {
                    guard let self = self else{return}
                    if let image=image as? UIImage
                    {
                        self.image4.image=image
                        picker.dismiss(animated: true, completion: nil)
                    }}}}
        
    }
    */
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        let alert=UIAlertController(title: "Audio Recorded", message: nil, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(handler)in
            
        }))
        present(alert,animated: true)
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
