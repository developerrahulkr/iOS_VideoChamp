//
//  LiveView.swift
//  MultiPeerLiveKitDemo
//
//  Created by hayaoMac on 2019/03/11.
//  Copyright © 2019年 Takashi Miyazaki. All rights reserved.
//

import UIKit
//import SnapKitFrame
import SnapKit
import AVFoundation


final class LiveView: NSObject {
    var view: UIView!
    private let toHiddenKeyboardGesture:UITapGestureRecognizer = .init()
    let imageView = UIImageView()
    let sendTextField = UITextField()
    let textSendButton = UIButton()
    let changeCameraButton = UIButton()
    let cameraControlButton = UIButton()
    let buttonAreaStackView = UIStackView()
    let bottomView = UIView()
    let viewMedia = UIView()
    let textAreaStackView = UIStackView()
    let viewCenterStackView = UIView()
//    let soundControlButton = UIButton()
    let btnBack = UIButton()
    let btnClose = UIButton()
    let lblFilmingDevice = UILabel()
    let lblRecording = UILabel()
    let lblRecordingTiming = UILabel()
    let imageCapture = UIImageView()
    
    let buttonView = UIView()
    let btnStopCasting = UIButton()
    let topViewStackView = UIStackView()
    let btnCamera = UIButton()
    let btnVideo = UIButton()
    let viewZoom = UIView()
    let lblZoom = UILabel()
    
    //    Video PReview
    var previewLayer = AVCaptureVideoPreviewLayer()
    @objc private func toHiddenKeyboard() {
        self.view.endEditing(true)
    }

    private func setUpSoundGesture() {
        toHiddenKeyboardGesture.addTarget(self, action: #selector(toHiddenKeyboard))
        toHiddenKeyboardGesture.numberOfTapsRequired = 1
        imageView.isUserInteractionEnabled = true
        view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(toHiddenKeyboardGesture)
    }

    private func addViews() {
        view.addSubview(imageView)
        view.addSubview(textAreaStackView)
        view.addSubview(imageCapture)
        imageView.layer.addSublayer(previewLayer)
//        view.addSubview(buttonAreaStackView)
        view.addSubview(bottomView)
        view.addSubview(btnBack)
        view.addSubview(btnClose)
        bottomView.addSubview(viewMedia)
        bottomView.addSubview(buttonAreaStackView)
        viewMedia.addSubview(topViewStackView)
        view.addSubview(buttonView)

//        ViewTopStack.addSubview(topStackView)
        
        textAreaStackView.addArrangedSubview(sendTextField)
        buttonAreaStackView.addArrangedSubview(textSendButton)
        buttonAreaStackView.addArrangedSubview(viewCenterStackView)
        viewCenterStackView.addSubview(cameraControlButton)
        viewCenterStackView.addSubview(lblFilmingDevice)
        viewCenterStackView.addSubview(lblRecording)
        viewCenterStackView.addSubview(lblRecordingTiming)
        buttonAreaStackView.addArrangedSubview(changeCameraButton)
        topViewStackView.addArrangedSubview(btnCamera)
        topViewStackView.addArrangedSubview(btnVideo)
//        topViewStackView.addArrangedSubview(lblZoom)
        topViewStackView.addArrangedSubview(viewZoom)
        viewZoom.addSubview(lblZoom)
        buttonView.addSubview(btnStopCasting)
        
    }

    func setUpViews(frame: CGRect, margin: CGFloat) -> UIView {
        view = .init(frame: frame)
        addViews()
        
        imageCapture.snp.makeConstraints { make in
            make.top.equalTo(100)
            make.right.equalTo(20)
            make.height.width.equalTo(100.0)
        }
        
        lblZoom.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        topViewStackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        viewMedia.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(buttonAreaStackView.snp.top).offset(0)
            
        }
        buttonView.snp.makeConstraints { make in
            make.left.equalTo(40.0)
            make.bottom.equalToSuperview().offset(-20.0)
            make.right.equalTo(-40.0)
            make.height.equalTo(50.0)
        }
        
        
        btnBack.snp.makeConstraints { make in
//            make.height.width.equalTo(50.0)
            make.top.equalTo(40.0)
            make.left.equalTo(20.0)
        }
        cameraControlButton.snp.makeConstraints { make in
            make.top.equalTo(15.0)
            make.centerX.equalToSuperview()
        }
        lblFilmingDevice.snp.makeConstraints { make in
            make.centerX.equalTo(cameraControlButton)
            make.top.equalTo(cameraControlButton.snp.bottom).offset(2)
        }
        lblRecording.snp.makeConstraints { make in
            make.centerX.equalTo(cameraControlButton)
            make.top.equalTo(lblFilmingDevice.snp.bottom).offset(2)
        }
        
        btnStopCasting.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            
        }
        lblRecordingTiming.snp.makeConstraints { make in
            make.centerX.equalTo(cameraControlButton)
            make.top.equalTo(lblRecording.snp.bottom).offset(2)
        }
        
        
        btnClose.snp.makeConstraints { make in
            make.height.width.equalTo(18.0)
            make.centerY.equalTo(btnBack)
            make.right.equalTo(-20.0)
        }

