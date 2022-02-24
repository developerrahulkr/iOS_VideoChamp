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
    
    
    func registerUser(userName : String, completionHandler : @escaping(Bool) -> Void) {
        
        ProgressBar.shared.showProgressbar()
        APIManager.shared.getUser(userName: userName) { dict in
            ProgressBar.shared.hideProgressBar()
            
            if dict == nil {
                print("Directory is Empty")
            }else{
                let statusCode = dict!["status"].stringValue
                let error_msg = dict!["message"].stringValue
                let data = dict!["data"].dictionary
                let token = data!["token"]?.stringValue
                let userManagement = data!["userManagement"]?.dictionary
                let name = userManagement!["name"]?.stringValue
                if statusCode == "200"{
                    print(name ?? "")
                    UserDefaults.standard.set(token ?? "", forKey: "Apptoken")
                    print("token : \(token ?? "")")
                    print(error_msg)
                    completionHandler(true)
                }else{
                    completionHandler(false)
                    print("Error Msg : \(error_msg)")
                }
            }
        }
    }
    
}
