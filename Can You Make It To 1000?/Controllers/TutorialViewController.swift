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
   
    
    @IBOutlet var videoLayer: UIView!
    
    @IBOutlet weak var exitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        assignTutorial()
        assignbackground()
        
        self.view.backgroundColor = UIColor.black
        
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
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
    
    func assignTutorial(){
        
            let tutStep = UIImage(named: "Tutorial Completed")

            var imageView : UIImageView!
            imageView = UIImageView(frame: view.bounds)
            imageView.contentMode =  UIView.ContentMode.scaleAspectFill
            imageView.clipsToBounds = true
            imageView.image = tutStep
            imageView.center = view.center
            imageView.alpha = 1;
            view.addSubview(imageView)
            self.view.sendSubviewToBack(imageView)
        
            
            
        
        }
    
    @IBAction func exitButtonClicked(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Home") as! ViewController
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
    }
   
}



