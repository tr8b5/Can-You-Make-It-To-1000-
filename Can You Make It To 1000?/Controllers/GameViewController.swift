//
//  GameViewController.swift
//  Can You Make It To 1000?
//
//  Created by William Miller on 2/18/20.
//  Copyright © 2020 William Miller. All rights reserved.
//

import UIKit
import GameplayKit
import SpriteKit
import AVFoundation
import GoogleMobileAds
import Lottie
import ReplayKit
import AVKit
import MobileCoreServices
import DPVideoMerger_Swift

class GameViewController: UIViewController, UIGestureRecognizerDelegate  {
        
    //private var interstitialAd: GADInterstitial? Not needed here
    
    var sound = Sound()
    var game = GameLogic()
    var shatterImages: [UIImage] = []
    var shatter1Images: [UIImage] = []
    var shatter2Images: [UIImage] = []
    var leftGlass = UIImageView()
    var rightGlass = UIImageView()
    var bottomGlass = UIImageView()
    var audioPlayer: AVAudioPlayer!
    var backgroundImage = UIImageView()

    @IBOutlet weak var scoreButton: UIButton!
    @IBOutlet weak var rightWall: UIImageView!
    @IBOutlet weak var leftWall: UIImageView!
    @IBOutlet weak var bottomWall: UIImageView!
    @IBOutlet weak var shape: UIImageView!
    @IBOutlet weak var leftDiamond: UIImageView!
    @IBOutlet weak var rightDiamond: UIImageView!
    @IBOutlet weak var bottomDiamond: UIImageView!
    @IBOutlet weak var circleIcon: UIImageView!
    @IBOutlet weak var squareIcon: UIImageView!
    @IBOutlet weak var triangleIcon: UIImageView!
    @IBOutlet weak var timerBar: UIProgressView!
    @IBOutlet weak var wallView: UIView!
    @IBOutlet weak var bottomWallView: UIView!
    @IBOutlet weak var coinAnimationView: LottieAnimationView!
    
    @IBOutlet var videoLayer: UIView!
    var player: AVPlayer!
    
    var timer = Timer()
    var randomNumber: Int = 0
    var didTimeUp: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black
        
