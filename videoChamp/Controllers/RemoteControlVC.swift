//
//  RemoteControlVC.swift
//  videoChamp
//
//  Created by iOS Developer on 18/02/22.
//

import UIKit

class RemoteControlVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblEnterCode: UILabel!
    
    let cameraViewModel = CameraConnectViewModel()
    
    let cellID = "CameraCodeCell"
    let cellID2 = "CodeVerifyCell"
    let cellId3 = "CameraCodeCell3"
    var otpString : String = ""
    
    let codeGenerateVM = GenerateNumberViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.gradientColor(topColor: lightGreenColor, bottomColor: lightYellow)
        cameraViewModel.getRemoteData()
        registerCell()
        lblEnterCode.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)
    }
    
    func registerCell(){
        tableView.register(UINib(nibName: cellID2, bundle: nil), forCellReuseIdentifier: cellID2)
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        tableView.register(UINib(nibName: cellId3, bundle: nil), forCellReuseIdentifier: cellId3)
    }

    @IBAction func onClickedBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func OnClickedCloaseBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - TableView  Delegate, Datasource and Verification Code Delegate
extension RemoteControlVC : UITableViewDataSource, UITableViewDelegate, VerifyCodeDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return cameraViewModel.remoteDataSource.count
        }else{
            return 1
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CameraCodeCell
            cell.updateData(inData: cameraViewModel.remoteDataSource[indexPath.row])
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID2, for: indexPath) as! CodeVerifyCell
            cell.delegate = self
            cell.callBack =
            { codeData in
                if self.otpString.count >= 4 {
                    self.otpString = ""
                }
                self.otpString = self.otpString + codeData
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId3, for: indexPath) as! CameraCodeCell3
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 60.0
        }else if indexPath.section == 1{
            return 205.0
        }else{
            return 165.0
        }
    }
    func verifyCode(tag: Int) {
        print("Varification Code : \(otpString)")
        if otpString.isEmpty {
            self.showAlert(alertMessage: "Please fill the Code")
        }else{
            self.CodeVerifyApi(number: otpString)
        }
        
    }
    
    
    
    func CodeVerifyApi(number : String){
        codeGenerateVM.verifyNumber(number: number) { [weak self] isSuccess in
            
            guard let self = self else{return}
            if isSuccess {
//                self.showAlert(alertMessage: "OTP Verified!")
                self.navigationController?.popViewController(animated: true)
            }else{
                self.showAlert(alertMessage: "\(self.otpString) is Not Correct")
            }
        }
    }
}
