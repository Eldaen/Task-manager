//
//  TaskTableViewCell.swift
//  Task-manager
//
//  Created by Денис Сизов on 14.02.2022.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

	@IBOutlet weak var taskNameLabel: UILabel!
	@IBOutlet weak var subtasksLabel: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