        assignbackground()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeDown)
        
        coinAnimationView.loopMode = .playOnce
        coinAnimationView.animationSpeed = 2
        
        timerBar.layer.cornerRadius = 5
        timerBar.clipsToBounds = true
        
        /**
         This was for opening the camera behind the scene for video recording of the user
         */
        /*VideoRecording.shared.imagePickerController.view.frame = self.view.bounds
        self.view.insertSubview(VideoRecording.shared.imagePickerController.view, at: 0)
        self.addChild(VideoRecording.shared.imagePickerController)
        VideoRecording.shared.imagePickerController.didMove(toParent: self)
        VideoRecording.shared.imagePickerController.delegate = self*/
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
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.shared().createInterstitialAd()
        AppDelegate.shared().createRewardedAds()

        if !Constants.didRevive {
            game = GameLogic()
            
            sound = Sound()
            
            sound.loadSound()
            sound.loadFx()
            
            updateScoreBoard(score: "\(game.score)")
            //Defines Colors and
            game.selectColors(repetitions: 3, maxValue: 8)
            
            circleIcon.image = game.sprites[0].icon[game.colorArray[0]]
            squareIcon.image = game.sprites[1].icon[game.colorArray[1]]
            triangleIcon.image = game.sprites[2].icon[game.colorArray[2]]
            updateScene()
            updateSceneStepTwo()

        } else {
            UIView.animate(withDuration: 0.5) {
                self.shape.transform = CGAffineTransform(translationX: 0, y: 0)
            }
            timer.invalidate()
            timerBar.progress = 1.0

            timer = Timer.scheduledTimer(timeInterval: TimeInterval(game.time), target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        }
        
        // In case the icons were hidden when user reaches past the 500 score then unhide those icons
        circleIcon.isHidden = false
        squareIcon.isHidden = false
        triangleIcon.isHidden = false
        
        // Start recording the user time
        RecordingUtility.shared.startRecordingTime()
        
        /**
         if VideoRecording.shared.allowRecording {
             DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                 self.startVideoCapture()
                 self.startRecording()
             }
         }
         */

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
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
    
    
    @objc func updateScene() {
        
        if game.score == 500 {
            circleIcon.isHidden = true
            squareIcon.isHidden = true
            triangleIcon.isHidden = true
        }
        
        if game.score == 1000 {
            timer.invalidate()
            self.gameOver(timeUp: false)
        } else {
            
            timer.invalidate()
            timerBar.progress = 1.0
            
            shape.image = game.pickShape()
            game.selectDiamonds()
            
            UIView.animate(withDuration: 0) {
                self.shape.transform = CGAffineTransform(translationX: 0, y: 0)
                self.shape.transform = CGAffineTransform(scaleX: 0, y: 0)
            }
            UIView.animate(withDuration: 0) {
                self.leftWall.transform = CGAffineTransform(translationX: 0, y: -1000)
                self.rightWall.transform = CGAffineTransform(translationX: 0, y: -1000)
                self.leftDiamond.transform = CGAffineTransform(translationX: 0, y: -1000)
                self.rightDiamond.transform = CGAffineTransform(translationX: 0, y: -1000)
                self.bottomWall.transform = CGAffineTransform(translationX: -1000, y: 0)
                self.bottomDiamond.transform = CGAffineTransform(translationX: -1000, y: 0)
            }
        }
    }
    
    func updateSceneStepTwo() {
        UIView.animate(withDuration: 0.5) {
            self.shape.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }
        UIView.animate(withDuration: 0.5) {
            self.shape.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        UIView.animate(withDuration: 0.5) {
            self.leftWall.transform = CGAffineTransform(translationX: 0, y: 0)
            self.rightWall.transform = CGAffineTransform(translationX: 0, y: 0)
            self.leftDiamond.transform = CGAffineTransform(translationX: 0, y: 0)
            self.rightDiamond.transform = CGAffineTransform(translationX: 0, y: 0)
            self.bottomWall.transform = CGAffineTransform(translationX: 0, y: 0)
            self.bottomDiamond.transform = CGAffineTransform(translationX: 0, y: 0)
        }

        game.difficulty()
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(game.time), target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        
        leftDiamond.image = game.sprites[game.shapeValue].diamond[game.leftDiamondValue]
        rightDiamond.image = game.sprites[game.shapeValue].diamond[game.rightDiamondValue]
        bottomDiamond.image = game.sprites[game.shapeValue].diamond[game.bottomDiamondValue]
        
        game.resetwallcount()
        
        leftWall.image = game.pickWalls()[0]
        rightWall.image = game.pickWalls()[1]
        bottomWall.image = game.pickWalls()[2]

        shatterImages = createImagesArray(total: 26, imagePrefix: "Shatter-\(game.sprites[0].color[game.wallColorArray[1]])") //right
        
        shatter2Images = createImagesArray(total: 26, imagePrefix: "Shatter-\(game.sprites[0].color[game.wallColorArray[0]])") //left
        
        shatter1Images = createImagesArray(total: 23, imagePrefix: "Shatter-\(game.sprites[0].color[game.wallColorArray[2]])") //Bottom
    }
    
    func playSound(breakGlassAudio: String) {
        if (sound.fx == true) {
            let url = Bundle.main.url(forResource: breakGlassAudio, withExtension: "mp3")
            audioPlayer = try! AVAudioPlayer(contentsOf: url!)
            audioPlayer.delegate = self
            
            audioPlayer.play()
        }
    }
    
    @objc func countDown() {
        timerBar.progress = timerBar.progress - 0.001
        if timerBar.progress == 0.0 {
            timer.invalidate()
            gameOver(timeUp: true)
        }
    }
    
    func updateLabel() {
        game.updateScore()
        updateScore(with: game.score)
        self.updateScene()
        updateScoreBoard(score: "\(game.score)")
    }
    
    func gameOver(timeUp: Bool) {
        /*
         Stop recording the time */
        RecordingUtility.shared.stopRecordingTime()
        //
        
        self.timer.invalidate()
        self.timerBar.progress = 1.0
        self.didTimeUp = timeUp
        
        self.game.loadGamesTillAd()
        self.performSegue(withIdentifier: "gotToGameOver", sender: self)
        self.game.updateGamesTillAd()
        
       /* stopVideoCapture()
        stopRecording(timeUp: timeUp)*/
    }
    
    func createImagesArray(total: Int, imagePrefix: String) -> [UIImage] {
        var imageArray: [UIImage] = []
       
        for imageCount in (1..<total) {
            let imageNames = ["\(imagePrefix)-\(imageCount)" , "\(imagePrefix)-000\(imageCount)","\(imagePrefix)-0\(imageCount)","\(imagePrefix)-_0000\(imageCount)","\(imagePrefix)-\(imageCount)", "\(imagePrefix)-0000\(imageCount)"]
            
            
            var didFindName = false
            for name in imageNames{
                if let path = Bundle.main.path(forResource: "\(name)", ofType: "png"){
                    let image = UIImage(contentsOfFile: path)!
                    imageArray.append(image)
                    didFindName = true
                }
            }
            
            if !didFindName{
                print(imageNames)
                print("\(imagePrefix)-\(imageCount)")
            }
        }

        return imageArray.compactMap({ $0 })
    }
    
    func animate(imageView: UIImageView, images: [UIImage]) {
        imageView.animationImages = images
        imageView.animationDuration = 0.7
        imageView.animationRepeatCount = 1
        imageView.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            imageView.removeFromSuperview()
        }
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:

                UIView.animate(withDuration:0.0, delay: 0) {
                    self.shape.transform = CGAffineTransform(translationX: 160, y: 0)
                }
                
                if self.game.correctValue == self.game.rightDiamondValue {
                    self.vibrateOnScoring()
                    self.coinAnimationView.play { _ in
                    }
                    self.playSound(breakGlassAudio: "Point")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.26) {
                        self.rightGlass.alpha = 1
                        self.updateLabel()
                        self.updateSceneStepTwo()
                    }

                } else {
                    self.playSound(breakGlassAudio: "Wrong")
                    
                    self.gameOver(timeUp: false)
                    
                }
                //print("Swiped right")
            case UISwipeGestureRecognizer.Direction.down:

                UIView.animate(withDuration: 0, delay: 0) {
                    self.shape.transform = CGAffineTransform(translationX: 0, y: 320)
                }
                
                if self.game.correctValue == self.game.bottomDiamondValue {
                    self.vibrateOnScoring()

                    self.coinAnimationView.play { _ in
                    }
                    self.playSound(breakGlassAudio: "Point")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.26) {
                        
                        self.bottomGlass.alpha = 1
                        self.updateLabel()
                        self.updateSceneStepTwo()
                    }
                } else {
                    self.playSound(breakGlassAudio: "Wrong")
                    
                    self.gameOver(timeUp: false)
                }
                //}
                //print("Swiped down")
            case UISwipeGestureRecognizer.Direction.left:

                UIView.animate(withDuration: 0, delay: 0) {
                    self.shape.transform = CGAffineTransform(translationX: -160, y: 0)
                }
                
                if self.game.correctValue == self.game.leftDiamondValue {
                    self.vibrateOnScoring()

                self.coinAnimationView.play()
                    self.playSound(breakGlassAudio: "Point")

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.26) {
                        
                        self.leftGlass.alpha = 1
                        self.updateLabel()
                        self.updateSceneStepTwo()
                    }
                } else {
                    self.playSound(breakGlassAudio: "Wrong")
                    
                    self.gameOver(timeUp: false)
                    
                }
                //print("Swiped left")
            case UISwipeGestureRecognizer.Direction.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "gotToGameOver" {
            
            let destinationVC = segue.destination as! GameOverViewController
            destinationVC.score = game.score
            destinationVC.didTimeUp = didTimeUp
            destinationVC.attemptsLeft = game.gamesTillAd
        }
    }
        
    private func updateScoreBoard(score: String) {
        let color1 = hexStringToUIColor(hex: "#000000")

        //This adds stroke to the Title Text
        let attrString = NSAttributedString(
            string: "$"+score,
            attributes: [
                //bbe1fa
                NSAttributedString.Key.strokeColor: color1,
                NSAttributedString.Key.strokeWidth: -6.0,
            ]
        )
        scoreButton.setAttributedTitle(attrString, for: .normal)
    }
    
    private func vibrateOnScoring() {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
    }
}

