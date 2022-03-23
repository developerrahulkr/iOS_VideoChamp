//
//  SideMenuVC.swift
//  videoChamp
//
//  Created by iOS Developer on 16/02/22.
//

import UIKit

class SideMenuVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    let menuViewModel = MenuViewModels()
    let cellID = "MenuCell"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        
        menuViewModel.getData()
    }

    @IBAction func onClickedDismissBtn(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
}




extension SideMenuVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuViewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MenuCell
        cell.updateData(inData: menuViewModel.dataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.dismiss(animated: false) {
                NotificationCenter.default.post(name: .kNotification, object: nil)
            }
        }
        
        if indexPath.row == 1 {
            self.dismiss(animated: false) {
                NotificationCenter.default.post(name: .kFeedback, object: nil)
            }
        }
        
        if indexPath.row == 2 {
            self.dismiss(animated: false) {
                NotificationCenter.default.post(name: .kTermsAndConditions, object: nil)
            }
        }
        
        if indexPath.row == 3 {
            self.dismiss(animated: false) {
                NotificationCenter.default.post(name: .kShare, object: nil)
            }
        }
    }
}
