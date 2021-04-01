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
    var sound = Sound()
    var tut = Tutorial()
    var shatterImages: [UIImage] = []
    var shatter1Images: [UIImage] = []
    var shatter2Images: [UIImage] = []
    var leftGlass = UIImageView()
    var rightGlass = UIImageView()
    var bottomGlass = UIImageView()
    var audioPlayer: AVAudioPlayer!
    
    @IBOutlet weak var tutLabel: UILabel!
    @IBOutlet weak var rightWall: UIImageView!
    @IBOutlet var leftWall: UIImageView!
    @IBOutlet weak var bottomWall: UIImageView!
    @IBOutlet weak var shape: UIImageView!
    @IBOutlet weak var leftDiamond: UIImageView!
    @IBOutlet weak var rightDiamond: UIImageView!
    @IBOutlet weak var bottomDiamond: UIImageView!
    @IBOutlet var circleIcon: UIImageView!
    @IBOutlet weak var squareIcon: UIImageView!
    @IBOutlet weak var triangleIcon: UIImageView!
    @IBOutlet weak var timerBar: UIProgressView!
    @IBOutlet weak var wallView: UIView!
    @IBOutlet weak var bottomWallView: UIView!
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var labelView: UIView!
    
    @IBOutlet var videoLayer: UIView!
    var player: AVPlayer!
    var label = UILabel()
    
    var timer = Timer()
    var randomNumber: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        tut = Tutorial()
        sound = Sound()
        playVideo()
        
        sound.loadSound()
        sound.loadFx()
        
        tutLabel.text = tut.tutorialStep
        tutLabel.lineBreakMode = .byWordWrapping
        tutLabel.numberOfLines = 0
        tut.selectColors(repetitions: 3, maxValue: 8)
        
        circleIcon.image = tut.sprites[0].icon[tut.colorArray[0]]
        squareIcon.image = tut.sprites[1].icon[tut.colorArray[1]]
        triangleIcon.image = tut.sprites[2].icon[tut.colorArray[2]]
        
        tutorialSteps()
        //updateScene()
        //fadeOut(finished: true)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    
    @objc func updateScene() {
        
        timer.invalidate()
//        timerBar.progress = 1.0
        
//        shape.image = tut.pickShape()
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
        
        if (tut.tutNumber > 2) {
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(tut.time), target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        }
        
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
        
        print(tut.introArray)
        shatterImages = createImagesArray(total: 26, imagePrefix: "Shatter-\(tut.sprites[0].color[tut.wallColorArray[1]])")/*, color: tut.sprites[0].color[tut.wallColorArray[0]]*/ //right
        shatter2Images = createImagesArray(total: 26, imagePrefix: "Shatter-\(tut.sprites[0].color[tut.wallColorArray[0]])")/*, color: tut.sprites[0].color[tut.wallColorArray[1]]*/ //left
        shatter1Images = createImagesArray(total: 23, imagePrefix: "Shatter1-\(tut.sprites[0].color[tut.wallColorArray[2]])")/*, color: tut.sprites[0].color[tut.wallColorArray[2]]*/
        
        tutorialActions()
        
    }
    func tutorialSteps() {
        
        //Logic Initializations
        tut.selectColors(repetitions: 3, maxValue: 8)
        shape.image = tut.pickShape()
        tut.selectDiamonds()
        
        leftDiamond.image = tut.sprites[tut.shapeValue].diamond[tut.leftDiamondValue]
        rightDiamond.image = tut.sprites[tut.shapeValue].diamond[tut.rightDiamondValue]
        bottomDiamond.image = tut.sprites[tut.shapeValue].diamond[tut.bottomDiamondValue]
        circleIcon.image = tut.sprites[0].icon[tut.colorArray[0]]
        squareIcon.image = tut.sprites[1].icon[tut.colorArray[1]]
        triangleIcon.image = tut.sprites[2].icon[tut.colorArray[2]]
        tut.resetwallcount()
        leftWall.image = tut.pickWalls()[0]
        rightWall.image = tut.pickWalls()[1]
        bottomWall.image = tut.pickWalls()[2]
        print(tut.wallColorArray)
        
        timer.invalidate()
        
        
        //Animation Initilizations
        self.shape.transform = CGAffineTransform(translationX: 0, y: 0)
        self.shape.transform = CGAffineTransform(scaleX: 0, y: 0)
        self.leftWall.transform = CGAffineTransform(translationX: 0, y: -1000)
        self.rightWall.transform = CGAffineTransform(translationX: 0, y: -1000)
        self.leftDiamond.transform = CGAffineTransform(translationX: 0, y: -1000)
        self.rightDiamond.transform = CGAffineTransform(translationX: 0, y: -1000)
        self.bottomWall.transform = CGAffineTransform(translationX: -1000, y: 0)
        self.bottomDiamond.transform = CGAffineTransform(translationX: -1000, y: 0)
        print(tut.tutNumber)
        
        //Tutorial Steps
        if (tut.tutNumber == 0) {
            
            //Logic Initializations
            
            rightGlass = UIImageView(image: UIImage(named: "Shatter-White-1.png")!)
            rightGlass.frame = CGRect(x: 10, y: -75, width: 700, height: 700)
            rightGlass.layer.zPosition = -1
            rightGlass.alpha = 0
            wallView.addSubview(rightGlass)
            
            leftGlass = UIImageView(image: UIImage(named: "Shatter-White-1.png")!)
            leftGlass.frame = CGRect(x: -310, y: -75, width: 700, height: 700)
            leftGlass.layer.zPosition = -1
            leftGlass.alpha = 0
            wallView.addSubview(leftGlass)
            
            bottomGlass = UIImageView(image: UIImage(named: "Shatter1-White-0.png"))
            bottomGlass.frame = CGRect(x: -140, y: -297, width: 700, height: 700)
            bottomGlass.layer.zPosition = -1
            bottomGlass.alpha = 0
            bottomWallView.addSubview(bottomGlass)
            
            shatterImages = createImagesArray(total: 26, imagePrefix: "Shatter-White")
            shatter2Images = createImagesArray(total: 26, imagePrefix: "Shatter-White")
            shatter1Images = createImagesArray(total: 23, imagePrefix: "Shatter1-White")
            
            //Animation Initilizations 1
            self.leftWall.transform = CGAffineTransform(translationX: -1000, y: 0)
            self.leftDiamond.transform = CGAffineTransform(translationX: -1000, y: 0)
            self.rightDiamond.transform = CGAffineTransform(translationX: 1000, y: 0)
            self.bottomDiamond.transform = CGAffineTransform(translationX: 0, y: 1200)
            self.bottomWall.transform = CGAffineTransform(translationX: 0, y: 1200)
            self.circleIcon.transform = CGAffineTransform(translationX: 0, y: -1200)
            self.squareIcon.transform = CGAffineTransform(translationX: 0, y: -1200)
            self.triangleIcon.transform = CGAffineTransform(translationX: 0, y: -1200)
            self.timerBar.transform = CGAffineTransform(translationX: 0, y: -1200)
            self.rightWall.transform = CGAffineTransform(translationX: 1000, y: 0)
            self.tutLabel.transform = CGAffineTransform(translationX: 0, y: 1200)
            self.shape.transform = CGAffineTransform(scaleX: 0, y: 0)
            
            UIView.animate(withDuration: 2) {
                self.tutLabel.transform = CGAffineTransform(translationX: 0, y: 400)
            }
            
            
        }
        if (tut.tutNumber == 1) {
            
            //Logic Initilizations 1
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
            swipeRight.direction = UISwipeGestureRecognizer.Direction.right
            self.view.addGestureRecognizer(swipeRight)
            
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
            swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
            self.view.addGestureRecognizer(swipeLeft)
            
            //Animation Initilizations 1
            UIView.animate(withDuration: 0.5) {
                self.leftWall.transform = CGAffineTransform(translationX: 0, y: 0)
                self.rightWall.transform = CGAffineTransform(translationX: 0, y: 0)
                self.leftDiamond.transform = CGAffineTransform(translationX: 0, y: 0)
                self.rightDiamond.transform = CGAffineTransform(translationX: 0, y: 0)
                self.bottomDiamond.transform = CGAffineTransform(translationX: 0, y: -100)
                self.tutLabel.transform = CGAffineTransform(translationX: 0, y: 50)
                self.shape.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                self.circleIcon.transform = CGAffineTransform(translationX: 70, y: 0)
            }
            UIView.animate(withDuration: 0.5) {
                self.shape.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
        if (tut.tutNumber == 2) {
            
            //Logic Initilizations 1
            let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
            swipeDown.direction = UISwipeGestureRecognizer.Direction.down
            self.view.addGestureRecognizer(swipeDown)
            
            leftWall.image = tut.pickWalls()[0]
            rightWall.image = tut.pickWalls()[1]
            bottomWall.image = tut.pickWalls()[2]
            
            rightGlass = UIImageView(image: UIImage(named: "Shatter-White-1.png")!)
            rightGlass.frame = CGRect(x: 10, y: -75, width: 700, height: 700)
            rightGlass.layer.zPosition = -1
            rightGlass.alpha = 0
            wallView.addSubview(rightGlass)
            
            leftGlass = UIImageView(image: UIImage(named: "Shatter-White-1.png")!)
            leftGlass.frame = CGRect(x: -310, y: -75, width: 700, height: 700)
            leftGlass.layer.zPosition = -1
            leftGlass.alpha = 0
            wallView.addSubview(leftGlass)
            
            bottomGlass = UIImageView(image: UIImage(named: "Shatter1-White-0.png"))
            bottomGlass.frame = CGRect(x: -140, y: -297, width: 700, height: 700)
            bottomGlass.layer.zPosition = -1
            bottomGlass.alpha = 0
            bottomWallView.addSubview(bottomGlass)
            
            shatterImages = createImagesArray(total: 26, imagePrefix: "Shatter-White")
            shatter2Images = createImagesArray(total: 26, imagePrefix: "Shatter-White")
            shatter1Images = createImagesArray(total: 23, imagePrefix: "Shatter1-White")
            
            //Animation Initilizations 1
            UIView.animate(withDuration: 0.5) {
                self.leftWall.transform = CGAffineTransform(translationX: 0, y: 0)
                self.rightWall.transform = CGAffineTransform(translationX: 0, y: 0)
                self.bottomWall.transform = CGAffineTransform(translationX: 0, y: 0)
                self.leftDiamond.transform = CGAffineTransform(translationX: 0, y: 0)
                self.rightDiamond.transform = CGAffineTransform(translationX: 0, y: 0)
                self.bottomDiamond.transform = CGAffineTransform(translationX: 0, y: 0)
                self.tutLabel.transform = CGAffineTransform(translationX: 0, y: 50)
                self.shape.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                self.circleIcon.transform = CGAffineTransform(translationX: 70, y: 0)
            }
            UIView.animate(withDuration: 0.5) {
                self.shape.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
            
        }
        if (tut.tutNumber == 3) {
            
            //Logic Initilizations 1
            let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
            swipeDown.direction = UISwipeGestureRecognizer.Direction.down
            self.view.addGestureRecognizer(swipeDown)
            
            leftWall.image = tut.pickWalls()[0]
            rightWall.image = tut.pickWalls()[1]
            bottomWall.image = tut.pickWalls()[2]
            
            rightGlass = UIImageView(image: UIImage(named: "Shatter-White-1.png")!)
            rightGlass.frame = CGRect(x: 10, y: -75, width: 700, height: 700)
            rightGlass.layer.zPosition = -1
            rightGlass.alpha = 0
            wallView.addSubview(rightGlass)
            
            leftGlass = UIImageView(image: UIImage(named: "Shatter-White-1.png")!)
            leftGlass.frame = CGRect(x: -310, y: -75, width: 700, height: 700)
            leftGlass.layer.zPosition = -1
            leftGlass.alpha = 0
            wallView.addSubview(leftGlass)
            
            bottomGlass = UIImageView(image: UIImage(named: "Shatter1-White-0.png"))
            bottomGlass.frame = CGRect(x: -140, y: -297, width: 700, height: 700)
            bottomGlass.layer.zPosition = -1
            bottomGlass.alpha = 0
            bottomWallView.addSubview(bottomGlass)
            
            shatterImages = createImagesArray(total: 26, imagePrefix: "Shatter-White")
            shatter2Images = createImagesArray(total: 26, imagePrefix: "Shatter-White")
            shatter1Images = createImagesArray(total: 23, imagePrefix: "Shatter1-White")
            
            //Animation Initilizations 1
            UIView.animate(withDuration: 0.5) {
                self.leftWall.transform = CGAffineTransform(translationX: 0, y: 0)
                self.rightWall.transform = CGAffineTransform(translationX: 0, y: 0)
                self.bottomWall.transform = CGAffineTransform(translationX: 0, y: 0)
                self.leftDiamond.transform = CGAffineTransform(translationX: 0, y: 0)
                self.rightDiamond.transform = CGAffineTransform(translationX: 0, y: 0)
                self.bottomDiamond.transform = CGAffineTransform(translationX: 0, y: 0)
                self.tutLabel.transform = CGAffineTransform(translationX: 0, y: 50)
                self.shape.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                self.circleIcon.transform = CGAffineTransform(translationX: 70, y: 0)
            }
            UIView.animate(withDuration: 0.5) {
                self.shape.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
            
        }
        if (tut.tutNumber == 4) {
            
            //Logic Initilizations 1
            let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
            swipeDown.direction = UISwipeGestureRecognizer.Direction.down
            self.view.addGestureRecognizer(swipeDown)
            
            leftWall.image = tut.pickWalls()[0]
            rightWall.image = tut.pickWalls()[1]
            bottomWall.image = tut.pickWalls()[2]
            
            rightGlass = UIImageView(image: UIImage(named: "Shatter-White-1.png")!)
            rightGlass.frame = CGRect(x: 10, y: -75, width: 700, height: 700)
            rightGlass.layer.zPosition = -1
            rightGlass.alpha = 0
            wallView.addSubview(rightGlass)
            
            leftGlass = UIImageView(image: UIImage(named: "Shatter-White-1.png")!)
            leftGlass.frame = CGRect(x: -310, y: -75, width: 700, height: 700)
            leftGlass.layer.zPosition = -1
            leftGlass.alpha = 0
            wallView.addSubview(leftGlass)
            
            bottomGlass = UIImageView(image: UIImage(named: "Shatter1-White-0.png"))
            bottomGlass.frame = CGRect(x: -140, y: -297, width: 700, height: 700)
            bottomGlass.layer.zPosition = -1
            bottomGlass.alpha = 0
            bottomWallView.addSubview(bottomGlass)
            
            shatterImages = createImagesArray(total: 26, imagePrefix: "Shatter-White")
            shatter2Images = createImagesArray(total: 26, imagePrefix: "Shatter-White")
            shatter1Images = createImagesArray(total: 23, imagePrefix: "Shatter1-White")
            
            //Animation Initilizations 1
            UIView.animate(withDuration: 0.5) {
                self.leftWall.transform = CGAffineTransform(translationX: 0, y: 0)
                self.rightWall.transform = CGAffineTransform(translationX: 0, y: 0)
                self.bottomWall.transform = CGAffineTransform(translationX: 0, y: 0)
                self.leftDiamond.transform = CGAffineTransform(translationX: 0, y: 0)
                self.rightDiamond.transform = CGAffineTransform(translationX: 0, y: 0)
                self.bottomDiamond.transform = CGAffineTransform(translationX: 0, y: 0)
                self.tutLabel.transform = CGAffineTransform(translationX: 0, y: 50)
                self.shape.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                self.circleIcon.transform = CGAffineTransform(translationX: 70, y: 0)
            }
            UIView.animate(withDuration: 0.5) {
                self.shape.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
            
        }
        if (tut.tutNumber == 5) {
            
            //Logic Initilizations 1
            let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
            swipeDown.direction = UISwipeGestureRecognizer.Direction.down
            self.view.addGestureRecognizer(swipeDown)
            
            leftWall.image = tut.pickWalls()[0]
            rightWall.image = tut.pickWalls()[1]
            bottomWall.image = tut.pickWalls()[2]
            
            rightGlass = UIImageView(image: UIImage(named: "Shatter-White-1.png")!)
            rightGlass.frame = CGRect(x: 10, y: -75, width: 700, height: 700)
            rightGlass.layer.zPosition = -1
            rightGlass.alpha = 0
            wallView.addSubview(rightGlass)
            
            leftGlass = UIImageView(image: UIImage(named: "Shatter-White-1.png")!)
            leftGlass.frame = CGRect(x: -310, y: -75, width: 700, height: 700)
            leftGlass.layer.zPosition = -1
            leftGlass.alpha = 0
            wallView.addSubview(leftGlass)
            
            bottomGlass = UIImageView(image: UIImage(named: "Shatter1-White-0.png"))
            bottomGlass.frame = CGRect(x: -140, y: -297, width: 700, height: 700)
            bottomGlass.layer.zPosition = -1
            bottomGlass.alpha = 0
            bottomWallView.addSubview(bottomGlass)
            
            shatterImages = createImagesArray(total: 26, imagePrefix: "Shatter-White")
            shatter2Images = createImagesArray(total: 26, imagePrefix: "Shatter-White")
            shatter1Images = createImagesArray(total: 23, imagePrefix: "Shatter1-White")
            
            //Animation Initilizations 1
            UIView.animate(withDuration: 0.5) {
                self.leftWall.transform = CGAffineTransform(translationX: 0, y: 0)
                self.rightWall.transform = CGAffineTransform(translationX: 0, y: 0)
                self.bottomWall.transform = CGAffineTransform(translationX: 0, y: 0)
                self.leftDiamond.transform = CGAffineTransform(translationX: 0, y: 0)
                self.rightDiamond.transform = CGAffineTransform(translationX: 0, y: 0)
                self.bottomDiamond.transform = CGAffineTransform(translationX: 0, y: 0)
                self.tutLabel.transform = CGAffineTransform(translationX: 0, y: 50)
                self.shape.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                self.circleIcon.transform = CGAffineTransform(translationX: 70, y: 0)
            }
            UIView.animate(withDuration: 0.5) {
                self.shape.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
            
        }
        if (tut.tutNumber == 6) {
            
            //Logic Initilizations 1
            let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
            swipeDown.direction = UISwipeGestureRecognizer.Direction.down
            self.view.addGestureRecognizer(swipeDown)
            
            leftWall.image = tut.pickWalls()[0]
            rightWall.image = tut.pickWalls()[1]
            bottomWall.image = tut.pickWalls()[2]
            
            rightGlass = UIImageView(image: UIImage(named: "Shatter-White-1.png")!)
            rightGlass.frame = CGRect(x: 10, y: -75, width: 700, height: 700)
            rightGlass.layer.zPosition = -1
            rightGlass.alpha = 0
            wallView.addSubview(rightGlass)
            
            leftGlass = UIImageView(image: UIImage(named: "Shatter-White-1.png")!)
            leftGlass.frame = CGRect(x: -310, y: -75, width: 700, height: 700)
            leftGlass.layer.zPosition = -1
            leftGlass.alpha = 0
            wallView.addSubview(leftGlass)
            
            bottomGlass = UIImageView(image: UIImage(named: "Shatter1-White-0.png"))
            bottomGlass.frame = CGRect(x: -140, y: -297, width: 700, height: 700)
            bottomGlass.layer.zPosition = -1
            bottomGlass.alpha = 0
            bottomWallView.addSubview(bottomGlass)
            
            shatterImages = createImagesArray(total: 26, imagePrefix: "Shatter-White")
            shatter2Images = createImagesArray(total: 26, imagePrefix: "Shatter-White")
            shatter1Images = createImagesArray(total: 23, imagePrefix: "Shatter1-White")
            
            //Animation Initilizations 1
            UIView.animate(withDuration: 0.5) {
                self.leftWall.transform = CGAffineTransform(translationX: 0, y: 0)
                self.rightWall.transform = CGAffineTransform(translationX: 0, y: 0)
                self.bottomWall.transform = CGAffineTransform(translationX: 0, y: 0)
                self.leftDiamond.transform = CGAffineTransform(translationX: 0, y: 0)
                self.rightDiamond.transform = CGAffineTransform(translationX: 0, y: 0)
                self.bottomDiamond.transform = CGAffineTransform(translationX: 0, y: 0)
                self.tutLabel.transform = CGAffineTransform(translationX: 0, y: 50)
                self.shape.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                self.circleIcon.transform = CGAffineTransform(translationX: 70, y: 0)
            }
            UIView.animate(withDuration: 0.5) {
                self.shape.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
            
        }
        if (tut.tutNumber == 7) {
            
            //Logic Initilizations 1
            let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
            swipeDown.direction = UISwipeGestureRecognizer.Direction.down
            self.view.addGestureRecognizer(swipeDown)
            
            leftWall.image = tut.pickWalls()[0]
            rightWall.image = tut.pickWalls()[1]
            bottomWall.image = tut.pickWalls()[2]
            
            rightGlass = UIImageView(image: UIImage(named: "Shatter-White-1.png")!)
            rightGlass.frame = CGRect(x: 10, y: -75, width: 700, height: 700)
            rightGlass.layer.zPosition = -1
            rightGlass.alpha = 0
            wallView.addSubview(rightGlass)
            
            leftGlass = UIImageView(image: UIImage(named: "Shatter-White-1.png")!)
            leftGlass.frame = CGRect(x: -310, y: -75, width: 700, height: 700)
            leftGlass.layer.zPosition = -1
            leftGlass.alpha = 0
            wallView.addSubview(leftGlass)
            
            bottomGlass = UIImageView(image: UIImage(named: "Shatter1-White-0.png"))
            bottomGlass.frame = CGRect(x: -140, y: -297, width: 700, height: 700)
            bottomGlass.layer.zPosition = -1
            bottomGlass.alpha = 0
            bottomWallView.addSubview(bottomGlass)
            
            shatterImages = createImagesArray(total: 26, imagePrefix: "Shatter-White")
            shatter2Images = createImagesArray(total: 26, imagePrefix: "Shatter-White")
            shatter1Images = createImagesArray(total: 23, imagePrefix: "Shatter1-White")
            
            //Animation Initilizations 1
            UIView.animate(withDuration: 0.5) {
                self.leftWall.transform = CGAffineTransform(translationX: 0, y: 0)
                self.rightWall.transform = CGAffineTransform(translationX: 0, y: 0)
                self.bottomWall.transform = CGAffineTransform(translationX: 0, y: 0)
                self.leftDiamond.transform = CGAffineTransform(translationX: 0, y: 0)
                self.rightDiamond.transform = CGAffineTransform(translationX: 0, y: 0)
                self.bottomDiamond.transform = CGAffineTransform(translationX: 0, y: 0)
                self.tutLabel.transform = CGAffineTransform(translationX: 0, y: 50)
                self.shape.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                self.circleIcon.transform = CGAffineTransform(translationX: 70, y: 0)
            }
            UIView.animate(withDuration: 0.5) {
                self.shape.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
            
        }
        if (tut.tutNumber == 8) {
            
            //Logic Initilizations 1
            let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
            swipeDown.direction = UISwipeGestureRecognizer.Direction.down
            self.view.addGestureRecognizer(swipeDown)
            
            leftWall.image = tut.pickWalls()[0]
            rightWall.image = tut.pickWalls()[1]
            bottomWall.image = tut.pickWalls()[2]
            
            rightGlass = UIImageView(image: UIImage(named: "Shatter-White-1.png")!)
            rightGlass.frame = CGRect(x: 10, y: -75, width: 700, height: 700)
            rightGlass.layer.zPosition = -1
            rightGlass.alpha = 0
            wallView.addSubview(rightGlass)
            
            leftGlass = UIImageView(image: UIImage(named: "Shatter-White-1.png")!)
            leftGlass.frame = CGRect(x: -310, y: -75, width: 700, height: 700)
            leftGlass.layer.zPosition = -1
            leftGlass.alpha = 0
            wallView.addSubview(leftGlass)
            
            bottomGlass = UIImageView(image: UIImage(named: "Shatter1-White-0.png"))
            bottomGlass.frame = CGRect(x: -140, y: -297, width: 700, height: 700)
            bottomGlass.layer.zPosition = -1
            bottomGlass.alpha = 0
            bottomWallView.addSubview(bottomGlass)
            
            shatterImages = createImagesArray(total: 26, imagePrefix: "Shatter-White")
            shatter2Images = createImagesArray(total: 26, imagePrefix: "Shatter-White")
            shatter1Images = createImagesArray(total: 23, imagePrefix: "Shatter1-White")
            
            //Animation Initilizations 1
            self.circleIcon.transform = CGAffineTransform(translationX: -1200, y: 0)
            self.squareIcon.transform = CGAffineTransform(translationX: 0, y: 0)
            UIView.animate(withDuration: 0.5) {
                self.leftWall.transform = CGAffineTransform(translationX: 0, y: 0)
                self.rightWall.transform = CGAffineTransform(translationX: 0, y: 0)
                self.bottomWall.transform = CGAffineTransform(translationX: 0, y: 0)
                self.leftDiamond.transform = CGAffineTransform(translationX: 0, y: 0)
                self.rightDiamond.transform = CGAffineTransform(translationX: 0, y: 0)
                self.bottomDiamond.transform = CGAffineTransform(translationX: 0, y: 0)
                self.tutLabel.transform = CGAffineTransform(translationX: 0, y: 50)
                self.shape.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }
            UIView.animate(withDuration: 0.5) {
                self.shape.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
            
        }
        if (tut.tutNumber == 9) {
            
            //Logic Initilizations 1
            let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
            swipeDown.direction = UISwipeGestureRecognizer.Direction.down
            self.view.addGestureRecognizer(swipeDown)
            
            leftWall.image = tut.pickWalls()[0]
            rightWall.image = tut.pickWalls()[1]
            bottomWall.image = tut.pickWalls()[2]
            
            rightGlass = UIImageView(image: UIImage(named: "Shatter-White-1.png")!)
            rightGlass.frame = CGRect(x: 10, y: -75, width: 700, height: 700)
            rightGlass.layer.zPosition = -1
            rightGlass.alpha = 0
            wallView.addSubview(rightGlass)
            
            leftGlass = UIImageView(image: UIImage(named: "Shatter-White-1.png")!)
            leftGlass.frame = CGRect(x: -310, y: -75, width: 700, height: 700)
            leftGlass.layer.zPosition = -1
            leftGlass.alpha = 0
            wallView.addSubview(leftGlass)
            
            bottomGlass = UIImageView(image: UIImage(named: "Shatter1-White-0.png"))
            bottomGlass.frame = CGRect(x: -140, y: -297, width: 700, height: 700)
            bottomGlass.layer.zPosition = -1
            bottomGlass.alpha = 0
            bottomWallView.addSubview(bottomGlass)
            
            shatterImages = createImagesArray(total: 26, imagePrefix: "Shatter-White")
            shatter2Images = createImagesArray(total: 26, imagePrefix: "Shatter-White")
            shatter1Images = createImagesArray(total: 23, imagePrefix: "Shatter1-White")
            
            //Animation Initilizations 1
            UIView.animate(withDuration: 0.5) {
                self.leftWall.transform = CGAffineTransform(translationX: 0, y: 0)
                self.rightWall.transform = CGAffineTransform(translationX: 0, y: 0)
                self.bottomWall.transform = CGAffineTransform(translationX: 0, y: 0)
                self.leftDiamond.transform = CGAffineTransform(translationX: 0, y: 0)
                self.rightDiamond.transform = CGAffineTransform(translationX: 0, y: 0)
                self.bottomDiamond.transform = CGAffineTransform(translationX: 0, y: 0)
                self.tutLabel.transform = CGAffineTransform(translationX: 0, y: 50)
                self.shape.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }
            UIView.animate(withDuration: 0.5) {
                self.shape.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
            
        }
        if (tut.tutNumber == 10) {
            
            //Logic Initilizations 1
            let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
            swipeDown.direction = UISwipeGestureRecognizer.Direction.down
            self.view.addGestureRecognizer(swipeDown)
            
            leftWall.image = tut.pickWalls()[0]
            rightWall.image = tut.pickWalls()[1]
            bottomWall.image = tut.pickWalls()[2]
            
            rightGlass = UIImageView(image: UIImage(named: "Shatter-White-1.png")!)
            rightGlass.frame = CGRect(x: 10, y: -75, width: 700, height: 700)
            rightGlass.layer.zPosition = -1
            rightGlass.alpha = 0
            wallView.addSubview(rightGlass)
            
            leftGlass = UIImageView(image: UIImage(named: "Shatter-White-1.png")!)
            leftGlass.frame = CGRect(x: -310, y: -75, width: 700, height: 700)
            leftGlass.layer.zPosition = -1
            leftGlass.alpha = 0
            wallView.addSubview(leftGlass)
            
            bottomGlass = UIImageView(image: UIImage(named: "Shatter1-White-0.png"))
            bottomGlass.frame = CGRect(x: -140, y: -297, width: 700, height: 700)
            bottomGlass.layer.zPosition = -1
            bottomGlass.alpha = 0
            bottomWallView.addSubview(bottomGlass)
            
            shatterImages = createImagesArray(total: 26, imagePrefix: "Shatter-White")
            shatter2Images = createImagesArray(total: 26, imagePrefix: "Shatter-White")
            shatter1Images = createImagesArray(total: 23, imagePrefix: "Shatter1-White")
            
            //Animation Initilizations 1
            self.squareIcon.transform = CGAffineTransform(translationX: 0, y: -1200)
            self.triangleIcon.transform = CGAffineTransform(translationX: -70, y: 0)
            UIView.animate(withDuration: 0.5) {
                self.leftWall.transform = CGAffineTransform(translationX: 0, y: 0)
                self.rightWall.transform = CGAffineTransform(translationX: 0, y: 0)
                self.bottomWall.transform = CGAffineTransform(translationX: 0, y: 0)
                self.leftDiamond.transform = CGAffineTransform(translationX: 0, y: 0)
                self.rightDiamond.transform = CGAffineTransform(translationX: 0, y: 0)
                self.bottomDiamond.transform = CGAffineTransform(translationX: 0, y: 0)
                self.tutLabel.transform = CGAffineTransform(translationX: 0, y: 50)
                self.shape.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }
            UIView.animate(withDuration: 0.5) {
                self.shape.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
            
        }
        if (tut.tutNumber == 11) {
            
            //Logic Initilizations 1
            let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
            swipeDown.direction = UISwipeGestureRecognizer.Direction.down
            self.view.addGestureRecognizer(swipeDown)
            
            leftWall.image = tut.pickWalls()[0]
            rightWall.image = tut.pickWalls()[1]
            bottomWall.image = tut.pickWalls()[2]
            
            rightGlass = UIImageView(image: UIImage(named: "Shatter-White-1.png")!)
            rightGlass.frame = CGRect(x: 10, y: -75, width: 700, height: 700)
            rightGlass.layer.zPosition = -1
            rightGlass.alpha = 0
            wallView.addSubview(rightGlass)
            
            leftGlass = UIImageView(image: UIImage(named: "Shatter-White-1.png")!)
            leftGlass.frame = CGRect(x: -310, y: -75, width: 700, height: 700)
            leftGlass.layer.zPosition = -1
            leftGlass.alpha = 0
            wallView.addSubview(leftGlass)
            
            bottomGlass = UIImageView(image: UIImage(named: "Shatter1-White-0.png"))
            bottomGlass.frame = CGRect(x: -140, y: -297, width: 700, height: 700)
            bottomGlass.layer.zPosition = -1
            bottomGlass.alpha = 0
            bottomWallView.addSubview(bottomGlass)
            
            shatterImages = createImagesArray(total: 26, imagePrefix: "Shatter-White")
            shatter2Images = createImagesArray(total: 26, imagePrefix: "Shatter-White")
            shatter1Images = createImagesArray(total: 23, imagePrefix: "Shatter1-White")
            
            //Animation Initilizations 1
            UIView.animate(withDuration: 0.5) {
                self.leftWall.transform = CGAffineTransform(translationX: 0, y: 0)
                self.rightWall.transform = CGAffineTransform(translationX: 0, y: 0)
                self.bottomWall.transform = CGAffineTransform(translationX: 0, y: 0)
                self.leftDiamond.transform = CGAffineTransform(translationX: 0, y: 0)
                self.rightDiamond.transform = CGAffineTransform(translationX: 0, y: 0)
                self.bottomDiamond.transform = CGAffineTransform(translationX: 0, y: 0)
                self.tutLabel.transform = CGAffineTransform(translationX: 0, y: 50)
                self.shape.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }
            UIView.animate(withDuration: 0.5) {
                self.shape.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
            
        }
        if (tut.tutNumber == 12) {
            
            //Logic Initilizations 1
            
            
            //Animation Initilizations 1
            self.triangleIcon.transform = CGAffineTransform(translationX: -1200, y: 0)
            
            
        }
        
    }
    
    func resetBars() {
        
        self.leftWall.transform = CGAffineTransform(translationX: -1000, y: 0)
        self.leftDiamond.transform = CGAffineTransform(translationX: -1000, y: 0)
        self.rightDiamond.transform = CGAffineTransform(translationX: 1000, y: 0)
        self.bottomDiamond.transform = CGAffineTransform(translationX: 0, y: 1200)
        self.circleIcon.transform = CGAffineTransform(translationX: 3, y: -1200)
        self.rightWall.transform = CGAffineTransform(translationX: 1000, y: 0)
        self.shape.transform = CGAffineTransform(scaleX: 0, y: 0)
        
    }
    
    @objc func countDown() {
        timerBar.progress = timerBar.progress - 0.001
        if timerBar.progress == 0.0 {
            self.tutLabel.text = "You ran out of time, Try again!"
            self.updateScene()
        }
    }
    
    func tutorialActions () {
        
        if (tut.tutNumber == 10) {
            timer.invalidate()
            timerBar.removeFromSuperview()
            leftWall.removeFromSuperview()
            rightWall.removeFromSuperview()
            bottomWall.removeFromSuperview()
            shape.removeFromSuperview()
            leftDiamond.removeFromSuperview()
            rightDiamond.removeFromSuperview()
            bottomDiamond.removeFromSuperview()
            circleIcon.removeFromSuperview()
            squareIcon.removeFromSuperview()
            triangleIcon.removeFromSuperview()
            
            let button:UIButton = UIButton(frame: CGRect(x: 0, y: wallView.frame.size.height/2 + 100, width: self.view.frame.width, height: 100))
            button.setTitleColor(UIColor(red: 108/225, green: 229/225, blue: 229/225, alpha: 0.25), for: .normal)
            button.backgroundColor = UIColor(red: 108/225, green: 229/225, blue: 229/225, alpha: 0.05)
            button.setTitle("Play", for: .normal)
            button.titleLabel!.font = UIFont(name: "Impact", size: 45)
            button.addTarget(self, action:#selector(playButtonClicked(_:)), for: .touchUpInside)
            self.view.addSubview(button)
            
        }
        
    }
    func updateLabel() {
        
        //self.updateScene()
        tutorialSteps()
        tut.updateLabel()
        tutLabel.text = tut.tutorialStep
        //tutLabel.font = tutLabel.font!.withSize(21)
    }
    
    func gameOver() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.performSegue(withIdentifier: "gotToGameOver", sender: self)
        }
    }
    
    func createImagesArray(total: Int, imagePrefix: String/*, color: UIColor*/) -> [UIImage] {
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
    
    
    func fadeOut(finished: Bool) {
        if (tut.tutNumber > 2) {
            leftDiamond.alpha = 1
            rightDiamond.alpha = 1
            bottomDiamond.alpha = 1
            circleIcon.alpha = 1
            squareIcon.alpha = 1
            triangleIcon.alpha = 1
        } else {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           options: [UIView.AnimationOptions.curveEaseInOut],
                           animations: {
                            if (self.tut.leftDiamondValue == self.tut.correctValue) {
                                self.leftDiamond.alpha = 0
                            }
                            if (self.tut.rightDiamondValue == self.tut.correctValue) {
                                self.rightDiamond.alpha = 0
                            }
                            if (self.tut.bottomDiamondValue == self.tut.correctValue) {
                                self.bottomDiamond.alpha = 0
                            }
                            if (self.tut.tutNumber == 0) {
                                self.circleIcon.alpha = 0
                            }
                            if (self.tut.tutNumber == 1) {
                                self.squareIcon.alpha = 0
                                self.circleIcon.alpha = 1
                            }
                            if (self.tut.tutNumber == 2) {
                                self.triangleIcon.alpha = 0
                                self.circleIcon.alpha = 1
                                self.squareIcon.alpha = 1
                            }
                           },
                           completion: self.fadeIn)
        }
    }
    func fadeIn(finished: Bool) {
        if (tut.tutNumber > 2) {
            leftDiamond.alpha = 1
            rightDiamond.alpha = 1
            bottomDiamond.alpha = 1
            circleIcon.alpha = 1
            squareIcon.alpha = 1
            triangleIcon.alpha = 1
        } else {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           options: [UIView.AnimationOptions.curveEaseInOut],
                           animations: {
                            if (self.tut.leftDiamondValue == self.tut.correctValue) {
                                self.leftDiamond.alpha = 1
                            }
                            if (self.tut.rightDiamondValue == self.tut.correctValue) {
                                self.rightDiamond.alpha = 1
                            }
                            if (self.tut.bottomDiamondValue == self.tut.correctValue) {
                                self.bottomDiamond.alpha = 1
                            }
                            if (self.tut.tutNumber == 0) {
                                self.circleIcon.alpha = 1
                            }
                            if (self.tut.tutNumber == 1) {
                                self.squareIcon.alpha = 1
                                self.circleIcon.alpha = 1
                            }
                            if (self.tut.tutNumber == 2) {
                                self.triangleIcon.alpha = 1
                                self.circleIcon.alpha = 1
                                self.squareIcon.alpha = 1
                            }
                           },
                           completion: self.fadeOut)
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
                        self.tut.tutNumber += 1
                        self.updateLabel()
                        self.playSound(breakGlassAudio: "Dook")
                    }
                } else {
                    self.tutLabel.text = "Wrong diamond, Try again!"
                    self.tutorialSteps()
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
                            self.tut.tutNumber += 1
                            self.updateLabel()
                            self.playSound(breakGlassAudio: "Dook")
                        }
                    } else {
                        self.tutLabel.text = "Wrong diamond, Try again!"
                        self.tutorialSteps()
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
                            self.tut.tutNumber += 1
                            self.updateLabel()
                            self.playSound(breakGlassAudio: "Dook")
                        }
                    } else {
                        self.tutLabel.text = "Wrong diamond, Try again!"
                        self.tutorialSteps()
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
    @objc func screenTapped() {
        tut.tutNumber += 1
        updateLabel()
    }
    
    @objc func playButtonClicked(_ sender : UIButton) {
        self.performSegue(withIdentifier: "goToGame", sender: self)
        print("Button Clicked")
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
    
    func playSound(breakGlassAudio: String) {
        if (sound.fx == true) {
            let url = Bundle.main.url(forResource: breakGlassAudio, withExtension: "mp3")
            audioPlayer = try! AVAudioPlayer(contentsOf: url!)
            audioPlayer.play()
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "gotToGameOver" {
            
            let destinationVC = segue.destination as! GameOverViewController
            //destinationVC.score = tut.score
        }
    }
}



