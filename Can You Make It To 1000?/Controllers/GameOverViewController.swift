//
//  GameOverViewController.swift
//  Can You Make It To 1000?
//
//  Created by William Miller on 2/29/20.
//  Copyright © 2020 William Miller. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    
    var gameView = GameViewController()
    var score: Int!
    var highscore = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
    @IBAction func tryButtonClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToGame", sender: self)
    }
    @IBAction func homeButtonClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToHome", sender: self)
    }
    
    
}
