//
//  CMFeedBack.swift
//  videoChamp
//
//  Created by iOS Developer on 22/02/22.
//

import Foundation

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
    init(title : String, desc : String, time : String) {
        super.init()
        self.desc = desc
        self.title = title
        self.time = time
    }
    
}
