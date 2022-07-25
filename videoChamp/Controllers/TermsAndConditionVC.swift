//
//  TermsAndConditionVC.swift
//  videoChamp
//
//  Created by iOS Developer on 16/02/22.
//

import UIKit

class TermsAndConditionVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTermAndCondition: UILabel!
    
    let cellID = "TermsAndConditionsCell"
    
    let termVM = GenerateNumberViewModel()
    var termsAndConditions = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        tableView.delegate = self
        tableView.dataSource = self
        self.gradientColor(topColor: lightWhite, bottomColor: lightgrey)
        
        lblTermAndCondition.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)
        loadData()
    }
    
    func loadData(){
        termVM.termAndConditionsData { [weak self] isSuccess, termData,blockCode  in
            guard let self = self else {return}
            if isSuccess && blockCode == "10" {
                self.showExitAlert()
            }else{
                if isSuccess {
                    self.termsAndConditions = termData
                    self.tableView.reloadData()
                    
                }else{
                    self.showAlert(alertMessage: "Data is Empty!")
                }
            }
            
        }
    }
    
    
    @IBAction func onClickedBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension TermsAndConditionVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! TermsAndConditionsCell
        cell.lblTermsAndCondition.text = termsAndConditions
        return cell
    }
}
