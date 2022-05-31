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
    private var sessionSetupSucceeds = false
    private var targetPeerID: MCPeerID!
    private var margin: CGFloat = 5
    private let sendInterval:TimeInterval = 0.1
    private let videoCompressionQuality:CGFloat = 0.8
    private let sessionPreset:AVCaptureSession.Preset = .medium
    private var activeCamera: AVCaptureDevice?
    var zoomScaleRange: ClosedRange<CGFloat> = 1...10
    private let sessionQueue = DispatchQueue(label: "Session Queue")
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
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        liveView.imageView.addGestureRecognizer(pinch)
        liveView.imageView.layer.addSublayer(previewLayer)
        session = liveViewModel.capSession
//        liveView.imageCapture.layer.addSublayer(previewLayer)
        checkCameraPermission()
    }
    
    private var initialScale: CGFloat = 0
    @objc
    private func handlePinch(_ pinch: UIPinchGestureRecognizer) {
        guard sessionSetupSucceeds,  let device = activeCamera else { return }

        switch pinch.state {
        case .began:
            initialScale = device.videoZoomFactor
        case .changed:
            let minAvailableZoomScale = device.minAvailableVideoZoomFactor
            let maxAvailableZoomScale = device.maxAvailableVideoZoomFactor
            let availableZoomScaleRange = minAvailableZoomScale...maxAvailableZoomScale
            let resolvedZoomScaleRange = zoomScaleRange.clamped(to: availableZoomScaleRange)

            print("Pinch Data : \(pinch.scale)")
            let resolvedScale = max(resolvedZoomScaleRange.lowerBound, min(pinch.scale * initialScale, resolvedZoomScaleRange.upperBound))

            configCamera(device) { device in
                device.videoZoomFactor = resolvedScale
            }
        default:
            return
        }
    }
    
    private func configCamera(_ camera: AVCaptureDevice?, _ config: @escaping (AVCaptureDevice) -> ()) {
        guard let device = camera else { return }

        sessionQueue.async { [device] in
            do {
                try device.lockForConfiguration()
            } catch {
                return
            }

            config(device)

            device.unlockForConfiguration()
        }
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
                sessionSetupSucceeds = true
                
//                session!.startRunning()
//                self.session = session
                
            }catch {
                print(error)
            }
        }
    }
}
