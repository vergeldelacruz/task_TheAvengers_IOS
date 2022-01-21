//
//  ViewController.swift
//  task_TheAvengers_IOS
//
//  Created by user209721 on 1/20/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func buttonC_click(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeController") as! HomeController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
}

