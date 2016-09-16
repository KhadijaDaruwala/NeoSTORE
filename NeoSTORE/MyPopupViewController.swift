//
//  MyPopupViewController.swift
//  SLPopupViewControllerDemo
//
//  Created by Nguyen Duc Hoang on 9/13/15.
//  Copyright © 2015 Nguyen Duc Hoang. All rights reserved.
//

import UIKit
import SDWebImage

protocol MyPopupViewControllerDelegate {
    func pressSubmit(sender: MyPopupViewController)
}
class MyPopupViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Local variables
    var delegate:MyPopupViewControllerDelegate?
    let access : String = NSUserDefaults.standardUserDefaults().objectForKey("access_token") as! String
    var product_Name : String?
    var productImage : String?
    var product_id: String?
    
    //MARK: Outlets
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productQuantity: CustomTextField!
    @IBOutlet weak var productImageView: UIImageView!
    
    //MARK: Button Actions
    @IBAction func cancelButton(sender: AnyObject) {
        self.delegate?.pressSubmit(self)
    }
    
    @IBAction func submitButton(sender: AnyObject) {
        
        let parameterDictionary:[String : String] = [
            "product_id": product_id!,
            "quantity": self.productQuantity.text!]
        let urlStr = "addToCart"
        
        if(Reachability.isConnectedToNetwork() == true){
            IJProgressView.shared.showProgressView(self.view.superview!)
            CommonFunctions.sharedInstance.postdataRequest(parameterDictionary, accessToken: access ,urlStr: urlStr, Block: { (AnyObject) -> Void in
                
                if(AnyObject.isKindOfClass(NSDictionary)) {
                    if (AnyObject["status"]! as! NSObject == 200) {
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            let msg: String = AnyObject["user_msg"]! as! String
                            self.view.makeToast(msg)
                        })
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.099 * Double(NSEC_PER_SEC))),dispatch_get_main_queue(), { () -> Void in
                            self.delegate?.pressSubmit(self)
                        })
                    }
                    else{
                        dispatch_async(dispatch_get_main_queue(), {
                            let msg: String = AnyObject["user_msg"]! as! String
                            self.view.makeToast(msg)
                        })
                    }
                }
                else{
                    self.view.makeToast("No server response")
                }
            })
        }
        else {
            //No internet connection
            let alert = UIAlertController(title: "NeoSTORE App" , message: "No Internet connection" , preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true , completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer.cornerRadius = 22
        self.view.layer.masksToBounds = true
        productName.text = product_Name
        productImageView.sd_setImageWithURL(NSURL(string: productImage!))
        
        //Keyboard disappers when screen tapped
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: Textfield delegate
    func textFieldDidBeginEditing(textField: UITextField) {
        UIView.animateWithDuration(0.2) { () -> Void in
            var y : Int?
            
            if DeviceType.IS_IPHONE_4_OR_LESS
            {
                y = -95
            }
            else if DeviceType.IS_IPHONE_5
            {
                y = -15
            }
            else if DeviceType.IS_IPHONE_6
            {
                y = 24
            }
            else if DeviceType.IS_IPHONE_6P
            {
                y = 83
            }
            else{
                y = 0
            }
            
            self.view.frame = CGRectMake(self.view.frame.origin.x, CGFloat(y!), self.view.frame.size.width, self.view.frame.size.height)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        UIView.animateWithDuration(0.2) { () -> Void in
            self.view.center = (self.view.superview?.center)!
        }
    }
    
}
