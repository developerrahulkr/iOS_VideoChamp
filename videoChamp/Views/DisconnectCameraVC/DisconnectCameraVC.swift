//
//  DisconnectCameraVC.swift
//  videoChamp
//
//  Created by Akshay_mac on 23/06/22.
//

import UIKit
import MultipeerFramework

class DisconnectCameraVC: UIViewController {

    @IBOutlet weak var viewAlert: UIView!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    var isBack : Bool = false
    var mcSessionManage : MCSessionManager!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
            self.dismiss(animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        viewAlert.layer.cornerRadius = 15.0
        btnYes.layer.cornerRadius = btnYes.bounds.height / 2
        btnNo.layer.cornerRadius = btnNo.bounds.height / 2
    }
    @IBAction func onClickedYesBtn(_ sender: UIButton) {
        
        if isBack {
            self.dismiss(animated: true)
            NotificationCenter.default.post(name: .kCloseScreen, object: nil)
        }else{
            self.dismiss(animated: true)
            NotificationCenter.default.post(name: .kCloseScreen, object: nil)
        }
        
    }
    
    @IBAction func onClickedNoBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    

 

}
