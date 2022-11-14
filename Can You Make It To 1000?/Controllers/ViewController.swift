//
//  ViewController.swift
//  Can You Make It To 1000?
//
//  Created by William Miller on 2/12/20.
//  Copyright © 2020 William Miller. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMobileAds
import GameKit

class ViewController: UIViewController {
    
    var sound = Sound()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var tutorialButton: UIButton!
    @IBOutlet weak var rankGameButton: UIButton!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet var fxLabel: UILabel!
    @IBOutlet var soundLabel: UILabel!
    @IBOutlet weak var Tutorial: UIButton!
    @IBOutlet weak var fxButton: UIButton!
    @IBOutlet weak var tutorialButtonOn: UIImageView!
    
    @IBOutlet var videoLayer: UIView!
    var player: AVPlayer!
    var gameNumber = 0
    var tutorialOn: Bool!
    var soundOn: Bool!
    var shouldShowGameScreen =  false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        
        assignbackground()
       
        //Plays background video
        //playVideo()
        
        // Do any additional setup after loading the view.
        
        //This is the stroke color
        let color1 = hexStringToUIColor(hex: "#000000")
                
        //Load game number
        let defaults: UserDefaults = UserDefaults.standard
        gameNumber = defaults.value(forKey: "gameNumber") as? Int ?? 0
        //if game number = 0 make defaults tutorial on
        
        sound.loadSound()
        sound.loadFx()
                
        if (sound.sound == false) {
            soundButton.setImage(nil, for: .normal)
        } else {
            soundButton.setImage(UIImage(named: "plain_white_button"), for: .normal)
            MusicPlayer.shared.startBackgroundMusics(backgroundMusicFileName: "APPSBYWILL2")
            MusicPlayer.shared.speedUpBackgroundMusic()
        }
        
        if (sound.fx == false) {
            fxButton.setImage(nil, for: .normal)
        } else {
            fxButton.setImage(UIImage(named: "plain_white_button"), for: .normal)
        }
        
        if shouldShowGameScreen{
            playButtonClicked("")
            
        }
        
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
        try? AVAudioSession.sharedInstance().setActive(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let defaults: UserDefaults = UserDefaults.standard

        // Check if the user had accepted the disclaimer
        guard let accepted = defaults.value(forKey: Constants.disclaimerAccepted) as? String,
              accepted == "1"
        else {
            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "DisclaimerViewController") as? DisclaimerViewController {
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true)
            }
            return
        }
        authenticatePlayer()
    }
    
    func assignbackground(){
            let background = UIImage(named: "Background")

            var imageView : UIImageView!
            imageView = UIImageView(frame: view.bounds)
            imageView.contentMode =  UIView.ContentMode.scaleAspectFill
            imageView.clipsToBounds = true
            imageView.image = background
            imageView.center = view.center
            imageView.alpha = 0.5;
            view.addSubview(imageView)
            self.view.sendSubviewToBack(imageView)
        
            
            
        
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
    
    @IBAction func fx(_ sender: Any) {
        
        if (sound.fx == false) {
            sound.fx = true;
            fxButton.setImage(UIImage(named: "plain_white_button"), for: .normal)
            sound.saveFx()
            return
        }
        if (sound.fx == true) {
            sound.fx = false;
            fxButton.setImage(nil, for: .normal)
            sound.saveFx()
            return
        }
    }
    
    @IBAction func soundButton(_ sender: Any) {
        
        if (sound.sound == false) {
            sound.sound = true;
            MusicPlayer.shared.startBackgroundMusics(backgroundMusicFileName: "APPSBYWILL2")
            MusicPlayer.shared.speedUpBackgroundMusic()
            soundButton.setImage(UIImage(named: "plain_white_button"), for: .normal)
            sound.saveSound()
            return
        }
        if (sound.sound == true) {
            sound.sound = false;
            MusicPlayer.shared.stopBackgroundMusic()
            soundButton.setImage(nil, for: .normal)
            sound.saveSound()
            return
        }
    }
    
    @IBAction func playButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "goToGame", sender: self)
    }
    
    @IBAction func tutorialButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "goToTutorial", sender: self)
    }
    
    @IBAction func rankGameButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "goToTutorial", sender: self)
    }
    
    @IBAction func shareButtonClicked(_ sender: Any) {
        openShare(applink: "https://github.com/tr8b5/Can-You-Make-It-To-1000-", message: "join thousand of other players in this challenge")
    }
    
    @IBAction func leaderboardButtonClicked(_ sender: Any) {
        if Constants.gcEnabled {
            openLeaderboard()
        } else {
            UIAlertController.show("Please wait while leaderboard is being prepared", from: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToGame" {
            
        }
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(0.3)
        )
    }

    func openShare(applink: String, message: String) {
        let appLink = NSURL(string: applink)
        let shareAll = [appLink] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll as [Any], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
}

