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
    init(message : String, type : String, createdAt : String) {
        super.init()
        self.message = message
        self.type = type
        self.createdAt = createdAt
    }
}



class CMPostFeedbackData : NSObject {
    var title : String?
    var desc : String?
    var email : String?
    var image : String?
    init(title : String, desc : String, email: String, image : String){
//        super.init()
        self.desc = desc
        self.title = title
        self.email = email
        self.image = image
    }
}
