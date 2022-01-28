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

class AddTaskViewController: UIViewController, PHPickerViewControllerDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate{
    
    var soundrecorder :  AVAudioRecorder?
    var soundplayer : AVAudioPlayer?
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var filename="testAudio.m4a"
    
    
    @IBOutlet weak var select_category: UITextField!
    var catPV = UIPickerView()
    var if_recording: Bool = true;
    var images = [UIImage]();
    var selected_category: Category?
    @IBOutlet weak var show_images_btn: UIButton!
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var heading: UITextField!
    @IBOutlet weak var desc: UITextView!
    @IBOutlet weak var imagee: UIImageView!
    @IBOutlet weak var play_audio_button: UIButton!
    @IBOutlet weak var images_modal: UIView!
    @IBOutlet weak var modal_close_btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        select_category.inputView = catPV
        
        catPV.delegate = self
        catPV.dataSource = self
        setupRecorder()
        fetchCategories()
        
        play_audio_button.alpha = 0.5
        play_audio_button.isEnabled = false
    }
    
    @IBAction func add(_ sender: Any) {
        let alert=UIAlertController(title: "Maximum 4 images only", message: nil, preferredStyle:.alert)
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
        newtask.desc = desc.text
        guard let data = try? Data(contentsOf: getFileURL() as URL) else { return }
        newtask.audio = data
        newtask.category = selected_category
        for img in images{
            let newImage = Image(context: self.context)
            newImage.image = img.pngData()
            newtask.addToImages(newImage)
        }
        do {
            try self.context.save()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    //MARK: Audio Func:
    @IBAction func recordAudio(_ sender: UIButton) {
        if if_recording == true{
            soundrecorder?.record()
            play_audio_button.setTitle("Recording...", for: .normal)
            AudioOutlet.setTitle("Stop  ", for: .normal)
            if_recording = false
        }else{
            soundrecorder?.stop()
            play_audio_button.setTitle("Play Audio", for: .normal)
            AudioOutlet.setTitle("Record  ", for: .normal)
            if_recording = true
            play_audio_button.isEnabled = true
            play_audio_button.alpha = 1
        }
    
    }
    
    @IBOutlet weak var AudioOutlet: UIButton!

    
    func setupRecorder()
    {
        let session = AVAudioSession.sharedInstance()
        do
        {
            try session.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
            try session.setActive(true)
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
            ]
            soundrecorder = try AVAudioRecorder(url: getFileURL() as URL, settings: settings)
            soundrecorder?.delegate = self
            soundrecorder?.isMeteringEnabled = true
            soundrecorder?.prepareToRecord()
        }
        catch let error {
            display_alert(msg_title: "Error", msg_desc: error.localizedDescription, action_title: "OK")
        }
        
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
    
    @IBAction func playaudio(_ sender: UIButton) {
        if sender.titleLabel?.text == "Play Audio"
        {

            if FileManager.default.fileExists(atPath: getFileURL().path!)
            {
                print("playing")
                sender.setTitle("Stop Audio", for: .normal)
                preparePlayer()
                soundplayer?.play()
            }
            else{
                display_alert(msg_title: "Error", msg_desc: "Audio file is missing.", action_title: "OK")
           }
        }else{
            soundplayer?.stop()
            sender.setTitle("Play Audio", for: .normal)
        }
    }
    func preparePlayer(){
        do{
            soundplayer=try AVAudioPlayer(contentsOf: getFileURL() as URL)
            soundplayer?.delegate = self
            soundplayer?.prepareToPlay()
            soundplayer?.volume=5.0
            
        }catch{
            print(error.localizedDescription)
            
        }
        
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
        images.removeAll()
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
                                    self.images.append(self.imagee.image!)
                                    picker.dismiss(animated: true, completion: nil)
                                }
                            } else
                            if i == 1 {
                                DispatchQueue.main.async {
                                    self.image2.image = image as? UIImage
                                    self.images.append(self.image2.image!)
                                    picker.dismiss(animated: true, completion: nil)
                                }
                            } else
                            if i == 2 {
                                DispatchQueue.main.async {
                                    self.image3.image = image as? UIImage
                                    self.images.append(self.image3.image!)
                                    picker.dismiss(animated: true, completion: nil)
                                }
                            } else
                            if i == 3 {
                                DispatchQueue.main.async {
                                    self.image4.image = image as? UIImage
                                    self.images.append(self.image4.image!)
                                    picker.dismiss(animated: true, completion: nil)
                                }
                            }
                        }
                }
            }
        }
        
        // update the images show button title
        show_images_btn.setTitle("Images (\(results.count))", for: .normal)
        // update the show button state
        show_images_btn.isEnabled = true
        show_images_btn.alpha = 1
    }
    
    @IBAction func showImages(_ sender: UIButton) {
        if(sender.isEnabled){
            images_modal.isHidden = false
            images_modal.alpha = 1
        }
    }
    
    @IBAction func closeModal(_ sender: Any) {
        images_modal.isHidden = true
        images_modal.alpha = 0
    }
    
    
    
    func display_alert(msg_title : String , msg_desc : String ,action_title : String)
    {
        let ac = UIAlertController(title: msg_title, message: msg_desc, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: action_title, style: .default)
        {
            (result : UIAlertAction) -> Void in
        _ = self.navigationController?.popViewController(animated: true)
        })
        present(ac, animated: true)
    }
    
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
    
}


// CATEGORY PICKER VIEW FUNCTIONS
extension AddTaskViewController: UIPickerViewDelegate,UIPickerViewDataSource{
    
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
        return categories.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        select_category.text = categories[row].name
        select_category.resignFirstResponder()
        selected_category = categories[row]
    }
    
}
