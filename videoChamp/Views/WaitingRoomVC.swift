//
//  WaitingRoomVC.swift
//  videoChamp
//
//  Created by Nishchal_Mac on 09/08/22.
//

import UIKit
import MBProgressHUD
import GradientView
import MultipeerFramework
import MultipeerConnectivity


class WaitingRoomVC: UIViewController {
    
    var timerTest : Timer?
    
    var hud: MBProgressHUD = MBProgressHUD()
    @IBOutlet weak var cancel_btn: UIButton!
    @IBOutlet weak var share_btn: UIButton!
    @IBOutlet weak var viewShare: GradientView!
    @IBOutlet weak var viewCancel: GradientView!
    @IBOutlet weak var viewTop: GradientView!
    @IBOutlet weak var viewqMain: GradientView!
    @IBOutlet var viewMain: UIView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet var ViewTable: UIView!
    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var imgPopup: UIImageView!
    
    var urlLink = ""
    var counter = 10
    private var mcSessionViewModel : MCSessionViewModel!
    var staticLink = "http://videochamp/remote/"
    var generatedUrlCode = ""
    var varCamera : Bool!
    var number : String?
    var userID : String?
    private let timeout: TimeInterval = 20
    var myPeerID : String!
    var isCamera : String?
    let codeGenerateVM = GenerateNumberViewModel()
    private var peerTableViewModel = PeerTableViewModel()
    let generateLinkVM = GeneratedLinkViewModel()
    var sessionManager: MCSessionManager!
    private let serviceType = "video-champ"
    private let displayName = UIDevice.current.name
    private let serviceProtocol:MCSessionManager.ServiceProtocol = .textAndVideo
    let cameraViewModel = CameraConnectViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        cameraViewModel.getCemaraData()
        loadData()
        viewPopup.isHidden = true
        tblView.delegate = self
        tblView.dataSource = self
        viewShare.clipsToBounds = true
        viewShare.layer.cornerRadius = 25
        viewCancel.layer.cornerRadius = 25
        NotificationCenter.default.addObserver(self, selector: #selector(closeVC), name: .home, object: nil)
        self.tblView.isUserInteractionEnabled = true
       imgPopup.image = UIImage.gifImageWithName("loader")
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        
        viewqMain.colors = [UIColor.init(hexString: "#F9B200") , UIColor.init(hexString: "#E63B11")]
        viewTop.applyGradient1(colorOne: .init(hexString: "#F9B200"), ColorTwo: .init(hexString: "#E63B11"))
        viewShare.colors = [UIColor.init(hexString: "#C8D400") , UIColor.init(hexString: "#93C01F") , UIColor.init(hexString: "#35A936")]
        viewCancel.colors = [UIColor.init(hexString: "#A9A6AE") , UIColor.init(hexString: "#58555C")]
        
        
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isPortrait {
            AppUtility.lockOrientation(.portrait)
        }else{
            AppUtility.lockOrientation(.landscape)
        }
    }
    
