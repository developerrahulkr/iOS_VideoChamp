//
//  ViewController.swift
//  videoChamp
//
//  Created by iOS Developer on 15/02/22.
//

import UIKit
import MultipeerConnectivity

enum RedirectVC {
    case camera
    case remote
    case none
}

class SplashVC: UIViewController {
    
    var timerTest : Timer?

    var redirectType : RedirectVC = .none
    var verified_Code : String!
    var userID : String!
    var isCamera : String!
    var typeDevice = "IOS"
    
    
    var myPeerID : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait

        Log(self)
        
        // Do any additional setup after loading the view.
        
//        if typeDevice.contains("And") {
//            let vc = AlertCameraVC(nibName: "AlertCameraVC", bundle: nil)
//            vc.modalPresentationStyle = .overFullScreen
//            vc.btnColor = UIColor(red: 147/255, green: 192/255, blue: 31/255, alpha: 1)
//
//            vc.image = UIImage(named: "alert_icon")!
//            vc.titleText = "Cross Platform is not Supported"
//            vc.messageText = "Connect between Android and Ios is not supported."
//            vc.type = 1
//            UIApplication.topViewController()?.present(vc, animated: true)
//        }
//        else {
//            StartTimer()
        if videochampManager.videochamp_sharedManager.redirectType == .remote || videochampManager.videochamp_sharedManager.redirectType == .camera
        {
            
            StartTimer(timer: 1.0)
        }else{
            StartTimer(timer: 2.0)
        }
       // }
        
       
        
        print("MMy Peer ID : \(myPeerID ?? "")")
        
        
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isPortrait {
            AppUtility.lockOrientation(.portrait)
        }else{
            AppUtility.lockOrientation(.landscape)
        }
    }
    
    
    func StartTimer(timer : Double) {
        timerTest =  Timer.scheduledTimer(timeInterval: timer, target: self, selector: #selector(self.timeInterval), userInfo: nil, repeats: false)
    }
    
    @objc func timeInterval(_ timer1: Timer) {
        stopTimerTest()
        if redirectType == .none {
            if Utility.shared.checkIsUserRegister().isEmpty {
                let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "StartTutorialVC") as! StartTutorialVC
                let nav_obj = UINavigationController(rootViewController: vc)
                nav_obj.isNavigationBarHidden = true
                UIApplication.shared.windows.first?.rootViewController = nav_obj
            }else{
                if UIDevice.current.userInterfaceIdiom == .phone
                {
                    let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    vc.typeDevice = typeDevice
                    
                    let nav_obj = UINavigationController(rootViewController: vc)
                    nav_obj.isNavigationBarHidden = true
                    UIApplication.shared.windows.first?.rootViewController = nav_obj
                }else {
                    let storyboard:UIStoryboard = UIStoryboard(name: "Storyboard", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    vc.typeDevice = typeDevice
                    
                    let nav_obj = UINavigationController(rootViewController: vc)
                    nav_obj.isNavigationBarHidden = true
                    UIApplication.shared.windows.first?.rootViewController = nav_obj
                }
            }
        }else{
            initialSetUp()
        }
        
    }
    func initialSetUp(){
        switch redirectType {
        case .camera:
            if Utility.shared.checkIsUserRegister().isEmpty {
                let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "StartTutorialVC") as! StartTutorialVC
                let nav_obj = UINavigationController(rootViewController: vc)
                nav_obj.isNavigationBarHidden = true
                UIApplication.shared.windows.first?.rootViewController = nav_obj
                
            }else{
                if UIDevice.current.userInterfaceIdiom == .phone {
                    let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    vc.checkConnectionState = .needToCameraToggle
                    vc.myPeerID = myPeerID
                    vc.verifyNum = verified_Code
                    vc.userID = userID
                    vc.isCamera = isCamera
                    vc.typeDevice = typeDevice
                    vc.typeDevice = typeDevice
                    let nav_obj = UINavigationController(rootViewController: vc)
                    nav_obj.isNavigationBarHidden = true
                    UIApplication.shared.windows.first?.rootViewController = nav_obj
                }
                else {
                    let storyboard:UIStoryboard = UIStoryboard(name: "Storyboard", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    vc.checkConnectionState = .needToCameraToggle
                    vc.myPeerID = myPeerID
                    vc.verifyNum = verified_Code
                    vc.userID = userID
                    vc.isCamera = isCamera
                    vc.typeDevice = typeDevice
                    vc.typeDevice = typeDevice
                    let nav_obj = UINavigationController(rootViewController: vc)
                    nav_obj.isNavigationBarHidden = true
                    UIApplication.shared.windows.first?.rootViewController = nav_obj
                }
            }
            
        case .remote:
            if Utility.shared.checkIsUserRegister().isEmpty {
                let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "StartTutorialVC") as! StartTutorialVC
                let nav_obj = UINavigationController(rootViewController: vc)
                nav_obj.isNavigationBarHidden = true
                UIApplication.shared.windows.first?.rootViewController = nav_obj
                
            }else{
                if UIDevice.current.userInterfaceIdiom == .phone {
                    
                    let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    vc.checkConnectionState = .needToRunToggle
                    vc.myPeerID = myPeerID
                    vc.verifyNum = verified_Code
                    vc.userID = userID
                    vc.isCamera = isCamera
                    vc.typeDevice = typeDevice
                    let nav_obj = UINavigationController(rootViewController: vc)
                    nav_obj.isNavigationBarHidden = true
                    UIApplication.shared.windows.first?.rootViewController = nav_obj
                }
                else{
                    let storyboard:UIStoryboard = UIStoryboard(name: "Storyboard", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    vc.checkConnectionState = .needToRunToggle
                    vc.myPeerID = myPeerID
                    vc.verifyNum = verified_Code
                    vc.userID = userID
                    vc.isCamera = isCamera
                    vc.typeDevice = typeDevice
                    let nav_obj = UINavigationController(rootViewController: vc)
                    nav_obj.isNavigationBarHidden = true
                    UIApplication.shared.windows.first?.rootViewController = nav_obj
                }
            }
        case .none:

            break
            
        }
    }
    
    //MARK:- End Timer Method
    func stopTimerTest() {
        timerTest?.invalidate()
        timerTest = nil
    }
}

