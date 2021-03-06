//
//  Tutorial.swift
//  Can You Make It To 1000?
//
//  Created by William Miller on 6/20/20.
//  Copyright © 2020 William Miller. All rights reserved.
//

import Foundation
import UIKit

struct Tutorial {
    
    var colorArray: [Int] = []
    var wallColorArray: [Int] = []
    var wallColorSet = Set<Int>()
    var wallArray: [UIImage] = []
    var wallSet = Set<UIImage>()
    var shapeValue = 0
    var color = 0
    var randomIndex = 0
    var correctValue = 0
    var leftDiamondValue = 0
    var rightDiamondValue = 1
    var bottomDiamondValue = 2
    var correctDiamondValue = 1
    var score = 0
    var tutorialStep = "Swipe the circle to the diamond with same color as its icon"
    var time: Float = 0.009
    var tutNumber = 0;
    
    var sprites = [
        Sprite(shape: [#imageLiteral(resourceName: "Blue  Circle"), #imageLiteral(resourceName: "Black  Circle"), #imageLiteral(resourceName: "Green  Circle"), #imageLiteral(resourceName: "Grey  Circle"), #imageLiteral(resourceName: "Red  Circle"), #imageLiteral(resourceName: "Purple  Circle"), #imageLiteral(resourceName: "White  Circle"), #imageLiteral(resourceName: "Yellow  Circle"), #imageLiteral(resourceName: "Orange  Circle")],
               diamond: [#imageLiteral(resourceName: "Blue Diamond"), #imageLiteral(resourceName: "Black Diamond"), #imageLiteral(resourceName: "Green Diamond"), #imageLiteral(resourceName: "Grey Diamond"), #imageLiteral(resourceName: "Red Diamond"), #imageLiteral(resourceName: "Purple Diamond"), #imageLiteral(resourceName: "White Diamond"), #imageLiteral(resourceName: "Yellow Diamond"), #imageLiteral(resourceName: "Orange Diamond")],
               wall: [#imageLiteral(resourceName: "Blue Wall"), #imageLiteral(resourceName: "Black Wall"), #imageLiteral(resourceName: "Green Wall"), #imageLiteral(resourceName: "Grey Wall"), #imageLiteral(resourceName: "Red Wall"), #imageLiteral(resourceName: "Purple Wall"), #imageLiteral(resourceName: "White Wall"), #imageLiteral(resourceName: "Yellow Wall"), #imageLiteral(resourceName: "Orange Wall")],
               bottomWall: [#imageLiteral(resourceName: "Blue Wall Small"), #imageLiteral(resourceName: "Black Wall Small"), #imageLiteral(resourceName: "Green Wall Small"), #imageLiteral(resourceName: "Grey Wall Small"), #imageLiteral(resourceName: "Red Wall Small"), #imageLiteral(resourceName: "Purple Wall Small"), #imageLiteral(resourceName: "White Wall Small"), #imageLiteral(resourceName: "Yellow Wall Small"), #imageLiteral(resourceName: "Orange Wall Small")],
               icon: [#imageLiteral(resourceName: "Blue Circle Icon"), #imageLiteral(resourceName: "Black Circle Icon"), #imageLiteral(resourceName: "Green Circle Icon"), #imageLiteral(resourceName: "Grey Circle Icon"), #imageLiteral(resourceName: "Red Circle Icon"), #imageLiteral(resourceName: "Purple Circle Icon"), #imageLiteral(resourceName: "White Circle Icon"), #imageLiteral(resourceName: "Yellow Circle Icon"), #imageLiteral(resourceName: "Orange Circle Icon")],
               correctValue: [0, 1, 2, 3, 4, 5, 6, 7, 8],
               color: ["Blue", "Black", "Green", "Gray", "Red", "Purple", "White", "Yellow", "Orange"]),
        
        Sprite(shape: [#imageLiteral(resourceName: "Blue  Square"), #imageLiteral(resourceName: "Black  Square"), #imageLiteral(resourceName: "Green  Square"), #imageLiteral(resourceName: "Grey  Square"), #imageLiteral(resourceName: "Red  Square"), #imageLiteral(resourceName: "Purple  Square"), #imageLiteral(resourceName: "White  Square"), #imageLiteral(resourceName: "Yellow  Square"), #imageLiteral(resourceName: "Orange  Square")],
               diamond: [#imageLiteral(resourceName: "Blue Diamond"), #imageLiteral(resourceName: "Black Diamond"), #imageLiteral(resourceName: "Green Diamond"), #imageLiteral(resourceName: "Grey Diamond"), #imageLiteral(resourceName: "Red Diamond"), #imageLiteral(resourceName: "Purple Diamond"), #imageLiteral(resourceName: "White Diamond"), #imageLiteral(resourceName: "Yellow Diamond"), #imageLiteral(resourceName: "Orange Diamond")],
               wall: [#imageLiteral(resourceName: "Blue Wall"), #imageLiteral(resourceName: "Black Wall"), #imageLiteral(resourceName: "Green Wall"), #imageLiteral(resourceName: "Grey Wall"), #imageLiteral(resourceName: "Red Wall"), #imageLiteral(resourceName: "Purple Wall"), #imageLiteral(resourceName: "White Wall"), #imageLiteral(resourceName: "Yellow Wall"), #imageLiteral(resourceName: "Orange Wall")],
               bottomWall: [#imageLiteral(resourceName: "Blue Wall Small"), #imageLiteral(resourceName: "Black Wall Small"), #imageLiteral(resourceName: "Green Wall Small"), #imageLiteral(resourceName: "Grey Wall Small"), #imageLiteral(resourceName: "Red Wall Small"), #imageLiteral(resourceName: "Purple Wall Small"), #imageLiteral(resourceName: "White Wall Small"), #imageLiteral(resourceName: "Yellow Wall Small"), #imageLiteral(resourceName: "Orange Wall Small")],
               icon: [#imageLiteral(resourceName: "Blue Square Icon"), #imageLiteral(resourceName: "Black Square Icon"), #imageLiteral(resourceName: "Green Square Icon"), #imageLiteral(resourceName: "Grey Square Icon"), #imageLiteral(resourceName: "Red Square Icon"), #imageLiteral(resourceName: "Purple Square Icon"), #imageLiteral(resourceName: "White Square Icon"), #imageLiteral(resourceName: "Yellow Square Icon"), #imageLiteral(resourceName: "Orange Square Icon")],
               correctValue: [0, 1, 2, 3, 4, 5, 6, 7, 8],
               color: ["Blue", "Black", "Green", "Gray", "Red", "Purple", "White", "Yellow", "Orange"]),
        
        Sprite(shape: [#imageLiteral(resourceName: "Blue  Triangle"), #imageLiteral(resourceName: "Black  Triangle"), #imageLiteral(resourceName: "Green  Triangle"), #imageLiteral(resourceName: "Grey  Triangle"), #imageLiteral(resourceName: "Red  Triangle"), #imageLiteral(resourceName: "Purple  Triangle"), #imageLiteral(resourceName: "White  Triangle"), #imageLiteral(resourceName: "Yellow  Triangle"), #imageLiteral(resourceName: "Orange  Triangle")],
               diamond: [#imageLiteral(resourceName: "Blue Diamond"), #imageLiteral(resourceName: "Black Diamond"), #imageLiteral(resourceName: "Green Diamond"), #imageLiteral(resourceName: "Grey Diamond"), #imageLiteral(resourceName: "Red Diamond"), #imageLiteral(resourceName: "Purple Diamond"), #imageLiteral(resourceName: "White Diamond"), #imageLiteral(resourceName: "Yellow Diamond"), #imageLiteral(resourceName: "Orange Diamond")],
               wall: [#imageLiteral(resourceName: "Blue Wall"), #imageLiteral(resourceName: "Black Wall"), #imageLiteral(resourceName: "Green Wall"), #imageLiteral(resourceName: "Grey Wall"), #imageLiteral(resourceName: "Red Wall"), #imageLiteral(resourceName: "Purple Wall"), #imageLiteral(resourceName: "White Wall"), #imageLiteral(resourceName: "Yellow Wall"), #imageLiteral(resourceName: "Orange Wall")],
               bottomWall: [#imageLiteral(resourceName: "Blue Wall Small"), #imageLiteral(resourceName: "Black Wall Small"), #imageLiteral(resourceName: "Green Wall Small"), #imageLiteral(resourceName: "Grey Wall Small"), #imageLiteral(resourceName: "Red Wall Small"), #imageLiteral(resourceName: "Purple Wall Small"), #imageLiteral(resourceName: "White Wall Small"), #imageLiteral(resourceName: "Yellow Wall Small"), #imageLiteral(resourceName: "Orange Wall Small")],
               icon: [#imageLiteral(resourceName: "Blue Triangle Icon"), #imageLiteral(resourceName: "Black Triangle Icon"), #imageLiteral(resourceName: "Green Triangle Icon"), #imageLiteral(resourceName: "Grey Triangle Icon"), #imageLiteral(resourceName: "Red Triangle Icon"), #imageLiteral(resourceName: "Purple Triangle Icon"), #imageLiteral(resourceName: "White Triangle Icon"), #imageLiteral(resourceName: "Yellow Triangle Icon"), #imageLiteral(resourceName: "Orange Triangle Icon")],
               correctValue: [0, 1, 2, 3, 4, 5, 6, 7, 8],
               color: ["Blue", "Black", "Green", "Gray", "Red", "Purple", "White", "Yellow", "Orange"]),
    ]
    
    
    //Selects 3 unique colors out of the 9 available colors
    mutating func selectColors(repetitions: Int, maxValue: Int) -> [Int] {
        
        if (tutNumber < 3) {
            colorArray = [0,4,7]
        }
        if (tutNumber > 2) {
            //Empties color array
            colorArray = []
            //Creates the array of colors, while not repeating previously picked colors
            for _ in 1...repetitions {
                var n: Int
                repeat {
                    n = random(maxValue: maxValue)
                } while colorArray.contains(n)
                colorArray.append(n)
            }
        }
        
        print(colorArray)
        
            return colorArray
        }
    
        //Randomly selects value out of the 8 colors
        private func random(maxValue: Int) -> Int {
            return Int(arc4random_uniform(UInt32(maxValue + 1)))
        }
        
    
    //Creates Diamonds
     mutating func selectDiamonds() {
        
        if (tutNumber < 3) {
            leftDiamondValue = correctValue
            rightDiamondValue = correctValue
            bottomDiamondValue = correctValue
        }
        if (tutNumber > 2) {
            //Selects a correct Diamond Value out of 3
            correctDiamondValue = Int.random(in: 0...2)
            //Selects left diamond color out of the 3 color array values
            leftDiamondValue = colorArray[Int.random(in: 0...2)]
            //Selects right diamond color out of the 3 color array values
            rightDiamondValue = colorArray[Int.random(in: 0...2)]
            //Selects bottom diamond color out of the 3 color array values
            bottomDiamondValue = colorArray[Int.random(in: 0...2)]
            
            //Picks which diamond will be the correct diamond value based off of the random values created above
            if correctDiamondValue == 0 {
                leftDiamondValue = correctValue
            }
            if correctDiamondValue == 1 {
                rightDiamondValue = correctValue
            }
            if correctDiamondValue == 2 {
                bottomDiamondValue = correctValue
            }
        }
        
    }
    
    //Picks a shape as the main item
    mutating func pickShape() -> UIImage {
        //Picks a random shape and random color
        color = colorArray.randomElement()!
        if (tutNumber == 0) {
            shapeValue = 0
        }
        if (tutNumber == 1) {
            shapeValue = 1
        }
        if (tutNumber == 2) {
            shapeValue = 2
        }
        if (tutNumber > 2) {
            shapeValue = Int.random(in: 0...2)
        }
        correctValue = colorArray[shapeValue]
        //Selects Shape based on Values selected
        let shape: UIImage = (sprites[shapeValue].shape[color])
        return shape
    }
    //Make interger set and assign it to an array then assign those array values to wallArray in order. Use values to determine color for shatter animation
    mutating func pickWalls() -> [UIImage] {
        
       while wallColorSet.count < 3 {
         randomIndex = colorArray.randomElement()!
            wallColorSet.insert(sprites[0].correctValue[randomIndex])
        }
        
        wallColorArray = Array(wallColorSet)
        wallArray = [sprites[0].wall[wallColorArray[0]], sprites[0].wall[wallColorArray[1]], sprites[0].bottomWall[wallColorArray[2]]]
        
        return wallArray
    }
    //Resets wall set
    mutating func resetwallcount() -> Set<Int> {
        wallColorSet = Set<Int>()
        return wallColorSet
    }
    
    //updaes score
    mutating func updateLabel() {
        if (tutNumber == 1) {
            tutorialStep = "Great Job! Now swipe the square to the \ndiamond with same color as its icon"
        }
        if (tutNumber == 2) {
            tutorialStep = "Great Job! Now swipe the Triangle to the diamond with same color as its icon"
        }
        if (tutNumber == 3) {
            tutorialStep = "Seem simple? Now try before the timer ends."
        }
        if (tutNumber == 4) {
            tutorialStep = "Looks like you got the hang of it! \nKeep going!"
        }
        if (tutNumber == 5) {
            tutorialStep = "Try a couple more times"
        }
        if (tutNumber == 6) {
            tutorialStep = "Good Job!"
        }
        if (tutNumber == 7) {
            tutorialStep = "Sensational!"
        }
        if (tutNumber == 8) {
            tutorialStep = "You're a legend!"
        }
        if (tutNumber == 9) {
            tutorialStep = "You are the greatest!"
        }
        if (tutNumber == 10) {
            tutorialStep = "Congratulations you're ready. \nMake it to 1000 and you beat the game. \nGood Luck."
        }
    }
    
}
