//
//  HomeVC.swift
//  videoChamp
//
//  Created by iOS Developer on 16/02/22.
//

import UIKit
//import MFrameWork
import MultipeerFramework
import MultipeerConnectivity


enum ConnectionState {
    case needToRunToggle
    case needToCameraToggle
    case none
}

class HomeVC: UIViewController {
    
    @IBOutlet var viewTable: UIView!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblShortName: UILabel!
    @IBOutlet weak var lblDeviceTitle: UILabel!
    @IBOutlet weak var lblCamera: UILabel!
    @IBOutlet weak var lblFindCameraDevice: UILabel!
    @IBOutlet weak var lblMonitorDevice: UILabel!
    @IBOutlet weak var lblControlDevice: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblOR: UILabel!
    var shortName = ""
    var nameTextColor : UIColor!
    var avatarImage : UIImage?
    var checkConnectionState : ConnectionState = .none
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var remoteView: UIView!
    
    let cameraViewModel = CameraConnectViewModel()
    private var mcSessionViewModel : MCSessionViewModel!
    var peerTableViewModel =  PeerTableViewModel()

    var peerIDs : [MCPeerID]!
    private let serviceType = "video-champ"
    private let displayName = UIDevice.current.name
    private let serviceProtocol:MCSessionManager.ServiceProtocol = .textAndVideo
    private let alertPresenter:AlertPresenter = .init()
    var myPeerID : String!
    var verifyNum : String!
    var userID : String!
    var isCamera : String!
    let homeVM = MenuViewModels()
    override func viewDidLoad() {
        super.viewDidLoad()
//        lblDeviceTitle.font = UIFont(name: "argentum-sans.bold", size: 14.0)
        setUpSessionManager()
        // Do any additional setup after loading the view.
        cameraAndRemoteViewAction()
        checkBlockAndActivateDate()
        loadData()
    }
    
    @IBAction func onClickedProfile(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AvatarVC") as! AvatarVC
        vc.modalPresentationStyle = .fullScreen
        vc.isUpdateProfile = true
        vc.userName = lblUserName.text ?? ""
        vc.shortName = lblShortName.text ?? ""
        self.present(vc, animated: true)
        
    }
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isPortrait {
            AppUtility.lockOrientation(.portrait)
        }else{
            AppUtility.lockOrientation(.landscape)
        }
    }
    
    
    private func setUpSessionManager() {
        Utility.shared.sessionManager = MCSessionManager.init(displayName: displayName, serviceType: serviceType,serviceProtocol: serviceProtocol)
        Utility.shared.sessionManager.onStateChanaged(connecting: {[weak self] (peerID, state) in
            guard let self = self else {return}
            print("PeerID is : \(peerID), connectionID : \(state)")
            self.peerTableViewModel.updateConnectedPeerIDs()
            self.peerTableViewModel.updateCellDataIfStateChanged(peerID: peerID, state: state)
            if state == MCConnectionState.connected {
                
                DispatchQueue.main.async {
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "PeerIDVC") as! PeerIDVC
//                    self.navigationController?.pushViewController(vc, animated: true)
                    let vc = LiveViewController.init(mcSessionManager: Utility.shared.sessionManager, targetPeerID: peerID)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            }, foundPeerIDs: {[weak self](ids) in
                guard let self = self else {return}
                self.peerIDs = ids
                let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: ids, requiringSecureCoding: false)
                UserDefaults.standard.set(encodedData, forKey: "MCPeerIDs")
                self.peerTableViewModel.updateFoundCell(ids)
                
        })
        setUpOnInvited()
    }
    
    private func setUpOnInvited() {
        let title = "Invitation from"
        let acceptTitle = "Accept"
        let cancelTitle = "Decline"
        Utility.shared.sessionManager.onInvited {[weak self] (fromPeerID, answerCallback) in
            guard let self = self else {return}
            let message = "\(fromPeerID.displayName)"
//            answerCallback(true)
            self.alertPresenter.confirmAlert(title: title, message: message, acceptTitle: acceptTitle, cancelTitle: cancelTitle, acceptCallback: { (isAccept) in
                answerCallback(isAccept)
            })
        }
    }
    

    func loadData(){
        
        mcSessionViewModel = MCSessionViewModel.init(mcSessionManger: Utility.shared.sessionManager)
        
        lblDeviceTitle.font = UIFont.systemFont(ofSize: 14.0, weight: .bold)
        lblOR.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)
        lblUserName.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)
        
        print("Baerer Token : \(Utility.shared.getUserAppToken())")
//        self.gradientColor(topColor: lightWhite, bottomColor: lightgrey)
//        self.gradientThreeColor(topColor: lightWhite, mediumColor: lightgrey, bottomColor: lightgrey)
        print("View Controller : \(String(describing: self.navigationController?.viewControllers))")
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationScreen), name: .kNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(termAndConditionScreen), name: .kTermsAndConditions, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(feedbackScreen), name: .kFeedback, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(shareScreen), name: .kShare, object: nil)
        
