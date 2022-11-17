//
//  GiveFeedbackVC.swift
//  videoChamp
//
//  Created by iOS Developer on 22/02/22.
//

import UIKit
import GradientView

class GiveFeedbackVC: UIViewController {

    @IBOutlet weak var lblGiveFeedback: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewMain: GradientView!
    @IBOutlet weak var viewTop: UIView!
    
    
    let cellID = "GiveFeedbackCell"
    let cellID2 = "GiveFeedbackCell2"
    let cellID3 = "GiveFeedbackCell3"
    let cellID1 = "GiveFeedbackCell1"
    let cellID4 = "GiveFeedbackCell4"
    let giveFeedbackViewModel = FeedbackViewModel()
    var isFirst = false
    var feedbackTitle = ""
    var email = ""
    var desc = ""
    var wordLimit = 100
    var selectImage : UIImage?
    var rightImage : UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        giveFeedbackViewModel.getSection()
        registerCell()
        self.gradientColor(topColor: lightWhite, bottomColor: lightgrey)
        selectImage = UIImage(named: "image_upload_icon")
        rightImage = UIImage(named: "image_upload_icon")
        lblGiveFeedback.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)
    }
    
    
    func registerCell(){
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        tableView.register(UINib(nibName: cellID1, bundle: nil), forCellReuseIdentifier: cellID1)
        tableView.register(UINib(nibName: cellID2, bundle: nil), forCellReuseIdentifier: cellID2)
        tableView.register(UINib(nibName: cellID3, bundle: nil), forCellReuseIdentifier: cellID3)
        tableView.register(UINib(nibName: cellID4, bundle: nil), forCellReuseIdentifier: cellID4)
    }
    
    
    
    
    override func viewDidLayoutSubviews() {
        viewTop.applyGradient1(colorOne: .init(hexString: "#F9B200"), ColorTwo: .init(hexString: "#E63B11"))
        viewMain.colors = [UIColor.init(hexString: "#9C9B9B"),UIColor(hexString: "#C6C6C5")]
        btnSubmit.layer.cornerRadius = btnSubmit.bounds.height / 2
    }
    
    @IBAction func onClickedBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension GiveFeedbackVC : UITableViewDelegate, UITableViewDataSource, FeedbackDataDelegate, openPhotoLibraryDelegate {
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return giveFeedbackViewModel.giveFeedbackSection.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = Bundle.main.loadNibNamed("FeedbackSectionCell", owner: self, options: nil)?.first as! FeedbackSectionCell
        
        if section == 2 {
            header.lblTitle1.isHidden = true
            header.lblTitle2.isHidden = true
        }else{
            header.lblTitle1.text = giveFeedbackViewModel.giveFeedbackSection[section].secTitle
            header.lblTitle2.text = giveFeedbackViewModel.giveFeedbackSection[section].secTitle2
        }

        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 {
            return 0.0
        }else {
            return 35.0
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0  || indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID1, for: indexPath) as! GiveFeedbackCell1
            
            cell.tfTitle.placeholder = (indexPath.section == 0) ? "Enter Subject" : "Enter Email"
            cell.bottomConstraints.constant = (indexPath.section == 0) ? 10.0 : 10.0
            cell.callBack = {
                val in
                if indexPath.section == 0{
                    cell.tfTitle.text = val
                    print("Title : \(val)")
                    self.feedbackTitle = val
                }
                else{
                    cell.tfTitle.text = val
                    print("email : \(val)")
                    self.email = val
                }
            }
            return cell
        }else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID2, for: indexPath) as! GiveFeedbackCell2
            
            cell.callBack  = {
                data in
                self.desc = data
                print("desc \(self.desc)")
            }
            
            cell.callBackUpdateCounting = { data in
                
                cell.lblCount.text = "\(data.count+1)/100"
            }
            return cell
            
        }else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID3, for: indexPath) as! GiveFeedbackCell3
            cell.delegate = self
            cell.callBackForleftImg = {
                self.isFirst = true
               
            }
            cell.callBackForRightImg = {
                self.isFirst = false
            }
            if isFirst{
                cell.imgLeft.image = self.selectImage
            
            }
            else{
                cell.imgRight.image = rightImage
            }
            cell.imgLeftView.tag = indexPath.row
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID4, for: indexPath) as! GiveFeedbackCell4
            cell.btnSubmit.tag = indexPath.row
            cell.delegate = self
            return cell
        }
        
    }
    
    func openLibrary2() {
        validateForCameraAccessForPhotoVideo()
    }
    
    func openLibrary() {
        validateForCameraAccessForPhotoVideo()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return 180.0
        }else if indexPath.section == 3 {
            return 120.0
        }else if indexPath.section == 4 {
            return 85.0
        }else if indexPath.section == 0{
            return 70.0
        }else{
            return 70.0
        }
    }
    
    private func validateForCameraAccessForPhotoVideo(){
        CameraUtilities.shared.checkCamraPermission { isGranted in
            guard isGranted else {
                return
            }
            
            guard UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) else {
                self.showAlert(alertMessage: "Camera is not build in this Device! ")
                return
            }
            
            DispatchQueue.main.async {
                let imagePickerVC = UIImagePickerController()
                imagePickerVC.sourceType = .photoLibrary
                imagePickerVC.delegate = self
                imagePickerVC.allowsEditing = true
                self.present(imagePickerVC, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if AppUtility.lockOrientation(.all) == AppUtility.lockOrientation(.portrait) {
            self.tableView.reloadData()
        }else if AppUtility.lockOrientation(.all) == AppUtility.lockOrientation(.landscape) {
            self.tableView.reloadData()
        }
    }
    
    
    func submitData(tag: Int) {
        if isValidEmail(testStr: email) {
            let cmFeedbackData = CMPostFeedbackData(title: feedbackTitle, desc: desc, email: email, image: [""])
            giveFeedbackViewModel.uploadFeedbackData(imageData: [selectImage?.pngData(), rightImage?.pngData()], feedBackData: cmFeedbackData) { isCompleted, blockCode  in
                if isCompleted {
                    NotificationCenter.default.post(name: .refreshFeedbackData, object: nil)
                    UIApplication.topViewController()?.showActivityIndicator()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        UIApplication.topViewController()?.hideActivityIndicator()
                        self.navigationController?.popViewController(animated: true)
                    }
                }else if isCompleted && blockCode == "10" {
                    self.showExitAlert()
                }else{
                    if self.feedbackTitle == "" {
                        self.showAlert(alertMessage: "Please Enter the title!")
                    }else if self.desc == "" {
                        self.showAlert(alertMessage: "Please Enter the description!")
                    }else if self.email == ""{
                        self.showAlert(alertMessage: "Please Enter the email!")
                    }else {
                        self.showAlert(alertMessage: "Something Went Wrong")
                    }
                }
            }
        }else {
            self.showAlert(alertMessage: "email is not Valid")
        }
        
    }
    
    func closeLeftImage(tag: Int) {
        self.selectImage = UIImage(named: "image_upload_icon")
        tableView.reloadData()
    }
    
    func closeRightImage(tag: Int) {
        self.rightImage = UIImage(named: "image_upload_icon")
    }
}


extension GiveFeedbackVC : UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        print(image.size)
        if isFirst {
            self.selectImage = image
        }
        else{
            self.rightImage = image
        }
        picker.dismiss(animated: true, completion: nil)
        self.tableView.reloadData()
    }
}

