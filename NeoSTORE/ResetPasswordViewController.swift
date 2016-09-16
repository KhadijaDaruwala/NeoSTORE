//
//  ResetPasswordViewController.swift
//  NeoSTORE
//
//  Created by webwerks1 on 8/22/16.
//  Copyright © 2016 webwerks1. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    
    let accessToken : String = NSUserDefaults.standardUserDefaults().objectForKey("access_token") as! String
    
    //MARK:Outlets
    @IBOutlet weak var currentPasswordTextField: CustomTextField!
    @IBOutlet weak var newPasswordTextField: CustomTextField!
    @IBOutlet weak var confirmPasswordTextField: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Adding icons to the textfields
        currentPasswordTextField.setLeftImage("password_icon")
        newPasswordTextField.setLeftImage("cpassword_icon")
        confirmPasswordTextField.setLeftImage("cpassword_icon")
        
        
        //Assigning border color to text field
        currentPasswordTextField!.layer.borderWidth = 1
        currentPasswordTextField!.layer.borderColor = UIColor.whiteColor().CGColor
        newPasswordTextField!.layer.borderWidth = 1
        newPasswordTextField!.layer.borderColor = UIColor.whiteColor().CGColor
        confirmPasswordTextField!.layer.borderWidth = 1
        confirmPasswordTextField!.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    //MARK: Button Actions
    @IBAction func resetPasswordButton(sender: AnyObject) {
        //if(currentPasswordTextField)
        if((currentPasswordTextField.text!.isEmpty)||(currentPasswordTextField.text == " ")){
            currentPasswordTextField.showAlertDialog("Password cannot be empty", viewController: self)
        }else if((newPasswordTextField.text!.isEmpty)||(newPasswordTextField.text == " ")){
            newPasswordTextField.showAlertDialog("Last Name cannot be empty", viewController: self)
        }else if(newPasswordTextField.text?.characters.count < 6){
            newPasswordTextField.showAlertDialog("Password cannot be less than 6 characters", viewController: self)
        }else if((confirmPasswordTextField.text!.isEmpty)||(confirmPasswordTextField.text == " ")){
            confirmPasswordTextField.showAlertDialog("Confirm Password cannot be empty", viewController: self)
        }else if(newPasswordTextField.text != confirmPasswordTextField.text){
            confirmPasswordTextField.showAlertDialog("Passwords do not match", viewController: self)
        }else{
            
            //Data dictionary to save user data
            let parameterDictionary:[String : String] = [
                "old_password": currentPasswordTextField.text!,
                "password": newPasswordTextField.text!,
                "confirm_password": confirmPasswordTextField.text!]
            
            let additionalUrlString = "users/change"
            
            if(Reachability.isConnectedToNetwork() == true){
                IJProgressView.shared.showProgressView(view)
                
                CommonFunctions.sharedInstance.postdataRequest(parameterDictionary, accessToken: accessToken, urlStr: additionalUrlString, Block: {
                    (AnyObject) -> Void in
                    dispatch_async(dispatch_get_main_queue(), {
                        if (AnyObject.isKindOfClass(NSDictionary)){
                            if(AnyObject["status"] as! NSObject == 200){
                                
                                self.view.makeToast(AnyObject["user_msg"]! as! String)
                                
                                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
                                dispatch_after(delayTime, dispatch_get_main_queue()) {
                                    let nextViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MyAccountDetailsViewController") as! MyAccountDetailsViewController
                                    self.navigationController?.pushViewController(nextViewController, animated: true)
                                }
                            }else{
                                self.view.makeToast(AnyObject["user_msg"]! as! String)
                            }
                        }else{
                            print("No server response")
                        }
                    })
                })}else{
                currentPasswordTextField.showAlertDialog("No internet connection", viewController: self)
            }
        }
    }
}
