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
import Alamofire
import GradientView


enum ConnectionState {
    case needToRunToggle
    case needToCameraToggle
    case none
}

class HomeVC: UIViewController {
    
    
    @IBOutlet weak var viewSplash: UIView!
    @IBOutlet weak var imgRemote1: UIImageView!
    @IBOutlet weak var imgCamera1: UIImageView!
    @IBOutlet weak var imgCamera: UIImageView!
    @IBOutlet weak var imgRemote: UIImageView!
    @IBOutlet var viewMain: GradientView!
    //  @IBOutlet var viewTable: UIView!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblShortName: UILabel!
    @IBOutlet weak var lblDeviceTitle: UILabel!
    @IBOutlet weak var lblCamera: UILabel!
    @IBOutlet weak var lblFindCameraDevice: UILabel!
    @IBOutlet weak var lblMonitorDevice: UILabel!
    @IBOutlet weak var lblControlDevice: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblOR: UILabel!
    // @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewPopUp: UIView!
    
    @IBOutlet weak var viewPotrait: UIView!
    @IBOutlet weak var viewLandscapoe: UIView!
    
    @IBOutlet weak var imgPopup: UIImageView!
    
    
    
    var shortName = ""
    var nameTextColor : UIColor!
    var avatarImage : UIImage?
    var checkConnectionState : ConnectionState = .none
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var remoteView: UIView!
    
    
    @IBOutlet weak var cameraView1: UIView!
    @IBOutlet weak var remoteView1: UIView!
    
