//
//  TaskTableViewCell.swift
//  task_TheAvengers_IOS
//
//  Created by Litson Thomas on 2022-01-21.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var view_wrapper: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var status: UIImageView!
    @IBOutlet weak var created_date: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        view_wrapper.layer.cornerRadius = 10
        view_wrapper.layer.masksToBounds = true
        view_wrapper.layer.borderWidth = 1
        view_wrapper.layer.borderColor = UIColor(named: "light-grey")?.cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
