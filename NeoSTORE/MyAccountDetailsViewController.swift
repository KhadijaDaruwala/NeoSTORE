//
//  MyAccountDetailsViewController.swift
//  NeoSTORE
//
//  Created by webwerks1 on 8/12/16.
//  Copyright © 2016 webwerks1. All rights reserved.
//

import UIKit

class MyAccountDetailsViewController: UIViewController {
    
    //Local Variables
    let accessToken : String = NSUserDefaults.standardUserDefaults().objectForKey("access_token") as! String
    var userDetailResponse: NSDictionary?
    var userDetails : NSDictionary?
    
    //MARK: Outlets
    @IBOutlet weak var profilePicImage: UIImageView!
    @IBOutlet weak var firstNameTextFIeld: CustomTextField!
    @IBOutlet weak var lastNameTextField: CustomTextField!
    @IBOutlet weak var emailIdTextField: CustomTextField!
    @IBOutlet weak var phoneNumberTextField: CustomTextField!
    @IBOutlet weak var dateOfBirthTextField: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Adding icons to the textfields
        firstNameTextFIeld.setLeftImage("username_icon")
        lastNameTextField.setLeftImage("username_icon")
        emailIdTextField.setLeftImage("email_icon")
        phoneNumberTextField.setLeftImage("cellphone")
        dateOfBirthTextField.setLeftImage("dob_icon")
        
        //Assigning border color to text field
        firstNameTextFIeld!.layer.borderWidth = 1
        firstNameTextFIeld!.layer.borderColor = UIColor.whiteColor().CGColor
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
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyAccountDetailsViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu_icon"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SSASideMenu.presentLeftMenuViewController))
        
        let additionalUrlString = "users/getUserData"
        if(Reachability.isConnectedToNetwork()==true){
            IJProgressView.shared.showProgressView(view)
            
            CommonFunctions.sharedInstance.getRequest(accessToken, urlStr: additionalUrlString, Block: {
                (AnyObject) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    if (AnyObject.isKindOfClass(NSDictionary)){
                        if(AnyObject["status"] as! NSObject == 200) {
                            
                            self.userDetailResponse = AnyObject["data"]! as? NSDictionary
                            self.userDetails  = self.userDetailResponse!["user_data"] as? NSDictionary
                            
                            self.firstNameTextFIeld.text = String(self.userDetails!["first_name"]!)
                            self.lastNameTextField.text = String(self.userDetails!["last_name"]!)
                            self.emailIdTextField.text = String(self.userDetails!["email"]!)
                            self.phoneNumberTextField.text = String(self.userDetails!["phone_no"]!)
                            self.dateOfBirthTextField.text = String(self.userDetails!["dob"]!)
                        }
                        else{
                            self.view.makeToast(AnyObject["user_msg"]! as! String)
                        }
                    }else{
                        print("No server response")
                    }
                })
            })
            
        }else {
            firstNameTextFIeld.showAlertDialog("No internet connection", viewController: self)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        let backItem = UIBarButtonItem()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        backItem.title = " "
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        self.navigationController?.navigationBarHidden = false
    }
    
    //MARK: Button Actions
    @IBAction func editProfileButton(sender: AnyObject) {
        let nextViewController = self.storyboard?.instantiateViewControllerWithIdentifier("EditProfileViewController") as! EditProfileViewController
        nextViewController.firstName = String(userDetails!["first_name"]!)
        nextViewController.lastName = String(userDetails!["last_name"]!)
        nextViewController.emailId = String(userDetails!["email"]!)
        nextViewController.phoneNumber = String(userDetails!["phone_no"]!)
        nextViewController.dateOfBirth = String(userDetails!["dob"]!)
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func resetPasswordButton(sender: AnyObject) {
        let nextViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ResetPasswordViewController") as! ResetPasswordViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
}
