//
//  FeedbackMessageViewModel.swift
//  videoChamp
//
//  Created by iOS Developer on 04/03/22.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON


class FeedbackMessageViewModel : NSObject {
    
    func feedbackMessage(message : String, feedId : String, completionHandler : @escaping(Bool) -> Void) {
        
        UIApplication.topViewController()?.showActivityIndicator()
        APIManager.shared.sendFeedbackMessage(feedbackId: feedId, message: message) { dict in
            UIApplication.topViewController()?.hideActivityIndicator()
            
            if dict == nil {
                UIApplication.topViewController()?.showAlert(alertMessage: "Directory is Empty...")
            }else{
                
                let statusCode = dict!["status"].stringValue
                let error_msg = dict!["message"].stringValue
                
                if statusCode == "200"{
                    print("msg : \(error_msg)")
                    completionHandler(true)
                }else{
                    print("Error Meaage : \(error_msg)")
                    completionHandler(false)
                }
            }
        }
        
    }
    
}


