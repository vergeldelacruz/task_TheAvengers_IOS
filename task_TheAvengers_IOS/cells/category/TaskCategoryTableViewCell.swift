//
//  TaskCategoryTableViewCell.swift
//  task_TheAvengers_IOS
//
//  Created by Vergel dela Cruz on 1/23/22.
//

import UIKit

class TaskCategoryTableViewCell: UITableViewCell {

    
    @IBOutlet weak var containerWrapper: UIView!
    @IBOutlet weak var lblCategoryName: UILabel!
    var controller: AddCategoryController?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerWrapper.layer.cornerRadius = 10
        containerWrapper.layer.masksToBounds = true
    }

    @IBAction func onDelete(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: controller?.tableView)
        guard let indexPath = controller?.tableView.indexPathForRow(at:point) else {
            return
        }
        controller?.deleteCategory(indexPath: indexPath.row)
        //controller?.tableView.deleteRows(at: [indexPath], with: .left)
        //controller?.tableView.reloadData()
        controller?.fetchCategories()
        controller?.tableView.reloadData()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
