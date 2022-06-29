//
//  VideoChampVideoUutputDelegate.swift
//  MultipeerFramework
//
//  Created by Akshay_mac on 29/06/22.
//

import AVFoundation

class VideoChampVideoDataOutput {
    static let shared_videoData =  VideoChampVideoDataOutput()
     var _captureSession: AVCaptureSession?
     var _videoOutput: AVCaptureVideoDataOutput?
     var _assetWriter: AVAssetWriter?
     var _assetWriterInput: AVAssetWriterInput?
     var _adpater: AVAssetWriterInputPixelBufferAdaptor?
     var _filename = ""
    var _filePath : URL!
     var _time: Double = 0
     var outputFileLocation : URL!
    
    var isRecording = false
    
    var _captureState : _CaptureState = .idle
    
    func setUp(){
        NotificationCenter.default.addObserver(self, selector: #selector(startVideo), name: NSNotification.Name(rawValue: "startRecording"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(stopVideo), name: NSNotification.Name(rawValue: "stopRecording"), object: nil)
        
    }
    
    
    
    func setUpWriter() {

        do {
            outputFileLocation = videoFileLocation()
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
//
//            audioWriterInput.expectsMediaDataInRealTime = true
//
//            if videoWriter.canAdd(audioWriterInput!) {
//                videoWriter.add(audioWriterInput!)
//                print("audio input added")
//            }


            _assetWriter?.startWriting()
        } catch let error {
            debugPrint(error.localizedDescription)
        }


    }
    
    func canWrite() -> Bool {
        return isRecording && _assetWriter != nil && _assetWriter?.status == .writing
    }
    
    
    //video file location method
   func videoFileLocation() -> URL {
       let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
       let videoOutputUrl = URL(fileURLWithPath: documentsPath.appendingPathComponent("videoFile")).appendingPathExtension("mov")
       do {
       if FileManager.default.fileExists(atPath: videoOutputUrl.path) {
           try FileManager.default.removeItem(at: videoOutputUrl)
           print("file removed")
       }
       } catch {
           print(error)
       }

       return videoOutputUrl
   }
    
    @objc func stopVideo(_ notification: Notification){
        print("\(notification.object.debugDescription)")
        _captureState = .end
    }
    
    @objc func startVideo(_ notification: Notification){
        print("\(notification.object.debugDescription)")
        _captureState = .start
    }
    
    enum _CaptureState {
            case idle, start, capturing, end
        }
    
}
