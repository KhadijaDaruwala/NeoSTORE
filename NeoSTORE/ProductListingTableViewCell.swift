//
//  ProductListingTableViewCell.swift
//  NeoSTORE
//
//  Created by webwerks1 on 8/3/16.
//  Copyright © 2016 webwerks1. All rights reserved.
//

import UIKit

class ProductListingTableViewCell: UITableViewCell {

    //Outlets
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productOwner: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productListImageView: UIImageView!
    @IBOutlet weak var starButton1: UIButton!
    @IBOutlet weak var starButton2: UIButton!
    @IBOutlet weak var starButton3: UIButton!
    @IBOutlet weak var starButton4: UIButton!
    @IBOutlet weak var starButton5: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
