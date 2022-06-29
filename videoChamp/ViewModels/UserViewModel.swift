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
    
    
    func registerUser(userName : String, deviceToken : String, completionHandler : @escaping(Bool, String) -> Void) {
        
        UIApplication.topViewController()?.showActivityIndicator()
        
        APIManager.shared.getUser(userName: userName, deviceToken : deviceToken) { dict in
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
    
}
