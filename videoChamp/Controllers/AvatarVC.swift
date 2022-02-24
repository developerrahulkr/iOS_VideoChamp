//
//  AvatarVC.swift
//  videoChamp
//
//  Created by iOS Developer on 16/02/22.
//

import UIKit

class AvatarVC: UIViewController {

    @IBOutlet weak var viewText: UIView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var tfName: UITextField!
    
    
    @IBOutlet weak var lblUserName1: UILabel!
    @IBOutlet weak var lblUserName2: UILabel!
    @IBOutlet weak var lblUserName3: UILabel!
    @IBOutlet weak var lblUserName4: UILabel!
    @IBOutlet weak var lblUserName5: UILabel!
    @IBOutlet weak var lblUserName6: UILabel!
    @IBOutlet weak var lblUserName7: UILabel!
    
    
    @IBOutlet weak var topView1: UIView!
    @IBOutlet weak var topView2: UIView!
    @IBOutlet weak var topView3: UIView!
    @IBOutlet weak var bottomView1: UIView!
    @IBOutlet weak var bottomView2: UIView!
    @IBOutlet weak var bottomView3: UIView!
    
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var imgAvatar2: UIImageView!
    @IBOutlet weak var imgAvatar3: UIImageView!
    @IBOutlet weak var imgAvatar4: UIImageView!
    @IBOutlet weak var imgAvatar5: UIImageView!
    @IBOutlet weak var imgAvatar6: UIImageView!
    @IBOutlet weak var imgAvatar7: UIImageView!
    
    let userViewModel = UserViewModel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tfName.delegate = self
        changeAvatar()
        self.gradientColor(topColor: lightWhite, bottomColor: lightgrey)
//        self.gradientThreeColor(topColor: lightWhite, mediumColor: lightgrey, bottomColor: lightgrey)
        
    }
    
    
//    MARK: - Change Avatar
    
    func changeAvatar(){
        let gesture1 = UITapGestureRecognizer(target: self, action: #selector(changeImage1))
        topView1.addGestureRecognizer(gesture1)
        
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(changeImage2))
        topView2.addGestureRecognizer(gesture2)
        
        let gesture3 = UITapGestureRecognizer(target: self, action: #selector(changeImage3))
        topView3.addGestureRecognizer(gesture3)
        
        let gesture4 = UITapGestureRecognizer(target: self, action: #selector(changeImage4))
        bottomView1.addGestureRecognizer(gesture4)
        
        let gesture5 = UITapGestureRecognizer(target: self, action: #selector(changeImage5))
        bottomView2.addGestureRecognizer(gesture5)
        
        let gesture6 = UITapGestureRecognizer(target: self, action: #selector(changeImage6))
        bottomView3.addGestureRecognizer(gesture6)
    }
    
    
    
    @objc func changeImage1(){
        img1.image = imgAvatar2.image
        lblUserName1.textColor = lblUserName2.textColor
    }
    
    @objc func changeImage2(){
        img1.image = imgAvatar3.image
        lblUserName1.textColor = lblUserName3.textColor
    }
    
    @objc func changeImage3(){
        img1.image = imgAvatar4.image
        lblUserName1.textColor = lblUserName4.textColor
    }
    
    @objc func changeImage4(){
        img1.image = imgAvatar5.image
        lblUserName1.textColor = lblUserName5.textColor
    }
    
    @objc func changeImage5(){
        img1.image = imgAvatar6.image
        lblUserName1.textColor = lblUserName6.textColor
    }
    
    @objc func changeImage6(){
        img1.image = imgAvatar7.image
        lblUserName1.textColor = lblUserName7.textColor
    }
    
    
    
    override func viewDidLayoutSubviews() {
        viewText.layer.cornerRadius = viewText.bounds.height/2
        btnSubmit.layer.cornerRadius = btnSubmit.bounds.height/2
        
    }
    
    
    @IBAction func onClickedSubmitButton(_ sender: UIButton) {
        if lblUserName1.text == ""{
            showAlert(alertMessage: "User Name  is Required!")
        }
        
        if tfName.text?.count != 0 && tfName.text != nil {
            UserDefaults.standard.set(tfName.text ?? "", forKey: kUserNAme)
            userViewModel.registerUser(userName: tfName.text ?? "") { [weak self] isSuccess in
                guard let self = self else {return}
                if isSuccess {
                    UserDefaults.standard.set("Register", forKey: "isUserRegister")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    vc.nameTextColor = self.lblUserName1.textColor
                    UserDefaults.standard.set(self.lblUserName1.textColor, forKey: "userTextColor")
                    vc.shortName = self.lblUserName1.text ?? ""
                    vc.avatarImage = self.img1.image
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    self.showAlert(alertMessage: "Something Went Wrong")
                }
            }
        }else {
            showAlert(alertMessage: "Name is Required!")
        }
        print("User Name : \(lblUserName1.text ?? "")")
    }
}

//MARK: - TextField Delegate

extension AvatarVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let str = upperCase(textField: textField.text ?? "")
        if str.count <= 2 {
            lblUserName1.text = str
            lblUserName2.text = str
            lblUserName3.text = str
            lblUserName4.text = str
            lblUserName5.text = str
            lblUserName6.text = str
            lblUserName7.text = str
            
            
        }else{
            
        } 
    }
}
