//
//  StartTutorialVC.swift
//  videoChamp
//
//  Created by Udit_Rajput_Mac on 26/09/22.
//

import UIKit
import GradientView

class StartTutorialVC: UIViewController {

    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet var viewMain: GradientView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetup()
    
    
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewMain.colors = [UIColor.init(hexString: "#FF9200"),UIColor(hexString: "#FF3100")]
        //self.viewMain.applyGradient(colorOne: .init(hexString: "#FF9200"), ColorTwo: .init(hexString: "#FF3100"))
    }
    
    
    @IBAction func StartBtn(_ sender: Any) {
        if UIDevice.current.userInterfaceIdiom == .phone {
            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

            let vc = storyboard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else{
            let storyboard:UIStoryboard = UIStoryboard(name: "Storyboard", bundle: nil)

            let vc = storyboard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @IBAction func btnSkip(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AvatarVC") as! AvatarVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

extension StartTutorialVC
{
    func initSetup()
    {
        skipBtn.layer.borderWidth = 1
        skipBtn.layer.cornerRadius = skipBtn.layer.bounds.height/2
        skipBtn.layer.borderColor = UIColor.white.cgColor
        btnStart.layer.cornerRadius = btnStart.layer.bounds.height/2
        btnStart.applyGradientForInsta(colorOne: .init(hexString: "#C8D400"), ColorTwo: .init(hexString: "#93C01F"), ColorThree: .init(hexString: "#35A936"))
        
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait

    }
    
}
