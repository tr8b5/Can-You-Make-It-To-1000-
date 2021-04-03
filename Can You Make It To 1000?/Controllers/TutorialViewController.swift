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
    @IBOutlet var noButton: UIButton!
    @IBOutlet var yesButton: UIButton!
    
    
    @IBOutlet var videoLayer: UIView!
    var player: AVPlayer!
    var label = UILabel()
    var label2 = UILabel()
    var label3 = UILabel()
    var label4 = UILabel()
    var label5 = UILabel()
    var ttContinue = UILabel()
    
    var canTap : Bool = true
    
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
        
        
        label2 = UILabel(frame: CGRect(x: 0, y: wallView.frame.size.height/5 + 100, width: self.view.frame.width, height: 75))
        label2.textColor = UIColor(red: 108/225, green: 229/225, blue: 229/225, alpha: 0.25)
        label2.textAlignment = .center
        label2.backgroundColor = UIColor(red: 108/225, green: 229/225, blue: 229/225, alpha: 0.05)
        label2.text = "Each game you are given the \nfollowing 3 shapes."
        label2.numberOfLines = 0
        label2.font = UIFont(name: "Impact", size: 21)
        self.view.addSubview(label2)
        
        label3 = UILabel(frame: CGRect(x: 0, y: wallView.frame.size.height/2 + 100, width: self.view.frame.width, height: 75))
        label3.textColor = UIColor(red: 108/225, green: 229/225, blue: 229/225, alpha: 0.25)
        label3.textAlignment = .center
        label3.backgroundColor = UIColor(red: 108/225, green: 229/225, blue: 229/225, alpha: 0.05)
        label3.text = "They stay the same colors each \ngame, so try to remeber them."
        label3.numberOfLines = 0
        label3.font = UIFont(name: "Impact", size: 21)
        self.view.addSubview(label3)
        
        label4 = UILabel(frame: CGRect(x: 0, y: wallView.frame.size.height - 100, width: self.view.frame.width, height: 75))
        label4.textColor = UIColor(red: 108/225, green: 229/225, blue: 229/225, alpha: 0.25)
        label4.textAlignment = .center
        label4.backgroundColor = UIColor(red: 108/225, green: 229/225, blue: 229/225, alpha: 0.05)
        label4.text = "Each game you are given the \nfollowing 3 shapes."
        label4.numberOfLines = 0
        label4.font = UIFont(name: "Impact", size: 21)
        self.view.addSubview(label4)
        
        label5 = UILabel(frame: CGRect(x: 0, y: wallView.frame.size.height, width: self.view.frame.width, height: 75))
        label5.textColor = UIColor(red: 108/225, green: 229/225, blue: 229/225, alpha: 0.25)
        label5.textAlignment = .center
        label5.backgroundColor = UIColor(red: 108/225, green: 229/225, blue: 229/225, alpha: 0.05)
        label5.text = "Each game you are given the \nfollowing 3 shapes."
        label5.numberOfLines = 0
        label5.font = UIFont(name: "Impact", size: 21)
        self.view.addSubview(label5)
        
        
        ttContinue = UILabel(frame: CGRect(x: 0, y: wallView.frame.size.height + 220, width: self.view.frame.width - 20, height: 10))
        ttContinue.textColor = .white
        ttContinue.textAlignment = .right
        ttContinue.text = "Tap to continue"
        ttContinue.numberOfLines = 0
        ttContinue.font = UIFont(name: "Impact", size: 14)
        self.view.addSubview(ttContinue)
        
        tutorialSteps()
        
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
        self.label2.transform = CGAffineTransform(translationX: 0, y: 1200)
        self.label3.transform = CGAffineTransform(translationX: 0, y: 1200)
        self.label4.transform = CGAffineTransform(translationX: 0, y: 1200)
        self.label5.transform = CGAffineTransform(translationX: 0, y: 1200)
        self.ttContinue.alpha = 0
        print(tut.tutNumber)
        
        //Tutorial Steps
        if (tut.tutNumber == 0) {
            
            //Logic Initializations
            
            canTap = false;
            
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
            
            label2.text = "Well You don't"
            label3.text = "Good luck though."
            
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
            self.label2.transform = CGAffineTransform(translationX: 0, y: 1200)
            self.label3.transform = CGAffineTransform(translationX: 0, y: 1200)
            self.label4.transform = CGAffineTransform(translationX: 0, y: 1200)
            self.label5.transform = CGAffineTransform(translationX: 0, y: 1200)
            self.shape.transform = CGAffineTransform(scaleX: 0, y: 0)
            
            UIView.animate(withDuration: 2) {
                self.tutLabel.transform = CGAffineTransform(translationX: 0, y: 100)
            }
            
            yesButton = UIButton(frame: CGRect(x: 15, y: wallView.frame.size.height + 100, width: self.view.frame.width/2 - 20, height: 100))
            yesButton.setTitleColor(UIColor(red: 108/225, green: 229/225, blue: 229/225, alpha: 0.25), for: .normal)
            yesButton.backgroundColor = UIColor(red: 108/225, green: 229/225, blue: 229/225, alpha: 0.05)
            yesButton.setTitle("Yes", for: .normal)
            yesButton.titleLabel!.font = UIFont(name: "Impact", size: 45)
            yesButton.addTarget(self, action:#selector(buttonClicked(_:)), for: .touchUpInside)
            self.view.addSubview(yesButton)
            
            noButton = UIButton(frame: CGRect(x: 215, y: wallView.frame.size.height + 100, width: self.view.frame.width/2 - 20, height: 100))
            noButton.setTitleColor(UIColor(red: 108/225, green: 229/225, blue: 229/225, alpha: 0.25), for: .normal)
            noButton.backgroundColor = UIColor(red: 108/225, green: 229/225, blue: 229/225, alpha: 0.05)
            noButton.setTitle("No", for: .normal)
            noButton.titleLabel!.font = UIFont(name: "Impact", size: 45)
            noButton.addTarget(self, action:#selector(buttonClicked(_:)), for: .touchUpInside)
            self.view.addSubview(noButton)
            
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
            fadeOut(finished: true)
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
        if (tut.tutNumber == 8) {
            
            //Logic Initilizations 1
            label2.text = "Each game you are given the \nfollowing 3 shapes."
            label3.text = "They stay the same colors each \ngame, so try to remeber them."
            
            //Animation Initilizations 1
            self.triangleIcon.transform = CGAffineTransform(translationX: -1200, y: 0)
            UIView.animate(withDuration: 0.5) {
            self.label2.transform = CGAffineTransform(translationX: 0, y: 0)
            self.label3.transform = CGAffineTransform(translationX: 0, y: 0)
            self.circleIcon.transform = CGAffineTransform(translationX: 0, y: 125)
            self.squareIcon.transform = CGAffineTransform(translationX: 0, y: 125)
            self.triangleIcon.transform = CGAffineTransform(translationX: 0, y: 125)
            }
            
            
        }
        if (tut.tutNumber == 9) {
            
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
                self.circleIcon.transform = CGAffineTransform(translationX: 0, y: 0)
                self.squareIcon.transform = CGAffineTransform(translationX: 0, y: 0)
                self.triangleIcon.transform = CGAffineTransform(translationX: 0, y: 0)
            }
            UIView.animate(withDuration: 0.5) {
                self.shape.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
            
        }
        if (tut.tutNumber == 10) {
            
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
                self.circleIcon.transform = CGAffineTransform(translationX: 0, y: 0)
                self.squareIcon.transform = CGAffineTransform(translationX: 0, y: 0)
                self.triangleIcon.transform = CGAffineTransform(translationX: 0, y: 0)
            }
            UIView.animate(withDuration: 0.5) {
                self.shape.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
            
        }
        if (tut.tutNumber == 11) {
            
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
                self.circleIcon.transform = CGAffineTransform(translationX: 0, y: 0)
                self.squareIcon.transform = CGAffineTransform(translationX: 0, y: 0)
                self.triangleIcon.transform = CGAffineTransform(translationX: 0, y: 0)
            }
            UIView.animate(withDuration: 0.5) {
                self.shape.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
            
        }
        if (tut.tutNumber == 12) {
            
            
            label2.text = "Peep the timer. In order to beat the game \nyou must match the shape correctly each \nround before the timer runs out."
            label3.text = "This countdown gets \nquicker with each point you score \nso you have to think fast."
            label4.text = "Each score is worth 5 points so you only \nneed to score 200 times to win."
            label5.text = "99% of people don’t beat this game \nand neither will you! Good Luck."
            
            self.circleIcon.transform = CGAffineTransform(translationX: 0, y: -1200)
            self.squareIcon.transform = CGAffineTransform(translationX: 0, y: -1200)
            self.triangleIcon.transform = CGAffineTransform(translationX: 0, y: -1200)
            
            UIView.animate(withDuration: 0.5) {
            self.timerBar.transform = CGAffineTransform(translationX: 0, y: 200)
            self.label2.transform = CGAffineTransform(translationX: 0, y: 0)
            self.label3.transform = CGAffineTransform(translationX: 0, y: 0)
            self.label4.transform = CGAffineTransform(translationX: 0, y: 0)
            self.label5.transform = CGAffineTransform(translationX: 0, y: 0)
            }
            
            let button:UIButton = UIButton(frame: CGRect(x: 0, y: wallView.frame.size.height + 100, width: self.view.frame.width, height: 100))
            button.setTitleColor(UIColor(red: 108/225, green: 229/225, blue: 229/225, alpha: 0.25), for: .normal)
            button.backgroundColor = UIColor(red: 108/225, green: 229/225, blue: 229/225, alpha: 0.05)
            button.setTitle("Play", for: .normal)
            button.titleLabel!.font = UIFont(name: "Impact", size: 45)
            button.addTarget(self, action:#selector(playButtonClicked(_:)), for: .touchUpInside)
            self.view.addSubview(button)
            
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
        if  (tut.tutNumber < 12 && canTap == true) {
        tut.tutNumber += 1
        updateLabel()
        }
        if (canTap == false) {
            print("Can't Tap")
        }
    }
    
    @objc func buttonClicked(_ sender : UIButton) {
        
        yesButton.removeFromSuperview()
        noButton.removeFromSuperview()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.canTap = true
        }
        UIView.animate(withDuration: 1.5) {
            self.label2.transform = CGAffineTransform(translationX: 0, y: 15)
        }
        UIView.animate(withDuration: 6) {
        self.label3.transform = CGAffineTransform(translationX: 0, y: -65)
        self.ttContinue.alpha = 1.0
        }
        
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



