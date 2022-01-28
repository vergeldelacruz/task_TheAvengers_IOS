//
//  SubTaskViewController.swift
//  task_TheAvengers_IOS
//
//  Created by Litson Thomas on 2022-01-28.
//

import UIKit

class SubTaskViewController: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var status_btn: UIButton!
    @IBOutlet weak var delete_btn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
