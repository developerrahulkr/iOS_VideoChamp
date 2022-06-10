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


public class LiveViewModel: NSObject {
    //
    private var mcSessionManager: MCSessionManager!
    var livePresenter: LivePresenter!
    
    //
    private var targetPeerID: MCPeerID?
    private var sendString = "SaveImage"
    private var sendImage = UIImage()
    private var zooomImageString = ""
    private let sessionQueue = DispatchQueue(label: "com.hayao.MultipeerLiveKit.videodata-ouput-queue")
    
    
    
    private var liveSetupView : LiveView!

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
    
    private var activeCamera: AVCaptureDevice?
    var zoomScaleRange: ClosedRange<CGFloat> = 1...10
    
    
    private enum ButtonType {
        case sound
        case sendVideo
    }

    
    
    typealias ButtonDisplayData = (title: String, color: UIColor)

    private lazy var soundBtnData: [Bool: ButtonDisplayData]    = [true: ("Sound ON", onColor), false: ("...", offColor)]
    private lazy var publishBtnData: [Bool: ButtonDisplayData]  = [true: ("start_video_recording_icon", onColor), false: ("stop_video_recording_icon", offColor)]


    
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
        capSession = livePresenter.cap
        attachButtonActions(liveView)
        attachDisplayData(liveView)
        
//        let data = publishBtnData[livePresenter.needsVideoRun]!
//        capSession = livePresenter.cap
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
//                print("Battery Percentage is : \(batterPercentage)")
                liveView.imageView.image = image
//                liveView.imageView.layer.addSublayer(liveView.previewLayer)
                
//                self.checkCameraPermission()
//                liveView.cameraControlButton.isUserInteractionEnabled = false
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
//                    liveView.imageView.contentMode = .scaleAspectFill
                    liveView.lblZoom.text = "2x"
                    self.zoomInSession()
                case "ZoomOut" :
//                    liveView.imageView.contentMode = .scaleAspectFit
                    liveView.lblZoom.text = "1x"
                    self.zoomOutSession()
                case "low":
                    let vc = AlertCameraVC(nibName: "AlertCameraVC", bundle: nil)
                    vc.modalPresentationStyle = .overFullScreen
                    vc.btnColor = UIColor(red: 147/255, green: 192/255, blue: 31/255, alpha: 1)
                    vc.image = UIImage(named: "battery_icon")!
                    vc.titleText = "BATTERY ALERT"
                    vc.messageText = "Remote Device Battery is low"
                    UIApplication.topViewController()?.present(vc, animated: true)
                case "close" :
                    let vc = DisconnectCameraVC(nibName: "DisconnectCameraVC", bundle: nil)
                    vc.modalPresentationStyle = .overFullScreen
                    UIApplication.topViewController()?.present(vc, animated: true)
                case "camera" :
                    self.sendString = str ?? ""
                    print("send String is : \(self.sendString)")
                    liveView.btnCamera.setImage(UIImage(named: "camera_icon_yellow"), for: .normal)
                    liveView.btnVideo.setImage(UIImage(named: "record_video_icon_white"), for: .normal)
                    liveView.cameraControlButton.setImage(UIImage(named: "stop_video_recording_icon"), for: .normal)
                    liveView.cameraControlButton.isUserInteractionEnabled = true
                case "video":
                    liveView.cameraControlButton.isUserInteractionEnabled = false
                    liveView.btnCamera.setImage(UIImage(named: "camera_change_icon"), for: .normal)
                    liveView.btnVideo.setImage(UIImage(named: "video_recording_icon"), for: .normal)
                case "popToRoot":
                    NotificationCenter.default.post(name: .kPopToRoot, object: nil)
                default :
                    let image = UIImage(data: msg)
                    print(image ?? UIImage())
                    let vc = AlertCameraVC(nibName: "AlertCameraVC", bundle: nil)
                    vc.modalPresentationStyle = .overFullScreen
                    vc.btnColor = UIColor(red: 147/255, green: 192/255, blue: 31/255, alpha: 1)
                    vc.image = UIImage(named: "save_Image_icon")!
                    vc.titleText = "MEDIA SAVED"
                    vc.messageText = "Files have been saved in your device gallery"
                    UIApplication.topViewController()?.present(vc, animated: true)
                    UIImageWriteToSavedPhotosAlbum(image ?? UIImage(), nil, nil, nil)
//                    break
                }
                
                
