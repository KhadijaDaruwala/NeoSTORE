//
//  slideMenuIconTableViewCell.swift
//  NeoSTORE
//
//  Created by webwerks1 on 8/2/16.
//  Copyright © 2016 webwerks1. All rights reserved.
//

import UIKit

class slideMenuIconTableViewCell: UITableViewCell {
        
    //Outlets
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var slideMenuTextLabel: UILabel!
    @IBOutlet weak var slideMenuIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
