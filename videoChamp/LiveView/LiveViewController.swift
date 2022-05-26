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
import MFrameWork
import AVFoundation

final class LiveViewController: UIViewController {
    //models
    private var mcSessionManager: MCSessionManager!
    private var liveView: LiveView!
    private var liveViewModel: LiveViewModel!
    //
    private var targetPeerID: MCPeerID!
    private var margin: CGFloat = 5
    private let sendInterval:TimeInterval = 0.1
    private let videoCompressionQuality:CGFloat = 0.8
    private let sessionPreset:AVCaptureSession.Preset = .medium
    
    
//    Capture Session
    var session : AVCaptureSession?
//    Photo Output
    let output = AVCapturePhotoOutput()
//    Video PReview
    let previewLayer = AVCaptureVideoPreviewLayer()
    

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
        liveView.imageView.layer.addSublayer(previewLayer)
        session = liveViewModel.capSession
//        liveView.imageCapture.layer.addSublayer(previewLayer)
        checkCameraPermission()
    }
    override func viewDidLayoutSubviews() {
        previewLayer.frame = liveView.imageView.bounds
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
    }
    
    
    
    private func checkCameraPermission(){
        switch AVCaptureDevice.authorizationStatus(for: .video){
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else{
                    return
                }
                DispatchQueue.main.async {
                    self?.setupCamera()
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setupCamera()
        @unknown default:
            break
        }
    }
    
    private func setupCamera(){
        if let device = AVCaptureDevice.default(for: .video) {
            do {
               let input = try AVCaptureDeviceInput(device: device)
                if session!.canAddInput(input) {
                    session!.addInput(input)
                }
                if session!.canAddOutput(output){
                    session!.addOutput(output)
                }
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                
//                session!.startRunning()
//                self.session = session
                
            }catch {
                print(error)
            }
        }
    }
}
