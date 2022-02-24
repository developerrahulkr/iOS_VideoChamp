//
//  WelcomeVC.swift
//  videoChamp
//
//  Created by iOS Developer on 15/02/22.
//

import UIKit

class WelcomeVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var btnGetStarted: UIButton!
    
    let cellID = "WelcomeCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: cellID, bundle: nil), forCellWithReuseIdentifier: cellID)
        // Do any additional setup after loading the view.
        self.gradientColor(topColor: yellowColor, bottomColor: redColor)
    }
    
    
    

    override func viewDidLayoutSubviews() {
        btnGetStarted.layer.cornerRadius = btnGetStarted.bounds.height/2
    }
    
    
    @IBAction func onClickedGetStartted(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AvatarVC") as! AvatarVC
        self.navigationController?.pushViewController(vc, animated: true)
        
//        self.openCamera()
    }
    


}

// MARK: - Collection View
extension WelcomeVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! WelcomeCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 230)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for cell in collectionView.visibleCells {
            let indexPath = collectionView.indexPath(for: cell)
            pageController.currentPage = indexPath?.item ?? 0
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    
}
