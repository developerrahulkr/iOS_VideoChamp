//
//  GenerateNumberViewModel.swift
//  videoChamp
//
//  Created by iOS Developer on 07/04/22.
//

import Foundation
import Alamofire
import UIKit
import SwiftyJSON


class GenerateNumberViewModel : NSObject {
    
    func getGenerateNumber(completionHandler : @escaping(Bool, String, String) -> ()) {
        UIApplication.topViewController()?.showActivityIndicator()
        guard APIManager.shared.isConnectedToInternet() else {
            UIApplication.topViewController()?.hideActivityIndicator()
            UIApplication.topViewController()?.showAlert(alertMessage: "Internet is not Access.")
            return
        }
        APIManager.shared.generateNumber { inDict in
            UIApplication.topViewController()?.hideActivityIndicator()
            
            if inDict == nil {
                UIApplication.topViewController()?.showAlert(alertMessage: "Directory in Empty")
            }else{
                let data = inDict!["data"].dictionary
                let userData = data?["data"]!.dictionary
                let msg = inDict!["message"].stringValue
                let statusCode = inDict!["status"].stringValue
                let blockCode = inDict!["Code"].stringValue
                let number = userData?["number"]?.stringValue
                
                if statusCode == "200" {
                    print(msg)
                    completionHandler(true, number ?? "", blockCode)
                }else{
                    print("error Message \(msg)")
                    completionHandler(false, "",blockCode)
                }
                
            }
        }
    }
    
    
    func verifyNumber(number : String,userID : String, isCamera : Bool, completionHandler : @escaping(Bool,String, String) -> Void){
        
        UIApplication.topViewController()?.showActivityIndicator()
        
        guard APIManager.shared.isConnectedToInternet() else {
            UIApplication.topViewController()?.hideActivityIndicator()
            UIApplication.topViewController()?.showAlert(alertMessage: "Internet is not Access.")
            return
        }
        APIManager.shared.verifyCode(verCode: number, userId: userID, isCamera: isCamera) { dict in
            UIApplication.topViewController()?.hideActivityIndicator()
            if dict == nil {
                print("Directory is Empty")
            }else{
                let statusCode = dict!["status"].stringValue
                let code = dict!["Code"].stringValue
                let message = dict!["message"].stringValue
                if statusCode == "200"{
                    print(message)
                    completionHandler(true,message,code)
                }else{
                    completionHandler(false, message, code)
                    print("Error Msg : \(message)")
                }
            }
        }
    }
    
    
    func termAndConditionsData(completionHandler : @escaping(Bool, String, String) -> Void) {
        UIApplication.topViewController()?.showActivityIndicator()
        guard APIManager.shared.isConnectedToInternet() else {
            UIApplication.topViewController()?.hideActivityIndicator()
            UIApplication.topViewController()?.showAlert(alertMessage: "Internet is not Access.")
            return
        }
        
        APIManager.shared.getTermAndCondition(type: 1) { dict in
            UIApplication.topViewController()?.hideActivityIndicator()
            if dict == nil {
                print("Directory is Empty")
            }else{
                let statusCode = dict!["status"].stringValue
                let blockCode = dict!["Code"].stringValue
                let message = dict!["message"].stringValue
                let data = dict!["data"].dictionary
                let termAndCondition = data?["termsCondition"]?.dictionary
                let condition = termAndCondition?["condition"]?.stringValue
                
                if statusCode == "200"{
                    print(dict as Any)
                    completionHandler(true,condition ?? "", blockCode)
                }else{
                    completionHandler(false, "", blockCode)
                }
            }
        }
    }
    
    
    
}
