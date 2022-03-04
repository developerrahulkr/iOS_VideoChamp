//
//  GiveFeedbackCell3.swift
//  videoChamp
//
//  Created by iOS Developer on 22/02/22.
//

import UIKit

protocol openPhotoLibraryDelegate{
    func openLibrary()
    func openLibrary2()
}


class GiveFeedbackCell3: UITableViewCell {

    @IBOutlet weak var imgLeftView: UIView!
    @IBOutlet weak var imgRightView: UIView!
    @IBOutlet weak var imgLeft: UIImageView!
    @IBOutlet weak var imgRight: UIImageView!
    
    var delegate : openPhotoLibraryDelegate!
    
    var callBackForleftImg:(()->())?
    var callBackForRightImg:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgLeftView.layer.cornerRadius = 20.0
        imgRightView.layer.cornerRadius = 20.0
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(openPhotoLibrary))
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(openRightPhotoLibrary))
        imgRightView.addGestureRecognizer(gesture2)
        imgLeftView.addGestureRecognizer(gesture)
    }
    
    @objc func openPhotoLibrary(){
        delegate.openLibrary()
        self.callBackForleftImg?()
    }
    
    @objc func openRightPhotoLibrary(){
        delegate.openLibrary2()
        self.callBackForRightImg?()
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
