//
//  WelcomeVC.swift
//  videoChamp
//
//  Created by iOS Developer on 15/02/22.
//

import UIKit
import GradientView


class WelcomeVC: UIViewController {
    
    @IBOutlet weak var viewPortrait: UIView!
    @IBOutlet weak var viewLand: UIView!
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet var viewMain: GradientView!
    @IBOutlet weak var collectionViewPortrait: UICollectionView!
    @IBOutlet weak var collectionViewLandScape: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var btnGetStarted: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    
    
    
    var type  = 0
    let cellID = "WelcomeCell"
    var imgArray = ["1","5","3"] as [Any]
    var imgArray1 = ["1","2","4"] as [Any]
    let titleArr1 = ["To start, decide which device you want to be the Camera vs. the Monitor & Remote.",
                     "Next, send an invitation to connect devices.",
                     "To use VideoChamp, you must connect devices that have the same type of operating system."]
    let titleArr2 = ["","Once the invitation is accepted you are ready to get started!",""]
    var IndexCheck = Bool()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            viewLand.isHidden = true
            collectionViewLandScape.delegate = self
            collectionViewLandScape.dataSource = self
            if UIScreen.main.bounds.width > UIScreen.main.bounds.height{
                IndexCheck = true
                self.viewLand.isHidden = false
                self.viewPortrait.isHidden = true
                self.collectionViewPortrait.isHidden = true
                self.collectionViewLandScape.isHidden = false
            }
            else
            {
                IndexCheck = false
                self.viewLand.isHidden = true
                self.viewPortrait.isHidden = false
                self.collectionViewPortrait.isHidden = false
                self.collectionViewLandScape.isHidden = true
                
            }
            
        }
        
        doneBtn.isHidden = true
        skipBtn.layer.borderWidth = 1
        skipBtn.layer.cornerRadius = skipBtn.layer.bounds.height/2
        skipBtn.layer.borderColor = UIColor.white.cgColor
        //collectionViewPortrait.register(UINib(nibName: cellID, bundle: nil), forCellWithReuseIdentifier: cellID)
        collectionViewPortrait.delegate = self
        collectionViewPortrait.dataSource = self
        //collectionViewLandScape.register(UINib(nibName: "CellLanscape", bundle: nil), forCellWithReuseIdentifier: "CellLanscape")
        pageController.currentPage = 0
        pageController.numberOfPages = titleArr1.count
    }
    
  

    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.userInterfaceIdiom == .pad{
            
            if UIDevice.current.orientation.isLandscape{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    self.IndexCheck = true
                    self.viewLand.isHidden = false
                    self.viewPortrait.isHidden = true
                    self.collectionViewPortrait.isHidden = true
                    self.collectionViewLandScape.isHidden = false
                    //                let rect = self.collectionViewLandScape.layoutAttributesForItem(at: IndexPath(row: self.IndexCheck, section: 0))?.frame
                    //                            self.imgcollview.scrollRectToVisible(rect!, animated: false)
                    self.collectionViewLandScape.reloadData()
                    
                })
                
            }else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.viewLand.isHidden = true
                    self.IndexCheck = false

                    self.viewPortrait.isHidden = false
                    self.collectionViewPortrait.isHidden = false
                    self.collectionViewLandScape.isHidden = true
                    self.collectionViewPortrait.reloadData()
                })
                
                
                
                
            }
        }
    
        
    }

    
    override func viewDidLayoutSubviews() {
        viewMain.colors = [UIColor.init(hexString: "#FF9200"),UIColor(hexString: "#FF3100")]
        btnGetStarted.layer.cornerRadius = btnGetStarted.bounds.height/2
        doneBtn.layer.cornerRadius = doneBtn.bounds.height/2
        btnGetStarted.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
        btnGetStarted.applyGradientForInsta(colorOne: .init(hexString: "#C8D400"), ColorTwo: .init(hexString: "#93C01F"), ColorThree: .init(hexString: "#35A936"))
        doneBtn.applyGradientForInsta(colorOne: .init(hexString: "#C8D400"), ColorTwo: .init(hexString: "#93C01F"), ColorThree: .init(hexString: "#35A936"))
        pageController.currentPageIndicatorTintColor = .yellow
    }
    
    
    @IBAction func btnSkip(_ sender: UIButton) {
        if type == 1{
            self.navigationController?.popViewController(animated: false)
        }else{
            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AvatarVC") as! AvatarVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
      
    }
    
    @IBAction func doneBtn(_ sender: Any) {
        if type == 1{
            self.navigationController?.popViewController(animated: false)
        }
        else{
            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AvatarVC") as! AvatarVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @IBAction func onClickedGetStartted(_ sender: UIButton) {
        if IndexCheck == false || UIDevice.current.orientation.isPortrait {
            let collectionBounds = self.collectionViewPortrait.bounds
            let contentOffset = CGFloat(floor(self.collectionViewPortrait.contentOffset.x + collectionBounds.size.width))
            
            let row = collectionViewPortrait.indexPathsForVisibleItems.first
            if row?.row == imgArray.count - 2 {
                self.moveCollectionToFrame(contentOffset: contentOffset)
                doneBtn.isHidden = false
                btnGetStarted.isHidden = true
                print("gdfghjjkljh")
            }
            else {
                self.moveCollectionToFrame(contentOffset: contentOffset)
            }
        }
        else{
            
            if UIDevice.current.userInterfaceIdiom == .pad && IndexCheck == true
            {
                let collectionBounds = self.collectionViewLandScape.bounds
                let contentOffset = CGFloat(floor(self.collectionViewLandScape.contentOffset.x + collectionBounds.size.width))
                
                let row = collectionViewLandScape.indexPathsForVisibleItems.first
                if row?.row == imgArray1.count - 2 {
                    self.moveCollectionToFrameLandscape(contentOffset: contentOffset)
                    doneBtn.isHidden = false
                    btnGetStarted.isHidden = true
                    print("gdfghjjkljh")
                }
                else {
                    self.moveCollectionToFrameLandscape(contentOffset: contentOffset)
                }
            }
        }

    }
    
    func moveCollectionToFrameLandscape(contentOffset : CGFloat) {
        let frame: CGRect = CGRect(x : contentOffset ,y : self.collectionViewLandScape.contentOffset.y ,width : self.collectionViewLandScape.frame.width,height : self.collectionViewLandScape.frame.height)
        self.collectionViewLandScape.scrollRectToVisible(frame, animated: true)
    }
    func moveCollectionToFrame(contentOffset : CGFloat) {
        let frame: CGRect = CGRect(x : contentOffset ,y : self.collectionViewPortrait.contentOffset.y ,width : self.collectionViewPortrait.frame.width,height : self.collectionViewPortrait.frame.height)
        self.collectionViewPortrait.scrollRectToVisible(frame, animated: true)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isPortrait {
            AppUtility.lockOrientation(.portrait)
        }else{
            AppUtility.lockOrientation(.landscape)
        }
    }
}

// MARK: - Collection View
extension WelcomeVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleArr1.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewPortrait{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WelcomeCell", for: indexPath) as! WelcomeCell
            cell.lbl1TutorialPage.text = titleArr1[indexPath.row]
            
            if titleArr2[indexPath.row] == "" {
                cell.lbl3ToUse.isHidden = true
            }else{
                cell.lbl3ToUse.isHidden = false
            }
            
            cell.lbl3ToUse.text = titleArr2[indexPath.row]
            cell.imgView.image = UIImage(named:imgArray[indexPath.row] as! String )
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellLanscape", for: indexPath) as! CellLanscape
            if indexPath.row == 2{
                cell.lbl2.isHidden = true
                cell.lbl1.isHidden = true
                cell.lblTop.text = titleArr1[indexPath.row]
            }else{
                cell.lbl2.isHidden = false
                cell.lbl1.isHidden = false
                cell.lblTop.isHidden = true
                cell.lbl1.text = titleArr1[indexPath.row]
            }
            cell.imgView.image = UIImage(named:imgArray1[indexPath.row] as! String)
            if titleArr2[indexPath.row] == "" {
                cell.lbl2.isHidden = true
            }else{
                
                cell.lbl2.text = titleArr2[indexPath.row]
                cell.lbl2.isHidden = false
            }
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
        
        if collectionView == collectionViewPortrait{
            return CGSize(width: self.collectionViewPortrait.frame.size.width , height: self.collectionViewPortrait.frame.size.height)
        }
        else{
            return CGSize(width: self.collectionViewLandScape.frame.size.width , height: self.collectionViewLandScape.frame.size.height)

        }
    }
        
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageController.currentPage = indexPath.item
        print("current Index : \(indexPath.item)")
    }

    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        for cell in collectionView.visibleCells {
//            let indexPath = collectionView.indexPath(for: cell)
//            pageController.currentPage = indexPath?.item ?? 0
//            print("Current Page : \(pageController.currentPage)")
//        }
//    }
  
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)
    {
        if  IndexCheck == false || UIDevice.current.orientation.isPortrait
        {
            let center = self.view.convert(self.collectionViewPortrait.center, to: self.collectionViewPortrait)
            let index = collectionViewPortrait!.indexPathForItem(at: center)
            let indexx = index![1]
            pageController?.currentPage = indexx
        }
        else
        {
            if UIDevice.current.userInterfaceIdiom == .pad && IndexCheck == true
            {
                let center = self.view.convert(self.collectionViewLandScape.center, to: self.collectionViewLandScape)
                let index = collectionViewLandScape!.indexPathForItem(at: center)
                let indexx = index![1]
                pageController?.currentPage = indexx
            }
        }

    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        if IndexCheck == false || UIDevice.current.orientation.isPortrait {
            
        let center = self.view.convert(self.collectionViewPortrait.center, to: self.collectionViewPortrait)
        let index = collectionViewPortrait!.indexPathForItem(at: center)
        let indexx = index![1]
        pageController?.currentPage = indexx
        if indexx == 2 {
                doneBtn.isHidden = false
                btnGetStarted.isHidden = true
                    }else {
                        btnGetStarted.isHidden = false
                        doneBtn.isHidden = true
                    }
        }
        else
        {
            if UIDevice.current.userInterfaceIdiom == .pad && IndexCheck == true
            {
                let center = self.view.convert(self.collectionViewLandScape.center, to: self.collectionViewLandScape)
                let index = collectionViewLandScape!.indexPathForItem(at: center)
                let indexx = index![1]
                pageController?.currentPage = indexx
                if indexx == 2 {
                    doneBtn.isHidden = false
                    btnGetStarted.isHidden = true
                }
                else {
                    btnGetStarted.isHidden = false
                    doneBtn.isHidden = true
                }
            }
        }
    }
    
}
