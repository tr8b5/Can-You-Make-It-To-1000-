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
import ReplayKit
import AVKit
import DPVideoMerger_Swift

class GameOverViewController: UIViewController, RPPreviewViewControllerDelegate {

    @IBOutlet weak var btnRevive: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet var videoLayer: UIView!
    
    var player: AVPlayer!
    
    var gameView = GameViewController()
    var score: Int!
    var highscore = 0
    private var interstitialAd: GADInterstitial?
    var rewardedAd: GADRewardedAd?
    var didTimeUp: Bool = false
    var attemptsLeft: Int = 0
    
    var sound = Sound()

    override func viewDidLoad() {
        super.viewDidLoad()
        sound.loadSound()

        assignbackground()
        
        btnRevive.isHidden = !Constants.canRevive
        if !Constants.canRevive {Constants.canRevive = true}

        self.view.backgroundColor = UIColor.black
        
        
        let color1 = hexStringToUIColor(hex: "#000000")
        
        Constants.didRevive = false
        
        getInterstitialAd()
        self.getRewardedAd()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if self.didTimeUp {
                self.displayAd()
            } else if self.attemptsLeft == 0 {
                self.displayAd()
            }
        }


        let defaults: UserDefaults = UserDefaults.standard
        highscore = defaults.value(forKey: "highscore") as? Int ?? 0
        highScoreLabel.text = "$\(String(highscore))"
        
        scoreLabel.text = "$\(String(score))"
        
        if score > highscore {
            highscore = score
            let defaults: UserDefaults = UserDefaults.standard
            defaults.set(highscore, forKey: "highscore")
            defaults.synchronize()
            highScoreLabel.text = "$\(String(highscore))"
        }
        
        if score == 1000 {
//            gameOverLabel.text = "Victory"
//            gameOverLabel.textColor = UIColor.green
        }
        
        //This adds stroke to the Title Text
        /*let attrString = NSAttributedString(
            string: gameOverLabel.text!,
            attributes: [
                NSAttributedString.Key.strokeColor: color1,
                NSAttributedString.Key.strokeWidth: -6.0,
            ]
        )
        gameOverLabel.attributedText = attrString*/
        
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        previewController.dismiss(animated: true) { [weak self] in
            //reset the UI and show the recording controls
        }
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
            MusicPlayer.shared.stopBackgroundMusic()
            interstitialAd?.present(fromRootViewController: self)
        } else {
            print("Ad Not Ready")
        }
    }
    
    private func getInterstitialAd() {
        interstitialAd = AppDelegate.shared().interstitialAd
        interstitialAd?.delegate = self
    }
    
    private func getRewardedAd() {
        rewardedAd = AppDelegate.shared().rewardedAd
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
        if rewardedAd?.isReady == false {
            AppDelegate.shared().createRewardedAds()
            getRewardedAd()

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                if self.rewardedAd?.isReady == true {
                    MusicPlayer.shared.stopBackgroundMusic()
                    self.rewardedAd?.present(fromRootViewController: self, delegate:self)
                } else {
                    self.showAlert(message: "Cannot revive as ad is not ready yet.")
                }
            }
        } else {
            rewardedAd?.present(fromRootViewController: self, delegate:self)
        }
    }
    
    @IBAction func shareVideo() {
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
                let objAVPlayerVC = AVPlayerViewController()
                objAVPlayerVC.player = AVPlayer(url: mergedVideoURL!)
                self.present(objAVPlayerVC, animated: true, completion: {() -> Void in
                    objAVPlayerVC.player?.play()
                })
        }
        
     /*   DPVideoMerger().gridMergeVideos(withFileURLs: [fileURL1!, fileURL2!], videoResolution: CGSize(width: 500, height: 500)) { mergedVideoURL, error in
            if error != nil {
                    let errorMessage = "Could not merge videos: \(error?.localizedDescription ?? "error")"
                    let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (a) in
                    }))
                    self.present(alert, animated: true) {() -> Void in }
                    return
                }
                let objAVPlayerVC = AVPlayerViewController()
                objAVPlayerVC.player = AVPlayer(url: mergedVideoURL!)
                self.present(objAVPlayerVC, animated: true, completion: {() -> Void in
                    objAVPlayerVC.player?.play()
                })
        }*/
        
        /*DPVideoMerger().mergeVideos(withFileURLs: [fileURL1!, fileURL2!]) { mergedVideoURL, error in
            if error != nil {
                    let errorMessage = "Could not merge videos: \(error?.localizedDescription ?? "error")"
                    let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (a) in
                    }))
                    self.present(alert, animated: true) {() -> Void in }
                    return
                }
                let objAVPlayerVC = AVPlayerViewController()
                objAVPlayerVC.player = AVPlayer(url: mergedVideoURL!)
                self.present(objAVPlayerVC, animated: true, completion: {() -> Void in
                    objAVPlayerVC.player?.play()
                })
        }*/
    }
    
    func showAlert(message: String) {
        UIAlertController.show(message, from: self)
    }
}

extension GameOverViewController : GADInterstitialDelegate{
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        //ad.present(fromRootViewController: self)
    }
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print(error.localizedDescription)
    }
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        //print(error.localizedDescription)
    }
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        if sound.sound {
            MusicPlayer.shared.playBackgroundMusic()
        }
    }
}

extension GameOverViewController : GADRewardedAdDelegate{
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        Constants.didRevive = true
        Constants.canRevive = false
        
    }
    func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
        print("Failed to load add\(error)")
    }
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        if sound.sound {
            MusicPlayer.shared.playBackgroundMusic()
        }
        if Constants.didRevive {
            self.dismiss(animated: true, completion: nil)
        }
    }
}


