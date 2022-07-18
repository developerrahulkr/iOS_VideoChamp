//
//  CameraVideoShareCodeVC.swift
//  videoChamp
//
//  Created by iOS Developer on 18/02/22.
//

import UIKit
//import MFrameWork
import MultipeerFramework
import MultipeerConnectivity

class CameraVideoShareCodeVC: UIViewController {
    
    @IBOutlet weak var lblShareCode: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbl: UILabel!
    
    let cellID = "CameraCodeCell"
    let cellID2 = "CameraCodeCell2"
    let cellId3 = "CameraCodeCell3"
    
    let cameraViewModel = CameraConnectViewModel()
    private var mcSessionViewModel : MCSessionViewModel!
    var staticLink = "http://videochamp/remote/"
    var generatedUrlCode = ""
    var urlLink = ""
    var varCamera : Bool!
    var number : String!
    var userID : String?
    private let timeout: TimeInterval = 20
    var myPeerID : String!
    var isCamera : String?
    let codeGenerateVM = GenerateNumberViewModel()
//    let generateNumberVM = GenerateNumberViewModel()
    
    private var peerTableViewModel = PeerTableViewModel()
    let generateLinkVM = GeneratedLinkViewModel()
    var sessionManager: MCSessionManager!
    private let serviceType = "video-champ"
    private let displayName = UIDevice.current.name
    private let serviceProtocol:MCSessionManager.ServiceProtocol = .textAndVideo
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cameraViewModel.getCemaraData()
        registerCell()
        loadData()
    }

    func loadData(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(closeScreen), name: .kCloseScreen, object: nil)
        mcSessionViewModel = MCSessionViewModel.init(mcSessionManger: Utility.shared.sessionManager)
        generateLinkVM.linkGenerated(cmGenerateLinkData: CMGenerateLink(deviceType: "IOS",
                                                                        deviceId: Utility.shared.sessionManager.myPeerID?.displayName ?? "",
                                                                        isCamera: "true",
                                                                        peerId: "\(Utility.shared.sessionManager.myPeerID?.displayName ?? "")",
                                                                        connectionState: "true")) {
            [weak self] isSuccess,linkURL,urlCode, codeMessage, blockCode in
            guard let self = self else {return}
            if isSuccess{
//                self.generatedNumber = number
                print("Deeplinking URL : \(linkURL)")
                print("url Code : \(urlCode)")
                self.urlLink = linkURL
                self.generatedUrlCode = urlCode
                if self.isCamera == "true" {
                    self.varCamera = true
                }else{
                    self.varCamera = false
                }
                
                self.staticLink = "\(self.staticLink)\(urlCode)"
                self.CodeVerifyApi(number: urlCode, userId: self.userID ?? "", isCamera: self.varCamera)
                self.tableView.reloadData()
                
            }
//            else if codeMessage == "code is already generated" && isSuccess {
//                print("Deeplinking URL : \(linkURL)")
//                print("url Code : \(urlCode)")
//                self.urlLink = linkURL
//
//                self.staticLink = "\(self.staticLink)\(urlCode)"
//                self.CodeVerifyApi(number: urlCode, userId: self.userID ?? "")
//                self.generatedUrlCode = urlCode
//                self.tableView.reloadData()
//            }
            else if codeMessage == "code Expire" && isSuccess{
                self.loadData()
            }else if isSuccess && blockCode == "10"{
                self.showExitAlert()
            
            }else{
                print("error")
            }
        }
        
        
        
        
        
    }
    
    @objc func closeScreen(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func CodeVerifyApi(number : String, userId : String, isCamera : Bool){
        
        
        codeGenerateVM.verifyNumber(number: number, userID: userId, isCamera: isCamera) {  [weak self] isSuccess, message, verCode in
            guard let self = self else{return}
            if isSuccess {
                
                print("Message : \(message)")
                if self.myPeerID == nil {
                    if Utility.shared.sessionManager.needsAdvertising == true {
                        print("Already Advertise.........")
                    }else{
                        self.mcSessionViewModel.toogleAdvertising()
                    }
                    
                }else{
                    self.mcSessionViewModel.toggleBrwosing()
                }
            }else if isSuccess && verCode == "4" {
                self.showAlert(alertMessage: message)
            }else{
                print("Message : \(message)")
                self.expireCodeAlert(message: message)
            }
        }
    }
    
    

    
    
    override func viewDidLayoutSubviews() {
        lbl.font = UIFont(name: "ArgentumSans-Bold", size: 31.0)
        lbl.font = UIFont.systemFont(ofSize: 31.0, weight: .regular)
        self.gradientColor(topColor: topyellowColor, bottomColor: bottomYellowColor)
        lblShareCode.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        if self.myPeerID == nil {
//            self.mcSessionViewModel.toogleAdvertising()
//        }else{
//            self.mcSessionViewModel.toggleBrwosing()
//        }
//    }
    
    
    func registerCell(){
        tableView.register(UINib(nibName: cellID2, bundle: nil), forCellReuseIdentifier: cellID2)
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        tableView.register(UINib(nibName: cellId3, bundle: nil), forCellReuseIdentifier: cellId3)
        
        
        self.showActivityIndicator()
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.hideActivityIndicator()
            
            guard let decoded  = UserDefaults.standard.object(forKey: "MCPeerIDs") as? Data else {
                return
            }
            guard let decodedTeams = try? (NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as! [MCPeerID]) else { return }
            print("decoded Data : \(decodedTeams)")
            
            self.peerTableViewModel.updateFoundCell(decodedTeams)
            if self.peerTableViewModel.foundCellData.count != 0 {
                for i in 0...self.peerTableViewModel.foundCellData.count-1 {
                    
                    if self.peerTableViewModel.foundCellData[i].peerID.displayName == self.myPeerID {
                        
                        
                        print("Data is found................... \(self.peerTableViewModel.foundCellData[i].peerID)")
                        let sameNameIndexes = PeerIDHelper.whereSameNames(ids: Utility.shared.sessionManager.connectedPeerIDs, target:
                                                                            self.peerTableViewModel.foundCellData[i].peerID)
                        if sameNameIndexes.isEmpty {
                            Utility.shared.sessionManager.inviteTo(peerID: self.peerTableViewModel.foundCellData[i].peerID, timeout: self.timeout)
            //                self.loadData()
                        } else {
                            Utility.shared.sessionManager.canselConectRequestTo(peerID: self.peerTableViewModel.foundCellData[i].peerID)

                        }
                    }else{
                        print("Data is Not Found.........")
                    }
                    
                }
            }else{
                print("Found Cell Data L : \(self.peerTableViewModel.foundCellData)")
            }
        }
    }
    
    
    
    
    @IBAction func onClickedBackBtn(_ sender: UIButton) {
        let vc = DisconnectCameraVC(nibName: "DisconnectCameraVC", bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        vc.isBack = true
        present(vc, animated: true)
//        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickedCloseBtn(_ sender: UIButton) {
        let vc = DisconnectCameraVC(nibName: "DisconnectCameraVC", bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        vc.isBack = true
        present(vc, animated: true)
//        self.navigationController?.popViewController(animated: true)
    }
}


extension CameraVideoShareCodeVC : UITableViewDelegate, UITableViewDataSource, CameraCodeDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CameraCodeCell
//            cell.updateData(inData: cameraViewModel.cameraDataSource[indexPath.row])
//            return cell
//        }else
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID2, for: indexPath) as! CameraCodeCell2
            cell.delegate = self
            cell.lblCode.text = staticLink
            cell.btnShare.tag = indexPath.row
            cell.btnResend.tag = indexPath.row
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId3, for: indexPath) as! CameraCodeCell3
//            cell.delegate = self
//            cell.btnShare.tag = indexPath.row
//            cell.btnResend.tag = indexPath.row
            return cell
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0 {
//            return 150
//        }else
        if indexPath.section == 0{
            return 170.0
        }else{
            return 165.0
        }
    }
    
    
    func resendCode(tag: Int) {
        print("resend Code : \(tag)")
        self.loadData()
    }
    
    func shareCode(tag: Int) {
        if let encoded = urlLink.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
            let url = URL(string: encoded)
        {
            print("original URL is : \(url)")
            let sharesheetVC = UIActivityViewController(activityItems: [sendingRemoteMessage,url], applicationActivities: nil)
            self.present(sharesheetVC, animated: true)
        }
//        let url = urlLink.replacingOccurrences(of: " ", with: "_")
////        let finalUrl1 = url.replacingOccurrences(of: "'", with: "_")
////        let finalUrl1 = url.replacingOccurrences(of: "<", with: "&")
//        let finalUrl = url.replacingOccurrences(of: "'", with: " ")
//
//
//        guard let url = URL(string: finalUrl)
//        else{
//            return
//        }
//        let sharesheetVC = UIActivityViewController(activityItems: [sendingRemoteMessage,url], applicationActivities: nil)
//        self.present(sharesheetVC, animated: true)
    }
    
    
    
    
    
}

//MARK: - ALert POPup

extension CameraVideoShareCodeVC  {
    func expireCodeAlert(message : String) {
        let alert = UIAlertController(title: appName, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let self = self else {
                return
            }
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}




