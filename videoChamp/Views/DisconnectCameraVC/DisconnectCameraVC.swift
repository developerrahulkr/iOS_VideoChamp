//
//  DisconnectCameraVC.swift
//  videoChamp
//
//  Created by Akshay_mac on 23/06/22.
//

import UIKit

class DisconnectCameraVC: UIViewController {

    @IBOutlet weak var viewAlert: UIView!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        viewAlert.layer.cornerRadius = 15.0
        btnYes.layer.cornerRadius = btnYes.bounds.height / 2
        btnNo.layer.cornerRadius = btnNo.bounds.height / 2
    }
    @IBAction func onClickedYesBtn(_ sender: UIButton) {
        
        
        self.dismiss(animated: true)
        NotificationCenter.default.post(name: .kCloseScreen, object: nil)
    }
    
    @IBAction func onClickedNoBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    

 

}
