//
//  OrderIDTableViewCell.swift
//  NeoSTORE
//
//  Created by webwerks1 on 8/12/16.
//  Copyright © 2016 webwerks1. All rights reserved.
//

import UIKit

class OrderIDTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productCategory: UILabel!
    @IBOutlet weak var productQuantity: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
