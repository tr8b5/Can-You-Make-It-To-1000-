//
//  GameViewController+Extensions.swift
//  Can You Make It To 1000?
//
//  Created by Ashutosh Bhatt on 02/11/22.
//  Copyright © 2022 William Miller. All rights reserved.
//

import Foundation
import GameKit

extension ViewController: GKGameCenterControllerDelegate {
    func authenticatePlayer() {
        let localPlayer = GKLocalPlayer.local
        localPlayer.authenticateHandler = {(controller, error) -> Void in
            
            if controller != nil {
                self.present(controller!, animated: true, completion: nil)
                
            } else if localPlayer.isAuthenticated {
                Constants.gcEnabled = true
                
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil {
                        UIAlertController.show("There is an issue with identifying the leaderboard!", from: self)
                        print(error!)
                    }
                    else {
                        Constants.gcDefaultLeaderBoard = leaderboardIdentifer!
                    }
                })
            } else {
                Constants.gcEnabled = false
                UIAlertController.show("Local player could not be authenticated!", from: self)
                print(error!)
            }
        }
    }
        
    func openLeaderboard() {
        let GameCenterVC = GKGameCenterViewController(leaderboardID: Constants.gcDefaultLeaderBoard, playerScope: .global, timeScope: .allTime)
        GameCenterVC.gameCenterDelegate = self
        present(GameCenterVC, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated:true)
    }
}

extension GameViewController {
    func updateScore(with value:Int)
    {
        if (Constants.gcEnabled)
        {
            GKLeaderboard.submitScore(value, context:0, player: GKLocalPlayer.local, leaderboardIDs: [Constants.gcDefaultLeaderBoard], completionHandler: {error in})
        }
    }
}
