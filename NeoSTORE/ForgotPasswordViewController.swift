//
//  ForgotPasswordViewController.swift
//  NeoSTORE
//
//  Created by webwerks1 on 7/29/16.
//  Copyright © 2016 webwerks1. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    var emailID : String?
    
    //MARK: Outlets
    @IBOutlet weak var emailTextField: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Assigning border color to text field
        emailTextField!.layer.borderWidth = 1
        emailTextField!.layer.borderColor = UIColor.whiteColor().CGColor
        
        //Adding icons to the textfields
        emailTextField.setLeftImage("email_icon")
        emailTextField.text = emailID
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.backItem?.title = " "
    }
    
    override func viewWillDisappear(animated: Bool) {
        let backItem = UIBarButtonItem()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        backItem.title = " "
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }
    
    //MARK: Button Action
    @IBAction func registerButton(sender: AnyObject) {
        let nextViewController = self.storyboard?.instantiateViewControllerWithIdentifier("RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func resetPasswordButton(sender: AnyObject) {
        if((emailTextField.text!.isEmpty)||(emailTextField.text == " ")){
            emailTextField.showAlertDialog("Username cannot be empty", viewController: self)
        }else{
            if(emailTextField.isValidEmail(emailTextField.text!)) {
                
                let additionalUrlString = "users/forgot"
                let parameterDictionary:[String : String] = [
                    "email": emailTextField.text!]
                
                if (Reachability.isConnectedToNetwork() == true) {
                    IJProgressView.shared.showProgressView(view)
                    
                    CommonFunctions.sharedInstance.postdataRequest(parameterDictionary, accessToken: "", urlStr: additionalUrlString, Block: {
                        (AnyObject) -> Void in
                        dispatch_async(dispatch_get_main_queue(), {
                            if (AnyObject.isKindOfClass(NSDictionary)){
                                if(AnyObject["status"] as! NSObject == 200){
                                    
                                    self.view.makeToast(AnyObject["user_msg"]! as! String)
                                    
                                    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
                                    dispatch_after(delayTime, dispatch_get_main_queue()) {
                                        let nextViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
                                        self.navigationController?.pushViewController(nextViewController, animated: true)
                                    }
                                }else{                                                                                        self.view.makeToast(AnyObject["user_msg"]! as! String)
                                }
                            }else{
                                print("No server response")
                            }
                        })
                    })}else{
                    emailTextField.showAlertDialog("No internet connection", viewController: self)
                }
            }else{
                emailTextField.showAlertDialog("Invalid email", viewController: self)
            }
        }
    }
}
