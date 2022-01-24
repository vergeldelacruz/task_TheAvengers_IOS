//
//  CategoryTableViewCell.swift
//  task_TheAvengers_IOS
//
//  Created by Litson Thomas on 2022-01-21.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCategoryName: UILabel!
    
    @IBAction func onDelete(_ sender: Any) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
