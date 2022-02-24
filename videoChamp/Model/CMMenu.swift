//
//  CMMenu.swift
//  videoChamp
//
//  Created by iOS Developer on 16/02/22.
//

import Foundation

class CMModel : NSObject {
    var ids : String?
    var name : String?
    var imageIcon : String?
    var arrowIcon : String?
    
    init(ids : String, name : String, imageIcon : String, arrowIcon : String) {
        super.init()
        self.ids = ids
        self.name = name
        self.imageIcon = imageIcon
        self.arrowIcon = arrowIcon
    }
    override init() {
        super.init()
    }
    

}

//MARK: - Camera VC Model
class CMCameraDeviceModel : NSObject{
    var name : String?
    var imageIcon : String?
    
    init(name : String, imageIcon : String) {
        super.init()
        self.name = name
        self.imageIcon = imageIcon
    }
    
    
    override init() {
        super.init()
    }
}


//MARK: - Notification Model

class CMNotification : NSObject {
    var title : String?
    var desc : String?
    
    init(title : String, desc : String) {
        super.init()
        self.desc = desc
        self.title = title
    }
}

