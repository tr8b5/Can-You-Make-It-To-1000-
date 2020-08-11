//
//  ViewController.swift
//  Can You Make It To 1000?
//
//  Created by William Miller on 2/12/20.
//  Copyright © 2020 William Miller. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var tutorialButton: UIButton!
    @IBOutlet weak var rankGameButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func removeTitleMenu() {
        titleLabel.removeFromSuperview()
        playButton.removeFromSuperview()
        tutorialButton.removeFromSuperview()
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

}

