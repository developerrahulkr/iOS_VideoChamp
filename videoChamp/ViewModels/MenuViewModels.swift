//
//  MenuViewModels.swift
//  videoChamp
//
//  Created by iOS Developer on 16/02/22.
//

import Foundation

import UIKit
//protocol MenuViewModelView : AnyObject {
//    func didReceievedResponse(inData : Any)
//}


class MenuViewModels : NSObject {
    
    var uuid : String{
        get{
            UUID().uuidString
        }
    }
    
//    private weak var view : MenuViewModelView?
    lazy var dataSource : [CMModel] = {
        let arrData = [CMModel]()
        return arrData
    }()
    
    
    func getData(){
        let data1 = CMModel(ids: uuid, name: "NOTIFICATION", imageIcon: "notification_icon", arrowIcon: "arrow_icon")
        dataSource.append(data1)
        
        let data2 = CMModel(ids: uuid, name: "GIVE US A FEEDBACK", imageIcon: "feedback_icon", arrowIcon: "arrow_icon")
        dataSource.append(data2)
        
        let data3 = CMModel(ids: uuid, name: "TERMS & CONDITIONS", imageIcon: "t_and_c_icon", arrowIcon: "arrow_icon")
        dataSource.append(data3)
        
        let data4 = CMModel(ids: uuid, name: "SHARE APPLICATION", imageIcon: "share_icon", arrowIcon: "arrow_icon")
        dataSource.append(data4)
        
    }
    
    func activateDateAPIData(completionHandler : @escaping(Bool,String) -> Void) {
        UIApplication.topViewController()?.showActivityIndicator()
        guard APIManager.shared.isConnectedToInternet() else {
            UIApplication.topViewController()?.hideActivityIndicator()
            UIApplication.topViewController()?.showAlert(alertMessage: "Internet is not Access.")
            return
        }
        APIManager.shared.activateDate { dict in
            UIApplication.topViewController()?.hideActivityIndicator()
            if dict == nil {
                print("Directore is Nil")
            }else{
                let statusCode = dict!["status"].stringValue
                let error_msg = dict!["message"].stringValue
                let data = dict?["data"].dictionary
                let Code = dict!["Code"].stringValue
                print("blocked code : \(Code)")
                let activatedDate = data?["activatedDate"]?.dictionary
                let activeStatus = activatedDate?["status"]?.boolValue
                if statusCode == "200"{
                    completionHandler(true, Code)
                }else{
                    completionHandler(false, Code)
                    print(error_msg)
                }
            }
        }
        
    }
}

class CameraConnectViewModel : NSObject {
    
    lazy var cameraDataSource : [CMCameraDeviceModel] = {
        let cameraData = [CMCameraDeviceModel]()
        return cameraData
    }()
    
    lazy var remoteDataSource : [CMCameraDeviceModel] = {
        let cameraData = [CMCameraDeviceModel]()
        return cameraData
    }()
    
    lazy var notificationDataSource : [CMNotification] = {
        let notificationData = [CMNotification]()
        return notificationData
    }()
    
    func getCemaraData(){
        let data1 = CMCameraDeviceModel(name: "1- Invite User & Share Code", imageIcon: "camera_user_icon")
        cameraDataSource.append(data1)
        
        let data2 = CMCameraDeviceModel(name: "2- Confirm Device Are Connected", imageIcon: "camera_device_icon")
        cameraDataSource.append(data2)
        
        let data3 = CMCameraDeviceModel(name: "3- Start Recording & Control", imageIcon: "camera_recording_icon")
        cameraDataSource.append(data3)
    }
    
    func getRemoteData() {
        let data1 = CMCameraDeviceModel(name: "1- Enter Code & Connect Device", imageIcon: "remote_connect_icon")
        remoteDataSource.append(data1)
        
        let data3 = CMCameraDeviceModel(name: "2- Start Recording & Control", imageIcon: "camera_recording_icon")
        remoteDataSource.append(data3)
        
    }
    
    func getNotificationData() {
        let data1 = CMNotification(title: "Lorem ipsum", desc: "euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.")
        notificationDataSource.append(data1)
        let data2 = CMNotification(title: "Lorem ipsum", desc: "euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.")
        notificationDataSource.append(data2)
        let data3 = CMNotification(title: "Lorem ipsum", desc: "euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.")
        notificationDataSource.append(data3)
        let data4 = CMNotification(title: "Lorem ipsum", desc: "euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.")
        notificationDataSource.append(data4)
        let data5 = CMNotification(title: "Lorem ipsum", desc: "euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.")
        notificationDataSource.append(data5)
        let data6 = CMNotification(title: "Lorem ipsum", desc: "euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.")
        notificationDataSource.append(data6)
        let data7 = CMNotification(title: "Lorem ipsum", desc: "euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.")
        notificationDataSource.append(data7)
        let data8 = CMNotification(title: "Lorem ipsum", desc: "euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.")
        notificationDataSource.append(data8)
        let data9 = CMNotification(title: "Lorem ipsum", desc: "euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.")
        notificationDataSource.append(data9)
        let data10 = CMNotification(title: "Lorem ipsum", desc: "euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.")
        notificationDataSource.append(data10)
    }
    
    
  
    
    
}






