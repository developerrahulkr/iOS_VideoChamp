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
    
    var myPeerID : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        Log(self)
        // Do any additional setup after loading the view.
        
        StartTimer()
        
        print("MMy Peer ID : \(myPeerID ?? "")")
        
        
    }
    
    
    
    func StartTimer() {
        timerTest =  Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.timeInterval), userInfo: nil, repeats: false)
    }
    
    @objc func timeInterval(_ timer1: Timer) {
        stopTimerTest()
        if redirectType == .none {
            if Utility.shared.checkIsUserRegister().isEmpty {
                let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
                let nav_obj = UINavigationController(rootViewController: vc)
                nav_obj.isNavigationBarHidden = true
                UIApplication.shared.windows.first?.rootViewController = nav_obj
            }else{
                let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                let nav_obj = UINavigationController(rootViewController: vc)
                nav_obj.isNavigationBarHidden = true
                UIApplication.shared.windows.first?.rootViewController = nav_obj
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
                let vc = storyboard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
                let nav_obj = UINavigationController(rootViewController: vc)
                nav_obj.isNavigationBarHidden = true
                UIApplication.shared.windows.first?.rootViewController = nav_obj
                
            }else{
                let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                vc.checkConnectionState = .needToCameraToggle
                vc.myPeerID = myPeerID
                vc.verifyNum = verified_Code
                vc.userID = userID
                vc.isCamera = isCamera
                let nav_obj = UINavigationController(rootViewController: vc)
                nav_obj.isNavigationBarHidden = true
                UIApplication.shared.windows.first?.rootViewController = nav_obj
            }
            
        case .remote:
            if Utility.shared.checkIsUserRegister().isEmpty {
                let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
                let nav_obj = UINavigationController(rootViewController: vc)
                nav_obj.isNavigationBarHidden = true
                UIApplication.shared.windows.first?.rootViewController = nav_obj
                
            }else{
                let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                vc.checkConnectionState = .needToRunToggle
                vc.myPeerID = myPeerID
                vc.verifyNum = verified_Code
                vc.userID = userID
                vc.isCamera = isCamera
                let nav_obj = UINavigationController(rootViewController: vc)
                nav_obj.isNavigationBarHidden = true
                UIApplication.shared.windows.first?.rootViewController = nav_obj
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

