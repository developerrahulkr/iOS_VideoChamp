//
//  SampleBufferCamera.swift
//  MultipeerLiveKit
//
//  Created by hayaoMac on 2019/03/11.
//  Copyright © 2019年 Takashi Miyazaki. All rights reserved.
//

import AVFoundation
import Photos
import UIKit
import SwiftyCam





class SampleBufferCamera: NSObject, VideoDataOutputDelegate, AVCaptureAudioDataOutputSampleBufferDelegate, AVCaptureFileOutputRecordingDelegate {

    private var captureDevice: AVCaptureDevice!
    private var captureAudio :AVCaptureDevice?
    var captureSession: AVCaptureSession!
    private var mediaType: AVMediaType = .video
    private var captureVideoDataOutput: AVCaptureVideoDataOutput!
    private var defualtCameraDeviceType: AVCaptureDevice.DeviceType = .builtInWideAngleCamera
    private let queue = DispatchQueue.init(label: "com.hayao.MultipeerLiveKit.videodata-ouput-queue")
    private let audioqueue = DispatchQueue.init(label: "com.hayao.MultipeerLiveKit.audioData-ouput-queue")
    var movieOutput = AVCaptureMovieFileOutput()
    private let captureDurationTime = CMTime(value: 1, timescale: 30)
    private var sessionPreset: AVCaptureSession.Preset
    private (set) var resultBuffer: CMSampleBuffer!
    var zoomScaleRange: ClosedRange<CGFloat> = 1...10
    var position: AVCaptureDevice.Position
    
    
    
    init(initPosition: AVCaptureDevice.Position, sessionPreset: AVCaptureSession.Preset) {
        self.position = initPosition
        self.sessionPreset = sessionPreset
    }
    
    func initUpMovieCamera() throws -> AVCaptureSession? {
        captureSession = AVCaptureSession()
        try setUpDevice()
        try setUpCameraInput()
        setUpVideoDataOutput()
        setVideoDataSetting()
        VideoChampVideoDataOutput.shared_videoData.setUp()
        let cap = captureSessionStart()
        return cap
    }
    
    func captureSessionStart() -> AVCaptureSession? {
        guard captureSession.isRunning == false else {return AVCaptureSession()}
        captureSession.startRunning()
        captureVideoDataOutput.setSampleBufferDelegate(self, queue: queue)
        return captureSession
    }
    
    func captureSessionStop() {
        guard captureSession.isRunning else {return}
        captureSession.stopRunning()
    }
    
    func toggleCameraPosition() throws {
        position = position == .back ? .front : .back
        deinitCaptureSession()
        try initUpMovieCamera()
    }
    
    func deinitCaptureSession() {
        captureSessionStop()
        captureVideoDataOutput = nil
        captureSession.inputs.forEach {self.captureSession.removeInput($0)}
        captureSession.outputs.forEach {self.captureSession.removeOutput($0)}
        captureSession = nil
    }
    
    private func setVideoDataSetting() {
        captureDevice.activeVideoMinFrameDuration = captureDurationTime
        captureSession.sessionPreset = sessionPreset
    }
    
    private func setUpDevice() throws {
        let avCaptureDeviceType: [AVCaptureDevice.DeviceType] = [.builtInMicrophone, defualtCameraDeviceType]
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: avCaptureDeviceType, mediaType: mediaType, position: position)
        
