//
//  CMGenerateLink.swift
//  videoChamp
//
//  Created by iOS Developer on 24/05/22.
//

import Foundation

class CMGenerateLink : NSObject{
    var deviceType : String?
    var deviceId : String?
    var isCamera : String?
    var peerId : String?
    var connectionState : String?
    
    init(deviceType : String, deviceId : String,isCamera : String,peerId : String,connectionState : String){
        super.init()
        self.deviceType = deviceType
        self.deviceId = deviceId
        self.isCamera = isCamera
        self.peerId = peerId
        self.connectionState = connectionState
        
    }
    
    override init() {
        super.init()
    }
    
}
