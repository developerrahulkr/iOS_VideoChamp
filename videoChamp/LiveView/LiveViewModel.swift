//
//  ViewModel.swift
//  MultiPeerLiveKitDemo
//
//  Created by hayaoMac on 2019/03/11.
//  Copyright © 2019年 Takashi Miyazaki. All rights reserved.
//

import MultipeerConnectivity
//import MultipeerLiveKit

import MultipeerFramework
import AVFoundation
import GSImageViewerController
import Photos




enum _CaptureState {
        case idle, start, capturing, end
    }

public class LiveViewModel: NSObject, AVCaptureFileOutputRecordingDelegate  {
    //
    private var mcSessionManager: MCSessionManager!
    var livePresenter: LivePresenter!
    
    //
    private var targetPeerID: MCPeerID?
    private var sendString = "SaveImage"
    private var sendImage = UIImage()
    private var zooomImageString = ""
    private let sessionQueue = DispatchQueue(label: "com.hayao.MultipeerLiveKit.videodata-ouput-queue")
    private lazy var photoOutput = AVCapturePhotoOutput()
    
    
   
    private var liveSetupView : LiveView!

    private var zoom = 1.0
    private var zoomText = 1
    public var capSession : AVCaptureSession?
    //    Photo Output
    let output = AVCapturePhotoOutput()
    private var needsMute = false
    private let onColor: UIColor = .red
    private let offColor: UIColor = .black
    private let cameraFrontLabel = "front"
    private let cameraBackLabel = "back"
    private let sendTextButtonTitle = "send text"
    private var sessionSetupSucceeds = false
    private var videoOrientation: AVCaptureVideoOrientation = .portrait
    private var captureProcessors: [Int64: PhotoCaptureProcessor] = [:]
    
    private var activeCamera: AVCaptureDevice?
    var zoomScaleRange: ClosedRange<CGFloat> = 1...10
    var isDisconnect : Bool = false
    
    var _captureState : _CaptureState = .idle
//    MARK: - VideoOutPut
    
    var captureSession = AVCaptureSession()
    var sessionOutput = AVCaptureStillImageOutput()
    var movieOutput = AVCaptureMovieFileOutput()
    var previewLayer = AVCaptureVideoPreviewLayer()
    private (set) var resultBuffer: CMSampleBuffer!
    
    private var _filename = ""
    private var _time: String = ""
    private var _captureSession: AVCaptureSession?
    private var _videoOutput: AVCaptureVideoDataOutput?
    private var _assetWriter: AVAssetWriter?
    private var _assetWriterInput: AVAssetWriterInput?
    private var _adpater: AVAssetWriterInputPixelBufferAdaptor?
    
    
    
    
    
    private enum ButtonType {
        case sound
        case sendVideo
    }

    
    
    typealias ButtonDisplayData = (title: String, color: UIColor)

    private lazy var soundBtnData: [Bool: ButtonDisplayData]    = [true: ("Sound ON", onColor), false: ("...", offColor)]
    private lazy var publishBtnData: [Bool: ButtonDisplayData]  = [true: ("stop_video_recording_icon", onColor), false: ("stop_video_recording_icon", offColor)]


    
    init(targetPeerID: MCPeerID?, mcSessionManager: MCSessionManager,
         sendVideoInterval:TimeInterval,videoCompressionQuality:CGFloat,
         sessionPreset:AVCaptureSession.Preset = .medium) throws {
        
        self.targetPeerID = targetPeerID
        print("target Peer ID is  : \(self.targetPeerID)")
        super.init()
        self.mcSessionManager = mcSessionManager
        try livePresenter = LivePresenter.init(mcSessionManager: mcSessionManager,
                                               sendVideoInterval: sendVideoInterval,
                                               videoCompressionQuality:videoCompressionQuality,
                                               targetPeerID: targetPeerID,
                                               sessionPreset: sessionPreset)
        
        
        
    }

    
    func updatePeerID(_ peerID: MCPeerID) {
        livePresenter.updateTargetPeerID(peerID)
    }
    
    

    func attachViews(liveView: LiveView) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(closeViewC), name: .kCloseScreen, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(disconnectVC), name: .kDisconnect, object: nil)
        
        if (videochampManager.videochamp_sharedManager.redirectType == .camera)
        {
            self.connectAlertVC()
            capSession = livePresenter.cap
            livePresenter.needsVideoRun.toggle()
            
            do {
                
                sendString = "startStreaming"
                
                try livePresenter.sendText(text: sendString, sendMode: .unreliable)
            }catch {
                print(error.localizedDescription)
            }
            
            
        }
        attachButtonActions(liveView)
        attachDisplayData(liveView)
        
