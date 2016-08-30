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
    var userIndex: Int = -1

    //
    // prefs
    //
    @IBOutlet weak var characterSet: UISegmentedControl!
    @IBOutlet weak var setDifficulty: UISegmentedControl!
    @IBOutlet weak var gameMode: UISegmentedControl!
    @IBOutlet weak var useSound: UISwitch!
    @IBOutlet weak var allowHints: UISwitch!
    
    //
    // now the game stats
    //
    @IBOutlet weak var timePlayed: UILabel!
    @IBOutlet weak var userGames: UILabel!
    @IBOutlet weak var userFastestTime: UILabel!
    @IBOutlet weak var userSlowestTime: UILabel!
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
        self.characterSet.selectedSegmentIndex  = (prefs?.characterSetInUse)!
        self.setDifficulty.selectedSegmentIndex = (prefs?.difficultyNew)! - 1
        self.gameMode.selectedSegmentIndex      = (prefs?.gameModeInUse)!
        self.useSound.on                        = (prefs?.soundOn)!
        self.allowHints.on                      = (prefs?.hintsOn)!
        //
        // game stats (all read only)
        //
        self.userHistory = state!.currentGame.userHistory
        self.userIndex   = self.findUserHistoryIndex()
        //
        // now we can populate the display fields (this will change if the user selects another difficulty)
        //
        if self.userIndex != -1 {
            self.updateGameHistoryStats()
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
    
    @IBAction func dismissDialog(sender: UIButton) {
        prefs?.difficultyNew = self.setDifficulty.selectedSegmentIndex + 1
        prefs?.gameModeInUse = self.gameMode.selectedSegmentIndex
        prefs?.soundOn       = self.useSound.on
        prefs?.hintsOn       = self.allowHints.on
        if prefs?.characterSetInUse != self.characterSet.selectedSegmentIndex {
            prefs?.characterSetInUse = self.characterSet.selectedSegmentIndex
            for redrawFunction: (Void) -> () in (prefs?.drawFunctions)! {
                redrawFunction()
            }
        }
        for saveFunction: (Void) -> () in (prefs?.saveFunctions)! {
            saveFunction()
        }
        self.dismissViewControllerAnimated(true, completion: nil)
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
    
    private func updateGameHistoryStats() {
        self.timePlayed.text      = (state?.currentGame.userHistory[self.userIndex].getTotalTimePlayedAsString())
        self.userGames.text       = (state?.currentGame.userHistory[self.userIndex].getGamesCountsAsString())
        self.userFastestTime.text = (state?.currentGame.userHistory[self.userIndex].getFastestTimeAsString())
        self.userSlowestTime.text = (state?.currentGame.userHistory[self.userIndex].getSlowestTimeAsString())
        self.userMoves.text       = (state?.currentGame.userHistory[self.userIndex].getMovesCountsAsString())
        return
    }
}
