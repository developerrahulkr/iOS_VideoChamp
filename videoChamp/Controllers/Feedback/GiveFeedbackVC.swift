//
//  GiveFeedbackVC.swift
//  videoChamp
//
//  Created by iOS Developer on 22/02/22.
//

import UIKit

class GiveFeedbackVC: UIViewController {

    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var tableView: UITableView!
    let cellID = "GiveFeedbackCell"
    let cellID2 = "GiveFeedbackCell2"
    let cellID3 = "GiveFeedbackCell3"
    let giveFeedbackViewModel = FeedbackViewModel()
    
    
    var headerArr = [[String : String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        gradientColor(topColor: lightWhite, bottomColor: lightgrey)
        
        headerArr.append(["Title" : ""])
        headerArr.append(["Enter your email Id (Optional)" :""])
        headerArr.append(["Please do share your feedback" : "0/1000"])
        headerArr.append(["Attach Screenshots (Optional)" : ""])
        
        giveFeedbackViewModel.getSection()
        registerCell()
    }
    
    
    func registerCell(){
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        tableView.register(UINib(nibName: cellID2, bundle: nil), forCellReuseIdentifier: cellID2)
        tableView.register(UINib(nibName: cellID3, bundle: nil), forCellReuseIdentifier: cellID3)
    }
    
    
    
    
    override func viewDidLayoutSubviews() {
        btnSubmit.layer.cornerRadius = btnSubmit.bounds.height / 2
    }
    
    @IBAction func onClickedBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onClickedSubmitBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension GiveFeedbackVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return giveFeedbackViewModel.giveFeedbackSection.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = Bundle.main.loadNibNamed("FeedbackSectionCell", owner: self, options: nil)?.first as! FeedbackSectionCell
        header.lblTitle1.text = giveFeedbackViewModel.giveFeedbackSection[section].secTitle
        header.lblTitle2.text = giveFeedbackViewModel.giveFeedbackSection[section].secTitle2

        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! GiveFeedbackCell
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! GiveFeedbackCell
            cell.tfTitle.placeholder = "Anisha21diosteq@gmail.com"
            return cell
        }else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID2, for: indexPath) as! GiveFeedbackCell2
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID3, for: indexPath) as! GiveFeedbackCell3
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return 130
        }else if indexPath.section == 3 {
            return 120
        }else{
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