//        let data = publishBtnData[livePresenter.needsVideoRun]!
//        capSession = livePresenter.cap
//

        UIDevice.current.isBatteryMonitoringEnabled = true
        let batterPercentage = UIDevice.current.batteryLevel * 100
        
        if batterPercentage <= 20 {
            do {
                try livePresenter.sendText(text: "low", sendMode: .unreliable)
            } catch let error {
                print(error)
            }
        }else{
            print("asdf asdfasd fasd fas dfasdf asdfas dfasdfasdf  \(batterPercentage)")
        }
        
        self.livePresenter.bindReceivedCallbacks(gotImage: {[liveView] (image, fromPeerID) in
//            self.capSession = nil
            liveView.imageView.layer.sublayers = nil
            DispatchQueue.main.async {
                liveView.imageView.image = image
            }
        }, gotAudioData: {[weak self](audioData, fromPeerID) in
            guard let weakSelf = self else {return}
            if weakSelf.needsMute == false {
                do {
                    try weakSelf.livePresenter.playSound(audioData: audioData)
                } catch let error {
                    print(error)
                }
            }
        }, gotTextMessage: {[liveView](msg, fromPeerID) in
            
            DispatchQueue.main.async {
//                let image = UIImage(data: msg)
                let str = String.init(data: msg, encoding: .utf8)
                
                switch str {
                case "zoomIn" :
                    self.sendString = str ?? ""
//                    liveView.imageView.contentMode = .scaleAspectFill
                    liveView.lblZoom.text = "\(self.zoomText)x"
                    self.zoomInSession()
                case "ZoomOut" :
//                    liveView.imageView.contentMode = .scaleAspectFit
                    self.sendString = str ?? ""
                    if self.zoomText > 0 {
                        liveView.lblZoom.text = "\(self.zoomText)x"
                        self.zoomOutSession()
                    }
                   
                case "low":
                    self.sendString = str ?? ""
                    let vc = AlertCameraVC(nibName: "AlertCameraVC", bundle: nil)
                    vc.modalPresentationStyle = .overFullScreen
                    vc.btnColor = UIColor(red: 147/255, green: 192/255, blue: 31/255, alpha: 1)
                    self.isDisconnect = false
                    vc.image = UIImage(named: "battery_icon")!
                    vc.titleText = "BATTERY ALERT"
                    vc.messageText = "Remote Device Battery is low"
                    UIApplication.topViewController()?.present(vc, animated: true)
                case "close" :
                    self.sendString = str ?? ""
                    let vc = DisconnectCameraVC(nibName: "DisconnectCameraVC", bundle: nil)
                    vc.modalPresentationStyle = .overFullScreen
                    UIApplication.topViewController()?.present(vc, animated: true)
                case "camera" :
                    self.sendString = str ?? ""
                    print("send String is : \(self.sendString)")
                    liveView.lblRecording.textColor = .white
                    liveView.lblRecording.text = "CAPTURE"
                    if videochampManager.videochamp_sharedManager.redirectType == .camera {
                        UIApplication.topViewController()?.showToast(message: "Photo Captured!", font: .systemFont(ofSize: 16.0))
                    }
                    liveView.btnCamera.setImage(UIImage(named: "camera_icon_yellow"), for: .normal)
                    liveView.btnVideo.setImage(UIImage(named: "record_video_icon_white"), for: .normal)
                    liveView.cameraControlButton.setImage(UIImage(named: "stop_video_recording_icon"), for: .normal)
                    liveView.cameraControlButton.isUserInteractionEnabled = true
                case "startStreaming":
                    self.sendString = str ?? ""
                    liveView.cameraControlButton.setImage(UIImage(named: "stop_video_recording_icon"), for: .normal)
                    if videochampManager.videochamp_sharedManager.redirectType == .camera {
                        self.connectAlertVC()
                    }else {
                        self.connectAlertVC()
                    }
                case "video":
//                    self.saveImageAlertVC()
//                    liveView.cameraControlButton.isUserInteractionEnabled = false
                    self.sendString = str ?? ""
                    
                    liveView.btnCamera.setImage(UIImage(named: "camera_change_icon"), for: .normal)
                    liveView.btnVideo.setImage(UIImage(named: "video_recording_icon"), for: .normal)
                    
                    liveView.cameraControlButton.setImage(UIImage(named: "stop_video_recording_icon"), for: .normal)
//                    liveView.lblRecording.textColor = .red
                    liveView.lblRecording.text = "CAPTURE"
//                    liveView.cameraControlButton.setImage(UIImage(named: "stop_video_recording_icon"), for: .normal)
                    
                case "stopRecording":
                    self.sendString = str ?? ""
                    if videochampManager.videochamp_sharedManager.redirectType == .camera {
                        
                        UIApplication.topViewController()?.showToast(message: "Video Captured!", font: .systemFont(ofSize: 16.0))
                        liveView.lblRecording.textColor = .white
                        liveView.lblRecording.text = "CAPTURE"
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopRecording"), object: nil)
                    }else{
                        liveView.lblRecording.textColor = .white
                        liveView.lblRecording.text = "CAPTURE"
                        self.saveImageAlertVC()
                    }
                    liveView.cameraControlButton.setImage(UIImage(named: "stop_video_recording_icon"), for: .normal)
                case "popToRoot":
                    
                    self.dismissAlertVC()
//                    NotificationCenter.default.post(name: .kPopToRoot, object: nil)
                    
                case "startRecording":
                    self.sendString = str ?? ""
//                    liveView.cameraControlButton.isUserInteractionEnabled = false
                    if videochampManager.videochamp_sharedManager.redirectType == .camera {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startRecording"), object: nil)
                    }
                    liveView.btnCamera.setImage(UIImage(named: "camera_change_icon"), for: .normal)
                    liveView.btnVideo.setImage(UIImage(named: "video_recording_icon"), for: .normal)
                    liveView.cameraControlButton.setImage(UIImage(named: "start_video_recording_icon"), for: .normal)
                    liveView.lblRecording.textColor = .red
                    liveView.lblRecording.text = "RECORDING"
                    
                case "captureImage" :
                    self.sendString = str ?? ""
                    if videochampManager.videochamp_sharedManager.redirectType == .camera {
                        UIApplication.topViewController()?.showToast(message: "Image Captured!", font: .systemFont(ofSize: 16.0))
                        self.takePhoto()

                    }else{
                        self.saveImageAlertVC()
                        let image = UIImage(data: msg)
                        print("Image is : \(image ?? UIImage())")

                    }
                default :
                    break
//                    UIImageWriteToSavedPhotosAlbum(image ?? UIImage(), nil, nil, nil)
                    
                }
            }
        })
        
        checkCameraPermission()
    }
    
