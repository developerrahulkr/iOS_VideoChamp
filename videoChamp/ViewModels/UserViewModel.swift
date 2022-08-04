//
//  UserViewModel.swift
//  videoChamp
//
//  Created by iOS Developer on 23/02/22.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class UserViewModel : NSObject {
    
    
    func registerUser(userName : String, avatarType : String, deviceToken : String, completionHandler : @escaping(Bool, String) -> Void) {
        
        UIApplication.topViewController()?.showActivityIndicator()
        guard APIManager.shared.isConnectedToInternet() else {
            UIApplication.topViewController()?.hideActivityIndicator()
            UIApplication.topViewController()?.showAlert(alertMessage: "Internet is not Access.")
            return
        }
        APIManager.shared.getUser(userName: userName, avatarType: avatarType, deviceToken : deviceToken) { dict in
            UIApplication.topViewController()?.hideActivityIndicator()
            
            if dict == nil {
                print("Directory is Empty")
            }else{
                let statusCode = dict!["status"].stringValue
                let error_msg = dict!["message"].stringValue
                let data = dict!["data"].dictionary
                let token = data!["token"]?.stringValue
                let userManagement = data!["userManagement"]?.dictionary
                let name = userManagement?["name"]?.stringValue
                
                if statusCode == "200"{
                    print(name ?? "")
                    UserDefaults.standard.set(token ?? "", forKey: "Apptoken")
                    print("Baerer token : \(token ?? "")")
                    print(error_msg)
                    completionHandler(true, error_msg)
                }else{
                    completionHandler(false, error_msg)
                    print("Error Msg : \(error_msg)")
                }
            }
        }
    }
    
    
    
    func updateAvatar(updateAvatar : Int, completionHandler : @escaping(Bool, String) -> Void) {
        UIApplication.topViewController()?.hideActivityIndicator()
        guard APIManager.shared.isConnectedToInternet() else {
            UIApplication.topViewController()?.hideActivityIndicator()
            UIApplication.topViewController()?.showAlert(alertMessage: "Internet is not Access.")
            return
        }
        APIManager.shared.updateAvatar(avatarType: updateAvatar) { dict in
            UIApplication.topViewController()?.hideActivityIndicator()
            
            if dict == nil {
                print("Directory is Empty")
            }else{
                let statusCode = dict!["status"].stringValue
                let msg = dict!["message"].stringValue
                let Code = dict!["Code"].stringValue
                if statusCode == "200"{
                   
                    print(msg)
                    completionHandler(true, Code)
                }else{
                    completionHandler(false, Code)
                    print("Error Msg : \(msg)")
                }
            }
        }
        
        
    }
    
}
