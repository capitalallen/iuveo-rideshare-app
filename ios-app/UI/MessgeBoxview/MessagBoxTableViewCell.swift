//
//  MessagBoxTableViewCell.swift
//  iuvo
//
//  Created by Govind Lokhande on 2018-02-10.
//  Copyright © 2018 vpicku. All rights reserved.
//

import UIKit

class MessagBoxTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    
    @IBOutlet weak var placelbl: UILabel!
    @IBOutlet weak var chatLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.profilePic.layer.cornerRadius = 40.0
        self.profilePic.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