//    MARK: - Save Image Alert VC
    func saveImageAlertVC(){
        let vc = AlertCameraVC(nibName: "AlertCameraVC", bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        vc.btnColor = UIColor(red: 147/255, green: 192/255, blue: 31/255, alpha: 1)
        vc.image = UIImage(named: "save_Image_icon")!
        vc.titleText = "MEDIA SAVED"
        isDisconnect = false
        vc.messageText = "Files have been saved in your camera device gallery"
        UIApplication.topViewController()?.present(vc, animated: true)
    }
    
    func connectAlertVC(){
        let vc = AlertCameraVC(nibName: "AlertCameraVC", bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        vc.btnColor = UIColor(red: 147/255, green: 192/255, blue: 31/255, alpha: 1)
        vc.image = UIImage(named: "success_icon")!
        vc.titleText = "CONECTION SUCCESSFUL"
        isDisconnect = false
        vc.messageText = "Established with Remote"
        UIApplication.topViewController()?.present(vc, animated: true)
    }
    
    func dismissAlertVC(){
        let vc = AlertCameraVC(nibName: "AlertCameraVC", bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        vc.btnColor = UIColor(red: 256/255, green: 9/255, blue: 19/255, alpha: 1)
        vc.image = UIImage(named: "alert_icon")!
        vc.titleText = "CONECTION FAILED"
        vc.messageText = "Code entered is incorrect"
        vc.btnOkText = "HELP?"
        isDisconnect = true
        UIApplication.topViewController()?.present(vc, animated: true)
    }
    
    @objc func closeViewC(){
        do {
            try livePresenter.sendText(text: "popToRoot", sendMode: .unreliable)
        }catch let error {
            print(error)
        }
    }
    
    @objc func disconnectVC(){
        if isDisconnect {
            NotificationCenter.default.post(name: .kPopToRoot, object: nil)
        }else{
            print("Disconnect : \(isDisconnect)")
        }
        
    }

    private func attachButtonActions(_ liveView: LiveView) {
        liveView.soundControlButton.addTarget(self, action: #selector(toggleSouondMuteState(_:)), for: .touchUpInside)
        liveView.changeCameraButton.addTarget(self, action: #selector(cameraToggle(_:)), for: .touchUpInside)
        liveView.cameraControlButton.addTarget(self, action: #selector(toggleSendVideoData(_:)), for: .touchUpInside)
        liveView.textSendButton.addTarget(self, action: #selector(zoomInImage(_:)), for: .touchUpInside)
        liveView.sendTextField.addTarget(self, action: #selector(onchangedTextField(_:)), for: .editingChanged)
        liveView.btnBack.addTarget(self, action: #selector(backVC(_:)), for: .touchUpInside)
        liveView.btnClose.addTarget(self, action: #selector(closeVC(_:)), for: .touchUpInside)
        liveView.btnCamera.addTarget(self, action: #selector(captureFrames(_:)), for: .touchUpInside)
        liveView.btnVideo.addTarget(self, action: #selector(startRecording(_:)), for: .touchUpInside)

    }
    
    @objc func startRecording(_ sender : UIButton){
        do {
            sender.setImage(UIImage(named: "video_recording_icon"), for: .normal)
            sendString = "startRecording"
//            liveSetupView.lblRecording.textColor = .red
            liveSetupView.lblRecording.text = "Capture"
            liveSetupView.cameraControlButton.setImage(UIImage(named: "stop_video_recording_icon"), for: .normal)
            liveSetupView.btnCamera.setImage(UIImage(named: "camera_change_icon"), for: .normal)
            sendString = "video"
            liveSetupView.cameraControlButton.isUserInteractionEnabled = true
            try livePresenter.sendText(text: sendString, sendMode: .unreliable)
        }catch let error {
            print(error)
        }
        
    }
    
    @objc func captureFrames(_ sender: UIButton){
//        liveSetupView.imageCapture.image = liveSetupView.imageView.image
        
//        savePic()
        do {
//            sendImage = liveSetupView.imageView.image ?? UIImage()
            sender.setImage(UIImage(named: "camera_icon_yellow"), for: .normal)
            liveSetupView.btnVideo.setImage(UIImage(named: "record_video_icon_white"), for: .normal)
            liveSetupView.cameraControlButton.setImage(UIImage(named: "stop_video_recording_icon"), for: .normal)
            liveSetupView.lblRecordingTiming.isHidden = true
            liveSetupView.lblRecording.textColor = .white
            liveSetupView.lblRecording.text = "CAPTURE"
            sendString = "camera"
            try livePresenter.sendText(text: sendString, sendMode: .unreliable)
            
        } catch let error {
            print(error)
        }
        
    }
    
    func savePic(){
        print("original Image : \(liveSetupView.imageView.image)")
         liveSetupView.imageCapture.image = liveSetupView.imageView.image
//        let image = UIImage(data: liveSetupView.imageView.image)
        UIImageWriteToSavedPhotosAlbum(liveSetupView.imageCapture.image ?? UIImage(), nil, nil, nil)
    }
    
    
    @objc func backVC(_ sender: UIButton) {
        disConectCameraVC()
    }
    @objc func closeVC(_ sender: UIButton){
       disConectCameraVC()
    }
    
    
    func disConectCameraVC (){
        let vc = DisconnectCameraVC(nibName: "DisconnectCameraVC", bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        UIApplication.topViewController()?.present(vc, animated: true)
    }

    private func attachDisplayData(_ liveView: LiveView) {

        liveSetupView = liveView
        capSession = livePresenter.cap
        let publishBtndata = setUpButtonLabel(buttonType: .sendVideo)
        let soundBtnData = setUpButtonLabel(buttonType: .sound)
        // title
//        liveView.cameraControlButton.setTitle(publishBtndata.title, for: .normal)
        liveView.cameraControlButton.setImage(UIImage(named: publishBtndata.title), for: .normal)
//        liveView.changeCameraButton.setTitle(setUpCameraPositionLabel(), for: .normal)
        liveView.changeCameraButton.setImage(UIImage(named: "zoom_icon"), for: .normal)
        liveView.soundControlButton.setTitle(soundBtnData.title, for: .normal)
        liveView.textSendButton.setImage(UIImage(named: "zoom_in_icon"), for: .normal)
//        liveView.sendTextField.placeholder = "text"
        liveView.lblFilmingDevice.text = "FILMING DEVICE"
        liveView.lblRecording.text = "Capture"
        liveView.lblRecordingTiming.isHidden = true
        liveView.lblRecordingTiming.text = "00:00:00"
        
        liveView.btnVideo.setImage(UIImage(named: "video_recording_icon"), for: .normal)
        liveView.btnCamera.setImage(UIImage(named: "camera_change_icon"), for: .normal)
        liveView.lblZoom.text = "1x"
        liveView.lblZoom.textAlignment = .center
        //colors
        liveView.imageCapture.isHidden = true
        liveView.imageView.backgroundColor = .black
        liveView.receivedTextLabel.backgroundColor = .white
        liveView.soundControlButton.backgroundColor = soundBtnData.color
        liveView.soundControlButton.isHidden = true
        liveView.sendTextField.backgroundColor = .white
        liveView.sendTextField.isHidden = true
        liveView.textSendButton.setTitleColor(onColor, for: .highlighted)
        liveView.imageView.isUserInteractionEnabled = false
        // others
        liveView.imageView.contentMode = .scaleAspectFill
        liveView.receivedTextLabel.adjustsFontSizeToFitWidth = true
        liveView.soundControlButton.layer.opacity = 0.5
        liveView.textSendButton.titleLabel?.adjustsFontSizeToFitWidth = true
    
        
        
    }
    
    
    private func checkCameraPermission(){
        switch AVCaptureDevice.authorizationStatus(for: .video){
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else{
                    return
                }
                self?.sessionQueue.async { [unowned self] in
                    self?.configureSession()
                }
//                DispatchQueue.main.async {
//                    self?.setupCamera()
//                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            sessionQueue.async { [unowned self] in
                self.configureSession()
            }
            
        @unknown default:
            break
        }
    }
    
    private func configureSession() {
        capSession?.beginConfiguration()
        capSession?.sessionPreset = .photo
        
        setupCamera()
        self.photoOutput.isHighResolutionCaptureEnabled = true
        guard ((self.capSession?.canAddOutput(self.photoOutput)) != nil) else {
            return
        }
        self.capSession?.addOutput(self.photoOutput)
        self.capSession?.commitConfiguration()
        sessionSetupSucceeds = true
    }
    
    private func setupCamera(){
        if (videochampManager.videochamp_sharedManager.redirectType  == .camera)
        {
        if let device = AVCaptureDevice.default(for: .video) {
            
            do {
               let input = try AVCaptureDeviceInput(device: device)
                if capSession!.canAddInput(input) {
                    capSession!.addInput(input)
                }
//                if capSession!.canAddOutput(output){
//                    capSession!.addOutput(output)
//                }
                liveSetupView.previewLayer.videoGravity = .resizeAspectFill
                liveSetupView.previewLayer.session = capSession
//                sessionSetupSucceeds = true
                
                activeCamera = device
//                session!.startRunning()
//                self.session = session
                
//                livePresenter.needsVideoRun.toggle()

            }catch {
                print(error)
            }
        }
        }
    }
    
    @objc private func cameraToggle(_ sender: UIButton) {
//        #if !targetEnvironment(simulator)
//
//        do {
//            try livePresenter.toggleCamera()
//        } catch let error {
//            print(error)
//        }
////        let title = setUpCameraPositionLabel()
////        sender.setTitle(title, for: .normal)
//
//        #endif
        #if !targetEnvironment(simulator)
        do {
//            liveSetupView.imageView.contentMode = .scaleAspectFill
            zooomImageString = "zoomIn"
            
            zoomInSession()
            try livePresenter.sendText(text: zooomImageString, sendMode: .unreliable)
        } catch let error {
            print(error)
        }
        #endif
    }
    
    
    func zoomInSession(){
        if (zoom <= 4.0){
            zoom += 0.5
            zoomText += 1
            if zoomText > 0 {
                liveSetupView.lblZoom.text = "\(zoomText)x"
            }
            guard sessionSetupSucceeds,  let device = activeCamera else { return }
            let minAvailableZoomScale = device.minAvailableVideoZoomFactor
            let maxAvailableZoomScale = device.maxAvailableVideoZoomFactor
            let availableZoomScaleRange = minAvailableZoomScale...maxAvailableZoomScale
            let resolvedZoomScaleRange = zoomScaleRange.clamped(to: availableZoomScaleRange)
            let resolvedScale = max(resolvedZoomScaleRange.lowerBound, min(1.34 * zoom, resolvedZoomScaleRange.upperBound))
            configCamera(device) { device in
                device.videoZoomFactor = resolvedScale
            }
        }else{
            UIApplication.topViewController()?.showToast(message: "You have reached maximum zoom limit", font: .systemFont(ofSize: 12.0))
        }
        
    }

    private func setUpCameraPositionLabel() -> String {
        guard let cameraPosition = livePresenter.cameraPosition else{
            return cameraFrontLabel
        }
        switch cameraPosition {
        case .back:
            return cameraBackLabel
        case .front:
            return cameraFrontLabel
        default:
            return ""
        }
    }

    private func setUpButtonLabel(buttonType: ButtonType) -> ButtonDisplayData {
        switch  buttonType {
        case .sound:
            return soundBtnData[!needsMute]!
        case .sendVideo:
            return publishBtnData[livePresenter.needsVideoRun]!
        }
    }

    @objc private func toggleSouondMuteState(_ sender: UIButton) {
        self.needsMute.toggle()

        let data = setUpButtonLabel(buttonType: .sound)
        sender.setTitle(data.title, for: .normal)
        sender.backgroundColor = data.color
    }
    
    
    
//    MARK: - Send Video Streaming

    @objc private func toggleSendVideoData(_ sender: UIButton) {
//        #if !targetEnvironment(simulator)
        if sendString == "camera"{
//            self.takePhoto()
            
//            if let _currentInput = self.capSession?.outputs.first {
//                if _currentInput == photoOutput{
//                    else{
//
//                    }
//                }
//            }
            liveSetupView.lblRecordingTiming.isHidden = true
            liveSetupView.lblRecording.textColor = .white
            liveSetupView.lblRecording.text = "CAPTURE"
            do {
                sendImage = liveSetupView.imageView.image ?? UIImage()
                if sender.image(for: .normal) == UIImage(named: "stop_video_recording_icon") {
                    if videochampManager.videochamp_sharedManager.redirectType == .camera {
                        UIApplication.topViewController()?.showToast(message: "Photo Captured!", font: .systemFont(ofSize: 12.0))
                    }
                    sendString = "captureImage"
                    try livePresenter.sendText(text: sendString, sendMode: .unreliable)
                    sender.isUserInteractionEnabled = true
                }
                
//                sender.setImage(UIImage(named: "stop_video_recording_icon"), for: .normal)
//                self.saveImageAlertVC()
                
//                let imageData = sendImage.pngData()
//
//                if ((imageData?.isEmpty) == nil) {
//                    self.takePhoto()
////                    try livePresenter.sendText(text: "cameraControlAccess", sendMode: .unreliable)
//                    if videochampManager.videochamp_sharedManager.redirectType == .camera {
//                        UIApplication.topViewController()?.showToast(message: "Image Captured!", font: .systemFont(ofSize: 16.0))
//                    }else if videochampManager.videochamp_sharedManager.redirectType == .remote{
//                        self.saveImageAlertVC()
//                    }
//                }else{
//
//
////                    try livePresenter.send(text: imageData ?? Data(), sendMode: .unreliable)
//
//                }
            } catch let error {
                print(error)
            }


        }else if sendString == "captureImage" {
            liveSetupView.lblRecordingTiming.isHidden = true
            liveSetupView.lblRecording.textColor = .white
            liveSetupView.lblRecording.text = "CAPTURE"
            do {
                sendImage = liveSetupView.imageView.image ?? UIImage()
                if sender.image(for: .normal) == UIImage(named: "stop_video_recording_icon") {
                    sendString = "captureImage"
                    try livePresenter.sendText(text: sendString, sendMode: .unreliable)
                    sender.isUserInteractionEnabled = true
                }
            }catch let error {
               print(error)
           }
        }else{
            
            
            if videochampManager.videochamp_sharedManager.redirectType == .remote{
                if sender.image(for: .normal) ==  UIImage(named: "stop_video_recording_icon")  {
                    
                }else{
                    self.saveImageAlertVC()
                }
            }else{
                UIApplication.topViewController()?.showToast(message: "Start Recording...", font: .systemFont(ofSize: 16.0))
            }
            do {
                if sender.image(for: .normal) == UIImage(named: "stop_video_recording_icon") {
                    liveSetupView.lblRecording.textColor = .red
                    liveSetupView.lblRecording.text = "RECORDING"
                    sendString = "startRecording"
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startRecording"), object: nil)
                    try livePresenter.sendText(text: sendString, sendMode: .unreliable)
                    sender.setImage(UIImage(named: "start_video_recording_icon"), for: .normal)
                }else{
                    
                    
//                    movieOutput.stopRecording()
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                        if let _currentOutput = self.capSession?.outputs.first {
//                            self.capSession?.removeOutput(_currentOutput)
//                        }
//                        self.photoOutput.isHighResolutionCaptureEnabled = true
//                        guard ((self.capSession?.canAddOutput(self.photoOutput)) != nil) else {
//                            return
//                        }
//                        self.capSession?.addOutput(self.photoOutput)
////                        self.capSession?.commitConfiguration()
//                        self.sessionSetupSucceeds = true
//                    }
//                    self.saveImageAlertVC()
                    
                    liveSetupView.lblRecordingTiming.isHidden = true
                    liveSetupView.lblRecording.textColor = .white
                    liveSetupView.lblRecording.text = "CAPTURE"
                    UIApplication.topViewController()?.showToast(message: "Video captured", font: .systemFont(ofSize: 16.0))
                    sendString = "stopRecording"
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopRecording"), object: nil)
                    try livePresenter.sendText(text: sendString, sendMode: .unreliable)
                    sender.setImage(UIImage(named: "stop_video_recording_icon"), for: .normal)
                }
                
            }catch let error {
                print(error)
            }

        }
//        sender.backgroundColor = data.color
//        #endif
    }

    @objc private func zoomInImage(_ sender : UIButton) {
        do {
            if zoomText > 0 {
                liveSetupView.lblZoom.text = "\(zoomText)x"
            }else{
                liveSetupView.lblZoom.text = "1x"
            }
            
            zooomImageString = "ZoomOut"
            zoomOutSession()
            try livePresenter.sendText(text: zooomImageString, sendMode: .unreliable)
        } catch let error {
            print(error)
        }
        
        
    }
    
    
//    MARK: - Zoomm Out Image
    
    func zoomOutSession(){
        if zoom > 0.1 {
            zoom -= 0.5
            zoomText -= 1
            
            guard sessionSetupSucceeds,  let device = activeCamera else { return }
            let minAvailableZoomScale = device.minAvailableVideoZoomFactor
            let maxAvailableZoomScale = device.maxAvailableVideoZoomFactor
            let availableZoomScaleRange = minAvailableZoomScale...maxAvailableZoomScale
            let resolvedZoomScaleRange = zoomScaleRange.clamped(to: availableZoomScaleRange)

            let resolvedScale = max(resolvedZoomScaleRange.lowerBound, min(1.34 * zoom, resolvedZoomScaleRange.upperBound))

            configCamera(device) { device in
                device.videoZoomFactor = resolvedScale
            }
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
    
    

    @objc private func onchangedTextField(_ sender: UITextField) {
        sendString = "saveImage"
    }

    deinit {
//         print("deinit:LiveViewModel")
    }

}


//MARK: StartVideo Recording
extension LiveViewModel {

    private func configureVideoSession() {
        if let currentOutput = capSession?.outputs.first {
            capSession?.removeOutput(currentOutput)
        }
        setupVideoRecording()
        sessionOutput.outputSettings = [AVVideoCodecKey : AVVideoCodecType.jpeg]
        if ((capSession?.canAddOutput(sessionOutput)) != nil)
        {
            capSession?.addOutput(sessionOutput)

            liveSetupView.previewLayer = AVCaptureVideoPreviewLayer(session: capSession!)
            liveSetupView.previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            liveSetupView.previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
//            capView.layer.addSublayer(previewLayer)
//            previewLayer.position = CGPoint(x: self.capView.frame.width / 2, y: self.capView.frame.height / 2)
//            previewLayer.bounds = capView.frame
        }
        capSession?.addOutput(movieOutput)
        capSession?.startRunning()
        sessionSetupSucceeds = true
        self.handleCaptureSession()
    }
    
    
    private func setupVideoRecording(){
        let session = AVCaptureDevice.DiscoverySession.init(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        let devices = session.devices
        guard let audioDevice = AVCaptureDevice.default(for: .audio) else { return }
        for device in devices
            {
                if device.position == AVCaptureDevice.Position.back
                {
                    do{
                        if let inputs = capSession?.inputs as? [AVCaptureDeviceInput] {
                            for input in inputs {
                                capSession?.removeInput(input)
                            }
                        }
                        let input = try AVCaptureDeviceInput(device: device )
                        let audioDeviceInput = try AVCaptureDeviceInput(device: audioDevice)
                        if ((capSession?.canAddInput(input)) != nil){
                            capSession?.addInput(input)
                            capSession?.addInput(audioDeviceInput)
                        }

                    }
                    catch{
                        print("Error")
                    }
                }
        }
        
    }
    func handleCaptureSession()
        {
            print("-----------Starting-----------")
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let dateFormatter : DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MMM-dd HH:mm:ss"
            let date = Date()
            let dateString = dateFormatter.string(from: date)
            let fileName = dateString + "output.mov"
            let fileUrl = paths[0].appendingPathComponent(fileName)
            try? FileManager.default.removeItem(at: fileUrl)
            print(self.capSession?.outputs)
            
            
            _filename = UUID().uuidString
            let videoPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(_filename).mov")
            
            print("video Path : \(videoPath.path)")
//            let writer = try! AVAssetWriter(outputURL: videoPath, fileType: .mov)
//            let settings = _videoOutput?.recommendedVideoSettingsForAssetWriter(writingTo: .mov)
//            let se = (self.capSession?.outputs[0] as? AVCaptureVideoDataOutput)?.recommendedVideoSettingsForAssetWriter(writingTo: .mov)
//            let input = AVAssetWriterInput(mediaType: .video, outputSettings: se) // [AVVideoCodecKey: AVVideoCodecType.h264, AVVideoWidthKey: 1920, AVVideoHeightKey: 1080])
//            input.mediaTimeScale = CMTimeScale(bitPattern: 600)
//            input.expectsMediaDataInRealTime = true
//            input.transform = CGAffineTransform(rotationAngle: .pi/2)
//            let adapter = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: input, sourcePixelBufferAttributes: nil)
//            if writer.canAdd(input) {
//                writer.add(input)
//            }
//
//            writer.startWriting()
//            writer.startSession(atSourceTime: .zero)
//            _assetWriter = writer
//            _assetWriterInput = input
//            _adpater = adapter
////            _captureState = .capturing
//            _time = dateString
//            self.movieOutput.startRecording(to: fileUrl, recordingDelegate: self)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 30.0, execute:
//                {
//
//            })
//            print(self.capSession?.outputs)
//            let fileOutput = (self.capSession?.outputs[1] as? AVCaptureVideoDataOutput)
//
////            let fileOutput = AVCaptureMovieFileOutput()
//            capSession!.addOutput(fileOutput!)
//            fileOutput!.startRecording(to: videoPath, recordingDelegate: self)
            setUpWriter()
            
        }
    
    func setUpWriter() {

        do {
            _filename = UUID().uuidString
            let outputFileLocation = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(_filename).mov")
            _assetWriter = try AVAssetWriter(outputURL: outputFileLocation, fileType: AVFileType.mov)

            // add video input
            _assetWriterInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: [
                AVVideoCodecKey : AVVideoCodecType.h264,
                AVVideoWidthKey : 720,
                AVVideoHeightKey : 1280,
                AVVideoCompressionPropertiesKey : [
                    AVVideoAverageBitRateKey : 2300000,
                    ],
                ])

            _assetWriterInput!.expectsMediaDataInRealTime = true

            if _assetWriter!.canAdd(_assetWriterInput!) {
                _assetWriter!.add(_assetWriterInput!)
                print("video input added")
            } else {
                print("no input added")
            }

            // add audio input
//            audioWriterInput = AVAssetWriterInput(mediaType: AVMediaType.audio, outputSettings: nil)

//            audioWriterInput.expectsMediaDataInRealTime = true

//            if videoWriter.canAdd(audioWriterInput!) {
//                videoWriter.add(audioWriterInput!)
//                print("audio input added")
//            }


            _assetWriter!.startWriting()
        } catch let error {
            debugPrint(error.localizedDescription)
        }


    }

    
    
    func saveVideo(){
        guard _assetWriterInput?.isReadyForMoreMediaData == true else { return }
            
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(_filename).mov")
        
            print("---------------FilePath--------------\(url.path)")
//            UISaveVideoAtPathToSavedPhotosAlbum(url.path, nil, nil, nil)
            _assetWriterInput?.markAsFinished()
            _assetWriter?.finishWriting { [weak self] in
                self?._captureState = .idle
                self?._assetWriter = nil
                self?._assetWriterInput = nil
                UISaveVideoAtPathToSavedPhotosAlbum(url.path, self, #selector(self?.video(_:didFinishSavingWithError:contextInfo:)), nil)
//                UISaveVideoAtPathToSavedPhotosAlbum(url.path, nil, nil, nil)
            }
            self.handleCaptureSession()
        
    }
    
    @objc func video(
      _ videoPath: String,
      didFinishSavingWithError error: Error?,
      contextInfo info: AnyObject
    ) {
      let title = (error == nil) ? "Success" : "Error"
      let message = (error == nil) ? "Video was saved" : "Video failed to save"

      let alert = UIAlertController(
        title: title,
        message: message,
        preferredStyle: .alert)
      alert.addAction(UIAlertAction(
        title: "OK",
        style: UIAlertAction.Style.cancel,
        handler: nil))
        UIApplication.topViewController()?.present(alert, animated: true)
//      present(alert, animated: true, completion: nil)
    }

    
    public func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
            print("FINISHED \(error )")
            // save video to camera roll
        guard _assetWriterInput?.isReadyForMoreMediaData == true, _assetWriter!.status == .completed else { return }
            if error == nil {
//                print("---------------FilePath--------------\(outputFileURL.path)")
                let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(_filename).mov")
                UISaveVideoAtPathToSavedPhotosAlbum(url.path, nil, nil, nil)
                _assetWriterInput?.markAsFinished()
                _assetWriter?.finishWriting { [weak self] in
                    self?._captureState = .idle
                    self?._assetWriter = nil
                    self?._assetWriterInput = nil
                }
                UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, nil, nil, nil)
                self.handleCaptureSession()
            }
        }
}
extension LiveViewModel {
    func takePhoto(_ completion: ((Photo) -> Void)? = nil) {
        guard sessionSetupSucceeds else { return }

        let settings: AVCapturePhotoSettings
        if self.photoOutput.availablePhotoCodecTypes.contains(.hevc) {
            settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
        } else {
            settings = AVCapturePhotoSettings()
        }

        let orientation = videoOrientation

        // Update the photo output's connection to match current device's orientation
        photoOutput.connection(with: .video)?.videoOrientation = orientation

        let processor = PhotoCaptureProcessor()
        processor.orientation = orientation
        processor.completion = { [unowned self] processor in
            if let photo = processor.photo {
                PHPhotoLibrary.shared().performChanges({
                    // Add the captured photo's file data as the main resource for the Photos asset.
                    let creationRequest = PHAssetCreationRequest.forAsset()
                    creationRequest.addResource(with: .photo, data: photo.fileDataRepresentation()!, options: nil)
                }, completionHandler: nil)

                completion?(Photo(photo: photo, orientation: processor.orientation))
            }

            if let settings = processor.settings {
                let id = settings.uniqueID
                self.captureProcessors.removeValue(forKey: id)
            }
        }
        captureProcessors[settings.uniqueID] = processor

        sessionQueue.async { [unowned self] in
            self.photoOutput.capturePhoto(with: settings, delegate: processor)
            do {
                try livePresenter.sendText(text: "captureImage", sendMode: .reliable)
            }catch {
                print(error)
            }
        }
    }
}

// MARK: - CameraController.Photo
extension LiveViewModel {
    /// An object to represent the result photo taken with the camera
    class Photo {
        private let photo: AVCapturePhoto
        private let orientation: AVCaptureVideoOrientation

        fileprivate init(photo: AVCapturePhoto, orientation: AVCaptureVideoOrientation) {
            self.photo = photo
            self.orientation = orientation
        }

        func image() -> UIImage? {
            guard let cgImage = photo.cgImageRepresentation() else { return nil }

//            guard let cgImages = photo.cgImageRepresentation()CameraController
            let imageOrientation: UIImage.Orientation
            switch orientation {
            case .portrait:
                imageOrientation = .right
            case .portraitUpsideDown:
                imageOrientation = .left
            case .landscapeRight:
                imageOrientation = .up
            case .landscapeLeft:
                imageOrientation = .down
            }

            return UIImage(cgImage: cgImage, scale: 1, orientation: imageOrientation)
        }
    }
}


// MARK: - PhotoCaptureProcessor
private class PhotoCaptureProcessor: NSObject, AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        guard error == nil else {
            return
        }
        self.handleCaptureSession()
    }
    
    var photo: AVCapturePhoto?
    var movieOutput = AVCaptureMovieFileOutput()
    var completion: ((PhotoCaptureProcessor) -> Void)?
    var settings: AVCaptureResolvedPhotoSettings?
    var orientation: AVCaptureVideoOrientation = .portrait
}

extension PhotoCaptureProcessor: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else {
            return
        }

//        self.handleCaptureSession()

        self.photo = photo
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishRecordingLivePhotoMovieForEventualFileAt outputFileURL: URL, resolvedSettings: AVCaptureResolvedPhotoSettings) {
        print("---------------FilePath--------------\(outputFileURL.path)")
        UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, nil, nil, nil)

        self.handleCaptureSession()
    }

    func handleCaptureSession()
        {
            print("-----------Starting-----------")
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let dateFormatter : DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MMM-dd HH:mm:ss"
            let date = Date()
            let dateString = dateFormatter.string(from: date)
            let fileName = dateString + "output.mov"
            let fileUrl = paths[0].appendingPathComponent(fileName)
            try? FileManager.default.removeItem(at: fileUrl)
            self.movieOutput.startRecording(to: fileUrl, recordingDelegate: self)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 30.0, execute:
//                {
//
//            })
        }
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        guard error == nil else {
            return
        }

        self.settings = resolvedSettings

        completion?(self)
    }
}

