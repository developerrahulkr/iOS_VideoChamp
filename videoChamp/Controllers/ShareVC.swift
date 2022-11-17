//
//  ShareVC.swift
//  videoChamp
//
//  Created by iOS Developer on 16/02/22.
//

import UIKit
import StoreKit
import GradientView

class ShareVC: UIViewController {

    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var viewCenter: UIView!
    @IBOutlet var viewMain: GradientView!
    
    var headingText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblHeading.text = headingText
        
        self.gradientColor(topColor: lightWhite, bottomColor: lightgrey)

    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isPortrait {
            AppUtility.lockOrientation(.portrait)
        }else{
            AppUtility.lockOrientation(.landscape)
        }
    }
    
    override func viewDidLayoutSubviews() {
        viewMain.colors = [UIColor.init(hexString: "#9C9B9B"),UIColor(hexString: "#C6C6C5")]
        viewCenter.layer.cornerRadius = 25.0
        //lblHeading.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)
    }
    
    @IBAction func onClickedBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func onClickedWhatsAppBtn(_ sender: UIButton) {

        openLink(urlLink: "https://api.whatsapp.com/", id: 310633997)
    }
    
    @IBAction func onClickedFacebookBtn(_ sender: UIButton) {
        openLink(urlLink: "https://www.facebook.com/", id: 284882215)
    }
    
    @IBAction func onClickedInstagramBtn(_ sender: UIButton) {
        openLink(urlLink: "https://api.instagram.com/", id: 389801252)
    }
    
    @IBAction func onClickedTwitter(_ sender: UIButton) {
        openLink(urlLink: "https://www.twitter.com/", id: 333903271)
    }
    
    @IBAction func onClickedYoutubeBtn(_ sender: UIButton) {
        openLink(urlLink: "https://www.youtube.com/", id: 544007664)
    }
    @IBAction func onClickedTiktokBtn(_ sender: UIButton) {
        openLink(urlLink: "https://www.tiktok.com/", id: 835599320)
    }
    
    
//    tiktok ID 835599320
//    MARK: - Open App Link Func
    func openLink(urlLink : String, id : Int) {
        let appURL = URL(string: "whatsapp://")!
        let application = UIApplication.shared

        if application.canOpenURL(appURL) {
            application.open(appURL)
        } else {
            // if Instagram app is not installed, open URL inside Safari
            let vc = SKStoreProductViewController()
            vc.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier : NSNumber(value: id)], completionBlock: nil)
            present(vc, animated: true)
        }
    }
    
    

}
