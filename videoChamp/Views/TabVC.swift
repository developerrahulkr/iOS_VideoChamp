//
//  TabVC.swift
//  videoChamp
//
//  Created by Udit_Rajput_Mac on 30/09/22.
//

import UIKit

class TabVC: UIViewController {

    @IBOutlet weak var viewLand: UIView!
    @IBOutlet weak var viewBottom: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape{
            viewBottom.isHidden = true
            viewLand.isHidden = false
            
        }else{
            viewBottom.isHidden = false
            viewLand.isHidden = true
            
        }
    }
}
