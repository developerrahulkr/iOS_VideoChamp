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
    
    func getGenerateNumber(completionHandler : @escaping(Bool, String) -> ()) {
        UIApplication.topViewController()?.showActivityIndicator()
        
        APIManager.shared.generateNumber { inDict in
            UIApplication.topViewController()?.hideActivityIndicator()
            
            if inDict == nil {
                UIApplication.topViewController()?.showAlert(alertMessage: "Directory in Empty")
            }else{
                let data = inDict!["data"].dictionary
                let userData = data?["data"]!.dictionary
                let msg = inDict!["message"].stringValue
                let statusCode = inDict!["status"].stringValue
                
                let number = userData?["number"]?.stringValue
                
                if statusCode == "200" {
                    print("Number Generate : \(number) ")
                    print(msg)
                    completionHandler(true, number ?? "")
                }else{
                    print("error Message \(msg)")
                    completionHandler(false, "")
                }
                
            }
        }
    }
    
    
    func verifyNumber(number : String, completionHandler : @escaping(Bool) -> Void){
        
        UIApplication.topViewController()?.showActivityIndicator()
        APIManager.shared.verifyCode(verCode: number) { dict in
            UIApplication.topViewController()?.hideActivityIndicator()
            if dict == nil {
                print("Directory is Empty")
            }else{
                let statusCode = dict!["status"].stringValue
                let message = dict!["message"].stringValue
                if statusCode == "200"{
                    print(message)
                    completionHandler(true)
                }else{
                    completionHandler(false)
                    print("Error Msg : \(message)")
                }
            }
        }
    }
    
    
    func termAndConditionsData(completionHandler : @escaping(Bool, String) -> Void) {
        UIApplication.topViewController()?.showActivityIndicator()
        
        APIManager.shared.getTermAndCondition(type: 1) { dict in
            UIApplication.topViewController()?.hideActivityIndicator()
            if dict == nil {
                print("Directory is Empty")
            }else{
                let statusCode = dict!["status"].stringValue
                let message = dict!["message"].stringValue
                let data = dict!["data"].dictionary
                
                let termAndCondition = data?["termsCondition"]?.dictionary
                let condition = termAndCondition?["condition"]?.stringValue
                
                if statusCode == "200"{
                    print(dict as Any)
                    completionHandler(true,condition ?? "")
                }else{
                    completionHandler(false, "")
                }
            }
        }
    }
    
    
    
}
