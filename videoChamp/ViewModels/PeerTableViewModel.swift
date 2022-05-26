//
//  PeerIDViewModel.swift
//  videoChamp
//
//  Created by iOS Developer on 10/05/22.
//

import Foundation
import MultipeerConnectivity
import MFrameWork


final class PeerTableViewModel: NSObject {

    enum PeerIDTableSections: CaseIterable {
        case founds
        case connected

        func titleLabel() -> String {
            switch self {
            case .founds:
                return "Found PeerIDs"
            case .connected:
                return "Connected PeerIDs"
            }
        }

        func cellData(_ model: PeerTableViewModel) -> [PeerIDCellData] {
            switch self {
            case .founds:
                return model.foundCellData
            case .connected:
                return model.connectedCellData
            }
        }
    }


    var onSetUpRefreshData : ((String) -> Void)?
    var foundCellData: [PeerIDCellData] = {
        let data = [PeerIDCellData]()
        return data
    }()
    
    
    lazy var foundData: [PeerIDCellData] = {
        let dataSource = [PeerIDCellData]()
        return dataSource
    }()
    var connectedCellData: [PeerIDCellData] = {
        let data = [PeerIDCellData]()
        return data
    }()
    var refreshTableView: ((String) -> Void)?
    
    func updateConnectedPeerIDs() {
        self.connectedCellData = Utility.shared.sessionManager.connectedPeerIDs.map {
            return PeerIDCellData.init(peerID: $0, connectionState: "")
            
        }
    }
    
    func updateCellDataIfStateChanged(peerID: MCPeerID, state: MCConnectionState) {
        self.foundCellData =  foundCellData.map {(idData) in
            guard idData.peerID == peerID && idData.connectionState != state.rawValue else {
                return idData
            }

            var stateDescription = state
            let sameInstances = Utility.shared.sessionManager.connectedPeerIDs.filter { $0 === idData.peerID }

            if sameInstances.isEmpty == false {
                stateDescription = MCConnectionState.connected
                refreshTableView?(stateDescription.rawValue)
            }

            let cellData = PeerIDCellData.init(peerID: idData.peerID, connectionState: stateDescription.rawValue)
            return cellData
        }
    }
    
    func updateFoundCell(_ ids: [MCPeerID]) {
        print(ids)
        self.foundCellData = ids.map {
            let isContains = PeerIDHelper.isContainsSameName(ids: Utility.shared.sessionManager.connectedPeerIDs, target: $0)
            let description = isContains ? MCConnectionState.connected : MCConnectionState.connectionFail
            return PeerIDCellData.init(peerID: $0, connectionState: description.rawValue)
        }
    }
}
