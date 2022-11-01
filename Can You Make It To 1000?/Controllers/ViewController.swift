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
    @IBOutlet weak var soundButtonOn: UIImageView!
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
        
        //This adds stroke to the Title Text
        let attrString = NSAttributedString(
            string: titleLabel.text!,
            attributes: [
                //bbe1fa
                NSAttributedString.Key.strokeColor: color1,
                NSAttributedString.Key.strokeWidth: -6.0,
            ]
        )
        titleLabel.attributedText = attrString
        
        //Sets transparancy on button holders
        //soundButton.alpha = 0.25
        //Tutorial.alpha = 0.25
        
        //Load game number
        let defaults: UserDefaults = UserDefaults.standard
        gameNumber = defaults.value(forKey: "gameNumber") as? Int ?? 0
        //if game number = 0 make defaults tutorial on
        
        sound.loadSound()
        sound.loadFx()
        
        print("Game number: ", gameNumber)
        
        if (sound.fx == false) {
            tutorialButtonOn.alpha = 0
        }
        if (sound.sound == false) {
            soundButtonOn.alpha = 0
        } else {
            MusicPlayer.shared.startBackgroundMusics(backgroundMusicFileName: "APPSBYWILL2")
            MusicPlayer.shared.speedUpBackgroundMusic()
        }
        
        if shouldShowGameScreen{
            playButtonClicked("")
            
        }
        
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
        try? AVAudioSession.sharedInstance().setActive(true)
        
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
    
    @IBAction func Tutorial(_ sender: Any) {
        
        if (sound.fx == false) {
            sound.fx = true;
            tutorialButtonOn.alpha = 1
            sound.saveFx()
            return
        }
        if (sound.fx == true) {
            sound.fx = false;
            tutorialButtonOn.alpha = 0
            sound.saveFx()
            return
        }
        
    }
    
    @IBAction func soundButton(_ sender: Any) {
        
        if (sound.sound == false) {
            sound.sound = true;
            MusicPlayer.shared.startBackgroundMusics(backgroundMusicFileName: "APPSBYWILL2")
            MusicPlayer.shared.speedUpBackgroundMusic()
            soundButtonOn.alpha = 1
            sound.saveSound()
            return
        }
        if (sound.sound == true) {
            sound.sound = false;
            MusicPlayer.shared.stopBackgroundMusic()
            soundButtonOn.alpha = 0
            sound.saveSound()
            return
        }
        
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
        self.performSegue(withIdentifier: "goToTutorial", sender: self)
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

}

