//
//  ShareVC.swift
//  videoChamp
//
//  Created by iOS Developer on 16/02/22.
//

import UIKit

class ShareVC: UIViewController {

    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var viewCenter: UIView!
    
    var headingText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblHeading.text = headingText
        
        self.gradientColor(topColor: lightWhite, bottomColor: lightgrey)

    }
    
    override func viewDidLayoutSubviews() {
        viewCenter.layer.cornerRadius = 25.0
        lblHeading.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)
    }
    
    @IBAction func onClickedBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func onClickedWhatsAppBtn(_ sender: UIButton) {
        openLink(urlLink: "https://api.whatsapp.com/")
    }
    
    @IBAction func onClickedFacebookBtn(_ sender: UIButton) {
        openLink(urlLink: "https://www.facebook.com/")
    }
    
    @IBAction func onClickedInstagramBtn(_ sender: UIButton) {
        openLink(urlLink: "https://api.instagram.com/")
    }
    
    @IBAction func onClickedTwitter(_ sender: UIButton) {
        openLink(urlLink: "https://www.twitter.com/")
    }
    
    @IBAction func onClickedYoutubeBtn(_ sender: UIButton) {
        openLink(urlLink: "https://www.youtube.com/")
    }
//    MARK: - Open App Link Func
    func openLink(urlLink : String) {
        let appURL = URL(string: "whatsapp://")!
        let application = UIApplication.shared

        if application.canOpenURL(appURL) {
            application.open(appURL)
        } else {
            // if Instagram app is not installed, open URL inside Safari
            let webURL = URL(string: urlLink)!
            application.open(webURL)
        }
    }
    
    

}
