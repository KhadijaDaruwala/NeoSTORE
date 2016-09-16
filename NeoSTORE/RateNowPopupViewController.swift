//
//  RateNowPopupViewController.swift
//  NeoSTORE
//
//  Created by webwerks1 on 8/17/16.
//  Copyright © 2016 webwerks1. All rights reserved.
//

import UIKit
import SDWebImage

protocol RateNowPopupViewControllerDelegate {
    func pressRateNow(sender: RateNowPopupViewController)
}

class RateNowPopupViewController: UIViewController {
    
    //MARK: Local variables
    var delegate:RateNowPopupViewControllerDelegate?
    var ratingResponse : NSDictionary?
    var product_Name : String?
    var productImage : String?
    var product_id: String?
    var product_rate: Int = 0
    var rateTag =  0
    
    //MARK: Outlets
    @IBOutlet weak var starButton1: UIButton!
    @IBOutlet weak var starButton2: UIButton!
    @IBOutlet weak var starButton3: UIButton!
    @IBOutlet weak var starButton4: UIButton!
    @IBOutlet weak var starButton5: UIButton!
    @IBOutlet weak var rateNowImageView: UIImageView!
    @IBOutlet weak var rateNowProductName: UILabel!
    
    //MARK: Button Action
    @IBAction func cancelButton(sender: AnyObject) {
        self.delegate?.pressRateNow(self)
    }
    
    @IBAction func rateNowButton(sender: AnyObject) {
        
        if(rateTag != 0){
            
            let prodRating  = String(Int(rateTag as NSNumber))
            let parameters = "product_id="+product_id!+"&"+"rating="+prodRating
            
            let additionalUrlString = "products/setRating"
            if (Reachability.isConnectedToNetwork() == true) {
                IJProgressView.shared.showProgressView(view)
                
                CommonFunctions.sharedInstance.postRequest(parameters, accessToken: "", urlStr: additionalUrlString, Block: {
                    (AnyObject) -> Void in
                    dispatch_async(dispatch_get_main_queue(), {
                        if (AnyObject.isKindOfClass(NSDictionary)){
                            if(AnyObject["status"] as! NSObject == 200) {
                                
                                self.ratingResponse = AnyObject["data"]! as? NSDictionary
                                print(self.ratingResponse)
                                self.view.makeToast(AnyObject["user_msg"]! as! String)
                                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
                                dispatch_after(delayTime, dispatch_get_main_queue()) {
                                    self.delegate?.pressRateNow(self)
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
                })}else{
                let alert = UIAlertController(title: "NeoSTORE App" , message: "No Internet connection" , preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true , completion: nil)
            }
        }else{
            let alert = UIAlertController(title: "NeoSTORE App" , message: "Invalid rating" , preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true , completion: nil)
        }
    }
    
    @IBAction func rateNowStar(sender: AnyObject) {
        rateTag = sender.tag
        
        let checkedImage = UIImage(named: "star_check")! as UIImage
        let uncheckedImage = UIImage(named: "star_unchek")! as UIImage
        switch rateTag {
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.cornerRadius = 22
        self.view.layer.masksToBounds = true
        rateNowProductName.text = product_Name
        rateNowImageView.sd_setImageWithURL(NSURL(string: productImage!))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
