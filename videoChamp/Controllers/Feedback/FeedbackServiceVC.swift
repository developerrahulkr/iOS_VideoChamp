//
//  FeedbackServiceVC.swift
//  videoChamp
//
//  Created by iOS Developer on 22/02/22.
//

import UIKit
import Alamofire
import SDWebImage

class FeedbackServiceVC: UIViewController {
    
    

    @IBOutlet weak var sendView: UIView!
    @IBOutlet weak var lblFeedbackTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgOpenCamera: UIImageView!
    @IBOutlet weak var imgAttatchmentIcon: UIImageView!
    let refreshControl = UIRefreshControl()
    var lblTitleText = ""
    let cellID = "FeedbackServiceCell"
    let cellID2 = "FeedbackMsgImageCell"
    var feed_id = ""
    let FeedbackVM = FeedbackViewModel()
    let feedbackMessageVM = FeedbackMessageViewModel()
    @IBOutlet weak var onClickSendData: UIButton!
    @IBOutlet weak var tfSendData: UITextField!
    var selectImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        lblFeedbackTitle.text = lblTitleText
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        tableView.register(UINib(nibName: cellID2, bundle: nil), forCellReuseIdentifier: cellID2)
        openCameraAndAttatchment()
        loadData()
        print("\(feed_id)")
        
        refreshControl.attributedTitle = NSAttributedString(string: "refresh Data")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
    }
    
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
//        loadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.FeedbackVM.getFeedbackServiceDataSource.removeAll()
//            self.tableView.reloadData()
            self.loadData()
            self.refreshControl.endRefreshing()
        }
        
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
        let attatchmentGesture = UITapGestureRecognizer(target: self, action: #selector(openGallery))
        imgOpenCamera.addGestureRecognizer(cameraGesture)
        imgAttatchmentIcon.addGestureRecognizer(attatchmentGesture)
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
        
        if tfSendData.text == "" {
            self.showAlert(alertMessage: "Please Send the Message!")
        }else{
            let CMMessageData = CMFeedbackMessageData(feedbackId: feed_id, image: "", message: tfSendData.text ?? "")
            
            feedbackMessageVM.feedbackMessageData(imageData: selectImage?.pngData(), messageData: CMMessageData) { isCompleted in
                if isCompleted {
                    self.tfSendData.text = ""
                    self.loadData()
                }else{
                    self.showAlert(alertMessage: "Something went wrong!")
                }
            }
        }
 
    }
    
    
    @objc func openCamera(){
        validateForCameraAccess()
    }
    @objc func openGallery(){
        validateForGalleryAccess()
    }

    private func validateForCameraAccess(){
        CameraUtilities.shared.checkCamraPermission { isGranted in
            guard isGranted else {
                return
            }
            
            guard UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) else {
                self.showAlert(alertMessage: "Camera is not build in this Device! ")
                return
            }
            
            DispatchQueue.main.async {
                let imagePickerVC = UIImagePickerController()
                imagePickerVC.sourceType = .camera
                imagePickerVC.delegate = self
                imagePickerVC.allowsEditing = true
                self.present(imagePickerVC, animated: true)
            }
        }
    }
    
    private func validateForGalleryAccess(){
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


//MARK: - UITableView Delegate and UIImagePickerView

extension FeedbackServiceVC : UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FeedbackVM.getFeedbackServiceDataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! FeedbackServiceCell
        let cell2 = tableView.dequeueReusableCell(withIdentifier:cellID2 , for: indexPath) as! FeedbackMsgImageCell
//        if indexPath.row == 0{
//            cell.lblMsg.text = FeedbackVM.getFeedbackDescriptionDataSource[indexPath.row].desc
//            cell.lblTime.text = Utility.shared.timeFormatConvertor(string: FeedbackVM.getFeedbackDescriptionDataSource[0].createdAt!)
//            cell.lblMsg.textColor = .white
//            cell.cellView.layer.backgroundColor = UIColor(red: 253/255, green: 97/255, blue: 43/255, alpha: 1).cgColor
//            cell.cellView.roundLeftChatCorner(cornerRadius: 16)
//        }else
        if FeedbackVM.getFeedbackServiceDataSource[indexPath.row].type == "incoming" && FeedbackVM.getFeedbackServiceDataSource[indexPath.row].message == "" {
            
            cell2.updateData(inData: FeedbackVM.getFeedbackServiceDataSource[indexPath.row])
            print("feedback Image : \(FeedbackVM.getFeedbackServiceDataSource[indexPath.row].image!)")
            cell2.cardView.layer.backgroundColor = UIColor(red: 253/255, green: 97/255, blue: 43/255, alpha: 1).cgColor
            cell2.cardView.roundLeftChatCorner(cornerRadius: 16)
            return cell2
        }else if FeedbackVM.getFeedbackServiceDataSource[indexPath.row].type == "outgoing" && FeedbackVM.getFeedbackServiceDataSource[indexPath.row].message == "" {
            cell2.updateData(inData: FeedbackVM.getFeedbackServiceDataSource[indexPath.row])
            print("feedback Image : \(FeedbackVM.getFeedbackServiceDataSource[indexPath.row].image!)")
            cell2.cardView.layer.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
            cell2.cardView.roundRightChatCorner(cornerRadius: 16)
        }else{
            if FeedbackVM.getFeedbackServiceDataSource[indexPath.row].type == "incoming" && FeedbackVM.getFeedbackServiceDataSource[indexPath.row].message != nil{
                cell.updateData(inData: FeedbackVM.getFeedbackServiceDataSource[indexPath.row])
                cell.lblMsg.textColor = .white
                cell.cellView.layer.backgroundColor = UIColor(red: 253/255, green: 97/255, blue: 43/255, alpha: 1).cgColor
                cell.cellView.roundLeftChatCorner(cornerRadius: 16)
            }else{
                cell.cellView.layer.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
                cell.updateData(inData: FeedbackVM.getFeedbackServiceDataSource[indexPath.row])
                cell.lblMsg.textColor = .black
                cell.cellView.roundRightChatCorner(cornerRadius: 16)
            }
        }
        return cell
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
//        self.selectedImage = image
    
        self.selectImage = image
        let CMMessageData = CMFeedbackMessageData(feedbackId: feed_id, image: "", message: "")
        
        feedbackMessageVM.feedbackMessageData(imageData: selectImage?.pngData(), messageData: CMMessageData) { isCompleted in
            if isCompleted {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.FeedbackVM.getFeedbackServiceDataSource.removeAll()
                    self.loadData()
                    self.dismiss(animated: true)
                }
                
            }else{
                self.showAlert(alertMessage: "Something went wrong!")
            }
        }
 
    }
}






