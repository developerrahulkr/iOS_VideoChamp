//
//  CameraVideoShareCodeVC.swift
//  videoChamp
//
//  Created by iOS Developer on 18/02/22.
//

import UIKit
import MFrameWork
import MultipeerConnectivity

class CameraVideoShareCodeVC: UIViewController {
    
    @IBOutlet weak var lblShareCode: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbl: UILabel!
    
    let cellID = "CameraCodeCell"
    let cellID2 = "CameraCodeCell2"
    let cellId3 = "CameraCodeCell3"
    
    let cameraViewModel = CameraConnectViewModel()
    private var mcSessionViewModel : MCSessionViewModel!
    var staticLink = "http://videochamp/remote/"
    var generatedUrlCode = ""
    var urlLink = ""
//    let generateNumberVM = GenerateNumberViewModel()
    
    let generateLinkVM = GeneratedLinkViewModel()
    var sessionManager: MCSessionManager!
    private let serviceType = "video-champ"
    private let displayName = UIDevice.current.name
    private let serviceProtocol:MCSessionManager.ServiceProtocol = .textAndVideo
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print("Display Name : \(Utility.shared.sessionManager.myPeerID?.description)")
        cameraViewModel.getCemaraData()
        registerCell()
        loadData()
    }
    
    
    
    func loadData(){
        mcSessionViewModel = MCSessionViewModel.init(mcSessionManger: Utility.shared.sessionManager)
        self.mcSessionViewModel.toogleAdvertising()
        
        
        
//        generateNumberVM.getGenerateNumber { [weak self] isSuccess, number in
//            guard let self = self else { return }
//            if isSuccess {
//                print("generated Number : \(number)")
//                self.generatedNumber = number
//
//                self.tableView.reloadData()
//            }else{
//                print("Error")
//            }
//        }
        
        
        generateLinkVM.linkGenerated(cmGenerateLinkData: CMGenerateLink(deviceType: "IOS",
                                                                        deviceId: Utility.shared.sessionManager.myPeerID?.displayName ?? "",
                                                                        isCamera: "true",
                                                                        peerId: Utility.shared.sessionManager.displayName,
                                                                        connectionState: "true")) {
            [weak self] isSuccess,linkURL,urlCode, codeMessage  in
            guard let self = self else {return}
            if isSuccess && codeMessage == "Number generate"{
//                self.generatedNumber = number
                print("Deeplinking URL : \(linkURL)")
                print("url Code : \(urlCode)")
                self.urlLink = linkURL
                self.generatedUrlCode = urlCode
                self.staticLink = "\(self.staticLink)\(urlCode)"
                self.tableView.reloadData()
                
            }else if codeMessage == "code is already generated" && isSuccess {
                print("Deeplinking URL : \(linkURL)")
                print("url Code : \(urlCode)")
                self.urlLink = linkURL
                self.generatedUrlCode = urlCode
                self.tableView.reloadData()
            }else if codeMessage == "code Expire" && isSuccess {
                self.expireCodeAlert(message: codeMessage)
            }else{
                print("Error")
            }
        }
        
        
        
        
    }
    
    

    
    
    override func viewDidLayoutSubviews() {
        lbl.font = UIFont(name: "ArgentumSans-Bold", size: 31.0)
        lbl.font = UIFont.systemFont(ofSize: 31.0, weight: .regular)
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
//        if section == 0 {
//            return cameraViewModel.cameraDataSource.count
//        }else{
//            return 1
//        }
        1
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }else{
            return 20
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CameraCodeCell
//            cell.updateData(inData: cameraViewModel.cameraDataSource[indexPath.row])
//            return cell
//        }else
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID2, for: indexPath) as! CameraCodeCell2
            cell.delegate = self
            cell.lblCode.text = staticLink
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
//        if indexPath.section == 0 {
//            return 150
//        }else
        if indexPath.section == 0{
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
        let url = urlLink.replacingOccurrences(of: " ", with: "_")
        let finalUrl = url.replacingOccurrences(of: "'", with: "_")
        guard let url = URL(string: finalUrl)
        else{
            return
        }
        let sharesheetVC = UIActivityViewController(activityItems: [sendingRemoteMessage,url], applicationActivities: nil)
        self.present(sharesheetVC, animated: true)
    }
    
    
    
    
    
}

//MARK: - ALert POPup

extension CameraVideoShareCodeVC  {
    func expireCodeAlert(message : String) {
        let alert = UIAlertController(title: appName, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let self = self else {
                return
            }
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}




