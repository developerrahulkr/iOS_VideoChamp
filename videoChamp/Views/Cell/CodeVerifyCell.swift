//
//  CodeVerifyCell.swift
//  videoChamp
//
//  Created by iOS Developer on 02/03/22.
//

import UIKit

protocol VerifyCodeDelegate {
    func verifyCode(tag : Int)
}

class CodeVerifyCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var tf1: UITextField!
    @IBOutlet weak var tf2: UITextField!
    @IBOutlet weak var tf3: UITextField!
    @IBOutlet weak var tf4: UITextField!
    @IBOutlet weak var btnConnect: UIButton!
    var delegate : VerifyCodeDelegate!
    var otpString = ""
    var callBack : ((_ str : String) -> ())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tf1.delegate = self
        tf2.delegate = self
        tf3.delegate = self
        tf4.delegate = self
        tf1.addTarget(self, action: #selector(changeCharacter), for: .editingChanged)
        tf2.addTarget(self, action: #selector(changeCharacter), for: .editingChanged)
        tf3.addTarget(self, action: #selector(changeCharacter), for: .editingChanged)
        tf4.addTarget(self, action: #selector(changeCharacter), for: .editingChanged)
        cardView.layer.cornerRadius = 20.0
        btnConnect.layer.cornerRadius = btnConnect.bounds.height / 2
    }
    
    @objc func changeCharacter(textField : UITextField){
        if textField.text?.utf8.count == 1 {
            switch textField {
            case tf1:
                tf2.becomeFirstResponder()
                otpString = tf1.text!
            case tf2:
                tf3.becomeFirstResponder()
                otpString = otpString + tf2.text!
            case tf3:
                tf4.becomeFirstResponder()
                otpString = otpString + tf3.text!
                
            case tf4:
                otpString = otpString + tf4.text!
                print("OTP : \(otpString)")
                textField.resignFirstResponder()
            default:
                break
            }
        }else if textField.text!.isEmpty {
            switch textField {
            case tf4 :
                tf3.becomeFirstResponder()
            case tf3 :
                tf2.becomeFirstResponder()
            case tf2 :
                tf1.becomeFirstResponder()
            default:
                break
                
            }
        }
    }

    @IBAction func onClickedConnectBtn(_ sender: UIButton) {
        delegate.verifyCode(tag: sender.tag)
    }
    
}


extension CodeVerifyCell : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text!.utf16.count == 1 && !string.isEmpty {
            return false
        }else {
            return true
        }
    }
    

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.callBack?(textField.text ?? "")
    }
    
}
