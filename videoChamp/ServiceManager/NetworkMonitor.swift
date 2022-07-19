//
//  NetworkMonitor.swift
//  videoChamp
//
//  Created by Akshay_mac on 19/07/22.
//

import Foundation
import Network
import Alamofire
enum ConnectionType {
    case wifi
    case celluler
    case ethernet
    case unknown
}

final class NetworkMonitor {
    
    
    
//    func checkInternetConnection(){
//        if !NetworkReachabilityManager()!.isReachable {
//            AppUtility.
//                   return
//               }
//    }
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue.global()
    private let monitor : NWPathMonitor
    
    
    public private(set) var isConnected : Bool = false
    public private(set) var connectionType : ConnectionType = .unknown
    private init() {
        monitor = NWPathMonitor()
    }
    
    
    public func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else {return}
            self.isConnected = path.status == .satisfied
        }
    }
    
    public func StopMonitoring() {
        monitor.cancel()
    }
}
