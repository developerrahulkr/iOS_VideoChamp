//
//  RemoteControlVC.swift
//  videoChamp
//
//  Created by iOS Developer on 18/02/22.
//

import UIKit

class RemoteControlVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let cameraViewModel = CameraConnectViewModel()
    
    let cellID = "CameraCodeCell"
    let cellID2 = "CameraCodeCell2"
    let cellId3 = "CameraCodeCell3"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.gradientColor(topColor: lightGreenColor, bottomColor: lightYellow)
        cameraViewModel.getRemoteData()
        registerCell()
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
    }
    
}



extension RemoteControlVC : UITableViewDataSource, UITableViewDelegate, CameraCodeDelegate {
    
    
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
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID2, for: indexPath) as! CameraCodeCell2
            cell.delegate = self
            cell.btnShare.tag = indexPath.row
            cell.btnResend.isHidden = true
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId3, for: indexPath) as! CameraCodeCell3
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80.0
        }else if indexPath.section == 1{
            return 160.0
        }else{
            return 180.0
        }
    }
    
    
    func resendCode(tag: Int) {
        print("resend Code : \(tag)")
    }
    
    func shareCode(tag: Int) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShareVC") as! ShareVC
        vc.headingText = "SHARE CODE"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
