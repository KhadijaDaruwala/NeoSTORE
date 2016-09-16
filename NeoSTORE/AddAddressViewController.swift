//
//  AddAddressViewController.swift
//  NeoSTORE
//
//  Created by webwerks1 on 8/5/16.
//  Copyright © 2016 webwerks1. All rights reserved.
//

import UIKit

class AddAddressViewController: UIViewController,UITextViewDelegate, UITextFieldDelegate {
    
    let accessToken : String = NSUserDefaults.standardUserDefaults().objectForKey("access_token") as! String
    
    //MARK: Outlets
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var landmarkTextField: CustomTextField!
    @IBOutlet weak var cityTextField: CustomTextField!
    @IBOutlet weak var stateTextField: CustomTextField!
    @IBOutlet weak var zipCodeTextField: CustomTextField!
    @IBOutlet weak var countryTextField: CustomTextField!
    @IBOutlet weak var addressScrollView: UIScrollView!
    
    //MARK: Action button
    @IBAction func saveAddressButton(sender: AnyObject) {
        if((addressTextView.text!.isEmpty)||(addressTextView.text == " ")){
            let alert = UIAlertController(title: "NeoSTORE App" , message: "Address cannot be empty" , preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true , completion: nil)
        }else if((landmarkTextField.text!.isEmpty)||(landmarkTextField.text == " ")){
            landmarkTextField.showAlertDialog("Landmark cannot be empty", viewController: self)
        }else if((cityTextField.text!.isEmpty)||(cityTextField.text == " ")){
            cityTextField.showAlertDialog("City cannot be empty", viewController: self)
        }else if((stateTextField.text!.isEmpty)||(stateTextField.text == " ")){
            stateTextField.showAlertDialog("State cannot be empty", viewController: self)
        }else if((zipCodeTextField.text!.isEmpty)||(zipCodeTextField.text == " ")){
            zipCodeTextField.showAlertDialog("Zipcode cannot be empty", viewController: self)
        }else if((countryTextField.text!.isEmpty)||(countryTextField.text == " ")){
            countryTextField.showAlertDialog("Country cannot be empty", viewController: self)
        }
        else {
            let address = addressTextView.text
            
            //Data dictionary to save user data
            let parameterDictionary:[String : String] =
                ["address": address!]
            let additionalUrlString = "order"
            
            if(Reachability.isConnectedToNetwork() == true){
                IJProgressView.shared.showProgressView(view)
                
                CommonFunctions.sharedInstance.postdataRequest(parameterDictionary, accessToken: accessToken, urlStr: additionalUrlString, Block: {
                    (AnyObject) -> Void in
                    dispatch_async(dispatch_get_main_queue(), {
                        if (AnyObject.isKindOfClass(NSDictionary)){
                            if(AnyObject["status"] as! NSObject == 200) {
                                
                                self.view.makeToast(AnyObject["user_msg"]! as! String)
                                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
                                dispatch_after(delayTime, dispatch_get_main_queue()) {
                                    let nextViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MyOrderDetailsViewController") as! MyOrderDetailsViewController
                                    self.navigationController?.pushViewController(nextViewController, animated: true)
                                }
                            }else{
                                print("Registration Unsuccessful")
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.view.makeToast(AnyObject["message"]! as! String)
                                })
                            }
                        }else{
                            print("No server response")
                        }
                    })
                })}else{
                landmarkTextField.showAlertDialog("No internet connection", viewController: self)
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: UITextField Delegate
    func textFieldDidBeginEditing(textField: UITextField) {
        addressScrollView.contentInset = UIEdgeInsetsMake(0, 0, 280, 0)
        addressScrollView.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        addressScrollView.setContentOffset(CGPointZero, animated: true)
    }
    
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        userText.resignFirstResponder()
        return true;
    }
}
