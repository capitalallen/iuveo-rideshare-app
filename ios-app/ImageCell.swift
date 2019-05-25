//
//  ImageCell.swift
//  iuvo
//
//  Created by Shobha V J on 2018-01-19.
//  Copyright © 2018 vpicku. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell {

    @IBOutlet weak var carpoolImage: UIImageView!
    
    @IBOutlet weak var clockImage: UIImageView!
    
    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet weak var destinationLbl: UILabel!
    
    @IBOutlet weak var priceLbl: UILabel!
    
    @IBOutlet weak var nameLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