extension GameViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
    }
}

extension GameViewController: RPPreviewViewControllerDelegate {
    func startRecording() {
        let recorder = RPScreenRecorder.shared()
        
        recorder.startRecording{ (error) in
        }
    }
    
    func stopRecording(timeUp: Bool) {
        let recorder = RPScreenRecorder.shared()
        var fileURL: URL?
        
        if let directory =  try? RecordingUtility.shared.getDocumentsDirectory() {
            if #available(iOS 16.0, *) {
                fileURL = directory.appending(components: "screen_recording.mov")
                
            } else {
                fileURL = directory.appendingPathComponent("screen_recording.mov")
            }
            
            try? FileManager.default.removeItem(at: fileURL!)
            
            if let fileURL = fileURL {
                recorder.stopRecording(withOutput: fileURL)
                print("User recording was saved to \(fileURL)")
            }
            
            self.timer.invalidate()
            self.timerBar.progress = 1.0
            self.didTimeUp = timeUp
            
            self.game.loadGamesTillAd()
            self.performSegue(withIdentifier: "gotToGameOver", sender: self)
            self.game.updateGamesTillAd()
        }
    }
}

extension UIImage {
    func imageWithColor(_ color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
        guard let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage else { return nil }

        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0);
        context.setBlendMode(.normal)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context.clip(to: rect, mask: cgImage)
        color.setFill()
        context.fill(rect)
        let  newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();

