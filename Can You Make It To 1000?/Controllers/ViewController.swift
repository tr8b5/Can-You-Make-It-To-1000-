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
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var Tutorial: UIButton!
    
    @IBOutlet var videoLayer: UIView!
    var player: AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playVideo()
        
        // Do any additional setup after loading the view.
        
        //This is the stroke color
        let color1 = hexStringToUIColor(hex: "#bbe1fa")
        
        //This adds stroke to the Title Text
        let attrString = NSAttributedString(
            string: titleLabel.text!,
            attributes: [
                //bbe1fa
                NSAttributedString.Key.strokeColor: color1,
                NSAttributedString.Key.strokeWidth: -3.0,
            ]
        )
        titleLabel.attributedText = attrString
        
        soundButton.alpha = 0.25
        Tutorial.alpha = 0.25
        
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

