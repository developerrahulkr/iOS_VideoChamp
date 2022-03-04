//
//  HomeVC.swift
//  videoChamp
//
//  Created by iOS Developer on 16/02/22.
//

import UIKit

class HomeVC: UIViewController {
    
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
    
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var remoteView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
//        lblDeviceTitle.font = UIFont(name: "argentum-sans.bold", size: 14.0)
        lblDeviceTitle.font = UIFont.systemFont(ofSize: 14.0, weight: .bold)
        lblOR.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationScreen), name: .kNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(termAndConditionScreen), name: .kTermsAndConditions, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(feedbackScreen), name: .kFeedback, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(shareScreen), name: .kShare, object: nil)
        cameraAndRemoteViewAction()
        print("Baerer Token : \(Utility.shared.getUserAppToken())")
        self.gradientColor(topColor: lightWhite, bottomColor: lightgrey)
        
        self.gradientThreeColor(topColor: lightWhite, mediumColor: lightgrey, bottomColor: lightgrey)
    }
    
    override func viewDidLayoutSubviews() {
        lblShortName.text = UserDefaults.standard.string(forKey: "userText")
        if let userSelectedColorData = UserDefaults.standard.object(forKey: "UserSelectedColor") as? Data {
            if let userSelectedColor = NSKeyedUnarchiver.unarchiveObject(with:userSelectedColorData as Data) as? UIColor {
                print(userSelectedColor)
                lblShortName.textColor = userSelectedColor
            }
        }
        imgAvatar.image = UserDefaults.standard.imageForKey(key: "avatarImage")
        lblUserName.text = "Hello \(UserDefaults.standard.string(forKey: kUserNAme) ?? "User Name")"
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
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CameraVideoShareCodeVC") as! CameraVideoShareCodeVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func funcRemoteActivity(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RemoteControlVC") as! RemoteControlVC
        self.navigationController?.pushViewController(vc, animated: true)
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
        vc.headingText = "Share Application"
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