    @objc func closeVC(){
        let controllers = self.navigationController!.viewControllers
        //        print("Browsing State : \(Utility.shared.sessionManager.needsBrowsing)")
        Utility.shared.sessionManager.needsAdvertising.toggle()
        Utility.shared.sessionManager.needsBrowsing.toggle()
        for controller in controllers {
            if controller is HomeVC {
                self.navigationController?.popToViewController(controller, animated: true)
            }else{
                if UIDevice.current.userInterfaceIdiom == .pad{
                    let storyboard:UIStoryboard = UIStoryboard(name: "Storyboard", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    self.navigationController?.popToViewController(vc, animated: true)
                }else{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    self.navigationController?.popToViewController(vc, animated: true)
                }
               
            }
        }
    }
    //    func StartTimer()
    //    {
    //
    //    }
    //
    // @objc func timeInterval(_ timer1: Timer)
    //    {
    //        print(counter)
    //        if counter > 0 {
    //            //self.showActivityIndicator()
    //            counter -= 1
    //        }
    //        else{
    //            timerTest?.invalidate()
    //            timerTest = nil
    //            self.hideActivityIndicator()
    //
    //        }
    //
    //    }
    //    func stopTimerTest() {
    //        timerTest?.invalidate()
    //        timerTest = nil
    //        self.hideActivityIndicator()
    //  }
    
    @IBAction func back_btn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func connection_btn(_ sender: Any) {
        
        if let encoded = urlLink.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
           let url = URL(string: encoded)
        {
            print("original URL is : \(url)")
            if UIDevice.current.userInterfaceIdiom == .pad {
                
                let activityVC = UIActivityViewController(activityItems: [sendingRemoteMessage,url], applicationActivities: nil)
               // activityVC.excludedActivityTypes = [.airDrop]
                let popover = activityVC.popoverPresentationController as UIPopoverPresentationController?
                popover?.sourceView = self.view
                popover?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY,width:0,height: 0)
                popover?.permittedArrowDirections = []
                activityVC.completionHandler = {(activityType, completed:Bool) in
                    if !completed {
                        //cancelled
                        return
                    }
                  
                    self.viewCancel.isHidden = true
                    self.viewShare.isHidden = true
                    self.viewPopup.isHidden = false

                }
                self.present(activityVC, animated: true, completion: nil)
                
            }
            else
            {
                
                let sharesheetVC = UIActivityViewController(activityItems: [sendingRemoteMessage,url], applicationActivities: nil)
                
                //                    sharesheetVC.completionWithItemsHandler = nil
              //  sharesheetVC.excludedActivityTypes = [.airDrop]

                sharesheetVC.completionHandler = {(activityType, completed:Bool) in
                    if !completed {
                        //cancelled
                        return
                    }
                    self.viewCancel.isHidden = true
                    self.viewShare.isHidden = true
                    self.viewPopup.isHidden = false

                }
                self.present(sharesheetVC, animated: true)
            }
        }
        
        
        
    }
    
    
    @IBAction func btnMovetoHome(_ sender: Any) {
        
        
            let vc = DismissAlertVC(nibName: "DismissAlertVC", bundle: nil)
            vc.modalPresentationStyle = .overFullScreen
            vc.isBack = false
            vc.poptohime = true
            present(vc, animated: true)
            
            //        for controller in self.navigationController!.viewControllers as Array {
            //                if controller.isKind(of: HomeVC.self) {
            //                    _ =  self.navigationController!.popToViewController(controller, animated: true)
            //                    break
            //                }
            //            }
    }
    
    @IBAction func btnRemove(_ sender: Any) {
        
      
        viewPopup.isHidden = true
        self.viewCancel.isHidden = false
        self.viewShare.isHidden = false
        let vc = DismissAlertVC(nibName: "DismissAlertVC", bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        vc.isBack = false
        vc.poptohime = true
        
        present(vc, animated: true)
        

    }
    @IBAction func btnCancel(_ sender: Any) {
        
        self.viewCancel.isHidden = false
        self.viewShare.isHidden = false
        viewPopup.isHidden = true
        let vc = DismissAlertVC(nibName: "DismissAlertVC", bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        vc.isBack = false
        vc.poptohime = true
        present(vc, animated: true)
        
    }
    
    @IBAction func dontShareCode(_ sender: Any) {
        
        let vc = DismissAlertVC(nibName: "DismissAlertVC", bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        vc.isBack = false
        vc.poptohime = true
        present(vc, animated: true)
        
        //        for controller in self.navigationController!.viewControllers as Array {
        //                if controller.isKind(of: HomeVC.self) {
        //                    _ =  self.navigationController!.popToViewController(controller, animated: true)
        //                    break
        //                }
        //            }
        
        
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    //    func showHUDWithCancel(_ aMessage: String) {
    //       self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    //       self.hud.label.text = aMessage
    //       self.hud.detailsLabel.text = "Tap to cancel"
    //       let tap = UITapGestureRecognizer(target: self, action: #selector(cancelButton))
    //       self.hud.addGestureRecognizer(tap)
    //   }
    //
    //   func cancelButton() {
    //       self.hud.hide(animated: true)
    //       // do your other stuff here.
    //    }
    func showHUDWithCancel(_ aMessage: String) {
        
        self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        self.hud.mode = MBProgressHUDMode.annularDeterminate
        
        self.hud.label.text = aMessage
        self.hud.detailsLabel.text = "Tap to cancel"
        let tap = UITapGestureRecognizer(target: self, action: #selector(cancelButton))
        self.hud.addGestureRecognizer(tap)
    }
    
    @objc func cancelButton() {
        
        self.hud.hide(animated: true)
        self.hud.progressObject?.cancel()
        
        print("cancel button is working")
        
    }
    
}


extension WaitingRoomVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return ViewTable
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isPortrait {
            AppUtility.lockOrientation(.portrait)
        }else{
            AppUtility.lockOrientation(.landscape)
        }
    }
    
    
}
extension WaitingRoomVC{
    
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
            if isSuccess && blockCode == "10"{
                self.showExitAlert()
            
            }else {
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
                    self.CodeVerifyApi(number: self.number ?? "", userId: self.userID ?? "", isCamera: self.varCamera)
                    self.tblView.reloadData()
                    
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
                }else{
                    print("error")
                }
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
    
    func registerCell(){
        self.showActivityIndicator()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
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
}


extension WaitingRoomVC  {
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
