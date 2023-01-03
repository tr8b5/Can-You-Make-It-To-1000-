//
//  VideoRecording.swift
//  Can You Make It To 1000?
//
//  Created by Ashutosh Bhatt on 30/11/22.
//  Copyright © 2022 William Miller. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

class RecordingUtility {
    static let shared = RecordingUtility()
    var allowRecording = Bool()
    var timer: Timer?
    
    var secondsLogged = 0
    
    lazy var imagePickerController: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.cameraDevice = .front
        imagePicker.mediaTypes = [kUTTypeMovie as String]
        imagePicker.allowsEditing = false
        imagePicker.showsCameraControls = false
        return imagePicker
    }()
    
    func getDocumentsDirectory() throws -> URL? {
        // find all possible documents directories for this user
        let path = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)

        // just send back the first one, which ought to be the only one
        return path
    }
    
    func startRecordingTime() {
        secondsLogged = 0 // reset
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(logTime), userInfo: nil, repeats: true)
    }
    
    func stopRecordingTime() {
        timer?.invalidate()
        
        UserDefaults.standard.set(secondsLogged, forKey: Constants.loggedTime)
    }
    
    @objc func logTime() {
        secondsLogged += 1
    }
    
    var loggedTime: String {
        let loggedTime = UserDefaults.standard.integer(forKey: Constants.loggedTime)
        
        var time = ""
        
        if loggedTime <= 59 {
            if loggedTime < 10 {
                time = "00:0\(loggedTime)"
            } else {
                time = "00:\(loggedTime)"
            }
            
        } else {
            let minute = Double(Double(loggedTime) / 60)

            if loggedTime % 60 == 0 {
                if minute < 10 {
                    time = "0\(Int(minute)):00"
                } else {
                    time = "\(Int(minute)):00"
                }
            } else {
                let minutesStr = String(format: "%.2f", minute)
                let timeComponents = minutesStr.components(separatedBy: ".")
                
                let separatedMinute = Int(timeComponents.first!)
                let separatedSecond = Int(timeComponents.last!)
                
                var minutes = ""
                var seconds = ""
                
                if separatedMinute! < 10 {
                    minutes = "0\(separatedMinute!)"
                } else {
                    minutes = "\(separatedMinute!)"
                }
                
                if separatedSecond! < 10 {
                    seconds = "0\(separatedSecond!)"
                } else {
                    seconds = "\(separatedSecond!)"
                }
                
                time = "\(minutes):\(seconds)"
            }
        }
        return time
    }
}