    var typeDevice = ""
    
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
    // let check = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .all
            
        }
        rotationSetup()
        imgRemote1.layer.cornerRadius = 12
        imgCamera1.layer.cornerRadius = 12
        imgPopup.image = UIImage.gifImageWithName("timer")
        viewPopUp.isHidden = true
        
        if videochampManager.videochamp_sharedManager.redirectType == .remote || videochampManager.videochamp_sharedManager.redirectType == .camera
        {
            
            viewSplash.isHidden = false
        }else{
            viewSplash.isHidden = true
        }
       
        
        // imgPopup.image = UIImage.gifImageWithName("timer")
        imgRemote.layer.cornerRadius = 22
        imgCamera.layer.cornerRadius = 22
        setUpSessionManager()
        cameraAndRemoteViewAction()
        checkBlockAndActivateDate()
        loadData()
    }
    
    func rotationSetup(){
        if UIScreen.main.bounds.width > UIScreen.main.bounds.height{
            viewLandscapoe.isHidden = false
            viewPotrait.isHidden = true
            
        }else{
            viewPotrait.isHidden = false
            viewLandscapoe.isHidden = true
            
        }
    }
    
    
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // if UIDevice.current.userInterfaceIdiom == .pad{
        if UIDevice.current.orientation.isLandscape{
            viewLandscapoe.isHidden = false
            viewPotrait.isHidden = true
        }
        else
        {
            viewPotrait.isHidden = false
            viewLandscapoe.isHidden = true
        }
        //}
    }
    
    override func viewWillLayoutSubviews() {
        viewMain.colors = [UIColor.init(hexString: "#9C9B9B"),UIColor.init(hexString: "#C6C6C5")]
        self.imgRemote.applyGradient1(colorOne: .init(hexString: "#00ACCC"), ColorTwo: .init(hexString: "#00519C"))
        if UIDevice.current.userInterfaceIdiom == .pad{
         self.imgRemote1.applyGradient1(colorOne: .init(hexString: "#00ACCC"), ColorTwo: .init(hexString: "#00519C"))
        }
        //viewMain.applyGradient2(frame: viewMain.bounds, colorOne: .init(hexString: "#9C9B9B"), ColorTwo: .init(hexString: "#C6C6C5"))
        //viewMain.applyGradient(colorOne: .init(hexString: "#9C9B9B"), ColorTwo: .init(hexString: "#C6C6C5"))
        //self.gradientColor(topColor: .init(hexString: "#9C9B9B"), bottomColor: .init(hexString: "#C6C6C5"))
        // remoteView.applyGradient(colorOne: .init(hexString: "#00ACCC"), ColorTwo: .init(hexString: "#00519C"))
    }
    
    @IBAction func onClickedProfile(_ sender: UIButton) {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AvatarVC") as! AvatarVC
        vc.modalPresentationStyle = .fullScreen
        vc.isUpdateProfile = true
        vc.userName = lblUserName.text ?? ""
        vc.shortName = lblShortName.text ?? ""
        self.present(vc, animated: true)
        
    }
    
    @IBAction func btncancell(_ sender: Any) {
        
        viewPopUp.isHidden = true
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        
        viewPopUp.isHidden = true
        
    }
    
    //    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
    //        if UIDevice.current.orientation.isPortrait {
    //            AppUtility.lockOrientation(.portrait)
    //        }else{
    //            AppUtility.lockOrientation(.landscape)
    //        }
    //}
    
    
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
                    // let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
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
        
        self.hideActivityIndicator()
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
        NotificationCenter.default.addObserver(self, selector: #selector(WelcomeScreen), name: .kWelcome, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(termAndConditionScreen), name: .kTermsAndConditions, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(feedbackScreen), name: .kFeedback, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(shareScreen), name: .kShare, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(privacyPolicy), name: .kPrivacyPolicy, object: nil)
        
        
        //        DispatchQueue.main.asyncAfter(deadline: .now()) {
        //            self.browsingState()
        //        }
        
        switch checkConnectionState {
        case .needToRunToggle:
            //self.showActivityIndicator()
            viewSplash.isHidden = false
           // viewPopUp.isHidden = false
            //Indicator.instance.show(loadingText: "Please wait for Connection")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                Indicator.instance.hide()
              //  self.viewPopUp.isHidden = true
               // self.viewSplash.isHidden = true

                //self.showToast(message: "Custom Toast", font: .systemFont(ofSize: 12.0))
                let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "RemoteControlVC") as! RemoteControlVC
                vc.indicatorType = 1
                vc.number = self.verifyNum
                vc.userID = self.userID
                vc.myPeerID = self.myPeerID
                vc.isCamera = self.isCamera
                vc.typeDevice = self.typeDevice
                self.viewSplash.isHidden = true
                self.navigationController?.pushViewController(vc, animated: false)
            }
        case .none:
            break
        case .needToCameraToggle:
           // viewPopUp.isHidden = false
            viewSplash.isHidden = false

            // Indicator.instance.show(loadingText: "Please wait for Connection")
            //self.showActivityIndicator()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                guard let self = self else {return}
                //Indicator.instance.hide()
              //  self.viewSplash.isHidden = true

               // self.viewPopUp.isHidden = true
                //self.showToast(message: "Custom Toast", font: .systemFont(ofSize: 12.0))
                let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "CameraVideoShareCodeVC") as! CameraVideoShareCodeVC
                vc.indicatorType = 1
                vc.number = self.verifyNum
                vc.userID = self.userID
                vc.myPeerID = self.myPeerID
                vc.isCamera = self.isCamera
                vc.typeDevice = self.typeDevice
                self.viewSplash.isHidden = true
                self.navigationController?.pushViewController(vc, animated: false)
            }
            
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .all
        rotationSetup()
        //tblView.isHidden = false
        if Utility.shared.sessionManager.needsToRunSession == true {
            print("already is in Running State...................")
        }else{
            self.mcSessionViewModel.togggleConnectionRunState()
        }
        imgAvatar.image = UserDefaults.standard.imageForKey(key: "avatarImage")
        lblShortName.text = UserDefaults.standard.string(forKey: "userText")
        if let userSelectedColorData = UserDefaults.standard.object(forKey: "UserSelectedColor") as? Data {
            if let userSelectedColor = NSKeyedUnarchiver.unarchiveObject(with:userSelectedColorData as Data) as? UIColor
            {
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
        //        lblCamera.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        //        lblControlDevice.font = UIFont.systemFont(ofSize: 14.0, weight: .light)
        //
        //        lblCamera.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        //        lblFindCameraDevice.font = UIFont.systemFont(ofSize: 14.0, weight: .light)
        //
        //        lblMonitorDevice.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        //        lblControlDevice.font = UIFont.systemFont(ofSize: 14.0, weight: .light)
    }
    
    
    
    func cameraAndRemoteViewAction(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(funcCameraActivity))
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(funcCameraActivity))
        cameraView.addGestureRecognizer(gesture)
        // if UIDevice.current.userInterfaceIdiom == .pad{
        cameraView1.addGestureRecognizer(gesture2)
        // }
        
        let gesture1 = UITapGestureRecognizer(target: self, action: #selector(funcRemoteActivity))
        let gesture3 = UITapGestureRecognizer(target: self, action: #selector(funcRemoteActivity))
        remoteView.addGestureRecognizer(gesture1)
        //  if UIDevice.current.userInterfaceIdiom == .pad{
        remoteView1.addGestureRecognizer(gesture3)
        //  }
    }
    
    @objc func funcCameraActivity(){
        if !APIManager.shared.isConnectedToInternet() {
            
            let vc = AlertCameraVC(nibName: "AlertCameraVC", bundle: nil)
            vc.modalPresentationStyle = .overFullScreen
            vc.btnColor = UIColor(red: 147/255, green: 192/255, blue: 31/255, alpha: 1)
            //self.isDisconnect = false
            vc.btnOkText = "ENABLE"
            vc.image = UIImage(named: "alert_icon")!
            vc.titleText = "WIFI DISABLED"
            vc.messageText = "Please enable WIFI"
            UIApplication.topViewController()?.present(vc, animated: true)
            // self.showAlert(alertMessage: "Internet is not Access.")
        }else{
            print("peer ids is : \(String(describing: self.peerIDs))")
            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CameraVideoShareCodeVC") as! CameraVideoShareCodeVC
            videochampManager.videochamp_sharedManager.redirectType = .camera
            //        vc.sessionManager = sessionManager
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @objc func funcRemoteActivity(){
        if !APIManager.shared.isConnectedToInternet() {
            let vc = AlertCameraVC(nibName: "AlertCameraVC", bundle: nil)
            vc.modalPresentationStyle = .overFullScreen
            vc.btnColor = UIColor(red: 147/255, green: 192/255, blue: 31/255, alpha: 1)
            //self.isDisconnect = false
            vc.btnOkText = "ENABLE"
            vc.image = UIImage(named: "alert_icon")!
            vc.titleText = "WIFI DISABLED"
            vc.messageText = "Please enable WIFI"
            UIApplication.topViewController()?.present(vc, animated: true)
            //self.showAlert(alertMessage: "Internet is not Access.")
        }else {
            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "RemoteControlVC") as! RemoteControlVC
            vc.indicatorType = 0
            self.navigationController?.pushViewController(vc, animated: true)
            videochampManager.videochamp_sharedManager.redirectType = .remote
        }
        
        
    }
    
    @objc func notificationScreen(){
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        self.navigationController?.pushViewController(vc, animated: true)
        print("Notification")
    }
    
    @objc func feedbackScreen(){
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FeedbackVC") as! FeedbackVC
        self.navigationController?.pushViewController(vc, animated: true)
        print("feedbackScreen")
    }
    
    @objc func WelcomeScreen(){
        if UIDevice.current.userInterfaceIdiom == .pad{
            let storyboard:UIStoryboard = UIStoryboard(name: "Storyboard", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
            vc.type = 1
            self.navigationController?.pushViewController(vc, animated: true)
            print("Welcome")
        }
        else
        {
            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
            vc.type = 1
            self.navigationController?.pushViewController(vc, animated: true)
            print("Welcome")
        }
    }
    @objc func termAndConditionScreen(){
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TermsAndConditionVC") as! TermsAndConditionVC
        self.navigationController?.pushViewController(vc, animated: true)
        print("termAndConditionScreen")
    }
    
    @objc func shareScreen(){
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ShareVC") as! ShareVC
        vc.headingText = "TELL FRIENDS"
        self.navigationController?.pushViewController(vc, animated: true)
        print("shareScreen")
    }
    
    @objc func privacyPolicy(){
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
        self.navigationController?.pushViewController(vc, animated: true)
        print("feedbackScreen")
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .kNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .kWelcome, object: nil)
        NotificationCenter.default.removeObserver(self, name: .kFeedback, object: nil)
        NotificationCenter.default.removeObserver(self, name: .kShare, object: nil)
        NotificationCenter.default.removeObserver(self, name: .kTermsAndConditions, object: nil)
        NotificationCenter.default.removeObserver(self, name: .kPrivacyPolicy, object: nil)
        print("Remove NotiFication")
    }
    
    
    
    
    @IBAction func onClickedMenuBtn(_ sender: UIButton) {
        
        viewPotrait.isHidden = true
        viewLandscapoe.isHidden = true
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
        
        vc.callback = {
            if UIScreen.main.bounds.width > UIScreen.main.bounds.height{
                self.viewLandscapoe.isHidden = false
                self.viewPotrait.isHidden = true
                
            }else{
                self.viewPotrait.isHidden = false
                self.viewLandscapoe.isHidden = true
            }
        }
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
}


//extension HomeVC : UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 0
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return UITableViewCell()
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return viewTable
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 550.0
//    }
//}