        imageView.snp.makeConstraints { (make) in
            make.width.top.leading.equalToSuperview()
//            make.height.equalToSuperview().multipliedBy(0.68)
            make.height.equalToSuperview()
        }

        
        bottomView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
//            make.width.equalTo()
            make.height.equalToSuperview().multipliedBy(0.25)
            make.left.equalTo(imageView.snp.left)
            make.right.equalTo(imageView.snp.right)
            make.bottom.equalTo(imageView.snp.bottom).offset(-margin)
        }

        buttonAreaStackView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
//            make.width.equalTo(baseWidth)
//            make.top.equalTo(imageView.snp.bottom).offset(-margin * 10)
            make.height.equalToSuperview().multipliedBy(0.65)
//            make.bottom.equalTo(imageView.snp.bottom).offset(-margin)
            make.bottom.equalTo(-10.0)
            make.left.equalTo(30.0)
            make.right.equalTo(-30.0)
        }

        setUpViewProperties(margin: margin)
//        setUpSoundControlButton(margin: margin)
        setUpSoundGesture()
        setUpKeyboardObserver()

        return self.view
    }

//    MARK: -SetupView Data
    
    private func setUpViewProperties(margin: CGFloat) {

        previewLayer.frame = view.bounds
        view.backgroundColor = Colors.whiteFb
        lblZoom.textColor = .white
        lblZoom.font = UIFont.systemFont(ofSize: 10.0)
        
        viewZoom.backgroundColor = .clear
        
        buttonView.clipsToBounds = true
        buttonView.backgroundColor = .green
        buttonView.layer.cornerRadius = 25
        
        btnStopCasting.clipsToBounds = true
        btnStopCasting.setTitle("END CONNECTION", for: .normal)
        btnStopCasting.backgroundColor = .red
        btnStopCasting.setTitleColor(.white, for: .normal)
        btnStopCasting.titleLabel?.font = UIFont(name: "argentum-sans.bold", size: 20.0)
        btnStopCasting.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
        
//        previewLayer.backgroundColor = UIColor(red: 231/255, green: 10/255, blue: 150/255, alpha: 1.0).cgColor
        
        viewZoom.clipsToBounds = true
        viewZoom.layer.cornerRadius = 12
        viewZoom.layer.borderColor = UIColor.white.cgColor
        viewZoom.layer.borderWidth = 0.5
//        imageCapture.layer.addSublayer(previewLayer)
        btnBack.setImage(UIImage(named: "back_arrow"), for: .normal)
        btnClose.setImage(UIImage(named: "close_icon"), for: .normal)
        
        textAreaStackView.axis = .vertical
        textAreaStackView.distribution = .fillProportionally
        textAreaStackView.spacing = margin

        bottomView.backgroundColor = .darkGray
        bottomView.layer.opacity = 0.6
        sendTextField.delegate = self

        buttonAreaStackView.axis = .horizontal
        topViewStackView.axis = .horizontal
        
        lblFilmingDevice.font = UIFont(name: "ArgentumSans-Regular", size: 6.0)
        lblFilmingDevice.font = UIFont.systemFont(ofSize: 10.0)
        
        lblRecording.font = UIFont(name: "ArgentumSans-Regular", size: 6.0)
        lblRecording.font = UIFont.systemFont(ofSize: 10.0)
        lblRecording.textColor = .white
        
        lblRecordingTiming.font = UIFont(name: "ArgentumSans-Regular", size: 6.0)
        lblRecordingTiming.textColor = .white
        lblRecordingTiming.font = UIFont.systemFont(ofSize: 10.0)
        
        lblFilmingDevice.textColor = .white
        
//        buttonAreaStackView.layer.opacity = 0.4
        buttonAreaStackView.distribution = .fillEqually
        buttonAreaStackView.spacing = 20.0
        
        topViewStackView.distribution = .fillEqually
        topViewStackView.spacing = 30.0
        
        
        
//        lblZoom.snp.makeConstraints { make in
//            make.edges.equalTo(lblZoom)
//        }

        textAreaStackView.arrangedSubviews.forEach {
            $0.toRoundly(margin)
        }

        buttonAreaStackView.arrangedSubviews.forEach {
//            $0.backgroundColor = .gray
            $0.toRoundly(margin)
        }
    }
}

extension LiveView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension LiveView {
    @objc func keyboardWillShow(notification: Notification?) {
        guard
            let duration: TimeInterval = notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let keyBoardRect = (notification?.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
            else {
                return
        }

        let keyboardHeight = keyBoardRect.height
        UIView.animate(withDuration: duration, animations: {[weak self]  in
            let transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
            self?.view.transform = transform
        })
    }

    @objc func keyboardWillHide(notification: Notification?) {
        guard
            let duration: TimeInterval = notification?.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Double
            else {
                return
        }
        UIView.animate(withDuration: duration, animations: {[weak self]  in
            self?.view.transform = CGAffineTransform.identity
        })
    }

    private func setUpKeyboardObserver() {
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func removeKeyboardObserver() {
        let notification = NotificationCenter.default
        notification.removeObserver(self)
    }
}
