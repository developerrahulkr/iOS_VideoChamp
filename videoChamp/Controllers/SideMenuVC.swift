//
//  SideMenuVC.swift
//  videoChamp
//
//  Created by iOS Developer on 16/02/22.
//

import UIKit

class SideMenuVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    let menuViewModel = MenuViewModels()
    let cellID = "MenuCell"
    
    var indexPath1 : IndexPath?
    var callback:(()->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        DispatchQueue.main.async {
           
        }
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        
        menuViewModel.getData()
    }
    
    override func viewDidLayoutSubviews() {
        self.imageView.applyGradient1(colorOne: .init(hexString: "#9C9B9B"), ColorTwo: .init(hexString: "#C6C6C5"))
    }
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isPortrait {
            AppUtility.lockOrientation(.portrait)
        }else{
            AppUtility.lockOrientation(.landscape)
        }
    }

    @IBAction func onClickedDismissBtn(_ sender: UIButton) {
        self.callback?()
        dismiss(animated: false, completion: nil)
    }
}





extension SideMenuVC : UITableViewDelegate, UITableViewDataSource{
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuViewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MenuCell
        cell.updateData(inData: menuViewModel.dataSource[indexPath.row])
        indexPath1 = indexPath
        cell.selectionStyle = .none
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
                NotificationCenter.default.post(name: .kWelcome, object: nil)
            }
        }
        
        if indexPath.row == 3 {
            self.dismiss(animated: false) {
                NotificationCenter.default.post(name: .kTermsAndConditions, object: nil)
            }
        }
        
        if indexPath.row ==  4{
            self.dismiss(animated: false) {
                NotificationCenter.default.post(name: .kPrivacyPolicy, object: nil)
            }
        }
        
        if indexPath.row == 5 {
            self.dismiss(animated: false) {
                NotificationCenter.default.post(name: .kShare, object: nil)
            }
        }
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if AppUtility.lockOrientation(.all) == AppUtility.lockOrientation(.portrait) {
            self.tableView.reloadData()
        }else if AppUtility.lockOrientation(.all) == AppUtility.lockOrientation(.landscape) {
            self.tableView.reloadData()
        }
    }
    
    
    

}
