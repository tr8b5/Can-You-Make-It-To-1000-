//
//  Sound.swift
//  Can You Make It To 1000?
//
//  Created by William Miller on 1/6/21.
//  Copyright © 2021 William Miller. All rights reserved.
//

import Foundation

struct Sound {
    var sound = true
    var fx = true
    
    mutating func loadSound() {
        let defaultSound: UserDefaults = UserDefaults.standard
        sound = defaultSound.bool(forKey: "sound")
    }
    
    mutating func saveSound() {
        
        let defaultSound: UserDefaults = UserDefaults.standard
        defaultSound.set(sound, forKey: "sound")
        defaultSound.synchronize()
        

    }
    
    mutating func loadFx() {
        let defaultfx: UserDefaults = UserDefaults.standard
        fx = defaultfx.bool(forKey: "fx")
    }
    
    mutating func saveFx() {
        
        let defaultfx: UserDefaults = UserDefaults.standard
        defaultfx.set(fx, forKey: "fx")
        defaultfx.synchronize()
        
    }
}
