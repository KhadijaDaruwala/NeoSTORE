//
//  EditProfileViewController.swift
//  NeoSTORE
//
//  Created by webwerks1 on 8/22/16.
//  Copyright © 2016 webwerks1. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    //Local variables
    let accessToken : String = NSUserDefaults.standardUserDefaults().objectForKey("access_token") as! String
    var firstName,lastName,emailId,phoneNumber,dateOfBirth : String?
    var userDetailResponse: NSDictionary?
    
    //MARK: Outlets
    @IBOutlet weak var profilePicImage: UIImageView!
    @IBOutlet weak var firstNameTextField: CustomTextField!
    @IBOutlet weak var lastNameTextField: CustomTextField!
    @IBOutlet weak var emailIdTextField: CustomTextField!
    @IBOutlet weak var phoneNumberTextField: CustomTextField!
    @IBOutlet weak var dateOfBirthTextField: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTextField.text = firstName
        lastNameTextField.text = lastName
        emailIdTextField.text = emailId
        phoneNumberTextField.text = phoneNumber
        dateOfBirthTextField.text = dateOfBirth
        
        //Adding icons to the textfields
        firstNameTextField.setLeftImage("username_icon")
        lastNameTextField.setLeftImage("username_icon")
        emailIdTextField.setLeftImage("email_icon")
        phoneNumberTextField.setLeftImage("cellphone")
        dateOfBirthTextField.setLeftImage("dob_icon")
        
        //Assigning border color to text field
        firstNameTextField!.layer.borderWidth = 1
        firstNameTextField!.layer.borderColor = UIColor.whiteColor().CGColor
        lastNameTextField!.layer.borderWidth = 1
        lastNameTextField!.layer.borderColor = UIColor.whiteColor().CGColor
        emailIdTextField!.layer.borderWidth = 1
        emailIdTextField!.layer.borderColor = UIColor.whiteColor().CGColor
        dateOfBirthTextField!.layer.borderWidth = 1
        dateOfBirthTextField!.layer.borderColor = UIColor.whiteColor().CGColor
        phoneNumberTextField!.layer.borderWidth = 1
        phoneNumberTextField!.layer.borderColor = UIColor.whiteColor().CGColor
        
        //Round Image View
        profilePicImage.layer.cornerRadius = profilePicImage.frame.height/2
        profilePicImage.clipsToBounds = true
        
        //Keyboard disappers when screen tapped
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditProfileViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: Button Action
    @IBAction func submitAction(sender: AnyObject) {
        if emailIdTextField.isValidEmail(emailIdTextField.text!){
            
            //Data dictionary to save user data
            let parameterDictionary:[String : String] = [
                "first_name": firstNameTextField.text!,
                "last_name": lastNameTextField.text!,
                "email": emailIdTextField.text!,
                "dob": dateOfBirthTextField.text!,
                "profile_pic": "",
                "phone_no": phoneNumberTextField.text!]
            let additionalUrlString = "users/update"
            
            if(Reachability.isConnectedToNetwork() == true){
                IJProgressView.shared.showProgressView(view)
                
                CommonFunctions.sharedInstance.postdataRequest(parameterDictionary, accessToken: accessToken, urlStr: additionalUrlString, Block: {
                    (AnyObject) -> Void in
                    dispatch_async(dispatch_get_main_queue(), {
                        if (AnyObject.isKindOfClass(NSDictionary)){
                            if(AnyObject["status"] as! NSObject == 200) {
                                
                                self.view.makeToast(AnyObject["user_msg"]! as! String)
                                self.userDetailResponse = AnyObject["data"]! as? NSDictionary
                                
                                NSUserDefaults.standardUserDefaults().setObject(self.userDetailResponse!.objectForKey("username") as! String, forKey: "username")
                                NSUserDefaults.standardUserDefaults().setObject(self.userDetailResponse!.objectForKey("first_name") as! String, forKey: "first_name")
                                NSUserDefaults.standardUserDefaults().setObject(self.userDetailResponse!.objectForKey("last_name") as! String, forKey: "last_name")
                                NSUserDefaults.standardUserDefaults().setObject(self.userDetailResponse!.objectForKey("email") as! String, forKey: "email")
                                NSUserDefaults.standardUserDefaults().setObject(self.userDetailResponse!.objectForKey("phone_no") as! String, forKey: "phone_no")
                                NSUserDefaults.standardUserDefaults().setObject(self.userDetailResponse!.objectForKey("access_token") as! String, forKey: "access_token")
                                NSUserDefaults.standardUserDefaults().setObject(self.userDetailResponse!.objectForKey("is_active") as! Bool, forKey: "is_active")
                                NSUserDefaults.standardUserDefaults().synchronize()
                                
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
                firstNameTextField.showAlertDialog("No internet connection", viewController: self)
            }
        }else{
            emailIdTextField.showAlertDialog("Invalid email ID", viewController: self)
        }
    }
}
