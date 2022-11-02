//
//  GameViewController+Extensions.swift
//  Can You Make It To 1000?
//
//  Created by Ashutosh Bhatt on 02/11/22.
//  Copyright © 2022 William Miller. All rights reserved.
//

import Foundation
import GameKit

extension GameViewController {
    func aunthenticatePlayer() {
        let localPlayer = GKLocalPlayer.local
        localPlayer.authenticateHandler = {(controller, error) -> Void in
            
            if controller != nil {
                self.present(controller!, animated: true, completion: nil)
                
            } else if localPlayer.isAuthenticated {
                self.gcEnabled = true
                
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil {
                        UIAlertController.show("There is an issue with identifying the leaderboard!", from: self)
                        print(error!)
                    }
                    else {
                        self.gcDefaultLeaderBoard = leaderboardIdentifer!
                    }
                })
            } else {
                self.gcEnabled = false
                UIAlertController.show("Local player could not be authenticated!", from: self)
                print(error!)
            }
        }
    }
    
    func updateScore(with value:Int)
    {
        if (self.gcEnabled)
        {
            GKLeaderboard.submitScore(value, context:0, player: GKLocalPlayer.local, leaderboardIDs: [self.gcDefaultLeaderBoard], completionHandler: {error in})
        }
    }
    
    func openLeaderboard() {
        let GameCenterVC = GKGameCenterViewController(leaderboardID: self.gcDefaultLeaderBoard, playerScope: .global, timeScope: .allTime)
        GameCenterVC.gameCenterDelegate = self
        present(GameCenterVC, animated: true, completion: nil)
    }
}

extension GameViewController: GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated:true)
    }
}
