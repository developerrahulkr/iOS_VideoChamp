//
//  AvatarVC.swift
//  videoChamp
//
//  Created by iOS Developer on 16/02/22.
//

import UIKit

class AvatarVC: UIViewController {

    @IBOutlet var viewTableView: UIView!
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
    
    var gradient = CAGradientLayer()
    var isSelected = false
    let userViewModel = UserViewModel()
    var isUpdateProfile = false
    var userName = ""
    var shortName = ""
    var avatarKey = 0
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tfName.delegate = self
        if isUpdateProfile {
            tfName.isUserInteractionEnabled = false
            btnSubmit.setTitle("UPDATE", for: .normal)
            tfName.text = userName
            lblUserName1.text = shortName
            lblUserName2.text = shortName
            lblUserName3.text = shortName
            lblUserName4.text = shortName
            lblUserName5.text = shortName
            lblUserName6.text = shortName
            lblUserName7.text = shortName
            viewText.backgroundColor = .lightGray
            
        }else{
            tfName.isUserInteractionEnabled = true
            viewText.backgroundColor = .white
            tfName.text = ""
        }
        changeAvatar()
        
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
        avatarKey = 1
        isSelected = true
    }
    
    @objc func changeImage2(){
        img1.image = imgAvatar3.image
        lblUserName1.textColor = lblUserName3.textColor
        avatarKey = 2
        isSelected = true
    }
    
    @objc func changeImage3(){
        img1.image = imgAvatar4.image
        lblUserName1.textColor = lblUserName4.textColor
        avatarKey = 3
        isSelected = true
    }
    
    @objc func changeImage4(){
        img1.image = imgAvatar5.image
        lblUserName1.textColor = lblUserName5.textColor
        avatarKey = 4
        isSelected = true
    }
    
    
    @objc func changeImage5(){
        img1.image = imgAvatar6.image
        lblUserName1.textColor = lblUserName6.textColor
        avatarKey = 5
        isSelected = true
    }
    
    @objc func changeImage6(){
        img1.image = imgAvatar7.image
        lblUserName1.textColor = lblUserName7.textColor
        avatarKey = 6
        isSelected = true
    }
    
    override func viewDidLayoutSubviews() {
        viewText.layer.cornerRadius = viewText.bounds.height/2
        btnSubmit.layer.cornerRadius = btnSubmit.bounds.height/2
        btnSubmit.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
        tfName.attributedPlaceholder = NSAttributedString(string: "Enter your name", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        gradient.frame = view.frame
        gradient.colors = [lightWhite, lightgrey]
        view.layer.insertSublayer(gradient, at: 0)


    }
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isPortrait {
            AppUtility.lockOrientation(.portrait)
        }else{
            AppUtility.lockOrientation(.landscape)
        }
    }
    
    @available(iOS, deprecated: 9.0)
    @IBAction func onClickedSubmitButton(_ sender: UIButton) {
        
        if !isUpdateProfile {
            if lblUserName1.text == "" {
                showAlert(alertMessage: "User Name  is Required!")
            }else if !isSelected {
                self.showAlert(alertMessage: "Please Choose Avatar!")
            }else if tfName.text?.count != 0 && tfName.text != nil {
                var color = UIColor()
                var avatarImage = UIImage()
                color = self.lblUserName1.textColor
                
                let colorToSetAsDefault : UIColor = self.lblUserName1.textColor
                let data : Data = NSKeyedArchiver.archivedData(withRootObject: colorToSetAsDefault) as Data
                UserDefaults.standard.set(data, forKey: "UserSelectedColor")
                UserDefaults.standard.synchronize()
                print("SET DEFAULT USER COLOR TO RED")
                
                avatarImage = self.img1.image!
                UserDefaults.standard.setImage(image: avatarImage, forKey: "avatarImage")
                UserDefaults.standard.set(tfName.text ?? "", forKey: kUserNAme)
                UserDefaults.standard.set("\(String(describing: color))", forKey: "userTextColor")
    //            UserDefaults.standard.set("\(String(describing: avatarImage))", forKey: "avatarImage")
                UserDefaults.standard.set("\(self.lblUserName1.text ?? "")", forKey: "userText")
    //            self.view.backgroundColor =
                let deviceToken = UserDefaults.standard.string(forKey: "deviceToken")
                
                userViewModel.registerUser(userName: tfName.text ?? "", avatarType: "\(avatarKey)", deviceToken: deviceToken!) { [weak self] isSuccess,error_msg  in
                    guard let self = self else {return}
                    if isSuccess && error_msg == "Success"{
                        print("device Token : \(deviceToken ?? "")")
                        UserDefaults.standard.set("Register", forKey: "isUserRegister")
                        UserDefaults.standard.set(self.lblUserName1.textColor, forKey: "userTextColor")
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                        vc.shortName = self.lblUserName1.text ?? ""
                        vc.avatarImage = self.img1.image
                        
                        if let navBar = UIApplication.getNavController() {
                            navBar.pushViewController(vc, animated: true)
                        }
                        
                    }else if isSuccess && error_msg == "User name already exit"{
                        self.showAlert(alertMessage: error_msg)
                    }else{
                        self.showAlert(alertMessage: error_msg)
                    }
                }
            }else {
                showAlert(alertMessage: "Name is Required!")
            }
            print("User Name : \(lblUserName1.text ?? "")")
        }else{
            
            userViewModel.updateAvatar(updateAvatar: avatarKey) { [weak self] isSuccess, Code in
                guard let self = self else{ return }
                if isSuccess {
                    var avatarImage = UIImage()
//                    self.showAlert(alertMessage: "Avatar Change Successfully...")
                    avatarImage = self.img1.image!
                    UserDefaults.standard.setImage(image: avatarImage, forKey: "avatarImage")
                    var color = UIColor()
                    let colorToSetAsDefault : UIColor = self.lblUserName1.textColor
                    let data : Data = NSKeyedArchiver.archivedData(withRootObject: colorToSetAsDefault) as Data
                    UserDefaults.standard.set(data, forKey: "UserSelectedColor")
                    UserDefaults.standard.synchronize()
                    self.dismiss(animated: true)
                }else if isSuccess && Code == "10"{
                    self.showExitAlert()
                }else{
                    print("something went Wrong..... ")
                }
            }
            
        }
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



extension AvatarVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return viewTableView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 896.0 - 150
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if AppUtility.lockOrientation(.all) == AppUtility.lockOrientation(.portrait) {
            self.tableView.reloadData()
        }else if AppUtility.lockOrientation(.all) == AppUtility.lockOrientation(.landscape) {
            self.tableView.reloadData()
        }
    }
    
    
    
}


