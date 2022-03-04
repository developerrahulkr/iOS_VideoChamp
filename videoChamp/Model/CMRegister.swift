//
//  CMRegister.swift
//  videoChamp
//
//  Created by iOS Developer on 28/02/22.
//

import Foundation


class CMRegister : NSObject{
    var name : String?
    var deviceToken : String?
    
    init(name : String, deviceToken : String){
        super.init()
        self.name = name
        self.deviceToken = deviceToken
    }
    
    override init() {
        super.init()
    }
    
}
