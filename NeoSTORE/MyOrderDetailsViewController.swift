//
//  MyOrderDetailsViewController.swift
//  NeoSTORE
//
//  Created by webwerks1 on 8/12/16.
//  Copyright © 2016 webwerks1. All rights reserved.
//

import UIKit

class MyOrderDetailsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    let accessToken : String = NSUserDefaults.standardUserDefaults().objectForKey("access_token") as! String
    
    var myOrderList  = []
    
    @IBOutlet weak var myOrderListTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu_icon"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SSASideMenu.presentLeftMenuViewController))
        
        let additionalUrlString = "orderList"
        if(Reachability.isConnectedToNetwork()==true){
            IJProgressView.shared.showProgressView(view)
            
            CommonFunctions.sharedInstance.getRequest(accessToken, urlStr: additionalUrlString, Block: {
                (AnyObject) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    if (AnyObject.isKindOfClass(NSDictionary)){
                        if(AnyObject["status"] as! NSObject == 200){
                            
                            self.myOrderList = AnyObject["data"] as! NSArray
                            self.myOrderListTableView.reloadData()
                            
                        }else{
                            dispatch_async(dispatch_get_main_queue(), {
                                self.view.makeToast(AnyObject["message"]! as! String)
                                
                            })
                        }
                    }else{
                        print("No server response")
                    }
                })
            })
            
        }else {
            //No internet connection
            let alert = UIAlertController(title: "NeoSTORE App" , message: "No Internet connection" , preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true , completion: nil)
            
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        let backItem = UIBarButtonItem()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        backItem.title = " "
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        self.navigationController?.navigationBarHidden = false
    }
    
    //MARK: Tablebiew delegates
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myOrderList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MyOrderDetailsTableViewCell
        let myOrderListDictionary : NSDictionary = myOrderList[indexPath.row] as! NSDictionary
        cell.orderNumber.text = "Order ID :" + String(myOrderListDictionary["id"]!)
        cell.orderPrice.text = "Rs " + String(myOrderListDictionary["cost"]!)
        cell.orderDate.text =  String(myOrderListDictionary["created"]!)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let myOrderListDictionary : NSDictionary = myOrderList[indexPath.row] as! NSDictionary
        let orderID = String(myOrderListDictionary["id"]!)
        let nextViewController = self.storyboard?.instantiateViewControllerWithIdentifier("OrderIDViewController") as! OrderIDViewController
        nextViewController.orderID = orderID
        nextViewController.navigationTitle = "Order ID :" + orderID
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
}
