//
//  CMFeedBack.swift
//  videoChamp
//
//  Created by iOS Developer on 22/02/22.
//

import Foundation
import UIKit

class CMFeedBack : NSObject {
    var secTitle : String?
    var secTitle2 : String?
    
    init(secTitle : String, secTitle2 : String) {
        super.init()
        self.secTitle = secTitle
        self.secTitle2 = secTitle2
    }
}

class CMGetNotificationData : NSObject {
    var title : String?
    var desc : String?
    var createdAt : String?
    var _id : String?
    var isRead : String?
//    var isSelected = "true"
    init(title : String, desc : String, createdAt : String, _id : String, isRead : String) {
        super.init()
        self.title = title
        self.desc = desc
        self.createdAt = createdAt
        self._id = _id
        self.isRead = isRead
    }
    
    override init(){
        super.init()
//        addObservers()
        
    }
    
//    func addObservers() {
//        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: .kNotificationReadSelection, object: nil)
//    }
//
//    @objc func methodOfReceivedNotification(notification: Notification) {
//        if let dataDic = notification.object as? [String:Any] {
//            guard dataDic["list"] != nil else { return }
//            let ids = dataDic["list"] as! [String]
//            if ids.contains(self._id ?? "") {
//                self.isSelected = dataDic["isSelected"] as! String == "0" ? "true" : "false"
//            }
//        }
//    }
//
//    deinit {
//        NotificationCenter.default.removeObserver(self, name: .kNotificationReadSelection, object: nil)
//    }
    
}



class CMGetFeedbackData : NSObject {
    var title : String?
    var desc : String?
    var time : String?
    var _id : String?
    init(title : String, desc : String, time : String, _id : String) {
        super.init()
        self.desc = desc
        self.title = title
        self.time = time
        self._id = _id
    }
}

class CMGetFeedbackServiceData : NSObject {
    var message : String?
    var type : String?
    var createdAt : String?
    var image : String?
    init(message : String, type : String, createdAt : String, image : String) {
//        super.init()
        self.message = message
        self.type = type
        self.createdAt = createdAt
        self.image = image
    }
    
    
}

//struct DataClass: Encodable {
//    let messagelisting: [Messagelisting]
//    let feedbackDetail: FeedbackDetail
//}
//// MARK: - FeedbackDetail
//struct FeedbackDetail: Codable {
//    let id, desc: String
//    let image: [String]
//    let createdAt: String
//
//    enum CodingKeys: String, CodingKey {
//        case id = "_id"
//        case desc, image, createdAt
//    }
//}
//
//// MARK: - Messagelisting
//struct Messagelisting: Codable {
//    let id, userID, message, type: String
//    let status: Bool
//    let createdAt: String
//    let image: [String]
//
//    enum CodingKeys: String, CodingKey {
//        case id = "_id"
//        case userID = "userId"
//        case message, type, status, createdAt, image
//    }
//}


class CMGetFeedbackDescriptionData : NSObject{
    var desc : String?
    var createdAt : String?
    init(desc : String,createdAt : String){
        super.init()
        self.desc = desc
        self.createdAt = createdAt
    }
}


class CMPostFeedbackData : NSObject {
    var title : String?
    var desc : String?
    var email : String?
    var image : [String?]
    init(title : String, desc : String, email: String, image : [String]){
//        super.init()
        self.desc = desc
        self.title = title
        self.email = email
        self.image = image
    }
}


class CMFeedbackMessageData : NSObject {
    var feedbackId : String?
    var message : String?
    var image : String?
    
    init(feedbackId : String, image : String, message : String) {
        super.init()
        self.feedbackId = feedbackId
        self.message = message
        self.image = image
    }
}
