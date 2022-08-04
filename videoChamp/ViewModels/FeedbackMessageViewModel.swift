//
//  FeedbackMessageViewModel.swift
//  videoChamp
//
//  Created by iOS Developer on 04/03/22.
import Foundation
import UIKit
import Alamofire
import SwiftyJSON
class FeedbackMessageViewModel : NSObject {
    func feedbackMessageData( imageData : Data?, messageData : CMFeedbackMessageData, completionHandler : @escaping(Bool,String) -> Void) {
        let param = ["feedbackId" : messageData.feedbackId ?? "", "message" : messageData.message ?? "", "image" : messageData.image ?? ""] as [String : Any]
        UIApplication.topViewController()?.showActivityIndicator()
        
        guard APIManager.shared.isConnectedToInternet() else {
            UIApplication.topViewController()?.hideActivityIndicator()
            UIApplication.topViewController()?.showAlert(alertMessage: "Internet is not Access.")
            return
        }
        
        APIManager.shared.postFeedbackMessageData(imgData: imageData, parameter: param) { inDict in
            UIApplication.topViewController()?.hideActivityIndicator()
            if inDict == nil {
                UIApplication.topViewController()?.showAlert(alertMessage: "Directory is Empty...")
            }else{
                
                let statusCode = inDict!["status"].stringValue
                let error_msg = inDict!["message"].stringValue
                let blockCode = inDict!["Code"].stringValue
                if statusCode == "200"{
                    print("msg : \(error_msg)")
                    completionHandler(true, blockCode)
                }else{
                    print("Error Meaage : \(error_msg)")
                    completionHandler(false, blockCode)
                }
            }
        }
    }
}