//                if str == "zoomIn" {
//                    liveView.imageView.contentMode = .scaleAspectFill
//                    liveView.lblZoom.text = "2x"
//                }else if str == "low"{
//                    let alert = UIAlertController(title: "VideoChamp", message: "Battry is Low", preferredStyle: .alert)
//                    let okAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
//                    alert.addAction(okAction)
//                    UIApplication.topViewController()?.present(alert, animated: true)
////                    print("BatteryPercentage is law \(batterPercentage)")
//                }else{
//                    liveView.imageView.contentMode = .scaleAspectFit
//                    liveView.lblZoom.text = "1x"
//                }
//                let image = UIImage(data: msg)
//                print(image)
//                UIImageWriteToSavedPhotosAlbum(image ?? UIImage(), nil, nil, nil)
            }
        })
        
        checkCameraPermission()
        
    }
    
    @objc func closeViewC(){
//        UIApplication.topViewController()?.navigationController?.popToRootViewController(animated: true)
        do {
            try livePresenter.sendText(text: "popToRoot", sendMode: .reliable)
        }catch let error {
            print(error)
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
            liveSetupView.btnCamera.setImage(UIImage(named: "camera_change_icon"), for: .normal)
            let data = publishBtnData[livePresenter.needsVideoRun]!
            
            if data.title == "start_video_recording_icon" {
                liveSetupView.lblRecordingTiming.isHidden = false
                liveSetupView.lblRecording.textColor = .red
                liveSetupView.lblRecording.text = "RECORDING"
//                liveSetupView.btnCamera.isUserInteractionEnabled = true
                
                liveSetupView.cameraControlButton.setImage(UIImage(named: "start_video_recording_icon"), for: .normal)
            }else{
                liveSetupView.lblRecordingTiming.isHidden = true
                liveSetupView.lblRecording.textColor = .white
                liveSetupView.lblRecording.text = "CAPTURE"
//                sender.setImage(UIImage(named: "video_recording_icon"), for: .normal)
//                liveSetupView.btnCamera.setImage(UIImage(named: "camera_change_icon"), for: .normal)
//                liveSetupView.btnCamera.isUserInteractionEnabled = false
                
            }
            
            
            sendString = "video"
            liveSetupView.cameraControlButton.isUserInteractionEnabled = true
//            liveSetupView.cameraControlButton.setImage(UIImage(named: "start_video_recording_icon"), for: .normal)
            try livePresenter.sendText(text: sendString, sendMode: .reliable)
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
//            print("send String : \(sendImage)")
//            let imageData = sendImage.pngData()
//            try livePresenter.send(text: imageData ?? Data(), sendMode: .reliable)
            liveSetupView.cameraControlButton.isUserInteractionEnabled = false
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
//        UIApplication.topViewController()?.navigationController?.popViewController(animated: true)
        let vc = DisconnectCameraVC(nibName: "DisconnectCameraVC", bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        UIApplication.topViewController()?.present(vc, animated: true)
    }
    @objc func closeVC(_ sender: UIButton){
//
//        do {
////            liveSetupView.imageView.contentMode = .scaleAspectFill
//            zooomImageString = "close"
//
//            try livePresenter.sendText(text: zooomImageString, sendMode: .unreliable)
////            UIApplication.topViewController()?.navigationController?.popViewController(animated: true)
//        } catch let error {
//            print(error)
//        }
        
        let vc = DisconnectCameraVC(nibName: "DisconnectCameraVC", bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        UIApplication.topViewController()?.present(vc, animated: true)
//        print("Close Tab")
//
        
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
        liveView.lblZoom.text = "2x"
        liveView.lblZoom.textAlignment = .center
        //colors
//        liveView.imageCapture.backgroundColor = .blue
//        imageCapture.layer.addSublayer(previewLayer)
        liveView.imageCapture.isHidden = true
        liveView.imageView.backgroundColor = .black
        liveView.receivedTextLabel.backgroundColor = .white
        liveView.soundControlButton.backgroundColor = soundBtnData.color
        liveView.soundControlButton.isHidden = true
        liveView.sendTextField.backgroundColor = .white
        liveView.sendTextField.isHidden = true
        liveView.textSendButton.setTitleColor(onColor, for: .highlighted)
        liveView.imageView.isUserInteractionEnabled = false
//        liveView.btnCamera.isUserInteractionEnabled = false
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
                if capSession!.canAddInput(input) {
                    capSession!.addInput(input)
                }
                if capSession!.canAddOutput(output){
                    capSession!.addOutput(output)
                }
                liveSetupView.previewLayer.videoGravity = .resizeAspectFill
                liveSetupView.previewLayer.session = capSession
                sessionSetupSucceeds = true
                
                activeCamera = device
//                session!.startRunning()
//                self.session = session
                
            }catch {
                print(error)
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
            liveSetupView.lblZoom.text = "2x"
            zoomInSession()
            try livePresenter.sendText(text: zooomImageString, sendMode: .unreliable)
        } catch let error {
            print(error)
        }
        
        
        
        
        
        #endif
    }
    
    
    func zoomInSession(){
        guard sessionSetupSucceeds,  let device = activeCamera else { return }
        let minAvailableZoomScale = device.minAvailableVideoZoomFactor
        let maxAvailableZoomScale = device.maxAvailableVideoZoomFactor
        let availableZoomScaleRange = minAvailableZoomScale...maxAvailableZoomScale
        let resolvedZoomScaleRange = zoomScaleRange.clamped(to: availableZoomScaleRange)
        let resolvedScale = max(resolvedZoomScaleRange.lowerBound, min( 1.34 * 1.0, resolvedZoomScaleRange.upperBound))

        configCamera(device) { device in
            device.videoZoomFactor = resolvedScale
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

    @objc private func toggleSendVideoData(_ sender: UIButton) {
        #if !targetEnvironment(simulator)
        if sendString == "camera"{
            sender.setImage(UIImage(named: "stop_video_recording_icon"), for: .normal)
            liveSetupView.lblRecordingTiming.isHidden = true
            liveSetupView.lblRecording.textColor = .white
            liveSetupView.lblRecording.text = "CAPTURE"
            SoundPlayer.shared.playAudioSound(name: SoundName.captureImageSound, volume: 1.0)
//            liveSetupView.btnCamera.isUserInteractionEnabled = false
            do {
                sendImage = liveSetupView.imageView.image ?? UIImage()
//                sender.setImage(UIImage(named: "camera_icon_yellow"), for: .normal)

                sender.isUserInteractionEnabled = true
                let imageData = sendImage.pngData()
                if ((imageData?.isEmpty) == nil) {
                    print("Data is Empty ")
                }else{
                    try livePresenter.send(text: imageData ?? Data(), sendMode: .reliable)
                }
            } catch let error {
                print(error)
            }
            
            
        }else{
            livePresenter.needsVideoRun.toggle()
            
            do {
                let data = publishBtnData[livePresenter.needsVideoRun]!
                sender.setImage(UIImage(named: data.title), for: .normal)
                if data.title == "start_video_recording_icon" {
                    liveSetupView.lblRecordingTiming.isHidden = false
                    liveSetupView.lblRecording.textColor = .red
                    liveSetupView.lblRecording.text = "RECORDING"
                    liveSetupView.btnCamera.isUserInteractionEnabled = true
                    
                }else{
                    liveSetupView.lblRecordingTiming.isHidden = true
                    liveSetupView.lblRecording.textColor = .white
                    liveSetupView.lblRecording.text = "CAPTURE"
                    liveSetupView.btnCamera.isUserInteractionEnabled = false
                }
                sendString = "video"
                try livePresenter.sendText(text: sendString, sendMode: .reliable)
            }catch let error {
                print(error)
            }
            
        }
//        sender.backgroundColor = data.color
        #endif
    }

    @objc private func zoomInImage(_ sender : UIButton) {
        do {
            liveSetupView.lblZoom.text = "1x"
            zooomImageString = "ZoomOut"
            zoomOutSession()
            try livePresenter.sendText(text: zooomImageString, sendMode: .unreliable)
        } catch let error {
            print(error)
        }
        
        
    }
    
    
//    MARK: - Zoomm Out Image
    
    func zoomOutSession(){
        guard sessionSetupSucceeds,  let device = activeCamera else { return }
        let minAvailableZoomScale = device.minAvailableVideoZoomFactor
        let maxAvailableZoomScale = device.maxAvailableVideoZoomFactor
        let availableZoomScaleRange = minAvailableZoomScale...maxAvailableZoomScale
        let resolvedZoomScaleRange = zoomScaleRange.clamped(to: availableZoomScaleRange)

        let resolvedScale = max(resolvedZoomScaleRange.lowerBound, min( 0.438976 * 1.8601487874984741, resolvedZoomScaleRange.upperBound))

        configCamera(device) { device in
            device.videoZoomFactor = resolvedScale
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
