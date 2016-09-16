//
//  MyCartTableViewCell.swift
//  NeoSTORE
//
//  Created by webwerks1 on 8/9/16.
//  Copyright © 2016 webwerks1. All rights reserved.
//

import UIKit

class MyCartTableViewCell: UITableViewCell {
    
    //Outlets

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productCategory: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var orderNowButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var quantityTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
