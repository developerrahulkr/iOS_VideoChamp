//
//  PeerIDVC.swift
//  videoChamp
//
//  Created by iOS Developer on 10/05/22.
//

import UIKit
import MultipeerConnectivity
import MFrameWork



class PeerIDVC: UIViewController {
    
    var peerTableViewModel = PeerTableViewModel()
    
    @IBOutlet weak var peerIDTableView: UITableView!
    private var sessionManager: MCSessionManager!

    
    let cellID = "PeerIDTableCell"
    private let timeout: TimeInterval = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loadData()
        
    }
    
    func loadData(){
        peerIDTableView.register(UINib(nibName: "PeerIDTableCell", bundle: nil), forCellReuseIdentifier: "PeerIDTableCell")
        
        let decoded  = UserDefaults.standard.object(forKey: "MCPeerIDs") as! Data
        guard let decodedTeams = try? (NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as! [MCPeerID]) else { return }
        print("\(decodedTeams)")
        peerTableViewModel.updateFoundCell(decodedTeams)
        print("\(peerTableViewModel.foundCellData.count)")
        self.peerTableViewModel.refreshTableView = { state in
            print("PVC State : \(state)")
            if state == "connected" {
                self.peerIDTableView.reloadData()
            }
            
        }
    }

    
}




//    MARK: - UITableViewDelegate
extension PeerIDVC : UITableViewDelegate, UITableViewDataSource, PeerButtonDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return peerTableViewModel.foundCellData.count
        }else{
            return peerTableViewModel.connectedCellData.count
        }
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "found PeerIDs"
        }else{
            return "Connected PeerIDs"
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeerIDTableCell", for: indexPath) as! PeerIDTableCell
        if indexPath.section == 0 {
            let foundCellData = peerTableViewModel.foundCellData
            guard foundCellData.isEmpty == false else{return
                UITableViewCell()
                
            }
            let data = foundCellData[indexPath.row]
            let labelMessage = Utility.shared.sessionManager.connectedPeerIDs.contains(data.peerID) ? "disconnect" : "connect"
            cell.lblDisplayName.text = data.peerID.displayName
            cell.lblConnectionType.text = data.connectionState
            cell.btnInvite.setTitle(labelMessage, for: .normal)
            cell.delegate = self
            return cell
        }else{
            let connectedCellData = peerTableViewModel.connectedCellData
            guard connectedCellData.isEmpty == false else {
                return UITableViewCell()
            }
            let data = connectedCellData[indexPath.row]
            cell.lblDisplayName.text = data.peerID.displayName
            cell.lblConnectionType.text = ""
            cell.btnInvite.setTitle("Live", for: .normal)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sameNameIndexes = PeerIDHelper.whereSameNames(ids: Utility.shared.sessionManager.connectedPeerIDs, target: peerTableViewModel.foundCellData[indexPath.row].peerID)
        if sameNameIndexes.isEmpty {
            Utility.shared.sessionManager.inviteTo(peerID: peerTableViewModel.foundCellData[indexPath.row].peerID, timeout: self.timeout)
            self.loadData()
        } else {
            Utility.shared.sessionManager.canselConectRequestTo(peerID: peerTableViewModel.foundCellData[indexPath.row].peerID)
            
        }
    }
    
    func onTappedButton(_ tag: Int) {
        print(tag)
        let sameNameIndexes = PeerIDHelper.whereSameNames(ids: Utility.shared.sessionManager.connectedPeerIDs, target: peerTableViewModel.foundCellData[tag].peerID)
        if sameNameIndexes.isEmpty {
            Utility.shared.sessionManager.inviteTo(peerID: peerTableViewModel.foundCellData[tag].peerID, timeout: self.timeout)
            self.loadData()
        } else {
            Utility.shared.sessionManager.canselConectRequestTo(peerID: peerTableViewModel.foundCellData[tag].peerID)
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}


