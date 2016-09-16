//
//  CustomTextField.swift
//  NeoSTORE
//
//  Created by webwerks1 on 7/25/16.
//  Copyright © 2016 webwerks1. All rights reserved.
//

import UIKit
import Foundation

class CustomTextField: UITextField {
    
    //MARK: Custom functions
    func setLeftImage(image : NSString) {
        let Padding = UIImageView(image: UIImage(named: image as String))
        Padding.frame = CGRectMake(0.0, 0.0, Padding.image!.size.width+15.0, Padding.image!.size.height);
        Padding.contentMode = UIViewContentMode.Center
        self.leftView = Padding;
        self.leftViewMode = UITextFieldViewMode.Always
    }
    
    func showAlertDialog(strMsg: String, viewController: UIViewController){
        let alert = UIAlertController(title: "NeoSTORE App" , message: strMsg , preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(okAction)
        viewController.presentViewController(alert, animated: true , completion: nil)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluateWithObject(testStr)
        return result
    }
}


