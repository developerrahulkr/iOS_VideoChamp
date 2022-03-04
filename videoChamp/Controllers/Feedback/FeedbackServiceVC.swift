//
//  FeedbackServiceVC.swift
//  videoChamp
//
//  Created by iOS Developer on 22/02/22.
//

import UIKit

class FeedbackServiceVC: UIViewController {
    
    

    @IBOutlet weak var sendView: UIView!
    @IBOutlet weak var lblFeedbackTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgOpenCamera: UIImageView!
    
    var lblTitleText = ""
    let cellID = "FeedbackServiceCell"
    var feed_id = ""
    let FeedbackVM = FeedbackViewModel()
    let feedbackMessageVM = FeedbackMessageViewModel()
    
    @IBOutlet weak var onClickSendData: UIButton!
    @IBOutlet weak var tfSendData: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        lblFeedbackTitle.text = lblTitleText
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        print("feed Id ::: ::: ::: :::\(feed_id)")
        openCameraAndAttatchment()
        loadData()
        
    }
    
    
    func loadData() {
        self.FeedbackVM.getFeedbackServiceDataSource.removeAll()
        FeedbackVM.getFeedbackListData(feedId: feed_id) { isSuccess in
            if isSuccess {
                self.tableView.reloadData()
            }else{
                self.showAlert(alertMessage: "Something Went Wrong!")
            }
        }
    }
    
    
    func openCameraAndAttatchment(){
        let cameraGesture = UITapGestureRecognizer(target: self, action: #selector(openCamera))
        imgOpenCamera.addGestureRecognizer(cameraGesture)
        tableView.transform = CGAffineTransform(scaleX: 1, y: 1)
        
    }

    override func viewDidLayoutSubviews() {
        sendView.layer.cornerRadius = sendView.bounds.height/2
        gradientColor(topColor: lightWhite, bottomColor: lightgrey)
        lblFeedbackTitle.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)
    }
    
    @IBAction func onClickedBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func onClickedSendBtn(_ sender: UIButton) {
        feedbackMessageVM.feedbackMessage(message: tfSendData.text ?? "" , feedId: feed_id) { isSuccess in
            if isSuccess {
                self.loadData()
            }else{
                self.showAlert(alertMessage: "Something went wrong!")
            }
            
        }
        
        
        
    }
    
    
    @objc func openCamera(){
        validateForCameraAccessForPhotoVideo()
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
    
}

extension FeedbackServiceVC : UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FeedbackVM.getFeedbackServiceDataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! FeedbackServiceCell
        if FeedbackVM.getFeedbackServiceDataSource[indexPath.row].type == "incoming" {
            cell.updateData(inData: FeedbackVM.getFeedbackServiceDataSource[indexPath.row])
            cell.lblMsg.textColor = .white
            cell.cellView.layer.backgroundColor = UIColor(red: 253/255, green: 97/255, blue: 43/255, alpha: 1).cgColor
            cell.cellView.roundLeftChatCorner(cornerRadius: 16)
        }
        else{
            cell.cellView.layer.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
            cell.updateData(inData: FeedbackVM.getFeedbackServiceDataSource[indexPath.row])
            cell.lblMsg.textColor = .black
            cell.cellView.roundRightChatCorner(cornerRadius: 16)
        }
        
        return cell
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        print(image.size)
        picker.dismiss(animated: true, completion: nil)
    }
}




