//
//  ProductDetailsViewController.swift
//  NeoSTORE
//
//  Created by webwerks1 on 8/9/16.
//  Copyright © 2016 webwerks1. All rights reserved.
//

import UIKit
import SDWebImage
import Social

struct ProductImage {
    var id:String = ""
    var productID:String = ""
    var image :String = ""
    var created :String = ""
    var modified :String = ""
    
    init(image: String) {
        self.image = image
    }
}

class ProductDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, MyPopupViewControllerDelegate, RateNowPopupViewControllerDelegate {
    
    //Local Variables
    var productDetailImageDictionary : NSDictionary?
    var productDetailImages = [ProductImage]()
    var navigationTitle : String?
    var productID : String?
    var productDetailsResponseData: NSDictionary?
    var productDetailsImage = []
    let screenSize: CGRect = UIScreen.mainScreen().bounds //gets the size of the screen
    var product_Name : String?
    var imgset: NSArray?
    var product_imageview : ProductImage?
    
    //MARK: Outlets
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productCategory: UILabel!
    @IBOutlet weak var productOwner: UILabel!
    @IBOutlet weak var starButton1: UIButton!
    @IBOutlet weak var starButton2: UIButton!
    @IBOutlet weak var starButton3: UIButton!
    @IBOutlet weak var starButton4: UIButton!
    @IBOutlet weak var starButton5: UIButton!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productDescription: UITextView!
    @IBOutlet weak var productDetailsCollectionVIew: UICollectionView!
    
    //MARK: Button Actions
    @IBAction func butNowButton(sender: AnyObject) {
        self.displayViewController(.BottomTop)
    }
    
    @IBAction func rateNowButton(sender: AnyObject) {
        self.displayRateNowViewController(.BottomTop)
    }
    
