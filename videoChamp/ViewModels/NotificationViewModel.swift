//
//  NotificationViewModel.swift
//  videoChamp
//
//  Created by iOS Developer on 03/03/22.
//

import Foundation
import UIKit

class NotificationViewModel : NSObject {
    
    lazy var getNotificationDataSource : [CMGetFeedbackData] = {
        let notificationData = [CMGetFeedbackData]()
        return notificationData
    }()
    
    
    func getNotificationData(completionHandler : @escaping(Bool, Bool) -> ()){
        UIApplication.topViewController()?.showActivityIndicator()
        
        APIManager.shared.getNotification { inDict in
            UIApplication.topViewController()?.hideActivityIndicator()
            if inDict == nil {
                UIApplication.topViewController()?.showAlert(alertMessage: "Directory is Empty")
            }else{
                let msg = inDict!["message"].stringValue
                let statusCode = inDict!["status"].stringValue
                
                let data = inDict!["data"].dictionary
                let notificationList = data!["notificationList"]!.arrayValue
                if statusCode == "200"{
                    for dic in notificationList {
                        self.getNotificationDataSource.append(CMGetFeedbackData(title: dic["title"].stringValue, desc: dic["description"].stringValue, time: dic["createdAt"].stringValue, _id: dic["_id"].stringValue))
                        
                    }
                    print("\(msg)")
                    self.getNotificationDataSource.reverse()
                    completionHandler(true,true)
                    if notificationList.isEmpty {
                        completionHandler(true, false)
                    }
                }else{
                    completionHandler(false, false)
                    print("error Message : \(msg)")
                }
            }
        }
    }
    
}