//        DispatchQueue.main.asyncAfter(deadline: .now()) {
//            self.browsingState()
//        }
        switch checkConnectionState {
        case .needToRunToggle:
            self.showActivityIndicator()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.hideActivityIndicator()
                self.showToast(message: "Custom Toast", font: .systemFont(ofSize: 12.0))
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "RemoteControlVC") as! RemoteControlVC
                vc.number = self.verifyNum
                vc.userID = self.userID
                vc.myPeerID = self.myPeerID
                vc.isCamera = self.isCamera
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case .none:
            break
        case .needToCameraToggle:
            self.showActivityIndicator()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                guard let self = self else {return}
                self.hideActivityIndicator()
                self.showToast(message: "Custom Toast", font: .systemFont(ofSize: 12.0))
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CameraVideoShareCodeVC") as! CameraVideoShareCodeVC
                vc.number = self.verifyNum
                vc.userID = self.userID
                vc.myPeerID = self.myPeerID
                vc.isCamera = self.isCamera
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Utility.shared.sessionManager.needsToRunSession == true {
            print("already is in Running State...................")
        }else{
            self.mcSessionViewModel.togggleConnectionRunState()
        }
        
//        AppUtility.lockOrientation(.portrait)
        imgAvatar.image = UserDefaults.standard.imageForKey(key: "avatarImage")
        
        lblShortName.text = UserDefaults.standard.string(forKey: "userText")
        if let userSelectedColorData = UserDefaults.standard.object(forKey: "UserSelectedColor") as? Data {
            if let userSelectedColor = NSKeyedUnarchiver.unarchiveObject(with:userSelectedColorData as Data) as? UIColor {
                print(userSelectedColor)
                lblShortName.textColor = userSelectedColor
            }
        }
        
    }
    
    
    func checkBlockAndActivateDate() {
        homeVM.activateDateAPIData { isSuccess, Code  in
            if isSuccess && Code == "1"{
                print("User is Unblock")
            }else if isSuccess && Code == "10"{
                self.showExitAlert()
            }else{
                self.showAlert(alertMessage: "Is Success is no Working")
            }
        }
    }

    
    @available(iOS, deprecated: 9.0)
    override func viewDidLayoutSubviews() {
        lblShortName.text = UserDefaults.standard.string(forKey: "userText")
        if let userSelectedColorData = UserDefaults.standard.object(forKey: "UserSelectedColor") as? Data {
            if let userSelectedColor = NSKeyedUnarchiver.unarchiveObject(with:userSelectedColorData as Data) as? UIColor {
                print(userSelectedColor)
                lblShortName.textColor = userSelectedColor
            }
        }
        imgAvatar.image = UserDefaults.standard.imageForKey(key: "avatarImage")
        lblUserName.text = "\(UserDefaults.standard.string(forKey: kUserNAme) ?? "User Name")"
        lblCamera.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        lblControlDevice.font = UIFont.systemFont(ofSize: 14.0, weight: .light)
        
        lblCamera.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        lblFindCameraDevice.font = UIFont.systemFont(ofSize: 14.0, weight: .light)
        
        lblMonitorDevice.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        lblControlDevice.font = UIFont.systemFont(ofSize: 14.0, weight: .light)
    }
    

    
    func cameraAndRemoteViewAction(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(funcCameraActivity))
        cameraView.addGestureRecognizer(gesture)
        
        let gesture1 = UITapGestureRecognizer(target: self, action: #selector(funcRemoteActivity))
        remoteView.addGestureRecognizer(gesture1)
    }
    
    @objc func funcCameraActivity(){
        print("peer ids is : \(String(describing: self.peerIDs))")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CameraVideoShareCodeVC") as! CameraVideoShareCodeVC
        videochampManager.videochamp_sharedManager.redirectType = .camera
//        vc.sessionManager = sessionManager
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func funcRemoteActivity(){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RemoteControlVC") as! RemoteControlVC
        self.navigationController?.pushViewController(vc, animated: true)
        videochampManager.videochamp_sharedManager.redirectType = .remote
    }
    
    @objc func notificationScreen(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        self.navigationController?.pushViewController(vc, animated: true)
        print("Notification")
    }
    
    @objc func feedbackScreen(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FeedbackVC") as! FeedbackVC
        self.navigationController?.pushViewController(vc, animated: true)
        print("feedbackScreen")
    }
    
    @objc func termAndConditionScreen(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TermsAndConditionVC") as! TermsAndConditionVC
        self.navigationController?.pushViewController(vc, animated: true)
        print("termAndConditionScreen")
    }
    
    @objc func shareScreen(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShareVC") as! ShareVC
        vc.headingText = "SHARE APPLICATION"
        self.navigationController?.pushViewController(vc, animated: true)
        print("shareScreen")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .kNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .kFeedback, object: nil)
        NotificationCenter.default.removeObserver(self, name: .kShare, object: nil)
        NotificationCenter.default.removeObserver(self, name: .kTermsAndConditions, object: nil)
        print("Remove NotiFication")
    }
    
    
  
    
    @IBAction func onClickedMenuBtn(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
//        vc.modalTransitionStyle = .

        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
}


extension HomeVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return viewTable
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 550.0
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isPortrait {
            AppUtility.lockOrientation(.portrait)
        }else{
            AppUtility.lockOrientation(.landscape)
        }
    }
    
    
}


