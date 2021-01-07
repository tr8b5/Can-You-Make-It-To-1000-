//
//  MusicPlayer.swift
//  Can You Make It To 1000?
//
//  Created by William Miller on 12/9/20.
//  Copyright © 2020 William Miller. All rights reserved.
//

import Foundation
import AVFoundation

class MusicPlayer {
    static let shared = MusicPlayer()
    var audioPlayer: AVAudioPlayer?
    
    func startBackgroundMusics(backgroundMusicFileName: String) {
        if let bundle = Bundle.main.path(forResource: backgroundMusicFileName, ofType: "mp3") {
            let backgroundMusic = NSURL(fileURLWithPath: bundle)
         do {
            audioPlayer = try AVAudioPlayer(contentsOf: backgroundMusic as URL)
            guard let audioPlayer = audioPlayer else { return }
            audioPlayer.numberOfLoops = -1
            audioPlayer.prepareToPlay()
            audioPlayer.rate = 2.0
            audioPlayer.play()
         } catch {
            print(error)
         }
        }
    }
    
    func stopBackgroundMusic() {
        guard let audioPlayer = audioPlayer else {return}
        audioPlayer.stop()
    }
    
    func speedUpBackgroundMusic() {
        guard let audioPlayer = audioPlayer else {return}
        audioPlayer.rate = 5.0
    }
    
    func playBackgroundMusic() {
        guard let audioPlayer = audioPlayer else {return}
        audioPlayer.play()
    }
    
}
