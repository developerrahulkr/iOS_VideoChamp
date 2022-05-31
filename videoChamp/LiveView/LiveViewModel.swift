//
//  ViewModel.swift
//  MultiPeerLiveKitDemo
//
//  Created by hayaoMac on 2019/03/11.
//  Copyright © 2019年 Takashi Miyazaki. All rights reserved.
//

import MultipeerConnectivity
//import MultipeerLiveKit
import MFrameWork
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
    
    
    private var liveSetupView : LiveView!

    public var capSession : AVCaptureSession!
    private var needsMute = false
    private let onColor: UIColor = .red
    private let offColor: UIColor = .black
    private let cameraFrontLabel = "front"
    private let cameraBackLabel = "back"
    private let sendTextButtonTitle = "send text"

    
    
    private enum ButtonType {
        case sound
        case sendVideo
    }

    
    
    typealias ButtonDisplayData = (title: String, color: UIColor)

    private lazy var soundBtnData: [Bool: ButtonDisplayData]    = [true: ("Sound ON", onColor), false: ("...", offColor)]
    private lazy var publishBtnData: [Bool: ButtonDisplayData]  = [true: ("start_video_recording_icon", onColor), false: ("stop_video_recording_icon", offColor)]


    
    init(targetPeerID: MCPeerID?, mcSessionManager: MCSessionManager,
         sendVideoInterval:TimeInterval,videoCompressionQuality:CGFloat,
         sessionPreset:AVCaptureSession.Preset = .low) throws {
        
        
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
        
        attachButtonActions(liveView)
        attachDisplayData(liveView)
//        let data = publishBtnData[livePresenter.needsVideoRun]!
        capSession = livePresenter.cap
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
            self.capSession = nil
            liveView.imageView.layer.sublayers = nil
            DispatchQueue.main.async {
//                print("Battery Percentage is : \(batterPercentage)")
                liveView.imageView.image = image
                liveView.cameraControlButton.isUserInteractionEnabled = false
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
                    liveView.imageView.contentMode = .scaleAspectFill
                    liveView.lblZoom.text = "2x"
                case "zoomOut" :
                    liveView.imageView.contentMode = .scaleAspectFit
                    liveView.lblZoom.text = "1x"
                case "low":
                    let alert = UIAlertController(title: "VideoChamp", message: "Battry is Low", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    UIApplication.topViewController()?.present(alert, animated: true)
                    
                default :
                    let image = UIImage(data: msg)
                    print(image)
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
        
    }

    private func attachButtonActions(_ liveView: LiveView) {

        liveView.soundControlButton.addTarget(self, action: #selector(toggleSouondMuteState(_:)), for: .touchUpInside)
        liveView.changeCameraButton.addTarget(self, action: #selector(cameraToggle(_:)), for: .touchUpInside)
        liveView.cameraControlButton.addTarget(self, action: #selector(toggleSendVideoData(_:)), for: .touchUpInside)
        liveView.textSendButton.addTarget(self, action: #selector(zoomInImage), for: .touchUpInside)
        liveView.sendTextField.addTarget(self, action: #selector(onchangedTextField(_:)), for: .editingChanged)
        liveView.btnBack.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        liveView.btnClose.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        liveView.btnCamera.addTarget(self, action: #selector(captureFrames(_:)), for: .touchUpInside)

    }
    @objc func captureFrames(_ sender: UIButton){
//        liveSetupView.imageCapture.image = liveSetupView.imageView.image
        
//        savePic()
        
        do {
            sendImage = liveSetupView.imageView.image ?? UIImage()
            print("send String : \(sendImage)")
            let imageData = sendImage.pngData()
            try livePresenter.send(text: imageData ?? Data(), sendMode: .reliable)
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
    @objc func closeVC(){
        print("Close Tab")
        UIApplication.topViewController()?.navigationController?.popViewController(animated: true)
    }

    private func attachDisplayData(_ liveView: LiveView) {

        liveSetupView = liveView
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
        liveView.lblZoom.layer.cornerRadius = liveView.lblZoom.bounds.height/2
        liveView.lblZoom.layer.borderColor = UIColor.white.cgColor
        liveView.lblZoom.layer.borderWidth = 0.5
        liveView.lblZoom.textAlignment = .center
   
        //colors
//        liveView.imageCapture.backgroundColor = .blue
        liveView.imageCapture.isHidden = true
        liveView.imageView.backgroundColor = .black
        liveView.receivedTextLabel.backgroundColor = .white
        liveView.soundControlButton.backgroundColor = soundBtnData.color
        liveView.soundControlButton.isHidden = true
        liveView.sendTextField.backgroundColor = .white
        liveView.sendTextField.isHidden = true
        liveView.textSendButton.setTitleColor(onColor, for: .highlighted)
//        liveView.btnCamera.isUserInteractionEnabled = false
        // others
        liveView.imageView.contentMode = .scaleAspectFill
        liveView.receivedTextLabel.adjustsFontSizeToFitWidth = true
        liveView.soundControlButton.layer.opacity = 0.5
        liveView.textSendButton.titleLabel?.adjustsFontSizeToFitWidth = true

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
            liveSetupView.imageView.contentMode = .scaleAspectFill
            zooomImageString = "zoomIn"
            try livePresenter.sendText(text: zooomImageString, sendMode: .unreliable)
        } catch let error {
            print(error)
        }
        
        
        
        
        
        #endif
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
        livePresenter.needsVideoRun.toggle()
        
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
//        sender.backgroundColor = data.color
        #endif
    }

    @objc private func zoomInImage() {
//        do {
//
//            sendImage = liveSetupView.imageView.image ?? UIImage()
//            print("send String : \(sendImage)")
//            let imageData = sendImage.pngData()
//            try livePresenter.send(text: imageData ?? Data(), sendMode: .reliable)
//        } catch let error {
//            print(error)
//        }
        
        
        do {
            liveSetupView.imageView.contentMode = .scaleAspectFit
            zooomImageString = "ZoomOut"
            try livePresenter.sendText(text: zooomImageString, sendMode: .unreliable)
        } catch let error {
            print(error)
        }
        
        
    }
    
    

    @objc private func onchangedTextField(_ sender: UITextField) {
        sendString = "saveImage"
    }

    deinit {
         //print("deinit:LiveViewModel")
    }
}
