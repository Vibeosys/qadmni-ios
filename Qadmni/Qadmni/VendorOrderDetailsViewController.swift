//
//  VendorOrderDetailsViewController.swift
//  Qadmni
//
//  Created by Prakash Sabale on 31/01/17.
//  Copyright © 2017 Qadmni. All rights reserved.
//

import UIKit

class VendorOrderDetailsViewController: UIViewController {

    @IBOutlet var orderIdLabel: UILabel!
    @IBOutlet var orderDateLabel: UILabel!
    @IBOutlet var paymentModeLabel: UILabel!
    @IBOutlet var deliveryTypeLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var customerNameLabel: UILabel!
    @IBOutlet var giftMessageLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var statusImageview: UIImageView!
    
    @IBAction func showOnMapButtonTapped(_ sender: UIButton) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
