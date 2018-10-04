//
//  MsgBoxTableCell.swift
//  iuvo
//
//  Created by boqian cheng on 2018-01-30.
//  Copyright © 2018 vpicku. All rights reserved.
//

import UIKit

class MsgBoxTableCell: UITableViewCell {
    
    @IBOutlet weak var photoImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var msgLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.photoImg.layer.cornerRadius = 40.0
        self.photoImg.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
