//
//  ViewController.swift
//  Can You Make It To 1000?
//
//  Created by William Miller on 2/12/20.
//  Copyright © 2020 William Miller. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var tutorialButton: UIButton!
    @IBOutlet weak var rankGameButton: UIButton!
    
    @IBOutlet var videoLayer: UIView!
    var player: AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playVideo()
        
        // Do any additional setup after loading the view.
        
        //This adds stroke to the Title Text
        let attrString = NSAttributedString(
            string: titleLabel.text!,
            attributes: [
                NSAttributedString.Key.strokeColor: UIColor.white,
                NSAttributedString.Key.strokeWidth: -2.0,
            ]
        )
        titleLabel.attributedText = attrString
        
    }
    
    func playVideo() {
        
        guard let path = Bundle.main.path(forResource:"Background", ofType: "mp4") else {
                return
        }
        
        player = AVPlayer(url: URL(fileURLWithPath: path))
        player.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.zPosition = -1
        self.videoLayer.layer.addSublayer(playerLayer)
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        player.seek(to: CMTime.zero)
        
        player.play()
        
        
    }
    
    @objc func playerItemDidReachEnd() {
        player.seek(to: CMTime.zero)
    }
    
    func removeTitleMenu() {
        titleLabel.removeFromSuperview()
        playButton.removeFromSuperview()
        //tutorialButton.removeFromSuperview()
        rankGameButton.removeFromSuperview()
    }
    
    @IBAction func playButtonClicked(_ sender: Any) {
        removeTitleMenu()
        self.performSegue(withIdentifier: "goToGame", sender: self)
    }
    
    @IBAction func tutorialButtonClicked(_ sender: Any) {
        removeTitleMenu()
        self.performSegue(withIdentifier: "goToTutorial", sender: self)
    }
    
    @IBAction func rankGameButtonClicked(_ sender: Any) {
        removeTitleMenu()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToGame" {
            
        }
    }

}