        return newImage
    }
}

struct Constants {
    static let interstitialAdId = "ca-app-pub-3526204639815359/7322176381"
    static let rewardAdId = "ca-app-pub-3526204639815359/6560355524"
    static var canRevive = true
    static var didRevive = false
    static let disclaimerAccepted = "DISCLAIMER_ACCEPTED"
    // Game Center
    static var gcEnabled = Bool() // Check if the user has Game Center enabled
    static var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    
    static let loggedTime = "LOGGED_TIME"
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

extension GameViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    func startVideoCapture() {
        RecordingUtility.shared.imagePickerController.startVideoCapture()
    }
    
    func stopVideoCapture() {
        RecordingUtility.shared.imagePickerController.stopVideoCapture()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        let mediaType:AnyObject? = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaType)] as AnyObject?
                        
        if let type:AnyObject = mediaType {
            if type is String {
                let stringType = type as! String
                if stringType == kUTTypeMovie as String {
                    let urlOfVideo = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaURL)] as? URL
                    var fileURL: URL?
                    
                    if let url = urlOfVideo {
                        do {
                            if let documentsDirectoryURL = try RecordingUtility.shared.getDocumentsDirectory() {
                                let movieData = try Data(contentsOf: url)
                                
                                
                                if #available(iOS 16.0, *) {
                                    fileURL = documentsDirectoryURL.appending(components: "user_recording.mov")
                                    
                                } else {
                                    fileURL = documentsDirectoryURL.appendingPathComponent("user_recording.mov")
                                }
                                
                                if let fileURL = fileURL {
                                    try movieData.write(to: fileURL)
                                    print("User video written to \(fileURL)")
                                }
                            }

                        } catch {
                            print(error)
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }

    // Helper function inserted by Swift migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
}
