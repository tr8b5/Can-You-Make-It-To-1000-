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

class VideoRecording {
    static let shared = VideoRecording()
    var allowRecording = Bool()
    
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
}
