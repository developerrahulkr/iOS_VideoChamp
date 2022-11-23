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
    private var sendString = "captureImage"
    
    
    private var sendImage = UIImage()
    private var zooomImageString = ""
    private let sessionQueue = DispatchQueue(label: "com.hayao.MultipeerLiveKit.videodata-ouput-queue")
    private lazy var photoOutput = AVCapturePhotoOutput()
    
    
    var timeMin = 0
    var timeSec = 0
    var timer: Timer?
   
    private var liveSetupView : LiveView!

    private var zoom = 0.5
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
        attachButtonActions(liveView)
        attachDisplayData(liveView)
        NotificationCenter.default.addObserver(self, selector: #selector(closeViewCs), name: .Sessionexpire, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(closeViewC), name: .kCloseScreen, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(disconnectVC), name: .kDisconnect, object: nil)
     //   NotificationCenter.default.addObserver(self, selector: #selector(closeViewCs), name: .SessionExpiren, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appdidenterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        if (videochampManager.videochamp_sharedManager.redirectType == .camera)
        {
            self.connectAlertVC()
            capSession = livePresenter.cap
            livePresenter.needsVideoRun.toggle()
            
            do {
                liveView.bottomView.isHidden = true
                sendString = "captureImage"
                try livePresenter.sendText(text: sendString, sendMode: .unreliable)
            }catch {
                print(error.localizedDescription)
            }
            
            
        }else if (videochampManager.videochamp_sharedManager.redirectType == .remote) {
            self.connectAlertVC()
            liveView.buttonView.isHidden = true
        }
        
        
        
        
        
//        let data = publishBtnData[livePresenter.needsVideoRun]!
//        capSession = livePresenter.cap
// print("totalDiskSpaceInBytes: \(UIDevice.current.totalDiskSpaceInBytes)")
        print("freeDiskSpace: \(UIDevice.current.freeDiskSpaceInBytes)")
        print("usedDiskSpace: \(UIDevice.current.usedDiskSpaceInBytes)")
        let storage = (Float(UIDevice.current.freeDiskSpaceInBytes)/Float(UIDevice.current.totalDiskSpaceInBytes))*100
        if storage <= 15 {
            do {
                let vc = AlertCameraVC(nibName: "AlertCameraVC", bundle: nil)
                vc.modalPresentationStyle = .overFullScreen
                vc.btnColor = UIColor(red: 147/255, green: 192/255, blue: 31/255, alpha: 1)
                self.isDisconnect = false
                vc.image = UIImage(named: "st")!
                vc.titleText = "STORAGE ALERT"
                vc.messageText = "Available storage capacity on CAMERA filming device is almost full"
                UIApplication.topViewController()?.present(vc, animated: true)
                try self.livePresenter.sendText(text: "lowstrorage", sendMode: .unreliable)
            } catch let error {
                print(error)
            }
        }
        else if  storage <= 10 {
            do {
                let vc = AlertCameraVC(nibName: "AlertCameraVC", bundle: nil)
                vc.modalPresentationStyle = .overFullScreen
                vc.btnColor = UIColor(red: 147/255, green: 192/255, blue: 31/255, alpha: 1)
                self.isDisconnect = false
                vc.image = UIImage(named: "st")!
                vc.titleText = "STORAGE ALERT"
                vc.messageText = "Available storage capacity on CAMERA filming device is almost full"
                UIApplication.topViewController()?.present(vc, animated: true)
                try self.livePresenter.sendText(text: "lowstrorage", sendMode: .unreliable)
            } catch let error {
                print(error)
            }
        }
        if storage <= 5 {
            do {
                let vc = AlertCameraVC(nibName: "AlertCameraVC", bundle: nil)
                vc.modalPresentationStyle = .overFullScreen
                vc.btnColor = UIColor(red: 147/255, green: 192/255, blue: 31/255, alpha: 1)
                self.isDisconnect = false
                vc.image = UIImage(named: "st")!
                vc.titleText = "STORAGE ALERT"
                vc.messageText = "Available storage capacity on CAMERA filming device is almost full"
                UIApplication.topViewController()?.present(vc, animated: true)
                try self.livePresenter.sendText(text: "lowstrorage", sendMode: .unreliable)
            } catch let error {
                print(error)
            }
        }
        
        else{
            print("asdf asdfasd fasd fas dfasdf asdfas dfasdfasdf  \(storage)")
        }
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        let batterPercentage = UIDevice.current.batteryLevel * 100
        
        if batterPercentage <= 20 {
            do {
                let vc = AlertCameraVC(nibName: "AlertCameraVC", bundle: nil)
                vc.modalPresentationStyle = .overFullScreen
                vc.btnColor = UIColor(red: 147/255, green: 192/255, blue: 31/255, alpha: 1)
                self.isDisconnect = false
                vc.image = UIImage(named: "battery_icon")!
                vc.titleText = "BATTERY ALERT"
                vc.messageText = "Remote Device Battery is low"
                UIApplication.topViewController()?.present(vc, animated: true)
                try self.livePresenter.sendText(text: "low", sendMode: .unreliable)
            } catch let error {
                print(error)
            }
        }
        else if  batterPercentage <= 10 {
            do {
                let vc = AlertCameraVC(nibName: "AlertCameraVC", bundle: nil)
                vc.modalPresentationStyle = .overFullScreen
                vc.btnColor = UIColor(red: 147/255, green: 192/255, blue: 31/255, alpha: 1)
                self.isDisconnect = false
                vc.image = UIImage(named: "battery_icon")!
                vc.titleText = "BATTERY ALERT"
                vc.messageText = "Remote Device Battery is low"
                UIApplication.topViewController()?.present(vc, animated: true)
                try self.livePresenter.sendText(text: "low", sendMode: .unreliable)
            } catch let error {
                print(error)
            }
        }
    
        if batterPercentage <= 5 {
            do {
                let vc = AlertCameraVC(nibName: "AlertCameraVC", bundle: nil)
                vc.modalPresentationStyle = .overFullScreen
                vc.btnColor = UIColor(red: 147/255, green: 192/255, blue: 31/255, alpha: 1)
                self.isDisconnect = false
                vc.image = UIImage(named: "battery_icon")!
                vc.titleText = "BATTERY ALERT"
                vc.messageText = "Remote Device Battery is low"
                UIApplication.topViewController()?.present(vc, animated: true)
                try self.livePresenter.sendText(text: "low", sendMode: .unreliable)
            } catch let error {
                print(error)
            }
        }
        
        else{
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
            if weakSelf.needsMute == true{
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
                    if self.zoomText >= 1 {
                        liveView.lblZoom.text = "\(self.zoomText)x"
                    }else{
                        liveView.lblZoom.text = "1x"
                    }
                    self.zoomInSession()
                    
                case "ZoomOut" :
//                    liveView.imageView.contentMode = .scaleAspectFit
                    self.sendString = str ?? ""
                    if self.zoomText > 1 {
                        
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
                    
                case "lowstrorage":
                    self.sendString = str ?? ""
                    let vc = AlertCameraVC(nibName: "AlertCameraVC", bundle: nil)
                    vc.modalPresentationStyle = .overFullScreen
                    vc.btnColor = UIColor(red: 147/255, green: 192/255, blue: 31/255, alpha: 1)
                    self.isDisconnect = false
                    vc.image = UIImage(named: "st")!
                    vc.titleText = "STORAGE ALERT"
                    vc.messageText = "Remote Device storage is low"
                    UIApplication.topViewController()?.present(vc, animated: true)
                case "close" :
                    self.sendString = str ?? ""
                    let vc = DisconnectCameraVC(nibName: "DisconnectCameraVC", bundle: nil)
                    vc.mcSessionManage = self.mcSessionManager
                    vc.modalPresentationStyle = .overFullScreen
                    UIApplication.topViewController()?.present(vc, animated: true)
                case "camera" :
                    self.sendString = str ?? ""
                    print("send String is : \(self.sendString)")
                    liveView.lblRecording.textColor = .white
                    liveView.lblFilmingDevice.text = "CAPTURE DEVICE"
                    liveView.lblRecording.text = "PHOTO"
                    
                    if liveView.cameraControlButton.image(for: .normal) == UIImage(named: "start_video_recording_icon") {
                        UIApplication.topViewController()?.showToast(message: "Vedio Captured!", font: .systemFont(ofSize: 12.0))
                        //self.saveImageAlertVC()
                        
                    }else{
                        
                    }
                    liveView.btnCamera.setImage(UIImage(named: "camera_icon_yellow"), for: .normal)
                    liveView.btnVideo.setImage(UIImage(named: "record_video_icon_white"), for: .normal)
                    liveView.cameraControlButton.setImage(UIImage(named: "stop_video_recording_icon"), for: .normal)
                    liveView.cameraControlButton.isUserInteractionEnabled = true
                case "startStreaming":
                    self.sendString = str ?? ""
                    liveView.lblFilmingDevice.text = "REMOTE DEVICE"
                    liveView.cameraControlButton.setImage(UIImage(named: "stop_video_recording_icon"), for: .normal)
                    if videochampManager.videochamp_sharedManager.redirectType == .camera {
                        self.connectAlertVC()
                    }else if  videochampManager.videochamp_sharedManager.redirectType == .remote {
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
                    liveView.lblFilmingDevice.text = "FILMING DEVICE"
                    liveView.lblRecording.text = "VIDEO"
//                    liveView.cameraControlButton.setImage(UIImage(named: "stop_video_recording_icon"), for: .normal)
                    
                case "stopRecording":
                    self.sendString = str ?? ""
                    if videochampManager.videochamp_sharedManager.redirectType == .camera {
                     //   self.saveImageAlertVC()
                     UIApplication.topViewController()?.showToast(message: "Media has been saved in your CAMERA device gallery", font: .systemFont(ofSize: 16.0))
                        liveView.lblRecording.textColor = .white
                        liveView.lblFilmingDevice.text = "FILMING DEVICE"
                        liveView.lblRecording.text = "VIDEO"
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopRecording"), object: nil)
                    }else{
                        liveView.lblRecording.textColor = .white
                        liveView.lblFilmingDevice.text = "FILMING DEVICE"
                        liveView.lblRecording.text = "VIDEO"
                       // self.saveImageAlertVC()
                        UIApplication.topViewController()?.showToast(message: "Media has been saved in your CAMERA device gallery", font: .systemFont(ofSize: 16.0))
                        
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
                    liveView.lblFilmingDevice.text = "FILMING DEVICE"
                    liveView.lblRecording.text = "VIDEO"
                    
                case "captureImage" :
                    self.sendString = str ?? ""
                   // DispatchQueue.global(qos: .userInteractive).async {
                        if videochampManager.videochamp_sharedManager.redirectType == .camera {
                            UIApplication.topViewController()?.showToast(message: "Media has been saved in your CAMERA device gallery", font: .systemFont(ofSize: 16.0))
                          //  self.saveImageAlertVC()
                            self.takePhoto()
                        }else{
                           // self.saveImageAlertVC()
                            UIApplication.topViewController()?.showToast(message: "Media has been saved in your CAMERA device gallery", font: .systemFont(ofSize: 16.0))
                            let image = UIImage(data: msg)
                            print("Image is : \(image ?? UIImage())")

                        }
                    //}
                    
                case "backgrongMode" :
//                    self.saveImageAlertVC()
                    self.backgroundDismissAlert()
                case "SessionExpire" :
//                    self.saveImageAlertVC()
                    self.dismissAlertexpireVC()
                default :
                    break
//                    UIImageWriteToSavedPhotosAlbum(image ?? UIImage(), nil, nil, nil)
                    
                }
            }
        })
        
            self.checkCameraPermission()
    }
    
    func removeObserverBackground() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    
    @objc func appdidenterBackground()
    {
        do {
            sendString = "backgrongMode"
            
            try livePresenter.sendText(text: sendString, sendMode: .unreliable)
        }catch {
            print(error.localizedDescription)
        }
//        if videochampManager.videochamp_sharedManager.redirectType == .camera {
//
//        }
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
    
    func backgroundDismissAlert(){
        let vc = RemoteDismissScreenVC(nibName: "RemoteDismissScreenVC", bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        UIApplication.topViewController()?.present(vc, animated: true)
    }
    
    func connectAlertVC(){
        let vc = AlertCameraVC(nibName: "AlertCameraVC", bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        vc.btnColor = UIColor(red: 147/255, green: 192/255, blue: 31/255, alpha: 1)
        vc.image = UIImage(named: "success_icon")!
        vc.titleText = "CONNECTION SUCCESSFUL"
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
    
    func dismissAlertexpireVC(){
        let vc = AlertCameraVC(nibName: "AlertCameraVC", bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        vc.btnColor = UIColor.init(hexString: "#39BB35")
        vc.image = UIImage(named: "done")!
        vc.titleText = "Session Completed"
        vc.messageText = "Media has been saved on CAMERA filming device"
        vc.btnOkText = "OK"
        vc.dimsiss = 1
        isDisconnect = true
        UIApplication.topViewController()?.present(vc, animated: true)
    }
    func dismissAlertVCS(){
        let vc = AlertCameraVC(nibName: "AlertCameraVC", bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        vc.btnColor = UIColor(red: 256/255, green: 9/255, blue: 19/255, alpha: 1)
        vc.image = UIImage(named: "done")!
        vc.dimsiss = 1
        vc.titleText = "Session Completed"
        vc.messageText = "Media has been saved on CAMERA filming device"
        vc.btnOkText = "OK"
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
    @objc func closeViewCs(){
        do {
            try livePresenter.sendText(text: "SessionExpire", sendMode: .unreliable)
        }catch let error {
            print(error)
        }
    }
    
    @objc func disconnectVC(){
        if isDisconnect {
            NotificationCenter.default.post(name: .kPopToRoot, object: nil)
        }else{
            UIApplication.topViewController()?.showAlert(alertMessage: "Video Paused.")
            print("Disconnect : \(isDisconnect)")
        }
        
    }

    private func attachButtonActions(_ liveView: LiveView) {
//        liveView.soundControlButton.addTarget(self, action: #selector(toggleSouondMuteState(_:)), for: .touchUpInside)
        liveView.changeCameraButton.addTarget(self, action: #selector(cameraToggle(_:)), for: .touchUpInside)
        liveView.cameraControlButton.addTarget(self, action: #selector(toggleSendVideoData(_:)), for: .touchUpInside)
        liveView.textSendButton.addTarget(self, action: #selector(zoomInImage(_:)), for: .touchUpInside)
        liveView.sendTextField.addTarget(self, action: #selector(onchangedTextField(_:)), for: .editingChanged)
        liveView.btnBack.addTarget(self, action: #selector(backVC(_:)), for: .touchUpInside)
        liveView.btnClose.addTarget(self, action: #selector(closeVC(_:)), for: .touchUpInside)
        liveView.btnCamera.addTarget(self, action: #selector(captureFrames(_:)), for: .touchUpInside)
        liveView.btnVideo.addTarget(self, action: #selector(startRecording(_:)), for: .touchUpInside)
        liveView.btnStopCasting.addTarget(self, action: #selector(stopCasting(_:)), for: .touchUpInside)
       // liveView.btnStopCasting.addTarget(self, action: #selector(closeVC(_:)), for: .touchUpInside)

    }
    
    @objc func stopCasting(_ sender : UIButton) {
        print("Stop Casting")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopRecording"), object: nil)
        capSession?.stopRunning()
        captureSession.stopRunning()
        disConectCameraVC()
    }
    
    @objc func startRecording(_ sender : UIButton){
        do {
            sender.setImage(UIImage(named: "video_recording_icon"), for: .normal)
            sendString = "startRecording"
//            liveSetupView.lblRecording.textColor = .red
            liveSetupView.lblFilmingDevice.text = "FILMING DEVICE"
            liveSetupView.lblRecording.text = "VIDEO"
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
        if liveSetupView.cameraControlButton.image(for: .normal) == UIImage(named: "start_video_recording_icon") {
          //  self.saveImageAlertVC()
            UIApplication.topViewController()?.showToast(message: "Video Captured!", font: .systemFont(ofSize: 16.0))
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopRecording"), object: nil)
//            self.stopTimer()
            self.resetTimerToZero()
            do {
    //            sendImage = liveSetupView.imageView.image ?? UIImage()
                sender.setImage(UIImage(named: "camera_icon_yellow"), for: .normal)
                liveSetupView.btnVideo.setImage(UIImage(named: "record_video_icon_white"), for: .normal)
                liveSetupView.cameraControlButton.setImage(UIImage(named: "stop_video_recording_icon"), for: .normal)
                liveSetupView.lblRecordingTiming.isHidden = true
                liveSetupView.lblRecording.textColor = .white
                liveSetupView.lblFilmingDevice.text = "CAPTURE DEVICE"
                liveSetupView.lblRecording.text = "PHOTO"
                sendString = "camera"
                try livePresenter.sendText(text: sendString, sendMode: .unreliable)
            } catch let error {
                print(error)
            }
        }else{
            do {
    //            sendImage = liveSetupView.imageView.image ?? UIImage()
                sender.setImage(UIImage(named: "camera_icon_yellow"), for: .normal)
                liveSetupView.btnVideo.setImage(UIImage(named: "record_video_icon_white"), for: .normal)
                liveSetupView.cameraControlButton.setImage(UIImage(named: "stop_video_recording_icon"), for: .normal)
                liveSetupView.lblRecordingTiming.isHidden = true
                liveSetupView.lblRecording.textColor = .white
                liveSetupView.lblFilmingDevice.text = "CAPTURE DEVICE"
                liveSetupView.lblRecording.text = "PHOTO"
                sendString = "camera"
                try livePresenter.sendText(text: sendString, sendMode: .unreliable)
                
            } catch let error {
                print(error)
            }
        }
//        savePic()

        
    }
    
    func savePic(){
//        print("original Image : \(liveSetupView.imageView.image)")
         liveSetupView.imageCapture.image = liveSetupView.imageView.image
//        let image = UIImage(data: liveSetupView.imageView.image)
        UIImageWriteToSavedPhotosAlbum(liveSetupView.imageCapture.image ?? UIImage(), nil, nil, nil)
    }
    
    
    @objc func backVC(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopRecording"), object: nil)
        disConectCameraVC()
    }
    @objc func closeVC(_ sender: UIButton){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopRecording"), object: nil)
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
//        liveView.soundControlButton.setTitle(soundBtnData.title, for: .normal)
        liveView.textSendButton.setImage(UIImage(named: "zoom_in_icon"), for: .normal)
//        liveView.sendTextField.placeholder = "text"
        liveView.lblFilmingDevice.text = "CAPTURE DEVICE"
        
        liveView.lblRecording.text = "PHOTO"
        liveView.lblRecordingTiming.isHidden = true
        liveView.lblRecordingTiming.text = "00:00:00"
        
        liveView.btnVideo.setImage(UIImage(named: "record_video_icon_white"), for: .normal)
        liveView.btnCamera.setImage(UIImage(named: "camera_icon_yellow"), for: .normal)
        liveView.lblZoom.text = "1x"
        liveView.lblZoom.textAlignment = .center
        //colors
        liveView.imageCapture.isHidden = true
        liveView.imageView.backgroundColor = .black
//        liveView.receivedTextLabel.backgroundColor = .white
       // liveView.soundControlButton.backgroundColor = soundBtnData.color
//        liveView.soundControlButton.isHidden = true
        liveView.sendTextField.backgroundColor = .white
        liveView.sendTextField.isHidden = true
        liveView.textSendButton.setTitleColor(onColor, for: .highlighted)
        liveView.imageView.isUserInteractionEnabled = false
        // others
        liveView.imageView.contentMode = .scaleAspectFill
//        liveView.receivedTextLabel.adjustsFontSizeToFitWidth = true
//        liveView.soundControlButton.layer.opacity = 0.5
//        liveView.textSendButton.titleLabel?.adjustsFontSizeToFitWidth = true
    
        
        
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
//        #if !targetEnvironment(simulator)
        do {
//            liveSetupView.imageView.contentMode = .scaleAspectFill
            zooomImageString = "zoomIn"
            
            zoomInSession()
            try livePresenter.sendText(text: zooomImageString, sendMode: .unreliable)
        } catch let error {
            print(error)
        }
//        #endif
    }
    
    
    func zoomInSession(){
        if (zoom <= 4.5){
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

//    @objc private func toggleSouondMuteState(_ sender: UIButton) {
//        self.needsMute.toggle()
//
//        let data = setUpButtonLabel(buttonType: .sound)
//        sender.setTitle(data.title, for: .normal)
//        sender.backgroundColor = data.color
//    }
    
//  MARK: - Send Video Streaming
    @objc private func toggleSendVideoData(_ sender: UIButton) {
//        #if !targetEnvironment(simulator)
        if sendString == "camera"{
            liveSetupView.lblRecordingTiming.isHidden = true
            liveSetupView.lblRecording.textColor = .white
            liveSetupView.lblFilmingDevice.text = "CAPTURE DEVICE"
            liveSetupView.lblRecording.text = "PHOTO"
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
//
//                sender.setImage(UIImage(named: "stop_video_recording_icon"), for: .normal)
//                self.saveImageAlertVC()
//
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
//            if videochampManager.videochamp_sharedManager.redirectType == .remote{
//                if sender.image(for: .normal) ==  UIImage(named: "stop_video_recording_icon")  {
//
//                }else{
////                    self.saveImageAlertVC()
////                    UIApplication.topViewController()?.showToast(message: "Video captured", font: .systemFont(ofSize: 16.0))
//                }
//            }else{
//
//                UIApplication.topViewController()?.showToast(message: "Start Recording...", font: .systemFont(ofSize: 16.0))
//            }
            do {
                if sender.image(for: .normal) == UIImage(named: "stop_video_recording_icon") {
                    liveSetupView.lblRecording.textColor = .red
                    liveSetupView.lblRecording.text = "RECORDING"
                    self.liveSetupView.lblRecordingTiming.isHidden = false
                    sendString = "startRecording"
                    self.startTimer()
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
                    
                 //   self.saveImageAlertVC()
                    UIApplication.topViewController()?.showToast(message: "Media has been saved in your CAMERA device gallery", font: .systemFont(ofSize: 16.0))
//                    self.saveImageAlertVC()
                    sendString = "stopRecording"
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopRecording"), object: nil)
//                    self.stopTimer()
                    self.resetTimerToZero()
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
        if zoom > 0.5 {
            zoom -= 0.5
            zoomText -= 1
            liveSetupView.lblZoom.text = "\(zoomText)x"
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
        else{
            
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
//            print(self.capSession?.outputs)
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
            @unknown default:
                fatalError()
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


extension LiveViewModel {
    fileprivate func startTimer(){
        
        // if you want the timer to reset to 0 every time the user presses record you can uncomment out either of these 2 lines

        // timeSec = 0
        // timeMin = 0

        // If you don't use the 2 lines above then the timer will continue from whatever time it was stopped at
        let timeNow = String(format: "%02d:%02d", timeMin, timeSec)
//        yourLabel.text = timeNow
        liveSetupView.lblRecordingTiming.text = timeNow
//        recordingIconView.image = UIImage(named: "iconRecordingNew")

//        stopTimer() // stop it at it's current time before starting it again
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                    self?.timerTick()
                }
    }
    
    @objc fileprivate func timerTick(){
         timeSec += 1
            
         if timeSec == 60{
             timeSec = 0
             timeMin += 1
         }
            
         let timeNow = String(format: "%02d:%02d", timeMin, timeSec)
            
        liveSetupView.lblRecordingTiming.text = timeNow
    }
    
    
    
    @objc fileprivate func resetTimerToZero(){
         timeSec = 0
         timeMin = 0
         stopTimer()
    }

    // if you need to reset the timer to 0 and yourLabel.txt back to 00:00
    @objc func resetTimerAndLabel(){
         resetTimerToZero()
        liveSetupView.lblRecordingTiming.text = String(format: "%02d:%02d", timeMin, timeSec)
    }

    // stops the timer at it's current time
    @objc func stopTimer(){
        timer?.invalidate()
        liveSetupView.lblRecordingTiming.text = "00:00:00"
    }
}



//extension UIDevice {
//
//    func totalDiskSpaceInBytes() -> Int64 {
//        do {
//            guard let totalDiskSpaceInBytes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())[FileAttributeKey.systemSize] as? Int64 else {
//                return 0
//            }
//            return totalDiskSpaceInBytes
//        } catch {
//            return 0
//        }
//    }
//
//    func freeDiskSpaceInBytes() -> Int64 {
//        do {
//            guard let totalDiskSpaceInBytes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())[FileAttributeKey.systemFreeSize] as? Int64 else {
//                return 0
//            }
//            return totalDiskSpaceInBytes
//        } catch {
//            return 0
//        }
//    }
//
//    func usedDiskSpaceInBytes() -> Int64 {
//        return totalDiskSpaceInBytes() - freeDiskSpaceInBytes()
//    }
//
//    func totalDiskSpace() -> String {
//        let diskSpaceInBytes = totalDiskSpaceInBytes()
//        if diskSpaceInBytes > 0 {
//            return ByteCountFormatter.string(fromByteCount: diskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.binary)
//        }
//        return "The total disk space on this device is unknown"
//    }
//
//    func freeDiskSpace() -> String {
//        let freeSpaceInBytes = freeDiskSpaceInBytes()
//        if freeSpaceInBytes > 0 {
//            return ByteCountFormatter.string(fromByteCount: freeSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.binary)
//        }
//        return "The free disk space on this device is unknown"
//    }
//
//    func usedDiskSpace() -> String {
//        let usedSpaceInBytes = totalDiskSpaceInBytes() - freeDiskSpaceInBytes()
//        if usedSpaceInBytes > 0 {
//            return ByteCountFormatter.string(fromByteCount: usedSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.binary)
//        }
//        return "The used disk space on this device is unknown"
//    }
//
//}

extension UIDevice {
    func MBFormatter(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = ByteCountFormatter.Units.useMB
        formatter.countStyle = ByteCountFormatter.CountStyle.decimal
        formatter.includesUnit = false
        return formatter.string(fromByteCount: bytes) as String
    }
    
    //MARK: Get String Value
    var totalDiskSpaceInGB:String {
       return ByteCountFormatter.string(fromByteCount: totalDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.decimal)
    }
    
    var freeDiskSpaceInGB:String {
        return ByteCountFormatter.string(fromByteCount: freeDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.decimal)
    }
    
    var usedDiskSpaceInGB:String {
        return ByteCountFormatter.string(fromByteCount: usedDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.decimal)
    }
    
    var totalDiskSpaceInMB:String {
        return MBFormatter(totalDiskSpaceInBytes)
    }
    
    var freeDiskSpaceInMB:String {
        return MBFormatter(freeDiskSpaceInBytes)
    }
    
    var usedDiskSpaceInMB:String {
        return MBFormatter(usedDiskSpaceInBytes)
    }
    
    //MARK: Get raw value
    var totalDiskSpaceInBytes:Int64 {
        guard let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
            let space = (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value else { return 0 }
        return space
    }
    
    /*
     Total available capacity in bytes for "Important" resources, including space expected to be cleared by purging non-essential and cached resources. "Important" means something that the user or application clearly expects to be present on the local system, but is ultimately replaceable. This would include items that the user has explicitly requested via the UI, and resources that an application requires in order to provide functionality.
     Examples: A video that the user has explicitly requested to watch but has not yet finished watching or an audio file that the user has requested to download.
     This value should not be used in determining if there is room for an irreplaceable resource. In the case of irreplaceable resources, always attempt to save the resource regardless of available capacity and handle failure as gracefully as possible.
     */
    var freeDiskSpaceInBytes:Int64 {
        if #available(iOS 11.0, *) {
            if let space = try? URL(fileURLWithPath: NSHomeDirectory() as String).resourceValues(forKeys: [URLResourceKey.volumeAvailableCapacityForImportantUsageKey]).volumeAvailableCapacityForImportantUsage {
                return space ?? 0
            } else {
                return 0
            }
        } else {
            if let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
            let freeSpace = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value {
                return freeSpace
            } else {
                return 0
            }
        }
    }
    
    var usedDiskSpaceInBytes:Int64 {
       return totalDiskSpaceInBytes - freeDiskSpaceInBytes
    }

}
