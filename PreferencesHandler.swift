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
    var difficultySet:              Int { get set }
    var difficultyNew:              Int { get set }
    var gameModeInUse:              Int { get set }
    var soundOn:                   Bool { get set }
    var hintsOn:                   Bool { get set }
    // if we swap the char set redraw the board
    var drawFunctions: [(Void) -> ()] { get set }
    var saveFunctions: [(Void) -> ()] { get set }
}

class PreferencesHandler: NSObject, PreferencesDelegate {
    var characterSetInUse:          Int = 0
    var difficultySet:              Int = 0
    var difficultyNew:              Int = 0
    var gameModeInUse:              Int = 0
    var soundOn:                   Bool = true
    var hintsOn:                   Bool = false
    var drawFunctions:   [(Void) -> ()] = []
    var saveFunctions:   [(Void) -> ()] = []
    
    let userDefaults: UserDefaults = UserDefaults.standard

    init(redrawFunctions: [(Void) -> ()]) {
        super.init()
        //
        // get the difficulty first, if we get 0 then the prefs have never been saved. so save them
        //
        let difficulty: Int = self.userDefaults.integer(forKey: "difficulty")
        if difficulty != 0 {
            self.characterSetInUse = self.userDefaults.integer(forKey: "charset")
            self.difficultySet     = difficulty
            self.difficultyNew     = self.difficultySet
            self.gameModeInUse     = self.userDefaults.integer(forKey: "gamemode")
            self.soundOn           = self.userDefaults.bool(forKey: "sound")
            self.hintsOn           = self.userDefaults.bool(forKey: "hint")
        } else {
            // store for the first time
            self.characterSetInUse = imageSet.Default.rawValue
            self.difficultySet     = sudokuDifficulty.Medium.rawValue
            self.difficultyNew     = self.difficultySet
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
        self.userDefaults.set(self.characterSetInUse, forKey: "charset")
        self.userDefaults.set(self.difficultySet, forKey: "difficulty")
        self.userDefaults.set(self.gameModeInUse, forKey: "gamemode")
        self.userDefaults.set(self.soundOn, forKey: "sound")
        self.userDefaults.set(self.hintsOn, forKey: "hint")
        return
    }
    
}


