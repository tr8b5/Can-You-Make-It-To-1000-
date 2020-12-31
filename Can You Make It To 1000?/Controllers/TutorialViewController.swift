//
//  TutorialViewController.swift
//  Can You Make It To 1000?
//
//  Created by William Miller on 6/20/20.
//  Copyright © 2020 William Miller. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class TutoialViewController : UIViewController {
    
    var game = GameLogic()
    var tut = Tutorial()
        var shatterImages: [UIImage] = []
        var shatter1Images: [UIImage] = []
        var shatter2Images: [UIImage] = []
        var leftGlass = UIImageView()
        var rightGlass = UIImageView()
        var bottomGlass = UIImageView()
        var audioPlayer: AVAudioPlayer!

        @IBOutlet weak var tutLabel: UITextView!
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
        @IBOutlet weak var timerView: UIView!
        @IBOutlet weak var labelView: UIView!
    
    @IBOutlet var videoLayer: UIView!
    var player: AVPlayer!
        
        var timer = Timer()
        var randomNumber: Int = 0
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            playVideo()
            
            tutLabel.text = String(tut.score)
            tut.selectColors(repetitions: 3, maxValue: 3)
            
            circleIcon.image = tut.sprites[0].icon[tut.colorArray[0]]
            squareIcon.image = tut.sprites[1].icon[tut.colorArray[1]]
            triangleIcon.image = tut.sprites[2].icon[tut.colorArray[2]]

//            circleIcon.isHidden = true;
//            squareIcon.isHidden = true;
//            triangleIcon.isHidden = true;
            timerView.isHidden = true;
//            wallView.isHidden = true;
//            bottomWallView.isHidden = true;
            
            updateScene()
//
            
