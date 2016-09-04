//
//  Preferences.swift
//  SudokuTest
//
//  Created by Graham Watson on 10/07/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import UIKit

class Preferences: UIViewController {
    
    weak var prefs: PreferencesDelegate?
    weak var state: GameStateDelegate?
    var userHistory: [GameHistory] = []

    //
    // prefs
    //
    @IBOutlet weak var userDifficulty: UISegmentedControl!
    @IBOutlet weak var userCharacterSet: UISegmentedControl!
    @IBOutlet weak var userSound: UISwitch!
    @IBOutlet weak var userHints: UISwitch!
    
    //
    // now the game stats
    //
    @IBOutlet weak var timePlayed: UILabel!
    @IBOutlet weak var userGames: UILabel!
    @IBOutlet weak var fastestTime: UILabel!
    @IBOutlet weak var slowestTime: UILabel!
    @IBOutlet weak var userMoves: UILabel!
    
    //
    // ** remember we re-map difficulty from 1 -> 3 to 0 -> 2 **
    // ** and reverse when we leave the dialog                **
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        // get the current state of the prefs
        //
        self.userDifficulty.selectedSegmentIndex   = (prefs?.difficultyNew)! - 1
        self.userCharacterSet.selectedSegmentIndex = (prefs?.characterSetInUse)!
        self.userSound.isOn                        = (prefs?.soundOn)!
        self.userHints.isOn                        = (prefs?.hintsOn)!
        //
        // game stats (all read only)
        //
        self.userHistory = state!.currentGame.userHistory
        let index: Int = self.findUserHistoryIndex()
        //
        // now we can populate the display fields (this will change if the user selects another difficulty)
        //
        if index != -1 {
            self.updateGameHistoryStats(index: index)
        }
        return
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func userSelectedDifficulty(_ sender: UISegmentedControl) {
        if prefs?.difficultyNew != self.userDifficulty.selectedSegmentIndex + 1 {
            prefs?.difficultyNew = self.userDifficulty.selectedSegmentIndex + 1
            self.updateGameHistoryStats(index: self.findUserHistoryIndex())
        }
        return
    }
    
    @IBAction func okButtonSelected(_ sender: UIButton) {
        prefs?.difficultyNew = self.userDifficulty.selectedSegmentIndex + 1
        prefs?.soundOn       = self.userSound.isOn
        prefs?.hintsOn       = self.userHints.isOn
        if prefs?.characterSetInUse != self.userCharacterSet.selectedSegmentIndex {
            prefs?.characterSetInUse = self.userCharacterSet.selectedSegmentIndex
            for redrawFunction: (Void) -> () in (prefs?.drawFunctions)! {
                redrawFunction()
            }
        }
        for saveFunction: (Void) -> () in (prefs?.saveFunctions)! {
            saveFunction()
        }
        self.dismiss(animated: true, completion: nil)
        return
    }
    
    private func findUserHistoryIndex() -> Int {
        for i: Int in 0 ..< self.userHistory.count {
            if (prefs?.difficultyNew)! == self.userHistory[i].getDifficulty().rawValue  {
                return i
            }
        }
        return -1
    }
    
    private func updateGameHistoryStats(index: Int) {
        self.timePlayed.text  = (state?.currentGame.userHistory[index].getTotalTimePlayedAsString())
        self.userGames.text   = (state?.currentGame.userHistory[index].getGamesCountsAsString())
        self.fastestTime.text = (state?.currentGame.userHistory[index].getFastestTimeAsString())
        self.slowestTime.text = (state?.currentGame.userHistory[index].getSlowestTimeAsString())
        self.userMoves.text   = (state?.currentGame.userHistory[index].getMovesCountsAsString())
        return
    }
}
