//
//  OrderIDViewController.swift
//  NeoSTORE
//
//  Created by webwerks1 on 8/12/16.
//  Copyright © 2016 webwerks1. All rights reserved.
//

import UIKit

class OrderIDViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    //MARK: Local Variables
    var orderID : String?
    var navigationTitle : String?
    let accessToken : String = NSUserDefaults.standardUserDefaults().objectForKey("access_token") as! String
    var orderIdDeatilsArray :NSMutableArray  = []
    var orderIdDeatilsResponse : NSDictionary?
    var count = 0
    var totalCost = 0
    
    @IBOutlet weak var orderIdDeatilsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Gotham-Medium", size: 18)!,  NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationItem.title = navigationTitle
        
        let additionalUrlString = "orderDetail"
        let order_id = "?order_id=" + orderID!
        
        if(Reachability.isConnectedToNetwork() == true){
            IJProgressView.shared.showProgressView(view)
            CommonFunctions.sharedInstance.getdataRequest(order_id, accessToken: accessToken, urlStr: additionalUrlString, Block: { (AnyObject) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    if(AnyObject.isKindOfClass(NSDictionary)){
                        if(AnyObject["status"] as! NSObject == 200){
                            
                            self.orderIdDeatilsResponse = AnyObject["data"]! as? NSDictionary
                            self.orderIdDeatilsArray  = self.orderIdDeatilsResponse!["order_details"] as! NSMutableArray
                            self.totalCost = self.orderIdDeatilsResponse!["cost"] as! Int
                            self.orderIdDeatilsTableView.reloadData()
                            
                        }else{
                            self.view.makeToast(AnyObject["message"]as! String)
                        }
                    }else{
                        print("No server response")
                    }
                })
            })
            
        }else{
            //No internet connection
            let alert = UIAlertController(title: "NeoSTORE App", message: "No Internet Connection", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Tableview delegate methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.count = orderIdDeatilsArray.count
        if(count > 0){
            count =  count + 1
        }
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row < orderIdDeatilsArray.count)
        {let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! OrderIDTableViewCell
            let order_detailDict: NSDictionary = orderIdDeatilsArray[indexPath.row] as! NSDictionary
            cell.productName.text = String(order_detailDict["prod_name"]!)
            cell.productCategory.text = String(order_detailDict["prod_cat_name"]!)
            cell.productQuantity.text = "QTY : " + String(order_detailDict["quantity"]!)
            cell.productPrice.text = "Rs " + String(order_detailDict["total"]!)
            let checkedUrl = NSURL(string: String(order_detailDict["prod_image"]!))
            cell.productImageView.sd_setImageWithURL(checkedUrl)
            
            return cell
        }
        else
        {
            let cell1 = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath)as! OrderIDTableViewCell
            cell1.totalPrice.text = "Rs " + String(totalCost)
            return cell1
        }
    }
}
