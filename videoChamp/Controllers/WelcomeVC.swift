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
    let titleArr1 = ["Tutorial Page","Tutorial Page","Tutorial Page"]
    let titleArr2 = ["HOW","HOW","HOW"]
    let titleArr3 = ["TO USE","TO USE","TO USE"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: cellID, bundle: nil), forCellWithReuseIdentifier: cellID)
        // Do any additional setup after loading the view.
        self.gradientColor(topColor: yellowColor, bottomColor: redColor)
        pageController.currentPage = 0
        pageController.numberOfPages = titleArr1.count
    }

    override func viewDidLayoutSubviews() {
        btnGetStarted.layer.cornerRadius = btnGetStarted.bounds.height/2
        pageController.currentPageIndicatorTintColor = .yellow
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
        return titleArr1.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! WelcomeCell
        cell.lbl1TutorialPage.text = titleArr1[indexPath.row]
        cell.lbl2How.text = titleArr2[indexPath.row]
        cell.lbl3ToUse.text = titleArr3[indexPath.row]
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
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        pageController.currentPage = indexPath.item
//        print("current Index : \(indexPath.item)")
//    }

    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in collectionView.visibleCells {
            let indexPath = collectionView.indexPath(for: cell)
            pageController.currentPage = indexPath?.item ?? 0
            print("Current Page : \(pageController.currentPage)")
        }
    }
  
    
}
