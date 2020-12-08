//
//  GameOverViewController.swift
//  Can You Make It To 1000?
//
//  Created by William Miller on 2/29/20.
//  Copyright © 2020 William Miller. All rights reserved.
//

import UIKit
import AVFoundation

class GameOverViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    
    @IBOutlet var videoLayer: UIView!
    var player: AVPlayer!
    
    var gameView = GameViewController()
    var score: Int!
    var highscore = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playVideo()
        
        let defaults: UserDefaults = UserDefaults.standard
        highscore = defaults.value(forKey: "highscore") as? Int ?? 0
        highScoreLabel.text = "HIGHSCORE: \(String(highscore))"
        
        scoreLabel.text = "SCORE: \(String(score))"
        
        if score > highscore {
            highscore = score
            let defaults: UserDefaults = UserDefaults.standard
            defaults.set(highscore, forKey: "highscore")
            defaults.synchronize()
            highScoreLabel.text = "HIGHSCORE: \(String(highscore))"
        }
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
    
    @IBAction func tryButtonClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToGame", sender: self)
    }
    @IBAction func homeButtonClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToHome", sender: self)
    }
    
    
}
