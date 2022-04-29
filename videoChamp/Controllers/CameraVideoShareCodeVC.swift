//
//  CameraVideoShareCodeVC.swift
//  videoChamp
//
//  Created by iOS Developer on 18/02/22.
//

import UIKit

class CameraVideoShareCodeVC: UIViewController {
    
    @IBOutlet weak var lblShareCode: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbl: UILabel!
    
    let cellID = "CameraCodeCell"
    let cellID2 = "CameraCodeCell2"
    let cellId3 = "CameraCodeCell3"
    
    let cameraViewModel = CameraConnectViewModel()

    var generatedNumber = ""
    
    let generateNumberVM = GenerateNumberViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cameraViewModel.getCemaraData()
        registerCell()
        loadData()
        
    }
    
    func loadData(){
        generateNumberVM.getGenerateNumber { isSuccess, number in
            if isSuccess {
                print("generated Number : \(number)")
                
                self.generatedNumber = number
                self.tableView.reloadData()
            }else{
                print("Error")
            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        lbl.font = UIFont(name: "ArgentumSans-Bold", size: 31.0)
        lbl.font = UIFont.systemFont(ofSize: 31.0, weight: .semibold)
        self.gradientColor(topColor: topyellowColor, bottomColor: bottomYellowColor)
        lblShareCode.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)
    }
    
    
    func registerCell(){
        tableView.register(UINib(nibName: cellID2, bundle: nil), forCellReuseIdentifier: cellID2)
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        tableView.register(UINib(nibName: cellId3, bundle: nil), forCellReuseIdentifier: cellId3)
    }
    
    
    
    
    @IBAction func onClickedBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickedCloseBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension CameraVideoShareCodeVC : UITableViewDelegate, UITableViewDataSource, CameraCodeDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return cameraViewModel.cameraDataSource.count
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
            cell.updateData(inData: cameraViewModel.cameraDataSource[indexPath.row])
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID2, for: indexPath) as! CameraCodeCell2
            cell.delegate = self
            cell.lblCode.text = generatedNumber
            cell.btnShare.tag = indexPath.row
            cell.btnResend.tag = indexPath.row
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId3, for: indexPath) as! CameraCodeCell3
//            cell.delegate = self
//            cell.btnShare.tag = indexPath.row
//            cell.btnResend.tag = indexPath.row
            return cell
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 60.0
        }else if indexPath.section == 1{
            return 150.0
        }else{
            return 165.0
        }
    }
    
    
    func resendCode(tag: Int) {
        print("resend Code : \(tag)")
        self.loadData()
    }
    
    func shareCode(tag: Int) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShareVC") as! ShareVC
        vc.headingText = "SHARE CODE"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    
}




