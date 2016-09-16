//
//  SlideMenuViewController.swift
//  NeoSTORE
//
//  Created by webwerks1 on 8/2/16.
//  Copyright © 2016 webwerks1. All rights reserved.
//

import UIKit

class SlideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Local variables
    let accessToken : String = NSUserDefaults.standardUserDefaults().objectForKey("access_token") as! String
    var myCartListResponse :NSMutableArray?
    var cartCount : Int = 0
    var cellSelected:UITableViewCell?
    var isHighlighted: Bool?
    
    //MARK: Outlets
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var Sidetableview: UITableView!
    @IBOutlet weak var slideViewWidth: NSLayoutConstraint!
    
    //MARK: Arrays
    let titles: [String] = ["My Cart", "Tables", "Sofas", "Chairs", "Cupboards","My Account", "Store Locator","My Orders", "Logout"]
    let images: [String] = ["my_cart", "table_icon_new", "sofa_icon_new", "chair_icon_new", "cupboard_icon", "my_account_icon", "locator", "my_order", "logout"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePicImageView.layer.borderWidth = 4
        profilePicImageView.layer.masksToBounds = false
        profilePicImageView.layer.borderColor = UIColor.whiteColor().CGColor
        profilePicImageView.layer.cornerRadius = profilePicImageView.frame.height/2
        profilePicImageView.clipsToBounds = true
        
        if DeviceType.IS_IPHONE_4_OR_LESS
        {
            slideViewWidth.constant = 238
        }
        else if DeviceType.IS_IPHONE_5
        {
            slideViewWidth.constant = 238
        }
        else if DeviceType.IS_IPHONE_6
        {
            slideViewWidth.constant = 275
        }
        else if DeviceType.IS_IPHONE_6P
        {
            slideViewWidth.constant = 298
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let firstname = NSUserDefaults.standardUserDefaults().objectForKey("first_name") as? String
        let lastname = NSUserDefaults.standardUserDefaults().objectForKey("last_name") as? String
        let emailId = NSUserDefaults.standardUserDefaults().objectForKey("email") as? String
        
        profileName.text = firstname!  + " " + lastname!
        userName.text = emailId
        
        let additionalUrlString = "cart"
        if(Reachability.isConnectedToNetwork()==true){
            
            CommonFunctions.sharedInstance.getRequest(accessToken, urlStr: additionalUrlString, Block: {
                (AnyObject) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    if (AnyObject.isKindOfClass(NSDictionary)){
                        if(AnyObject["status"] as! NSObject == 200){
                            if(AnyObject["data"]! as! NSObject === NSNull()){
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.cartCount = 0
                                    self.Sidetableview.reloadData()
                                })
                            }else{
                                
                                self.myCartListResponse = AnyObject["data"] as? NSMutableArray
                                self.cartCount = AnyObject["count"]! as! Int
                                self.Sidetableview.reloadData()
                            }
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Tableview delegate methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  titles.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! slideMenuIconTableViewCell
        cell.layoutMargins = UIEdgeInsetsZero
        cell.contentView.backgroundColor = UIColor.clearColor()
        
        if (isHighlighted == true){
            cellSelected?.contentView.backgroundColor = UIColor.grayColor()
        }
        cell.slideMenuTextLabel?.text  = titles[indexPath.row]
        cell.slideMenuIcon.image = UIImage(named: images[indexPath.row])
        cell.countLabel.hidden = true
        cell.countLabel.layer.masksToBounds = false
        cell.countLabel.layer.cornerRadius =  cell.countLabel.frame.height/2
        cell.countLabel.clipsToBounds = true
        cell.countLabel.text = String(self.cartCount)
        
        if(indexPath.row == 0){
            cell.countLabel.hidden = false
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cellToDeSelect:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        cellToDeSelect.contentView.backgroundColor = UIColor.clearColor()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        cellSelected = tableView.cellForRowAtIndexPath(indexPath)!
        cellSelected?.contentView.backgroundColor = UIColor.grayColor()
        isHighlighted = true
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        switch indexPath.row {
            
        case 0:
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MyCartViewController")
            sideMenuViewController?.contentViewController = UINavigationController(rootViewController: viewController)
            sideMenuViewController?.hideMenuViewController()
            
        case 1:
            let nextViewController:ProductListingViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ProductListingViewController") as! ProductListingViewController
            nextViewController.productID = "1"
            nextViewController.navigationTitle = "Tables"
            
            sideMenuViewController?.contentViewController = UINavigationController(rootViewController: nextViewController)
            sideMenuViewController?.hideMenuViewController()
            
        case 2:
            let nextViewController:ProductListingViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ProductListingViewController") as! ProductListingViewController
            nextViewController.productID = "3"
            nextViewController.navigationTitle = "Sofas"
            
            sideMenuViewController?.contentViewController = UINavigationController(rootViewController: nextViewController)
            sideMenuViewController?.hideMenuViewController()
            
        case 3:
            let nextViewController:ProductListingViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ProductListingViewController") as! ProductListingViewController
            nextViewController.productID = "2"
            nextViewController.navigationTitle = "Chairs"
            
            sideMenuViewController?.contentViewController = UINavigationController(rootViewController: nextViewController)
            sideMenuViewController?.hideMenuViewController()
            
        case 4:
            let nextViewController:ProductListingViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ProductListingViewController") as! ProductListingViewController
            nextViewController.productID = "4"
            nextViewController.navigationTitle = "Cupboards"
            
            sideMenuViewController?.contentViewController = UINavigationController(rootViewController: nextViewController)
            sideMenuViewController?.hideMenuViewController()
            
        case 5:
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MyAccountDetailsViewController")
            sideMenuViewController?.contentViewController = UINavigationController(rootViewController: viewController)
            sideMenuViewController?.hideMenuViewController()
            
        case 6:
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("StoreLocatorViewController")
            sideMenuViewController?.contentViewController = UINavigationController(rootViewController: viewController)
            sideMenuViewController?.hideMenuViewController()
            
        case 7:
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MyOrderDetailsViewController")
            sideMenuViewController?.contentViewController = UINavigationController(rootViewController: viewController)
            sideMenuViewController?.hideMenuViewController()
            
        case 8:
            NSUserDefaults.standardUserDefaults().removeObjectForKey("is_active")
            NSUserDefaults.standardUserDefaults().synchronize()
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController")
            let nav = UINavigationController(rootViewController: viewController)
            appDelegate.window!.rootViewController = nav
        default:
            break
        }
    }
}
