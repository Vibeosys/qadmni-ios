//
//  CustItemListTableViewCell.swift
//  Qadmni
//
//  Created by Prakash Sabale on 27/02/17.
//  Copyright © 2017 Qadmni. All rights reserved.
//

import UIKit
import Cosmos

class CustItemListTableViewCell: UITableViewCell {
    @IBOutlet var displayItemImage: UIView!
    @IBOutlet var itemName: UILabel!
    @IBOutlet var favImage: UIImageView!
    @IBOutlet var itemRatingView: CosmosView!
    @IBOutlet var producerNameLabel: UILabel!
    @IBOutlet var itemDescription: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var qautityLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
