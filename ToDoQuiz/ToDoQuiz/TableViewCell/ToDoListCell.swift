//
//  ToDoListCell.swift
//  ToDoQuiz
//
//  Created by MAC on 01/10/19.
//  Copyright © 2019 Capanicus. All rights reserved.
//

import UIKit

class ToDoListCell: UITableViewCell {

    @IBOutlet weak var todoTextLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
