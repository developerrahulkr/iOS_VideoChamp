//
//  collectionView.swift
//  videoChamp
//
//  Created by Udit_Rajput_Mac on 03/10/22.
//

import UIKit

class collectionView: UIViewController {

    @IBOutlet weak var viewPotrait: UIView!
    @IBOutlet weak var viewLandscape: UIView!
    
    
    @IBOutlet weak var PotraitCollectionView: UICollectionView!
    @IBOutlet weak var LandscapeCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.orientation.isLandscape{
            viewLandscape.isHidden = false
            viewPotrait.isHidden = true
            PotraitCollectionView.isHidden = true
            LandscapeCollectionView.isHidden = false
            
        }else{
            viewLandscape.isHidden = true
            PotraitCollectionView.isHidden = false
            LandscapeCollectionView.isHidden = true
            viewPotrait.isHidden = false
        }
        
        PotraitCollectionView.delegate = self
        PotraitCollectionView.dataSource = self
        LandscapeCollectionView.delegate = self
        LandscapeCollectionView.dataSource = self
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                self.viewLandscape.isHidden = false
                self.viewPotrait.isHidden = true
                self.PotraitCollectionView.isHidden = true
                self.LandscapeCollectionView.isHidden = false
                self.LandscapeCollectionView.reloadData()
            })
            
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                self.viewLandscape.isHidden = true
                self.PotraitCollectionView.isHidden = false
                self.PotraitCollectionView.reloadData()
                self.LandscapeCollectionView.isHidden = true
                self.viewPotrait.isHidden = false
            })
            
           
            

        }
    }

    
    

}



extension collectionView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == PotraitCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell_Potrait", for: indexPath) as! Cell_Potrait
            //
            return cell
        }
        
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellLanscape", for: indexPath) as! CellLanscape
            //
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == PotraitCollectionView{
            print(self.PotraitCollectionView.bounds.size.width)
            print(self.PotraitCollectionView.bounds.size.height)
            return CGSize(width: self.PotraitCollectionView.bounds.size.width , height: self.PotraitCollectionView.bounds.size.height)

        }else{
            return CGSize(width: self.LandscapeCollectionView.frame.size.width , height: self.LandscapeCollectionView.frame.size.height)
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        pageController.currentPage = indexPath.item
//        print("current Index : \(indexPath.item)")
//    }

    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        for cell in collectionView.visibleCells {
//            let indexPath = collectionView.indexPath(for: cell)
//            pageController.currentPage = indexPath?.item ?? 0
//            print("Current Page : \(pageController.currentPage)")
//        }
//    }
  
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)
    {
//        let center = self.view.convert(self.collectionView.center, to: self.collectionView)
//        let index = collectionView!.indexPathForItem(at: center)
//        let indexx = index![1]
//        pageController?.currentPage = indexx
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
//        let center = self.view.convert(self.collectionView.center, to: self.collectionView)
//        let index = collectionView!.indexPathForItem(at: center)
//        let indexx = index![1]
//        pageController?.currentPage = indexx
//        if indexx == 2 {
//            doneBtn.isHidden = false
//            btnGetStarted.isHidden = true
//        }else {
//            btnGetStarted.isHidden = false
//            doneBtn.isHidden = true
//        }
    }
    
}
