//
//  MenuViewModels.swift
//  videoChamp
//
//  Created by iOS Developer on 16/02/22.
//

import Foundation

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
        
        let data3 = CMCameraDeviceModel(name: "3- Start Recoring & Control", imageIcon: "camera_recording_icon")
        cameraDataSource.append(data3)
    }
    
    func getRemoteData() {
        let data1 = CMCameraDeviceModel(name: "1- Enter Code & Connect Device", imageIcon: "remote_connect_icon")
        remoteDataSource.append(data1)
        
        let data3 = CMCameraDeviceModel(name: "2- Start Recoring & Control", imageIcon: "camera_recording_icon")
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






