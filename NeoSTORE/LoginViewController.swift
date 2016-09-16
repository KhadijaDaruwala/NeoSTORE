//
//  LoginViewController.swift
//  NeoSTORE
//
//  Created by webwerks1 on 7/25/16.
//  Copyright © 2016 webwerks1. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var userDetailResponse : NSDictionary?
    
    //MARK: Outlets
    @IBOutlet weak var userNameTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var loginScrollView: UIScrollView!
    @IBOutlet weak var plusButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var registerAccountConstraint: NSLayoutConstraint!
    
    //MARK: Button actions
    @IBAction func loginButton(sender: UIButton) {
        if((userNameTextField.text!.isEmpty)||(userNameTextField.text == " ")){
            userNameTextField.showAlertDialog("Username cannot be empty", viewController: self)
        }else if((passwordTextField.text!.isEmpty)||(passwordTextField.text == " ")){
            passwordTextField.showAlertDialog("Password cannot be empty", viewController: self)
        }else if(passwordTextField.text?.characters.count < 6){
            passwordTextField.showAlertDialog("Password cannot be less than 6 characters", viewController: self)
        }else{
            if userNameTextField.isValidEmail(userNameTextField.text!)
            {
                //Data dictionary to save user data
                let parameterDictionary:[String : String] = [
                    "email": userNameTextField.text!,
                    "password": passwordTextField.text!]
                let additionalUrlString = "users/login"
                
                if (Reachability.isConnectedToNetwork() == true) {
                    IJProgressView.shared.showProgressView(view)
                    CommonFunctions.sharedInstance.postdataRequest(parameterDictionary, accessToken: "", urlStr: additionalUrlString, Block: {
                        (AnyObject) -> Void in
                        dispatch_async(dispatch_get_main_queue(), {
                            if (AnyObject.isKindOfClass(NSDictionary)){
                                if(AnyObject["status"] as! NSObject == 200){
                                    
                                    self.view.makeToast(AnyObject["user_msg"]! as! String)
                                    self.userDetailResponse = AnyObject["data"]! as? NSDictionary
                                    
                                    //Saving user deatils in User defaults
                                    NSUserDefaults.standardUserDefaults().setObject(self.userDetailResponse!.objectForKey("username") as! String, forKey: "username")
                                    NSUserDefaults.standardUserDefaults().setObject(self.userDetailResponse!.objectForKey("first_name") as! String, forKey: "first_name")
                                    NSUserDefaults.standardUserDefaults().setObject(self.userDetailResponse!.objectForKey("last_name") as! String, forKey: "last_name")
                                    NSUserDefaults.standardUserDefaults().setObject(self.userDetailResponse!.objectForKey("email") as! String, forKey: "email")
                                    NSUserDefaults.standardUserDefaults().setObject(self.userDetailResponse!.objectForKey("phone_no") as! String, forKey: "phone_no")
                                    NSUserDefaults.standardUserDefaults().setObject(self.userDetailResponse!.objectForKey("access_token") as! String, forKey: "access_token")
                                    NSUserDefaults.standardUserDefaults().setObject(self.userDetailResponse!.objectForKey("is_active") as! Bool, forKey: "is_active")
                                    NSUserDefaults.standardUserDefaults().synchronize()
                                    
                                    //Check if user already logged in or not
                                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                                    appDelegate.application(UIApplication.sharedApplication(), didFinishLaunchingWithOptions: nil)
                                    
                                    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
                                    dispatch_after(delayTime, dispatch_get_main_queue()) {
                                        let nextViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HomePageViewController") as! HomePageViewController
                                        self.navigationController?.pushViewController(nextViewController, animated: true)
                                    }
                                }else{
                                    print("Login Unsuccessful")
                                    self.view.makeToast(AnyObject["user_msg"]! as! String)
                                    
                                }
                            }else{
                                print("No server response")
                            }
                        })
                    })}else{
                    userNameTextField.showAlertDialog("No internet connection", viewController: self)
                }
            } else {
                userNameTextField.showAlertDialog("Invalid email ID", viewController: self)
            }
        }
    }
    
    @IBAction func ForgotPasswordButton(sender: UIButton) {
        let nextViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ForgotPasswordViewController") as! ForgotPasswordViewController
        nextViewController.emailID = userNameTextField.text
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func resgisterButton(sender: AnyObject) {
        let nextViewController = self.storyboard?.instantiateViewControllerWithIdentifier("RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if DeviceType.IS_IPHONE_4_OR_LESS
        {
            plusButtonConstraint.constant = 50
            registerAccountConstraint.constant = 33
        }
        else if DeviceType.IS_IPHONE_5
        {
            plusButtonConstraint.constant = 130
            registerAccountConstraint.constant = 113
        }
        else if DeviceType.IS_IPHONE_6
        {
            plusButtonConstraint.constant = 240
            registerAccountConstraint.constant = 223
        }
        else if DeviceType.IS_IPHONE_6P
        {
            plusButtonConstraint.constant = 290
            registerAccountConstraint.constant = 273
        }
        
        //Adding icons to the textfields
        userNameTextField.setLeftImage("username_icon")
        passwordTextField.setLeftImage("cpassword_icon")
        
        //Assigning border color to text field
        userNameTextField!.layer.borderWidth = 1
        userNameTextField!.layer.borderColor = UIColor.whiteColor().CGColor
        passwordTextField!.layer.borderWidth = 1
        passwordTextField!.layer.borderColor = UIColor.whiteColor().CGColor
        
        //Keyboard disappers when screen tapped
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillDisappear(animated: Bool) {
        let backItem = UIBarButtonItem()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        backItem.title = " "
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: UITextField Delegate
    func textFieldDidBeginEditing(textField: UITextField) {
        loginScrollView.contentInset = UIEdgeInsetsMake(0, 0, 280, 0)
        loginScrollView.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        loginScrollView.setContentOffset(CGPointZero, animated: true)
    }
    
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        userText.resignFirstResponder()
        return true;
    }
    
}
