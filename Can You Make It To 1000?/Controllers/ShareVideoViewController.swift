//
//  ShareVideoViewController.swift
//  Can You Make It To 1000?
//
//  Created by Ashutosh Bhatt on 03/12/22.
//  Copyright © 2022 William Miller. All rights reserved.
//

import UIKit
import AVKit
import DPVideoMerger_Swift

class ShareVideoViewController: UIViewController {
    @IBOutlet weak var videoContainer: UIView!
    var videoURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var fileURL1: URL?
        var fileURL2: URL?
        
        if let directory =  try? VideoRecording.shared.getDocumentsDirectory() {
            if #available(iOS 16.0, *) {
                fileURL1 = directory.appending(components: "screen_recording.mov")
                
            } else {
                fileURL1 = directory.appendingPathComponent("screen_recording.mov")
            }
        }
        
        if let directory =  try? VideoRecording.shared.getDocumentsDirectory() {
            if #available(iOS 16.0, *) {
                fileURL2 = directory.appending(components: "user_recording.mov")
                
            } else {
                fileURL2 = directory.appendingPathComponent("user_recording.mov")
            }
        }
        DPVideoMerger().parallelMergeVideos(withFileURLs: [fileURL2!, fileURL1!], videoResolution: CGSize(width: 500, height: 500)) { mergedVideoURL, error in
            if error != nil {
                    let errorMessage = "Could not merge videos: \(error?.localizedDescription ?? "error")"
                    let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (a) in
                    }))
                    self.present(alert, animated: true) {() -> Void in }
                    return
                }
            guard let url = mergedVideoURL else {
                let errorMessage = "Could not load video. Please try later!"
                let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (a) in
                }))
                self.present(alert, animated: true) {() -> Void in }

                return
            }
            self.videoURL = url
            
            let player = AVPlayer(url: url)
            var playerLayer: AVPlayerLayer?
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
            playerLayer!.frame = self.videoContainer.frame
            self.videoContainer.layer.addSublayer(playerLayer!)
            
            player.play()
        }
    }
    
    @IBAction func shareVideo() {
        if let url = videoURL {
            let activityItems: [Any] = [url, "Check this out!"]

            let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancel() {
        self.dismiss(animated: true)
    }
}
