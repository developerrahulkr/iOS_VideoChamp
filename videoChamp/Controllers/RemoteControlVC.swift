//
//  RemoteControlVC.swift
//  videoChamp
//
//  Created by iOS Developer on 18/02/22.
//


//8610
import UIKit
//import MFrameWork
import MultipeerFramework
import MultipeerConnectivity



class RemoteControlVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblEnterCode: UILabel!
    
    let cameraViewModel = CameraConnectViewModel()
    private var mcSessionViewModel : MCSessionViewModel!
    let cellID = "CameraCodeCell"
    let cellID2 = "CameraCodeCell2"
    let cellId3 = "CameraCodeCell3"
    var otpString : String = ""
    var foundCellData: [PeerIDCellData] = []
    var connectedCellData: [PeerIDCellData] = []
    let codeGenerateVM = GenerateNumberViewModel()
    private var peerTableViewModel = PeerTableViewModel()
    private let timeout: TimeInterval = 20
    private let alertPresenter:AlertPresenter = .init()
    
    var myPeerID : String!
    var number : String!
    var userID : String?
    let generateLinkVM = GeneratedLinkViewModel()
    var generatedUrlCode = ""
    var staticLink = "http://videochamp/camera/"
    var urlLink = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.gradientColor(topColor: lightGreenColor, bottomColor: lightYellow)
        cameraViewModel.getRemoteData()
        
        
        registerCell()
        lblEnterCode.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)
        loadData()
        
        
                
    }
    func loadData(){
        
        let linkGenerated = CMGenerateLink(deviceType: "IOS",deviceId: Utility.shared.sessionManager.myPeerID?.displayName ?? "", isCamera: "false", peerId: Utility.shared.sessionManager.displayName, connectionState: "true")
        generateLinkVM.linkGenerated(cmGenerateLinkData: linkGenerated) {
            [weak self] isSuccess,linkURL,urlCode, codeMessage  in
            guard let self = self else {return}
            if isSuccess && codeMessage == "Number generate"{
//                self.generatedNumber = number
                print("Deeplinking URL : \(linkURL)")
                print("url Code : \(urlCode)")
                self.urlLink = linkURL
                self.generatedUrlCode = urlCode
//                self.mcSessionViewModel.toggleBrwosing()
                print(self.userID)
                self.CodeVerifyApi(number: urlCode, userId: self.userID ?? "")
                self.staticLink = "\(self.staticLink)\(urlCode)"
                self.tableView.reloadData()
                
            }else if codeMessage == "code is already generated" && isSuccess {
                print("Deeplinking URL : \(linkURL)")
                print("url Code : \(urlCode)")
                self.urlLink = linkURL
                self.generatedUrlCode = urlCode
//                self.mcSessionViewModel.toggleBrwosing()
                self.CodeVerifyApi(number: urlCode, userId: self.userID ?? "")
                self.tableView.reloadData()
            }else if codeMessage == "code Expire" && isSuccess{
                self.loadData()
            }else{
                print("Error")
            }
        }
    }
    
    
    func expireCodeAlert(message : String) {
        let alert = UIAlertController(title: appName, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
 
    func registerCell(){
        mcSessionViewModel = MCSessionViewModel.init(mcSessionManger: Utility.shared.sessionManager)
//        self.mcSessionViewModel.toogleAdvertising()
       
        tableView.register(UINib(nibName: cellID2, bundle: nil), forCellReuseIdentifier: cellID2)
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        tableView.register(UINib(nibName: cellId3, bundle: nil), forCellReuseIdentifier: cellId3)
        
        
        self.showActivityIndicator()
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.hideActivityIndicator()
            
            let decoded  = UserDefaults.standard.object(forKey: "MCPeerIDs") as! Data
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
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func OnClickedCloaseBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - TableView  Delegate, Datasource and Verification Code Delegate
extension RemoteControlVC : UITableViewDataSource, UITableViewDelegate, VerifyCodeDelegate, CameraCodeDelegate {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            return cameraViewModel.remoteDataSource.count
//        }else{
//            return 1
//        }
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CameraCodeCell
//            cell.updateData(inData: cameraViewModel.remoteDataSource[indexPath.row])
//            return cell
//        }else
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID2, for: indexPath) as! CameraCodeCell2
            cell.delegate = self
            cell.lblCode.text = staticLink
            cell.btnShare.tag = indexPath.row
            cell.btnResend.tag = indexPath.row
//            cell.delegate = self
//            cell.callBack =
//            { codeData in
//                if self.otpString.count >= 4 {
//                    self.otpString = ""
//                }
//                self.otpString = self.otpString + codeData
//            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId3, for: indexPath) as! CameraCodeCell3
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }else{
            return 20
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0 {
//            return 60.0
//        }else
        if indexPath.section == 0{
            return 150.0
        }else{
            return 165.0
        }
    }
    func verifyCode(tag: Int) {
        self.showActivityIndicator()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.hideActivityIndicator()
            
            let decoded  = UserDefaults.standard.object(forKey: "MCPeerIDs") as! Data
            guard let decodedTeams = try? (NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as! [MCPeerID]) else { return }
            print("\(decodedTeams)")
            
            let sameNameIndexes = PeerIDHelper.whereSameNames(ids: Utility.shared.sessionManager.connectedPeerIDs, target: self.peerTableViewModel.foundCellData[0].peerID)
            if sameNameIndexes.isEmpty {
                Utility.shared.sessionManager.inviteTo(peerID: self.peerTableViewModel.foundCellData[0].peerID, timeout: self.timeout)
//                self.loadData()
            } else {
                Utility.shared.sessionManager.canselConectRequestTo(peerID: self.peerTableViewModel.foundCellData[0].peerID)
                
            }
            
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PeerIDVC") as! PeerIDVC
//            self.navigationController?.pushViewController(vc, animated: true)
        }
        
//        print("Varification Code : \(otpString)")
//        if otpString.isEmpty {
//            self.showAlert(alertMessage: "Please fill the Code")
//        }else{
//            self.CodeVerifyApi(number: otpString)
//        }
        
    }
    func resendCode(tag: Int) {
        
    }
    
    func shareCode(tag: Int) {
        if let encoded = urlLink.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
            let url = URL(string: encoded)
        {
            print("original URL is : \(url)")
            let sharesheetVC = UIActivityViewController(activityItems: [sendingRemoteMessage,url], applicationActivities: nil)
            self.present(sharesheetVC, animated: true)
        }
    }
    
    
    
    func CodeVerifyApi(number : String, userId : String){
        
        codeGenerateVM.verifyNumber(number: number, userID: userId) { [weak self] isSuccess, message in
            guard let self = self else{return}
            if isSuccess {
                print("Message : \(message)")
                self.mcSessionViewModel.toggleBrwosing()
                
            }else{
                print("Message : \(message)")
                self.expireCodeAlert(message: message)
            }
        }
    }
    
    
    
    func showOTPAlert(alertMessage : String) {
        let alert = UIAlertController(title: appName, message: alertMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                
//                let decoded  = UserDefaults.standard.object(forKey: "MCPeerIDs") as! Data
//                guard let decodedTeams = try? (NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as! [MCPeerID]) else { return }
//                print("\(decodedTeams)")
//                self.peerTableViewModel?.updateFoundCell(decodedTeams)
//                print("\(self.peerTableViewModel?.foundCellData.count ?? 0)")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PeerIDVC") as! PeerIDVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}