        let devices = deviceDiscoverySession.devices
        for device in devices {
            if device.position == position {
                self.captureDevice = device
                break
            }
        }
        if captureDevice == nil {
            throw CameraError.canNotGetDevice
        }
    }
    
    
    //    private func setupCameraPinchGesture() throws {
    //        guard let device = captureDevice else { return }
    //
    //        let minAvailableZoomScale = device.minAvailableVideoZoomFactor
    //        let maxAvailableZoomScale = device.maxAvailableVideoZoomFactor
    //        let availableZoomScaleRange = minAvailableZoomScale...maxAvailableZoomScale
    //        let resolvedZoomScaleRange = zoomScaleRange.clamped(to: availableZoomScaleRange)
    //
    //        let resolvedScale = max(resolvedZoomScaleRange.lowerBound, min(pinch.scale * initialScale, resolvedZoomScaleRange.upperBound))
    //        configCamera(device) { device in
    //            device.videoZoomFactor = resolvedScale
    //        }
    //    }
    
    
    
    private func setUpCameraInput() throws {
        
        let captureDeviceInput = try AVCaptureDeviceInput.init(device: captureDevice)
        captureSession.addInput(captureDeviceInput)
        
    }
    
    private func setUpVideoDataOutput() {
       // captureSession.commitConfiguration()
        captureVideoDataOutput = AVCaptureVideoDataOutput()
        captureSession.addOutput(captureVideoDataOutput)
//        captureSession.addOutput(movieOutput)
    }
    
}
extension SampleBufferCamera: AVCaptureVideoDataOutputSampleBufferDelegate {

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        self.resultBuffer = sampleBuffer
        let timestamp = CMSampleBufferGetPresentationTimeStamp(self.resultBuffer).seconds
        switch VideoChampVideoDataOutput.shared_videoData._captureState {
            
        case .idle:
            
            break
            
            
        case .start:
            // Set up recorder
            VideoChampVideoDataOutput.shared_videoData._filename = UUID().uuidString
            let videoPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(VideoChampVideoDataOutput.shared_videoData._filename).mov")
            
            let writer = try! AVAssetWriter(outputURL: videoPath, fileType: .mov)
            let settings = (captureSession.outputs[0] as! AVCaptureVideoDataOutput).recommendedVideoSettingsForAssetWriter(writingTo: .mov)
            let input = AVAssetWriterInput(mediaType: .video, outputSettings: settings)
            
            // [AVVideoCodecKey: AVVideoCodecType.h264, AVVideoWidthKey: 1920, AVVideoHeightKey: 1080])
            input.mediaTimeScale = CMTimeScale(bitPattern: 600)
            input.expectsMediaDataInRealTime = true
            input.transform = CGAffineTransform(rotationAngle: .pi/2)
            if writer.canAdd(input) {
                writer.add(input)
            }

//            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//            let fileUrl = paths[0].appendingPathComponent("output.mov")
//            try? FileManager.default.removeItem(at: fileUrl)
//            movieOutput.startRecording(to: fileUrl, recordingDelegate: self as AVCaptureFileOutputRecordingDelegate)
            VideoChampVideoDataOutput.shared_videoData._assetWriter = writer
            VideoChampVideoDataOutput.shared_videoData._assetWriterInput = input
            VideoChampVideoDataOutput.shared_videoData._captureState = .capturing
            VideoChampVideoDataOutput.shared_videoData._time = timestamp
            let adapter = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: input, sourcePixelBufferAttributes: nil)
            writer.startWriting()
            writer.startSession(atSourceTime: .zero)
            VideoChampVideoDataOutput.shared_videoData._adpater = adapter
            
        case .capturing:
            print("capturing FUNC Call.............")
            if VideoChampVideoDataOutput.shared_videoData._assetWriterInput?.isReadyForMoreMediaData == true {
                let time = CMTime(seconds: timestamp - VideoChampVideoDataOutput.shared_videoData._time, preferredTimescale: CMTimeScale(600))
                VideoChampVideoDataOutput.shared_videoData._adpater?.append(CMSampleBufferGetImageBuffer(sampleBuffer)!, withPresentationTime: time)
            }
            break
            
            
        case .end:
            guard VideoChampVideoDataOutput.shared_videoData._assetWriterInput?.isReadyForMoreMediaData == true, VideoChampVideoDataOutput.shared_videoData._assetWriter!.status != .failed else { break }
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(VideoChampVideoDataOutput.shared_videoData._filename).mov")
            print("Final Url ::::::::::::::::::::::::::::::::::::::  \(url)")
            VideoChampVideoDataOutput.shared_videoData._assetWriterInput?.markAsFinished()
            VideoChampVideoDataOutput.shared_videoData._assetWriter?.finishWriting { [weak self] in
            VideoChampVideoDataOutput.shared_videoData._captureState = .idle
            VideoChampVideoDataOutput.shared_videoData._assetWriter = nil
            VideoChampVideoDataOutput.shared_videoData._assetWriterInput = nil
            UISaveVideoAtPathToSavedPhotosAlbum(url.path, nil, nil, nil)
            }
        }
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!){
        // save video to camera roll
        if error == nil {
            captureSession.stopRunning()
            UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, nil, nil, nil)
            
        }
        
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if error == nil {
        captureSession.stopRunning()
        UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, nil, nil, nil)

        }
    }
    
    
}







