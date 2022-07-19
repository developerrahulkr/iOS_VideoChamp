//
//  ViewController.swift
//  MultiPeerLiveKitDemo
//
//  Created by hayaoMac on 2019/03/11.
//  Copyright © 2019年 Takashi Miyazaki. All rights reserved.
//

import UIKit
import MultipeerConnectivity
//import MultipeerLiveKit
import MultipeerFramework
import AVFoundation

final class LiveViewController: UIViewController {
    //models
    private var mcSessionManager: MCSessionManager!
    private var liveView: LiveView!
    private var liveViewModel: LiveViewModel!
    //
    private var sessionSetupSucceeds = false
    private var targetPeerID: MCPeerID!
    private var margin: CGFloat = 5
    private let sendInterval:TimeInterval = 0.1
    private let videoCompressionQuality:CGFloat = 0.1
    private let sessionPreset:AVCaptureSession.Preset = .low
    private var activeCamera: AVCaptureDevice?
    

    private func setUpLiveViewPresenter() {
        
        liveView = LiveView()
        self.view = liveView.setUpViews(frame: UIScreen.main.bounds, margin: margin)
    }
    private func setUpChatViewModel() {
        do {
            liveViewModel = try .init(targetPeerID: targetPeerID,
                                      mcSessionManager: mcSessionManager,
                                      sendVideoInterval:sendInterval,
                                      videoCompressionQuality: videoCompressionQuality,
                                      sessionPreset: sessionPreset)
            liveViewModel.updatePeerID(targetPeerID)
            liveViewModel.attachViews(liveView: liveView)
        } catch let error {
            print(error)
        }
        
    }


    private func setNavBar() {
        guard let navBar = navigationController?.navigationBar else {
            return
        }

        navBar.isTranslucent = false
        title = "\(targetPeerID.displayName)"

    }

    override func loadView() {
        setNavBar()
        setUpLiveViewPresenter()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpChatViewModel()
        NotificationCenter.default.addObserver(self, selector: #selector(closeVC), name: .kPopToRoot, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(closeVC), name: .kCloseScreen, object: nil)
        
    }
    
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isPortrait {
            AppUtility.lockOrientation(.portrait)
        }else{
            AppUtility.lockOrientation(.landscape)
        }
    }
    @objc func closeVC(){
        let controllers = self.navigationController!.viewControllers
        for controller in controllers {
            if controller is HomeVC {
                self.navigationController?.popToViewController(controller, animated: true)
            }else{
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        
    }
    

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(mcSessionManager: MCSessionManager, targetPeerID: MCPeerID!) {
        super.init(nibName: nil, bundle: nil)
        self.targetPeerID = targetPeerID
        self.mcSessionManager = mcSessionManager
    }

    deinit {
        //print("deinit:LiveVC")
        NotificationCenter.default.removeObserver(self, name: .kCloseScreen, object: nil)
        NotificationCenter.default.removeObserver(self, name: .kPopToRoot, object: nil)
    }
    

}
