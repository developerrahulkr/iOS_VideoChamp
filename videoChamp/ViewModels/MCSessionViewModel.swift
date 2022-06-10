//
//  MCSessionViewModel.swift
//  videoChamp
//
//  Created by iOS Developer on 11/05/22.
//

import Foundation
//import MFrameWork
import MultipeerFramework
import MultipeerConnectivity


final class MCSessionViewModel : NSObject {
    
    private var mcSessionManager: MCSessionManager!
    init(mcSessionManger: MCSessionManager?) {
        self.mcSessionManager = mcSessionManger
    }
    func togggleConnectionRunState(){
        self.mcSessionManager?.needsToRunSession.toggle()
    }
    
    func toogleAdvertising(){
        self.mcSessionManager?.needsAdvertising.toggle()
    }
    
    func toggleBrwosing(){
        self.mcSessionManager?.needsBrowsing.toggle()
    }
    
}