//            Activate Swipe
//            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
//            swipeRight.direction = UISwipeGestureRecognizer.Direction.right
//            self.view.addGestureRecognizer(swipeRight)
//
//            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
//            swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
//            self.view.addGestureRecognizer(swipeLeft)
//
//            let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
//            swipeDown.direction = UISwipeGestureRecognizer.Direction.down
//            self.view.addGestureRecognizer(swipeDown)
            
            
            
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
            
            
            timer.invalidate()
            timerBar.progress = 1.0
            
            shape.image = tut.pickShape()
            tut.selectDiamonds()
            
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
            
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(tut.time), target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
            
            leftDiamond.image = tut.sprites[tut.shapeValue].diamond[tut.leftDiamondValue]
            rightDiamond.image = tut.sprites[tut.shapeValue].diamond[tut.rightDiamondValue]
            bottomDiamond.image = tut.sprites[tut.shapeValue].diamond[tut.bottomDiamondValue]
            
            tut.resetwallcount()
            
            leftWall.image = tut.pickWalls()[0]
            rightWall.image = tut.pickWalls()[1]
            bottomWall.image = tut.pickWalls()[2]
            
            rightGlass = UIImageView(image: UIImage(named: "Shatter-\(tut.sprites[0].color[tut.wallColorArray[1]])-1.png")!)
            rightGlass.frame = CGRect(x: 10, y: -75, width: 700, height: 700)
            rightGlass.layer.zPosition = -1
            rightGlass.alpha = 0
            wallView.addSubview(rightGlass)
            
            leftGlass = UIImageView(image: UIImage(named: "Shatter-\(tut.sprites[0].color[tut.wallColorArray[0]])-1.png")!)
            leftGlass.frame = CGRect(x: -310, y: -75, width: 700, height: 700)
            leftGlass.layer.zPosition = -1
            leftGlass.alpha = 0
            wallView.addSubview(leftGlass)
            
            bottomGlass = UIImageView(image: UIImage(named: "Shatter1-\(tut.sprites[0].color[tut.wallColorArray[2]])-0.png"))
            bottomGlass.frame = CGRect(x: -140, y: -297, width: 700, height: 700)
            bottomGlass.layer.zPosition = -1
            bottomGlass.alpha = 0
            bottomWallView.addSubview(bottomGlass)
            
            shatterImages = createImagesArray(total: 26, imagePrefix: "Shatter-\(tut.sprites[0].color[tut.wallColorArray[1]])")/*, color: tut.sprites[0].color[tut.wallColorArray[0]]*/ //right
            shatter2Images = createImagesArray(total: 26, imagePrefix: "Shatter-\(tut.sprites[0].color[tut.wallColorArray[0]])")/*, color: tut.sprites[0].color[tut.wallColorArray[1]]*/ //left
            shatter1Images = createImagesArray(total: 23, imagePrefix: "Shatter1-\(tut.sprites[0].color[tut.wallColorArray[2]])")/*, color: tut.sprites[0].color[tut.wallColorArray[2]]*/
            
        
        }
        
        func playSound(breakGlassAudio: String) {
            let url = Bundle.main.url(forResource: breakGlassAudio, withExtension: "mp3")
            audioPlayer = try! AVAudioPlayer(contentsOf: url!)
            audioPlayer.play()
        }
        
        @objc func countDown() {
            timerBar.progress = timerBar.progress - 0.001
            if timerBar.progress == 0.0 {
                timer.invalidate()
                gameOver()
            }
        }
    
    func tutorialActions () {
        
    }
    
    func playTutorial () {
        
        //reduce the hight of the background box
        
        //Add a tap to continue button
        
        //Add a 3 second countdown
        
        //Run next set of instructions in array
        
        
    }
        
        func updateLabel() {
            self.updateScene()
            tut.updateLabel()
            tutLabel.text = String(tut.score)
            tutLabel.font = tutLabel.font!.withSize(21)
        }
        
        func gameOver() {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.performSegue(withIdentifier: "gotToGameOver", sender: self)
            }
        }
        
        func createImagesArray(total: Int, imagePrefix: String/*, color: UIColor*/) -> [UIImage] {
            var imageArray: [UIImage] = []
            
            for imageCount in (1..<total) {
                let imageName = "\(imagePrefix)-\(imageCount).png"
                let image = UIImage(named: imageName)!
                //image = image.imageWithColor(color)!
                
                imageArray.append(image)
                
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
                    UIView.animate(withDuration: 0.1) {
                        self.shape.transform = CGAffineTransform(translationX: 160, y: 0)
                    }
                    if self.tut.correctValue == self.tut.rightDiamondValue {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.animate(imageView: self.rightGlass, images: self.shatter2Images)
                            self.rightGlass.alpha = 1
                            self.updateLabel()
                            self.playSound(breakGlassAudio: "Dook")
                        }
                    } else {
                        self.gameOver()
                    }
                    //print("Swiped right")
                case UISwipeGestureRecognizer.Direction.down:
                    UIView.animate(withDuration: 0.1) {
                        self.shape.transform = CGAffineTransform(translationX: 0, y: 320)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        if self.tut.correctValue == self.tut.bottomDiamondValue {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                self.animate(imageView: self.bottomGlass, images: self.shatter1Images)
                                self.bottomGlass.alpha = 1
                                self.updateLabel()
                                self.playSound(breakGlassAudio: "Dook")
                            }
                            } else {
                            self.gameOver()
                            }
                        }
                    //print("Swiped down")
                case UISwipeGestureRecognizer.Direction.left:
                    UIView.animate(withDuration: 0.1) {
                        self.shape.transform = CGAffineTransform(translationX: -160, y: 0)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if self.tut.correctValue == self.tut.leftDiamondValue {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.animate(imageView: self.leftGlass, images: self.shatterImages)
                            self.leftGlass.alpha = 1
                            self.updateLabel()
                            self.playSound(breakGlassAudio: "Dook")
                        }
                        } else {
                        self.gameOver()
                        }
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
                //destinationVC.score = tut.score
               }
           }
    }



