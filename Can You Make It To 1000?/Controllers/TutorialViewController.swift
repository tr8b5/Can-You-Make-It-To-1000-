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
        var shatterImages: [UIImage] = []
        var shatter1Images: [UIImage] = []
        var shatter2Images: [UIImage] = []
        var leftGlass = UIImageView()
        var rightGlass = UIImageView()
        var bottomGlass = UIImageView()
        var audioPlayer: AVAudioPlayer!

        @IBOutlet weak var scoreLabel: UILabel!
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
        
        var timer = Timer()
        var randomNumber: Int = 0
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            //image = UIImage(named: imageName)
            
            scoreLabel.text = String(game.score)
            game.selectColors(repetitions: 3, maxValue: 8)
            
            circleIcon.image = game.sprites[0].icon[game.colorArray[0]]
            squareIcon.image = game.sprites[1].icon[game.colorArray[1]]
            triangleIcon.image = game.sprites[2].icon[game.colorArray[2]]

            
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
            swipeRight.direction = UISwipeGestureRecognizer.Direction.right
            self.view.addGestureRecognizer(swipeRight)
            
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
            swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
            self.view.addGestureRecognizer(swipeLeft)

            let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
            swipeDown.direction = UISwipeGestureRecognizer.Direction.down
            self.view.addGestureRecognizer(swipeDown)
            
            
            
            updateScene()
            
            
        }
        
        @objc func updateScene() {
            
            if game.score == 500 {
                circleIcon.removeFromSuperview()
                squareIcon.removeFromSuperview()
                triangleIcon.removeFromSuperview()
            }
            
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
            
            rightGlass = UIImageView(image: UIImage(named: "Shatter-\(game.sprites[0].color[game.wallColorArray[1]])-1.png")!)
            rightGlass.frame = CGRect(x: 10, y: -75, width: 700, height: 700)
            rightGlass.layer.zPosition = -1
            rightGlass.alpha = 0
            wallView.addSubview(rightGlass)
            
            leftGlass = UIImageView(image: UIImage(named: "Shatter-\(game.sprites[0].color[game.wallColorArray[0]])-1.png")!)
            leftGlass.frame = CGRect(x: -310, y: -75, width: 700, height: 700)
            leftGlass.layer.zPosition = -1
            leftGlass.alpha = 0
            wallView.addSubview(leftGlass)
            
            bottomGlass = UIImageView(image: UIImage(named: "Shatter1-\(game.sprites[0].color[game.wallColorArray[2]])-0.png"))
            bottomGlass.frame = CGRect(x: -140, y: -297, width: 700, height: 700)
            bottomGlass.layer.zPosition = -1
            bottomGlass.alpha = 0
            bottomWallView.addSubview(bottomGlass)
            
            shatterImages = createImagesArray(total: 26, imagePrefix: "Shatter-\(game.sprites[0].color[game.wallColorArray[1]])")/*, color: game.sprites[0].color[game.wallColorArray[0]]*/ //right
            shatter2Images = createImagesArray(total: 26, imagePrefix: "Shatter-\(game.sprites[0].color[game.wallColorArray[0]])")/*, color: game.sprites[0].color[game.wallColorArray[1]]*/ //left
            shatter1Images = createImagesArray(total: 23, imagePrefix: "Shatter1-\(game.sprites[0].color[game.wallColorArray[2]])")/*, color: game.sprites[0].color[game.wallColorArray[2]]*/
            
        
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
        
        func updateLabel() {
            self.updateScene()
            game.updateScore()
            scoreLabel.text = String(game.score)
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
                    if self.game.correctValue == self.game.rightDiamondValue {
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
                        if self.game.correctValue == self.game.bottomDiamondValue {
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
                    if self.game.correctValue == self.game.leftDiamondValue {
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
                destinationVC.score = game.score
               }
           }
    }



