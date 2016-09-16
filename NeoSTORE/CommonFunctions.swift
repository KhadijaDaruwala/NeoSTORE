
//
//  CommanFunctions.swift
//  NeoSTORE
//
//  Created by Webwerks on 11/03/16.
//  Copyright © 2016 Webwerks. All rights reserved.
//

import UIKit

class CommonFunctions: NSObject {
    
    typealias completionBlockType = (AnyObject) ->Void
    
    static let sharedInstance = CommonFunctions()
    let baseURL = "http://staging.php-dev.in:8844/trainingapp/api/"
    
    func reDirector(className: String, currentView : UIViewController) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(className)
            currentView.navigationController?.pushViewController(viewController, animated: true)
        })
    }
    
    func getRequest(accessToken: String, urlStr: String, Block block:completionBlockType) {
        //created url
        let url:NSURL = NSURL(string: baseURL + urlStr)!
        //created reqiuest Object
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.setValue(accessToken, forHTTPHeaderField: "access_token")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        //set Body as NSdata
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler:
            {
                data, response, error in
                dispatch_async(dispatch_get_main_queue(), {
                    IJProgressView.shared.hideProgressView()
                })
                
                let datastring = try! NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers) as! NSDictionary
                block(datastring)
        })
        task.resume()
    }
    
    func getdataRequest(parameters: String, accessToken: String ,urlStr: String, Block block:completionBlockType) {
        //created url
        let url:NSURL = NSURL(string: baseURL + urlStr + parameters)!
        //created reqiuest Object
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(accessToken, forHTTPHeaderField: "access_token")
        //set Body as NSdata
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler:
            {
                data, response, error in
                dispatch_async(dispatch_get_main_queue(), {
                    IJProgressView.shared.hideProgressView()
                })
                let datastring = try! NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers) as! NSDictionary
                block(datastring)
        })
        task.resume()
    }
    
    func postdataRequest(parameters:[String : String], accessToken: String, urlStr: String, Block block:completionBlockType) {
        
        
        let session = NSURLSession.sharedSession()
        let url:NSURL = NSURL(string: baseURL + urlStr)!
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST" //set http method as POST
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(accessToken, forHTTPHeaderField: "access_token")
        setBodyContent(parameters, request: request)
        let task =  session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                IJProgressView.shared.hideProgressView()
            })
            let datastring = try! NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers) as! NSDictionary
            block(datastring)
        })
        
        task.resume()
    }
    
    func postRequest(parameters: String, accessToken: String, urlStr: String, Block block:completionBlockType) {
        //created vairbale to store email and pass
        let requestData = parameters
        //data from string
        let  postData:NSData = requestData.dataUsingEncoding(NSUTF8StringEncoding)!
        //store length
        let  postLength:String = String(postData.length)
        //created url
        let url:NSURL = NSURL(string: baseURL + urlStr)!
        //created reqiuest Object
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        request.setValue(accessToken, forHTTPHeaderField: "access_token")
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        //set Body as NSdata
        request.HTTPBody = postData
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler:
            {
                data, response, error in
                dispatch_async(dispatch_get_main_queue(), {
                    IJProgressView.shared.hideProgressView()
                })
                let datastring = try! NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers) as! NSDictionary
                block(datastring)
        })
        task.resume()
    }
    
    func setBodyContent(contentMap: Dictionary<String, String>, request:NSMutableURLRequest)
    {
        var firstOneAdded = false
        var contentBodyAsString = String()
        let contentKeys:Array<String> = Array(contentMap.keys)
        for contentKey in contentKeys {
            if(!firstOneAdded) {
                
                contentBodyAsString = contentBodyAsString + contentKey + "=" + contentMap[contentKey]!
                firstOneAdded = true
            }
            else {
                contentBodyAsString = contentBodyAsString + "&" + contentKey + "=" + contentMap[contentKey]!
            }
        }
        contentBodyAsString = contentBodyAsString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        request.HTTPBody = contentBodyAsString.dataUsingEncoding(NSUTF8StringEncoding)
    }
}

enum UIUserInterfaceIdiom : Int
{
    case Unspecified
    case Phone
    case Pad
}

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.mainScreen().bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.mainScreen().bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.currentDevice().userInterfaceIdiom == .Pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
}