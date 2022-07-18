//
//  NotificationViewModel.swift
//  videoChamp
//
//  Created by iOS Developer on 03/03/22.
//

import Foundation
import UIKit

class NotificationViewModel : NSObject {
    
    lazy var getNotificationDataSource : [CMGetNotificationData] = {
        let notificationData = [CMGetNotificationData]()
        return notificationData
    }()

    lazy var readDataSource : [CMReadNotificationStatus] = {
        let readData = [CMReadNotificationStatus]()
        return readData
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
                let notificationList = data?["notificationList"]!.arrayValue
                if statusCode == "200"{
                    for dic in notificationList! {
                        self.getNotificationDataSource.append(CMGetNotificationData(title: dic["title"].stringValue, desc: dic["description"].stringValue, time: dic["createdAt"].stringValue, _id: dic["_id"].stringValue, status: dic["status"].stringValue))
                        print("notification id : \(dic["_id"].stringValue)")
                        
                    }
                    self.getNotificationDataSource.reverse()
                    completionHandler(true,true)
                    if notificationList!.isEmpty {
                        completionHandler(true, false)
                    }
                }else{
                    completionHandler(false, false)
                    print("error Message : \(msg)")
                }
            }
        }
    }
    
    
    
    func readNotificationData(notificationId : String, completionHandler : @escaping(Bool, String) -> ()) {
        UIApplication.topViewController()?.showActivityIndicator()
        APIManager.shared.readNotification(notificationId: notificationId) { inDict in
            UIApplication.topViewController()?.hideActivityIndicator()
            if inDict == nil {
                UIApplication.topViewController()?.showAlert(alertMessage: "Directory is Empty!")
            }else{
                let statusCode = inDict!["status"].stringValue
                let msg = inDict!["message"].stringValue
                let data = inDict!["data"].dictionary
                let blockCode = inDict!["Code"].stringValue
                let notification = data!["notification"]?.dictionary
                let read_status = notification!["status"]?.stringValue
                
                if statusCode == "200"{
                    completionHandler(true, blockCode)
                    print("read Status : \(read_status ?? "")")
                    print(msg)
                }else{
                    completionHandler(false,blockCode)
                }
                
            }
        }
    }
    
//    MARK: - Delete Notification Function 
    
    func deleteNotificationData(notificationId : String, completionHandler : @escaping(Bool, String) -> ()) {
        UIApplication.topViewController()?.showActivityIndicator()
        APIManager.shared.deleteNotification(notificationId: notificationId) { inDict in
            UIApplication.topViewController()?.hideActivityIndicator()
            if inDict == nil {
                UIApplication.topViewController()?.showAlert(alertMessage: "Directory is Empty!")
            }else{
                let statusCode = inDict!["status"].stringValue
                let msg = inDict!["message"].stringValue
                let blockedCode = inDict?["Code"].stringValue ?? ""
                if statusCode == "200"{
                    completionHandler(true, blockedCode)
                    print("Successfully delete the Notification.")
                    print(msg)
                }else{
                    completionHandler(false, blockedCode)
                }
            }
        }
    }
}