    @IBAction func socialShare(sender: AnyObject) {
        
        let actionSheet = UIAlertController(title: "", message: "Share your App", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        // Configure a new action for sharing the note in Twitter.
        let tweetAction = UIAlertAction(title: "Share on Twitter", style: UIAlertActionStyle.Default) { (action) -> Void in
            
            // Check if sharing to Twitter is possible.
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
                
                // Initialize the default view controller for sharing the post.
                let twitterComposeVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                twitterComposeVC.setInitialText(self.productName.text!)
                twitterComposeVC.addImage(self.productImageView.image)
                
                // Display the compose view controller.
                self.presentViewController(twitterComposeVC, animated: true, completion: nil)
            }
            else {
                self.showAlertMessage("You are not logged in to your Twitter account.")
            }
        }
        let facebookPostAction = UIAlertAction(title: "Share on Facebook", style: UIAlertActionStyle.Default){ (action) -> Void in
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
                let facebookComposeVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                facebookComposeVC.setInitialText(self.productName.text!)
                facebookComposeVC.addImage(self.productImageView.image)
                self.presentViewController(facebookComposeVC, animated: true, completion: nil)
            }
            else {
                self.showAlertMessage("You are not connected to your Facebook account.")
            }
        }
        let dismissAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel) { (action) -> Void in
        }
        actionSheet.addAction(tweetAction)
        actionSheet.addAction(facebookPostAction)
        actionSheet.addAction(dismissAction)
        
        presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func showAlertMessage(message: String!) {
        let alertController = UIAlertController(title: "NeoSTORE", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func displayViewController(animationType: SLpopupViewAnimationType) {
        let product_imageview = productDetailImages[0]
        let myPopupViewController:MyPopupViewController = MyPopupViewController(nibName:"MyPopupViewController", bundle: nil)
        myPopupViewController.delegate = self
        myPopupViewController.product_Name = productName.text
        myPopupViewController.productImage =  product_imageview.image
        myPopupViewController.product_id = productID
        self.presentpopupViewController(myPopupViewController, animationType: animationType, completion: { () -> Void in
        })
    }
    
    func displayRateNowViewController(animationType: SLpopupViewAnimationType) {
        let product_imageview = productDetailImages[0]
        let myPopupViewController:RateNowPopupViewController = RateNowPopupViewController(nibName:"ProductRating", bundle: nil)
        myPopupViewController.delegate = self
        myPopupViewController.product_Name = productName.text
        myPopupViewController.productImage =  product_imageview.image
        myPopupViewController.product_id = productID
        let productRate : Int = self.productDetailsResponseData!["rating"] as! Int
        myPopupViewController.product_rate = productRate
        self.presentpopupViewController(myPopupViewController, animationType: animationType, completion: { () -> Void in
        })
    }
    
    func pressSubmit(sender: MyPopupViewController) {
        self.dismissPopupViewController(.Fade)
    }
    
    func pressRateNow(sender: RateNowPopupViewController) {
        self.dismissPopupViewController(.Fade)
        viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Gotham-Medium", size: 18)!,  NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationItem.title = navigationTitle
        
        let additionalUrlString = "products/getDetail"
        let product_id = "?product_id=" + productID!
        
        if(Reachability.isConnectedToNetwork() == true){
            IJProgressView.shared.showProgressView(view)
            
            CommonFunctions.sharedInstance.getdataRequest(product_id, accessToken:"", urlStr: additionalUrlString, Block: {
                (AnyObject) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    if (AnyObject.isKindOfClass(NSDictionary)){
                        if(AnyObject["status"] as! NSObject == 200){
                            
                            self.productDetailsResponseData = AnyObject["data"]! as? NSDictionary
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                self.productDetailImageDictionary = self.productDetailsResponseData
                                
                                let productImages  = self.productDetailImageDictionary!["product_images"] as! NSArray
                                self.productDetailImages = []
                                for product_image in productImages {
                                    
                                    let prds = product_image["image"] as! String
                                    print(prds)
                                    let pro_image = ProductImage(image: prds)
                                    self.productDetailImages.append(pro_image)
                                }
                                
                                self.productDetailsCollectionVIew.reloadData()
                                self.productName.text = String(self.productDetailsResponseData!["name"]!)
                                self.productOwner.text = String(self.productDetailsResponseData!["producer"]!)
                                self.productPrice.text = "Rs " + String(self.productDetailsResponseData!["cost"]!)
                                self.productDescription.text = String(self.productDetailsResponseData!["description"]!)
                                
                                let checkedImage = UIImage(named: "star_check")! as UIImage
                                let uncheckedImage = UIImage(named: "star_unchek")! as UIImage
                                let productRate : Int = self.productDetailsResponseData!["rating"] as! Int
                                switch productRate {
                                case 1:
                                    self.starButton1.setImage(checkedImage, forState: .Normal)
                                    self.starButton2.setImage(uncheckedImage, forState: .Normal)
                                    self.starButton3.setImage(uncheckedImage, forState: .Normal)
                                    self.starButton4.setImage(uncheckedImage, forState: .Normal)
                                    self.starButton5.setImage(uncheckedImage, forState: .Normal)
                                case 2:
                                    self.starButton1.setImage(checkedImage, forState: .Normal)
                                    self.starButton2.setImage(checkedImage, forState: .Normal)
                                    self.starButton3.setImage(uncheckedImage, forState: .Normal)
                                    self.starButton4.setImage(uncheckedImage, forState: .Normal)
                                    self.starButton5.setImage(uncheckedImage, forState: .Normal)
                                case 3:
                                    self.starButton1.setImage(checkedImage, forState: .Normal)
                                    self.starButton2.setImage(checkedImage, forState: .Normal)
                                    self.starButton3.setImage(checkedImage, forState: .Normal)
                                    self.starButton4.setImage(uncheckedImage, forState: .Normal)
                                    self.starButton5.setImage(uncheckedImage, forState: .Normal)
                                case 4:
                                    self.starButton1.setImage(checkedImage, forState: .Normal)
                                    self.starButton2.setImage(checkedImage, forState: .Normal)
                                    self.starButton3.setImage(checkedImage, forState: .Normal)
                                    self.starButton4.setImage(checkedImage, forState: .Normal)
                                    self.starButton5.setImage(uncheckedImage, forState: .Normal)
                                case 5:
                                    self.starButton1.setImage(checkedImage, forState: .Normal)
                                    self.starButton2.setImage(checkedImage, forState: .Normal)
                                    self.starButton3.setImage(checkedImage, forState: .Normal)
                                    self.starButton4.setImage(checkedImage, forState: .Normal)
                                    self.starButton5.setImage(checkedImage, forState: .Normal)
                                default:
                                    print("Error")
                                }
                                
                                let productCategoryNum : Int = self.productDetailsResponseData!["product_category_id"]! as! Int
                                switch productCategoryNum {
                                case 1 :
                                    self.productCategory.text = "Category - Tables"
                                case 2 :
                                    self.productCategory.text = "Category - Chairs"
                                case 3 :
                                    self.productCategory.text = "Category - Sofa"
                                case 4 :
                                    self.productCategory.text = "Category - Cupboards"
                                default:
                                    print("Error")
                                }
                                self.product_imageview = self.productDetailImages[0]
                                self.productImageView.sd_setImageWithURL(NSURL(string: self.product_imageview!.image))
                            })
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
    
    override func viewWillDisappear(animated: Bool) {
        let backItem = UIBarButtonItem()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        backItem.title = " "
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }
    
    //MARK: Collection view delegate methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return productDetailImages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as!ProductDetailsCollectionViewCell
        print(productDetailImageDictionary)
        
        let product_image = productDetailImages[indexPath.row]
        cell.productImage.sd_setImageWithURL(NSURL(string: product_image.image))
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var screenwidth : CGFloat
        var padding : CGFloat
        var itemWidth : CGFloat
        screenwidth = screenSize.width
        padding = 10.0 * 6;
        itemWidth = (screenwidth - padding) / 3.0;
        
        return CGSizeMake(itemWidth, itemWidth); // The size of one cell
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as? ProductDetailsCollectionViewCell
        cell?.productImage.layer.borderColor = UIColor.clearColor().CGColor
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath)! as! ProductDetailsCollectionViewCell
        let product_image = productDetailImages[indexPath.row]
        productImageView.sd_setImageWithURL(NSURL(string: product_image.image))
        cell.productImage.layer.borderWidth = 1
        cell.productImage.layer.borderColor = UIColor.redColor().CGColor
    }
}
