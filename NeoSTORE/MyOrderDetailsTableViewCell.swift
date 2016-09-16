//
//  MyOrderDetailsTableViewCell.swift
//  NeoSTORE
//
//  Created by webwerks1 on 8/12/16.
//  Copyright © 2016 webwerks1. All rights reserved.
//

import UIKit

class MyOrderDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var separator: UILabel!
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var orderPrice: UILabel!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
