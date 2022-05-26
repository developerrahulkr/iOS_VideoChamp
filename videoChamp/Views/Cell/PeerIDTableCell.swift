//
//  PeerIDTableCell.swift
//  videoChamp
//
//  Created by iOS Developer on 10/05/22.
//

import UIKit

protocol PeerButtonDelegate {
    func onTappedButton(_ tag : Int)
}

class PeerIDTableCell: UITableViewCell {

    @IBOutlet weak var lblConnectionType: UILabel!
    @IBOutlet weak var lblDisplayName: UILabel!
    @IBOutlet weak var btnInvite: UIButton!
    var delegate : PeerButtonDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onClickedBtnInvite(_ sender: UIButton) {
        delegate.onTappedButton(sender.tag)
    }
    
    
}
