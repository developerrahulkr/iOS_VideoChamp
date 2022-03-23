//
//  FeedbackImageVC.swift
//  videoChamp
//
//  Created by iOS Developer on 16/03/22.
//

import UIKit

class FeedbackImageVC: UIViewController {

    @IBOutlet weak var imgFeedback: UIImageView!
    var imgURL = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        
    }
    
    func setupUI(){
        let url = URL(string: imgURL)!
        guard let imgData = try? Data(contentsOf: url) else {
            return
        }
        let image = UIImage(data: imgData)
        imgFeedback.image = image

        
    }
    
    @IBAction func onClickedCloseBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
