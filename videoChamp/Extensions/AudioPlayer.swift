//
//  AudioPlayer.swift
//  videoChamp
//
//  Created by Akshay_mac on 06/06/22.
//

import Foundation
import AVFoundation
import UIKit


class SoundPlayer {
    
    static let shared = SoundPlayer()
    
    
    var audioPlayer: AVAudioPlayer?
    
    func playAudioSound(name: String, volume: Float = 1.0) {
        if let path = Bundle.main.path(forResource: name, ofType: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.play()
                audioPlayer?.volume = volume
            } catch {
                print(error)
            }
        } else {
            print("No Path Found")
        }
    }
}

