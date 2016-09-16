//
//  RegisterViewController.swift
//  NeoSTORE
//
//  Created by webwerks1 on 7/26/16.
//  Copyright © 2016 webwerks1. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate{
    
    //Local Variables
    var isGenderCheck = false
    var termsCheck = true
    
    //MARK: Outlets
    @IBOutlet weak var firstNameTextField: CustomTextField!
    @IBOutlet weak var lastNameTextField: CustomTextField!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var confrimPasswordTextField: CustomTextField!
    @IBOutlet weak var phoneNumberTextField: CustomTextField!
    @IBOutlet weak var termsAndConditionsLabel: UILabel!
    @IBOutlet weak var registerScrolView: UIScrollView!
    @IBOutlet weak var maleCheckButton: UIButton!
    @IBOutlet weak var femaleCheckButton: UIButton!
    @IBOutlet weak var termsCheckButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Adding icons to the textfields
        firstNameTextField.setLeftImage("username_icon")
        lastNameTextField.setLeftImage("username_icon")
        emailTextField.setLeftImage("email_icon")
        passwordTextField.setLeftImage("password_icon")
        confrimPasswordTextField.setLeftImage("cpassword_icon")
        phoneNumberTextField.setLeftImage("cellphone")
        
        //Assigning border color to text field
        firstNameTextField!.layer.borderWidth = 1
        firstNameTextField!.layer.borderColor = UIColor.whiteColor().CGColor
        lastNameTextField!.layer.borderWidth = 1
        lastNameTextField!.layer.borderColor = UIColor.whiteColor().CGColor
        emailTextField!.layer.borderWidth = 1
        emailTextField!.layer.borderColor = UIColor.whiteColor().CGColor
        passwordTextField!.layer.borderWidth = 1
        passwordTextField!.layer.borderColor = UIColor.whiteColor().CGColor
        confrimPasswordTextField!.layer.borderWidth = 1
        confrimPasswordTextField!.layer.borderColor = UIColor.whiteColor().CGColor
        phoneNumberTextField!.layer.borderWidth = 1
        phoneNumberTextField!.layer.borderColor = UIColor.whiteColor().CGColor
        
        //Keyboard disappers when screen tapped
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: UITextField Delegate
    func textFieldDidBeginEditing(textField: UITextField) {
        registerScrolView.contentInset = UIEdgeInsetsMake(0, 0, 280, 0)
        registerScrolView.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        registerScrolView.setContentOffset(CGPointZero, animated: true)
    }
    
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        userText.resignFirstResponder()
        return true;
    }
    
    //MARK: Button Actions
    @IBAction func maleCheckButton(sender: AnyObject) {
        let checkedImage = UIImage(named: "chky")! as UIImage
        let uncheckedImage = UIImage(named: "chkn")! as UIImage
        if (isGenderCheck == true) {
            maleCheckButton.setImage(checkedImage, forState: .Normal)
            femaleCheckButton.setImage(uncheckedImage, forState: .Normal)
            isGenderCheck = false
        }
    }
    
    @IBAction func femaleCheckButton(sender: AnyObject) {
        let checkedImage = UIImage(named: "chky")! as UIImage
        let uncheckedImage = UIImage(named: "chkn")! as UIImage
        if (isGenderCheck == false) {
            maleCheckButton.setImage(uncheckedImage, forState: .Normal)
            femaleCheckButton.setImage(checkedImage, forState: .Normal)
            isGenderCheck = true
        }
    }
    
    @IBAction func termsCheckButton(sender: AnyObject) {
        //Images
        let checkedImage = UIImage(named: "checked_icon")! as UIImage
        let uncheckedImage = UIImage(named: "uncheck_icon")! as UIImage
        if (termsCheck) {
            termsCheckButton.setImage(checkedImage, forState: .Normal)
            termsCheck = false
        }else{
            termsCheckButton.setImage(uncheckedImage, forState: .Normal)
            termsCheck = true
        }
    }
    
    @IBAction func registerButton(sender: AnyObject) {
        if((firstNameTextField.text!.isEmpty)||(firstNameTextField.text == " ")){
            firstNameTextField.showAlertDialog("First Name cannot be empty", viewController: self)
        }else if((lastNameTextField.text!.isEmpty)||(lastNameTextField.text == " ")){
            lastNameTextField.showAlertDialog("Last Name cannot be empty", viewController: self)
        }else if((emailTextField.text!.isEmpty)||(emailTextField.text == " ")){
            emailTextField.showAlertDialog("Email cannot be empty", viewController: self)
        }else if((passwordTextField.text!.isEmpty)||(passwordTextField.text == " ")){
            passwordTextField.showAlertDialog("Password cannot be empty", viewController: self)
        }else if(passwordTextField.text?.characters.count < 6){
            passwordTextField.showAlertDialog("Password cannot be less than 6 characters", viewController: self)
        }else if((confrimPasswordTextField.text!.isEmpty)||(firstNameTextField.text == " ")){
            confrimPasswordTextField.showAlertDialog("Confirm Password cannot be empty", viewController: self)
        }else if(passwordTextField.text != confrimPasswordTextField.text){
            passwordTextField.showAlertDialog("Passwords do not match", viewController: self)
        }
        else if((phoneNumberTextField.text!.isEmpty)||(phoneNumberTextField.text == " ")){
            phoneNumberTextField.showAlertDialog("Phone number cannot be empty", viewController: self)
        }
        else if(termsCheck) {
            let controller = UIAlertController(title: "Agreement", message:"Please Accept Terms & Conditions", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            controller.addAction(okAction)
            presentViewController(controller, animated: true, completion: nil)
        }
        else {
            if emailTextField.isValidEmail(emailTextField.text!)
            {
                var gender = "M"
                if (isGenderCheck == true)
                {
                    gender = "F"
                }
                
                //Data dictionary to save user data
                let parameterDictionary:[String : String] = [
                    "first_name": firstNameTextField.text!,
                    "last_name": lastNameTextField.text!,
                    "email": emailTextField.text!,
                    "password": passwordTextField.text!,
                    "confirm_password": confrimPasswordTextField.text!,
                    "gender": gender,
                    "phone_no": phoneNumberTextField.text!]
                
                let additionalUrlString = "users/register"
                if(Reachability.isConnectedToNetwork() == true){
                    IJProgressView.shared.showProgressView(view)
                    
                    CommonFunctions.sharedInstance.postdataRequest(parameterDictionary, accessToken: "", urlStr: additionalUrlString, Block: {
                        (AnyObject) -> Void in
                        dispatch_async(dispatch_get_main_queue(), {
                            if (AnyObject.isKindOfClass(NSDictionary)){
                                if(AnyObject["status"] as! NSObject == 200){
                                    
                                    self.view.makeToast(AnyObject["user_msg"]! as! String)
                                    
                                    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
                                    dispatch_after(delayTime, dispatch_get_main_queue()) {
                                        let nextViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
                                        self.navigationController?.pushViewController(nextViewController, animated: true)
                                    }
                                }else{
                                    print("Registration Unsuccessful")
                                    self.view.makeToast(AnyObject["user_msg"]! as! String)
                                }
                            }else{
                                print("No server response")
                            }
                        })
                    })}else{
                    emailTextField.showAlertDialog("No internet connection", viewController: self)
                }
            }else {
                emailTextField.showAlertDialog("Invalid email ID", viewController: self)
            }
        }
    }
}
