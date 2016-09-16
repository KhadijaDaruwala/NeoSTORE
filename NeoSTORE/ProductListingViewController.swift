//
//  ProductListingViewController.swift
//  NeoSTORE
//
//  Created by webwerks1 on 8/3/16.
//  Copyright © 2016 webwerks1. All rights reserved.
//

import UIKit
import SDWebImage

class ProductListingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: Local variables
    var navigationTitle : String?
    var productID : String?
    var productListResponseData = []
    var productListTotalResponseData = []
    var spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    var prodLimit = 0
    
    //MARK: Outlets
    @IBOutlet weak var productTableview: UITableView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu_icon"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SSASideMenu.presentLeftMenuViewController))
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Gotham-Medium", size: 18)!,  NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationItem.title = navigationTitle
        
        if DeviceType.IS_IPHONE_4_OR_LESS
        {
            prodLimit = 5
        }
        else if DeviceType.IS_IPHONE_5
        {
            prodLimit = 6
        }
        else if DeviceType.IS_IPHONE_6
        {
            prodLimit = 7
        }
        else if DeviceType.IS_IPHONE_6P
        {
            prodLimit = 8
        }
        
        spinner.frame = CGRectMake(0, 0, 320, 44)
        self.productTableview.tableFooterView = spinner
    }
    
    func GetTotalProductList() {
        let product_id = "?product_category_id=" + productID!
        let additionalUrlString = "products/getList"
         IJProgressView.shared.showProgressView(view)
        CommonFunctions.sharedInstance.getdataRequest(product_id, accessToken:"", urlStr: additionalUrlString, Block: {
            (AnyObject) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), {
                if (AnyObject.isKindOfClass(NSDictionary)){
                    if(AnyObject["status"] as! NSObject == 200){
                        
                        self.productListTotalResponseData = AnyObject["data"]! as! NSArray
                        self.GetProductList()
                    }else{
                        self.view.makeToast(AnyObject["message"]! as! String)
                    }
                }else{
                    print("No server response")
                }
            })
        })
    }
    
    func GetProductList() {
        let limit = String(prodLimit)
        let product_id = "?product_category_id=" + productID!+"&"+"limit="+limit
        let additionalUrlString = "products/getList"
        if(Reachability.isConnectedToNetwork() == true){
       //     IJProgressView.shared.showProgressView(view)
            
            CommonFunctions.sharedInstance.getdataRequest(product_id, accessToken:"", urlStr: additionalUrlString, Block: {
                (AnyObject) -> Void in
                
                dispatch_async(dispatch_get_main_queue(), {
                    if (AnyObject.isKindOfClass(NSDictionary)){
                        if(AnyObject["status"] as! NSObject == 200){
                            // self.loadingView.hidden = true
                            self.productListResponseData = AnyObject["data"]! as! NSArray
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                self.productTableview.tableFooterView?.hidden = true
                                self.productTableview.reloadData()
                                self.performSelector(#selector(self.refreshcount), withObject: nil, afterDelay: 0)
                            })
                        }else{
                            self.view.makeToast(AnyObject["message"]! as! String)
                        }
                    }else{
                        print("No server response")
                    }
                })
            })
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        GetTotalProductList()
    }
    
    override func viewWillDisappear(animated: Bool) {
        let backItem = UIBarButtonItem()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        backItem.title = " "
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }
    
    func refreshcount() {
        let index = productTableview.visibleCells
        let cell = index.last!
        self.view.makeToast("\(cell.tag) of \(UInt(productListTotalResponseData.count))")
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        prodLimit = prodLimit + 2
        self.productTableview.tableFooterView?.hidden = false
        spinner.startAnimating()
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.GetProductList()
            
        }
    }
    
    //MARK: Tableview delegate functions
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productListResponseData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ProductListingTableViewCell
        cell.layoutMargins = UIEdgeInsetsZero
        cell.separatorInset = UIEdgeInsetsZero
        cell.tag = indexPath.row + 1
        
        let productListDictionary : NSDictionary = productListResponseData[indexPath.row] as! NSDictionary
        
        cell.productName.text = String(productListDictionary["name"]!)
        cell.productOwner.text = String(productListDictionary["producer"]!)
        cell.productPrice.text = "Rs " + String(productListDictionary["cost"]!)
        
        let checkedUrl = NSURL(string: String(productListDictionary["product_images"]!))
        SDWebImageManager.sharedManager().downloadImageWithURL(checkedUrl, options: [],progress: nil, completed: {[weak self] (image, error, cached, finished, url) in
            
            if self != nil {
                //On Main Thread
                dispatch_async(dispatch_get_main_queue()){
                    cell.productListImageView.sd_setImageWithURL(checkedUrl)
                }
            }
            })
        
        let checkedImage = UIImage(named: "star_check")! as UIImage
        let uncheckedImage = UIImage(named: "star_unchek")! as UIImage
        
        let productRate : Int = productListDictionary["rating"] as! Int
        switch productRate {
        case 1:
            cell.starButton1.setImage(checkedImage, forState: .Normal)
            cell.starButton2.setImage(uncheckedImage, forState: .Normal)
            cell.starButton3.setImage(uncheckedImage, forState: .Normal)
            cell.starButton4.setImage(uncheckedImage, forState: .Normal)
            cell.starButton5.setImage(uncheckedImage, forState: .Normal)
        case 2:
            cell.starButton1.setImage(checkedImage, forState: .Normal)
            cell.starButton2.setImage(checkedImage, forState: .Normal)
            cell.starButton3.setImage(uncheckedImage, forState: .Normal)
            cell.starButton4.setImage(uncheckedImage, forState: .Normal)
            cell.starButton5.setImage(uncheckedImage, forState: .Normal)
        case 3:
            cell.starButton1.setImage(checkedImage, forState: .Normal)
            cell.starButton2.setImage(checkedImage, forState: .Normal)
            cell.starButton3.setImage(checkedImage, forState: .Normal)
            cell.starButton4.setImage(uncheckedImage, forState: .Normal)
            cell.starButton5.setImage(uncheckedImage, forState: .Normal)
            
        case 4:
            cell.starButton1.setImage(checkedImage, forState: .Normal)
            cell.starButton2.setImage(checkedImage, forState: .Normal)
            cell.starButton3.setImage(checkedImage, forState: .Normal)
            cell.starButton4.setImage(checkedImage, forState: .Normal)
            cell.starButton5.setImage(uncheckedImage, forState: .Normal)
            
        case 5:
            cell.starButton1.setImage(checkedImage, forState: .Normal)
            cell.starButton2.setImage(checkedImage, forState: .Normal)
            cell.starButton3.setImage(checkedImage, forState: .Normal)
            cell.starButton4.setImage(checkedImage, forState: .Normal)
            cell.starButton5.setImage(checkedImage, forState: .Normal)
            
        default: break
            
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let nextViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ProductDetailsViewController") as! ProductDetailsViewController
        let productListDictionary : NSDictionary = productListResponseData[indexPath.row] as! NSDictionary
        nextViewController.productID = String(productListDictionary["id"]!)
        nextViewController.navigationTitle = String(productListDictionary["name"]!)
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}





