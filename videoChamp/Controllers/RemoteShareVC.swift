//
//  RemoteShareVC.swift
//  videoChamp
//
//  Created by Udit_Rajput_Mac on 20/09/22.
//

import UIKit
import GradientView
import MBProgressHUD
import MultipeerFramework
import MultipeerConnectivity

class RemoteShareVC: UIViewController {

    
    @IBOutlet weak var viewCancel: GradientView!
    @IBOutlet weak var viewShare: GradientView!
    
    @IBOutlet weak var viewMain: GradientView!
    @IBOutlet weak var viewTop: GradientView!
    @IBOutlet weak var viewPopup: UIView!
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet var viewTbl: UIView!
    @IBOutlet weak var imgPopUP: UIImageView!
    
    
    var hud: MBProgressHUD = MBProgressHUD()
    var urlLink = ""
    var counter = 10
    var generatedUrlCode = ""
    private var peerTableViewModel = PeerTableViewModel()
    private let timeout: TimeInterval = 20
    private var mcSessionViewModel : MCSessionViewModel!
    let codeGenerateVM = GenerateNumberViewModel()
    let generateLinkVM = GeneratedLinkViewModel()
    var myPeerID : String!
    var number : String?
    var userID : String?
    var isCamera : String!
    var staticLink = "http://videochamp/camera/"
    var varCamera : Bool!
    let cameraViewModel = CameraConnectViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        cameraViewModel.getRemoteData()
        loadData()
      imgPopUP.image = UIImage.gifImageWithName("loader")
        viewPopup.isHidden = true
        tblView.delegate = self
        tblView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(closeVC), name: .home, object: nil)
        self.tblView.isUserInteractionEnabled = true
        viewShare.layer.cornerRadius = 25
        viewCancel.layer.cornerRadius = 25
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        
        viewMain.colors = [UIColor.init(hexString: "#00ACCC") , UIColor.init(hexString: "#00519C")]
        viewTop.applyGradient1(colorOne: .init(hexString: "#00ACCC"), ColorTwo: .init(hexString: "#00519C"))
        viewShare.colors = [UIColor.init(hexString: "#C8D400") , UIColor.init(hexString: "#93C01F") , UIColor.init(hexString: "#35A936")]
        viewCancel.colors = [UIColor.init(hexString: "#A9A6AE") , UIColor.init(hexString: "#58555C")]
        
       
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
        
    @IBAction func remove(_ sender: Any) {
        self.viewCancel.isHidden = false
        self.viewShare.isHidden = false
        viewPopup.isHidden = true
    }
    
    @IBAction func viewCancel(_ sender: Any) {
        self.viewCancel.isHidden = false
        self.viewShare.isHidden = false
        viewPopup.isHidden = true
        let vc = DismissAlertVC(nibName: "DismissAlertVC", bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        vc.isBack = false
        vc.poptohime = true
        
       
        present(vc, animated: true)
    }
        
    @IBAction func btnMovetoHome(_ sender: Any) {
            let vc = DismissAlertVC(nibName: "DismissAlertVC", bundle: nil)
            vc.modalPresentationStyle = .overFullScreen
            vc.isBack = false
            vc.poptohime = true
            present(vc, animated: true)
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ShareBtn(_ sender: Any) {
        if let encoded = urlLink.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
           let url = URL(string: encoded)
        {
            if UIDevice.current.userInterfaceIdiom == .pad {
                
                let activityVC = UIActivityViewController(activityItems: [sendingCameraMessage,url], applicationActivities: nil)
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
                let sharesheetVC = UIActivityViewController(activityItems: [sendingCameraMessage,url], applicationActivities: nil)
               // sharesheetVC.excludedActivityTypes = [.airDrop]

                //                    sharesheetVC.completionWithItemsHandler = nil3
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
    
    @IBAction func btnCancel(_ sender: Any) {
        let vc = DismissAlertVC(nibName: "DismissAlertVC", bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        vc.isBack = false
        vc.poptohime = true
        
       
        present(vc, animated: true)
    }
    
    
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


extension RemoteShareVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return viewTbl
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        if !UIDevice.current.orientation.isPortrait {
//
//            AppUtility.lockOrientation(.portrait)
//        }else{
//            AppUtility.lockOrientation(.landscape)
//        }
//    }
    
    //MARK: - Today -
    
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
    
    func expireCodeAlert(message : String) {
        let alert = UIAlertController(title: appName, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    @objc func closeScreen(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
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
                    self.tblView.reloadData()
                    
                }
                else if codeMessage == "code Expire" && isSuccess{
                    self.loadData()
                }else{
                    print("Error")
                }
            }
            
        }
    }
    
    
       func registerCell(){
           mcSessionViewModel = MCSessionViewModel.init(mcSessionManger: Utility.shared.sessionManager)
           
           self.showActivityIndicator()
           DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
               self.hideActivityIndicator()
               
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
}
