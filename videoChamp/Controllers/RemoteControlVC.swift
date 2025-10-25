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
import GradientView



class RemoteControlVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblEnterCode: UILabel!
    @IBOutlet weak var viewTop: GradientView!
    @IBOutlet weak var viewTblView: GradientView!
    @IBOutlet weak var viewPopUP: UIView!
    @IBOutlet weak var imgPopup: UIImageView!
    
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
    var number : String?
    var userID : String?
    var isCamera : String!
    let generateLinkVM = GeneratedLinkViewModel()
    var generatedUrlCode = ""
    var varCamera : Bool!
    var staticLink = "http://videochamp/camera/"
    var urlLink = ""
    var typeDevice = "IOS"
    var indicatorType = Int()
    var time = Double()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .all

        imgPopup.image = UIImage.gifImageWithName("timer")
        
        if indicatorType ==  1{
            viewPopUP.isHidden = false
            
        }
        else{
            viewPopUP.isHidden = true
            
        }
        
        // Do any additional setup after loading the view.
        if !typeDevice.contains("IOS") && !typeDevice.contains("") {
            let vc = AlertCameraVC(nibName: "AlertCameraVC", bundle: nil)
            vc.modalPresentationStyle = .overFullScreen
            vc.btnColor = UIColor(red: 147/255, green: 192/255, blue: 31/255, alpha: 1)
            
            vc.image = UIImage(named: "alert_icon")!
            vc.titleText = "Cross Platform is not Supported"
            vc.messageText = "Connect between Android and Ios is not supported."
            vc.type = 1
            UIApplication.topViewController()?.present(vc, animated: true)
        }
        else{
            cameraViewModel.getRemoteData()
            loadData()
        }
        
        
        
        registerCell()
        lblEnterCode.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)
        
        print("user ID : \(self.userID ?? "")")
        
    }
    
    override func viewDidLayoutSubviews() {
        self.viewTop.applyGradient1(colorOne: .init(hexString: "#00ACCC"), ColorTwo: .init(hexString: "#00519C"))
        viewTblView.colors = [UIColor.init(hexString: "#00ACCC") , UIColor.init(hexString: "#00519C")]
        
        
    }
    
    
    
