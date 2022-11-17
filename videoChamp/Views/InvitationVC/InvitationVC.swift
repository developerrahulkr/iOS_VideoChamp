//
//  InvitationVC.swift
//  videoChamp
//
//  Created by Udit_Rajput_Mac on 28/09/22.
//

import UIKit

class InvitationVC: UIViewController {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.viewMain.applyGradient(colorOne: .init(hexString: "#ECECEC"), ColorTwo: .init(hexString: "#C6C6C5"))
        }
        cancelBtn.layer.cornerRadius = 15
        viewMain.layer.cornerRadius = 25
        // Do any additional setup after loading the view.
    }

    
    @IBAction func btnCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func btnRemove(_ sender: Any) {
        dismiss(animated: true)
    }
}
