//
//  MyCartViewController.swift
//  NeoSTORE
//
//  Created by webwerks1 on 8/9/16.
//  Copyright © 2016 webwerks1. All rights reserved.
//

import UIKit
import SDWebImage

class MyCartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    //MARK: Local variables
    let accessToken : String = NSUserDefaults.standardUserDefaults().objectForKey("access_token") as! String
    var myCartListResponse : NSMutableArray  = []
    var myCartProductdeatils = []
    var productQuantity = []
    var productIds = []
    var total : Int?
    var count = 0
    
    //MARK: Outlets
    @IBOutlet weak var cartTableView: UITableView!
    
    @IBAction func orderNowButton(sender: AnyObject) {
        let nextViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AddAddressViewController") as! AddAddressViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    //MARK : Custom functions
    func plusButton(sender: AnyObject) {
        let buttonRow = sender.tag
        var prodQty  = productQuantity[buttonRow]
        prodQty  = String(Int(prodQty as! NSNumber) + 1)
        let myCartListDictionary : NSDictionary = self.myCartProductdeatils[buttonRow] as! NSDictionary
        let prodId = String(myCartListDictionary["id"]!)
        editCart(prodQty as! String, prodId: prodId)
    }
    
    func minusButton(sender: AnyObject) {
        let buttonRow = sender.tag
        var prodQty  = productQuantity[buttonRow]
        prodQty  = String(Int(prodQty as! NSNumber) - 1)
        let myCartListDictionary : NSDictionary = self.myCartProductdeatils[buttonRow] as! NSDictionary
        let prodId = String(myCartListDictionary["id"]!)
        editCart(prodQty as! String, prodId: prodId)
    }
    
    func editCart(prodQty : String, prodId : String ){
        
        let additionalUrlString = "editCart"
        let parameters = "product_id="+prodId+"&"+"quantity="+prodQty
        
        if(Reachability.isConnectedToNetwork() == true){
            CommonFunctions.sharedInstance.postRequest(parameters, accessToken: self.accessToken, urlStr: additionalUrlString, Block: {
                (AnyObject) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    if (AnyObject.isKindOfClass(NSDictionary)){
                        if(AnyObject["status"] as! NSObject == 200){
                            
                            self.view.makeToast(AnyObject["user_msg"]! as! String)
                            self.viewWillAppear(true)
                            
                        }else{
                            self.view.makeToast(AnyObject["user_msg"]! as! String)
                        }
                    }else{
                        print("No server response")
                    }
                })
            })
        }else{
            let alert = UIAlertController(title: "NeoSTORE App" , message: "No Internet connection" , preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true , completion: nil)
        }
    }
    
    //MARK: Overide functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu_icon"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SSASideMenu.presentLeftMenuViewController))
        
        let additionalUrlString = "cart"
        if(Reachability.isConnectedToNetwork()==true){
            IJProgressView.shared.showProgressView(view)
            
            CommonFunctions.sharedInstance.getRequest(accessToken, urlStr: additionalUrlString, Block: {
                (AnyObject) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    if (AnyObject.isKindOfClass(NSDictionary)){
                        if(AnyObject["status"] as! NSObject == 200){
                            if(AnyObject["data"]! as! NSObject === NSNull()){
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.cartTableView.reloadData()
                                    let msg: String = AnyObject["user_msg"]! as! String
                                    self.view.makeToast(msg)
                                })
                                
                            }else{
                                self.myCartListResponse = AnyObject["data"] as! NSMutableArray
                                self.total = AnyObject["total"]! as? Int
                                self.myCartProductdeatils = self.myCartListResponse.valueForKey("product") as! NSArray
                                self.productQuantity =  self.myCartListResponse.valueForKey("quantity") as! NSArray
                                self.productIds = self.myCartListResponse.valueForKey("id") as! NSArray
                                self.cartTableView.reloadData()
                            }
                        }else{
                            dispatch_async(dispatch_get_main_queue(), {
                                self.view.makeToast(AnyObject["user_msg"]! as! String)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        let backItem = UIBarButtonItem()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        backItem.title = " "
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        self.navigationController?.navigationBarHidden = false
    }
    
    //MARK: Tableview delegate methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.count = myCartListResponse.count
        if(count > 0){
            count =  count + 2
        }
        return count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (indexPath.row < myCartListResponse.count)
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MyCartTableViewCell
            let myCartListDictionary : NSDictionary = myCartProductdeatils[indexPath.row] as! NSDictionary
            productQuantity =  self.myCartListResponse.valueForKey("quantity") as! NSArray
            cell.quantityTextField.text = String(productQuantity[indexPath.row])
            cell.productName.text = String(myCartListDictionary["name"]!)
            cell.productPrice.text = "Rs " + String(myCartListDictionary["sub_total"]!)
            cell.productCategory.text   = String(myCartListDictionary["product_category"]!)
            let checkedUrl = NSURL(string: String(myCartListDictionary["product_images"]!))
            cell.productImageView.sd_setImageWithURL(checkedUrl)
            cell.plusButton.tag = indexPath.row
            cell.plusButton.addTarget(self, action: #selector(MyCartViewController.plusButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            cell.minusButton.tag = indexPath.row
            cell.minusButton.addTarget(self, action: #selector(MyCartViewController.minusButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            return cell
        }
            
        else if (indexPath.row == myCartListResponse.count)
        {
            let cell1 = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath)as! MyCartTableViewCell
            cell1.selectionStyle = UITableViewCellSelectionStyle.None
            
            cell1.totalPrice.text = "Rs " + String(self.total!)
            return cell1
        }
        else  {
            let cell2 = tableView.dequeueReusableCellWithIdentifier("cell2", forIndexPath: indexPath)as! MyCartTableViewCell
            cell2.selectionStyle = UITableViewCellSelectionStyle.None
            
            return cell2
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if ((indexPath.row == self.count - 2)||(indexPath.row == self.count - 1)) {
            return false
        }
        return true
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let rowDelete = UITableViewRowAction(style: .Normal, title: "          ") { (action: UITableViewRowAction, indexPath: NSIndexPath) -> Void in
            
            let myCartListDictionary : NSDictionary = self.myCartProductdeatils[indexPath.row] as! NSDictionary
            let productId = String(myCartListDictionary["id"]!)
            let parameters = "product_id=" + productId
            let additionalUrlString = "deleteCart"
            
            if(Reachability.isConnectedToNetwork() == true){
                CommonFunctions.sharedInstance.postRequest(parameters, accessToken: self.accessToken, urlStr: additionalUrlString, Block: {
                    (AnyObject) -> Void in
                    dispatch_async(dispatch_get_main_queue(), {
                        if (AnyObject.isKindOfClass(NSDictionary)){
                            if(AnyObject["status"] as! NSObject == 200) {
                                
                                self.view.makeToast(AnyObject["user_msg"]! as! String)
                                self.myCartListResponse.removeObjectAtIndex(indexPath.row)
                                self.viewWillAppear(true)
                                self.cartTableView.reloadData()
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
            }else{
                let alert = UIAlertController(title: "NeoSTORE App" , message: "No Internet connection" , preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true , completion: nil)
            }
        }
        rowDelete.backgroundColor = UIColor(patternImage: UIImage(named: "delete")!)
        return [rowDelete]
    }
}


