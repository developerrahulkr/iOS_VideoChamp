//
//  CameraUtilities.swift
//  videoChamp
//
//  Created by iOS Developer on 23/02/22.
//

import Foundation
import UIKit
import AVFoundation
import PhotosUI

class CameraUtilities {
    
    static let shared  = CameraUtilities()
    
    func checkCamraPermission(closure: @escaping (Bool)-> Void) {
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: // The user has previously granted access to the camera.
            closure(true)
            
        case .notDetermined: // The user has not yet been asked for camera access.
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    closure(true)
                } else {
                    self?.failedCameraAccess()
                    closure(false)
                }
            }
            
        case .denied: // The user has previously denied access.
            failedCameraAccess()
            closure(false)
            
        case .restricted: // The user can't grant access due to restrictions.
            failedCameraAccess()
            closure(false)
            
        @unknown default:
            failedCameraAccess()
            closure(false)
        }
        
    }
    
    func checkGalleryPermission(closure: @escaping (Bool)-> Void) {
        
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            closure(true)
            
        case .denied:
            failedGalleyAccess()
            closure(false)
            
        case .limited:
            failedGalleyAccess()
            closure(false)
            
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ [weak self] status in
                if status == .authorized{
                    closure(true)
                } else {
                    self?.failedGalleyAccess()
                    
                    closure(false)
                }
            })
            
            
            
        case .restricted:
            failedGalleyAccess()
            closure(false)
            
        @unknown default:
            failedGalleyAccess()
            closure(false)
        }
    }
    
    func failedCameraAccess(){
        UIApplication.topViewController()?.showAlert(alertMessage: "Camera Access Failed")
    }
    
    func failedGalleyAccess(){
        UIApplication.topViewController()?.showAlert(alertMessage: "Gallary Access Failed")
    }
}