//    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
//        
//        if UIDevice.current.orientation.isPortrait {
//            AppUtility.lockOrientation(.portrait)
//        }else{
//            AppUtility.lockOrientation(.landscape)
//        }
//    }
    
    func loadData(){
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(closeScreen), name: .kCloseScreen, object: nil)
        let linkGenerated = CMGenerateLink(deviceType: "IOS",deviceId: Utility.shared.sessionManager.myPeerID?.displayName ?? "", isCamera: "false", peerId: Utility.shared.sessionManager.displayName, connectionState: "true")
        generateLinkVM.linkGenerated(cmGenerateLinkData: linkGenerated) {
            [weak self] isSuccess,linkURL,urlCode, codeMessage,blockedCode   in
            guard let self = self else {return}
            
            if isSuccess && blockedCode == "10" {
                self.showExitAlert()
            }else{
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
                    
                    self.CodeVerifyApi(number: self.number ?? "", userId: self.userID ?? "", isCamera: self.varCamera)
                    self.staticLink = "\(self.staticLink)\(urlCode)"
                    self.tableView.reloadData()
                    
                }
                else if codeMessage == "code Expire" && isSuccess{
                    self.loadData()
                }else{
                    print("Error")
                }
            }
            
        }
    }
    
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        if self.myPeerID == nil {
    //            self.mcSessionViewModel.toogleAdvertising()
    //        }else{
    //            self.mcSessionViewModel.toggleBrwosing()
    //        }
    //    }
    
    
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
        tableView.register(UINib(nibName: cellID2, bundle: nil), forCellReuseIdentifier: cellID2)
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        tableView.register(UINib(nibName: cellId3, bundle: nil), forCellReuseIdentifier: cellId3)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0 ) {
            //            if self.indicatorType == 1 {
            //                Indicator.instance.hide()
            //            }
            //            else{
            //                self.hideActivityIndicator()
            //            }
            
            guard  let decoded  = UserDefaults.standard.object(forKey: "MCPeerIDs") as? Data else {
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
    
    @objc func closeScreen(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickedBackBtn(_ sender: UIButton) {
        guard UserDefaults.standard.string(forKey: "isCheck") != "true"  else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        let vc = DismissAlertVC(nibName: "DismissAlertVC", bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        vc.isBack = true
        vc.poptohime = false
        present(vc, animated: true)
        //        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func OnClickedCloaseBtn(_ sender: UIButton) {
        guard UserDefaults.standard.string(forKey: "isCheck") != "true"  else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        let vc = DismissAlertVC(nibName: "DismissAlertVC", bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        vc.isBack = true
        vc.poptohime = false
        present(vc, animated: true)
        //        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnRemove(_ sender: Any) {
        indicatorType = 0
        let vc = DismissAlertVC(nibName: "DismissAlertVC", bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        vc.isBack = true
        vc.poptohime = false
        present(vc, animated: true)
        
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        indicatorType = 0
        viewPopUP.isHidden = true
        let vc = DismissAlertVC(nibName: "DismissAlertVC", bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        vc.isBack = true
        vc.poptohime = false
        present(vc, animated: true)
        
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
        if indicatorType == 1{
           return 1
        }
        else
        {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        if indexPath.section == 0 {
        //            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CameraCodeCell
        //            cell.updateData(inData: cameraViewModel.remoteDataSource[indexPath.row])
        //            return cell
        //        }else
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CameraCodeCell
           // cell.lblText2.text = "MONITOR & REMOTE"
            cell.selectionStyle = .none
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
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID2, for: indexPath) as! CameraCodeCell2
            cell.delegate = self
            cell.selectionStyle = .none
            cell.lblCode.text = staticLink
            cell.btnShare.tag = indexPath.row
            cell.btnResend.tag = indexPath.row
            cell.bottomView.layer.backgroundColor = UIColor(red: 57/255, green: 187/255, blue: 53/255, alpha: 1.0).cgColor
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        if indexPath.section == 0 Uelse
        if indexPath.section == 0{
            return UITableView.automaticDimension
        }else{
            return UITableView.automaticDimension
        }
    }
    //    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    //        if AppUtility.lockOrientation(.all) == AppUtility.lockOrientation(.portrait) {
    //            self.viewDidLoad()
    //            self.viewWillAppear(true)
    //            self.tableView.reloadData()
    //        }else if AppUtility.lockOrientation(.all) == AppUtility.lockOrientation(.landscape) {
    //            self.viewDidLoad()
    //            self.viewWillAppear(true)
    //            self.tableView.reloadData()
    //        }
    //    }
    
    
    
    func verifyCode(tag: Int) {
        self.showActivityIndicator()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.hideActivityIndicator()
            let decoded  = UserDefaults.standard.object(forKey: "MCPeerIDs") as! Data
            guard let decodedTeams = try? (NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as! [MCPeerID]) else { return }
            print("\(decodedTeams)")
            
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
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RemoteShareVC") as! RemoteShareVC
        //vc.urlLink = urlLink
        self.navigationController?.pushViewController(vc, animated: true)
        
        //        if let encoded = urlLink.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
        //            let url = URL(string: encoded)
        //        {
        //            print("original URL is : \(url)")
        //            let sharesheetVC = UIActivityViewController(activityItems: [sendingCameraMessage,url], applicationActivities: nil)
        //            self.present(sharesheetVC, animated: true)
        //        }
    }
    
    
    
    func CodeVerifyApi(number : String, userId : String, isCamera : Bool){
        
        codeGenerateVM.verifyNumber(number: number, userID: userId, isCamera: isCamera) { [weak self] isSuccess, message, verCode in
            guard let self = self else{return}
            if isSuccess {
                print("Message : \(message)")
                if self.myPeerID == nil {
                    if Utility.shared.sessionManager.needsAdvertising == true {
                        print("Already Advertise.........")
                    }else{
                        self.mcSessionViewModel.toogleAdvertising()
                    }
                }else if isSuccess && verCode == "4" {
                    self.showAlert(alertMessage: message)
                }else{
                    self.mcSessionViewModel.toggleBrwosing()
                }
                
                
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



