//
//  GameOverViewController.swift
//  Can You Make It To 1000?
//
//  Created by William Miller on 2/29/20.
//  Copyright © 2020 William Miller. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMobileAds

class GameOverViewController: UIViewController {

    @IBOutlet weak var btnRevive: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var gameOverLabel: UILabel!
    
    @IBOutlet var videoLayer: UIView!
    var player: AVPlayer!
    
    var gameView = GameViewController()
    var score: Int!
    var highscore = 0
    private var interstitialAd: GADInterstitial?
    var rewardedAd: GADRewardedAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //playVideo()
        assignbackground()
        
        self.view.backgroundColor = UIColor.black
        
        
        let color1 = hexStringToUIColor(hex: "#000000")
        
        Constants.didRevive = false
        btnRevive.isHidden = !Constants.canRevive
        if !Constants.canRevive {Constants.canRevive = true}
        rewardedAd = GADRewardedAd(adUnitID: Constants.rewardAdId)
        rewardedAd?.load(GADRequest()) { error in
              if let error = error {
                print(error.localizedDescription)
                // Handle ad failed to load case.
              } else {
                // Ad successfully loaded.
              }
            }
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
        
        if score == 1000 {
            gameOverLabel.text = "Victory"
            gameOverLabel.textColor = UIColor.green
        }
        
        //This adds stroke to the Title Text
        let attrString = NSAttributedString(
            string: gameOverLabel.text!,
            attributes: [
                NSAttributedString.Key.strokeColor: color1,
                NSAttributedString.Key.strokeWidth: -6.0,
            ]
        )
        gameOverLabel.attributedText = attrString
        
        let attrString1 = NSAttributedString(
            string: highScoreLabel.text!,
            attributes: [
                NSAttributedString.Key.strokeColor: color1,
                NSAttributedString.Key.strokeWidth: -6.0,
            ]
        )
        highScoreLabel.attributedText = attrString1
        
        let attrString2 = NSAttributedString(
            string: scoreLabel.text!,
            attributes: [
                NSAttributedString.Key.strokeColor: color1,
                NSAttributedString.Key.strokeWidth: -6.0,
            ]
        )
        scoreLabel.attributedText = attrString2
        
         interstitialAd =  createAd()
        
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    func displayAd() {
        if interstitialAd?.isReady == true {
            interstitialAd?.present(fromRootViewController: self)
        } else {
            print("Ad Not Ready")
        }
    }
    
    private func createAd() -> GADInterstitial {
        let ad = GADInterstitial(adUnitID: Constants.interstitialAdId)
        ad.delegate = self
        ad.load(GADRequest())
        return ad
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
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func homeButtonClicked(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Home") as! ViewController
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
      
    }
    
    @IBAction func revive(_ sender: Any) {
        if rewardedAd?.isReady == true {
               rewardedAd?.present(fromRootViewController: self, delegate:self)
            }
    }
    
}

extension GameOverViewController : GADInterstitialDelegate{
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        ad.present(fromRootViewController: self)
    }
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print(error.localizedDescription)
    }
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        //print(error.localizedDescription)
    }

}

extension GameOverViewController : GADRewardedAdDelegate{
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        Constants.didRevive = true
        Constants.canRevive = false
        
    }
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        if Constants.didRevive{
            self.dismiss(animated: true, completion: nil)
        }
    }
}


