//
//  PreferencesHandler.swift
//  SudokuTest
//
//  Created by Graham Watson on 10/07/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//
//----------------------------------------------------------------------------
// this class defines the 'protocol' used to allow the settings dialog to
// delegate the responsibility of keeping the defaults updated and including
// ensuring they are updated through the NSUserDefaults interface
//----------------------------------------------------------------------------

import Foundation

protocol PreferencesDelegate: class {
    // what we use to populate the pref dialog
    var characterSetInUse:          Int { get set }
    var difficultySet: sudokuDifficulty { get set }
    var gameModeInUse:              Int { get set }
    var soundOn:                   Bool { get set }
    var hintsOn:                   Bool { get set }
    // if we swap the char set redraw the board
    var drawFunctions: [(Void) -> ()] { get set }
    var saveFunctions: [(Void) -> ()] { get set }
}

class PreferencesHandler: NSObject, PreferencesDelegate {
    var characterSetInUse:          Int = 0
    var difficultySet: sudokuDifficulty = sudokuDifficulty.Medium
    var gameModeInUse:              Int = 0
    var soundOn:                   Bool = true
    var hintsOn:                   Bool = false
    var drawFunctions:   [(Void) -> ()] = []
    var saveFunctions:   [(Void) -> ()] = []
    
    let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()

    //init(charSet: Int, difficulty: Int, mode: Int, sound: Bool, hints: Bool, redrawFunctions: [(Void) -> ()]) {
    init(redrawFunctions: [(Void) -> ()]) {
        super.init()
        //
        // get the difficulty first, if we get 0 then the prefs have never been saved. so save them
        //
        let difficulty: Int = self.userDefaults.integerForKey("difficulty")
        if difficulty != 0 {
            self.characterSetInUse = self.userDefaults.integerForKey("charset")
            switch difficulty {
            case 0:
                self.difficultySet = sudokuDifficulty.Easy
                break
            case 1:
                self.difficultySet = sudokuDifficulty.Medium
                break
            case 2:
                self.difficultySet = sudokuDifficulty.Hard
                break
            default:
                self.difficultySet = sudokuDifficulty.Medium
            }
            self.gameModeInUse     = self.userDefaults.integerForKey("gamemode")
            self.soundOn           = self.userDefaults.boolForKey("sound")
            self.hintsOn           = self.userDefaults.boolForKey("hint")
        } else {
            // store for the first time
            self.characterSetInUse = imageSet.Default.rawValue
            self.difficultySet     = sudokuDifficulty.Medium
            self.gameModeInUse     = gameMode.Normal.rawValue
            self.soundOn           = true
            self.hintsOn           = false
            self.savePreferences()
        }
        for functionName: (Void) -> () in redrawFunctions {
            self.drawFunctions.append(functionName)
        }
        self.saveFunctions = [ self.savePreferences ]
        return
    }

    func savePreferences() -> (Void) {
        self.userDefaults.setInteger(self.characterSetInUse, forKey: "charset")
        self.userDefaults.setInteger(self.difficultySet.rawValue, forKey: "difficulty")
        self.userDefaults.setInteger(self.gameModeInUse, forKey: "gamemode")
        self.userDefaults.setBool(self.soundOn, forKey: "sound")
        self.userDefaults.setBool(self.hintsOn, forKey: "hint")
        return
    }
    
}


