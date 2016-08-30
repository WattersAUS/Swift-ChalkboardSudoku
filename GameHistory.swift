//
//  GameHistory.swift
//  ChalkBoardSudoku
//
//  Created by Graham Watson on 30/08/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation

class GameHistory {
    private var difficulty:        sudokuDifficulty
    private var startedGames:      Int
    private var completedGames:    Int
    private var totalTimePlayed:   Int
    private var totalMovesMade:    Int
    private var totalMovesDeleted: Int
    private var highestScore:      Int
    private var lowestScore:       Int
    private var fastestGame:       Int
    private var slowestGame:       Int
    
    init(difficulty: sudokuDifficulty = sudokuDifficulty.Medium) {
        self.difficulty        = difficulty
        self.startedGames      = 0
        self.completedGames    = 0
        self.totalTimePlayed   = 0
        self.totalMovesMade    = 0
        self.totalMovesDeleted = 0
        self.highestScore      = 0
        self.lowestScore       = 0
        self.fastestGame       = 0
        self.slowestGame       = 0
    }
    
    //
    // formatters to help
    //
    private func formatTimeInSecondsAsTimeString(time: Int) -> String {
        let hours: Int = time / 3600
        let mins:  Int = (time - (hours * 3600)) / 60
        let secs:  Int = time - (hours * 3600) - (mins * 60)
        return String(format: "%02d", hours) + ":" + String(format: "%02d", mins) + ":" + String(format: "%02d", secs)
    }
    
    private func formatNumbersAsString(numbers: Int...) -> String {
        var str: String = ""
        for number: Int in numbers {
            if str != "" {
                str.appendContentsOf(" / ")
            }
            str.appendContentsOf(String(format: "%04d", number))
        }
        return str
    }
    
    //
    // default gets/sets
    //
    func getDifficulty() -> sudokuDifficulty {
        return self.difficulty
    }
    
    func getStartedGames() -> Int {
        return self.startedGames
    }
    
    func getCompletedGames() -> Int {
        return self.completedGames
    }

    func getGamesCountsAsString() -> String {
        return self.formatNumbersAsString(self.startedGames, self.completedGames)
    }
    
    func getTotalTimePlayed() -> Int {
        return self.totalTimePlayed
    }
    
    func getTotalTimePlayedAsString() -> String {
        return self.formatTimeInSecondsAsTimeString(self.totalTimePlayed)
    }
    
    func getTotalMovesMade() -> Int {
        return self.totalMovesMade
    }
    
    func getTotalMovedDeleted() -> Int {
        return self.totalMovesDeleted
    }
    
    func getMovesCountsAsString() -> String {
        return self.formatNumbersAsString(self.totalMovesMade, self.totalMovesDeleted)
    }
    
    func getHighestScore() -> Int {
        return self.highestScore
    }
    
    func getLowestScore() -> Int {
        return self.lowestScore
    }
    
    func getFastestGame() -> Int {
        return self.fastestGame
    }
    
    func getSlowestGame() -> Int {
        return self.slowestGame
    }

    func getFastestTimeAsString() -> String {
        return self.formatTimeInSecondsAsTimeString(self.fastestGame)
    }
    
    func getSlowestTimeAsString() -> String {
        return self.formatTimeInSecondsAsTimeString(self.slowestGame)
    }
    
    //
    // set when we load the save game, otherwise increments should be used
    //
    func setStartedGames(games: Int) {
        self.startedGames = games
        return
    }
    
    func setCompletedGames(games: Int) {
        self.completedGames = games
        return
    }
    
    func setTotalGameTimePlayed(time: Int) {
        self.totalTimePlayed = time
    }
    
    func setTotalPlayerMovesMade(moves: Int) {
        self.totalMovesMade = moves
    }
    
    func setTotalPlayerMovesDeleted(moves: Int) {
        self.totalMovesMade = moves
    }
    
    //
    // once created most attributes of the GameHistory obj are incremented
    //
    func incrementStartedGames() {
        self.startedGames = self.startedGames + 1
        return
    }
    
    func incrementCompletedGames() {
        self.completedGames = self.completedGames + 1
        return
    }
    
    func incrementTotalGameTimePlayed(increment: Int) -> Int {
        self.totalTimePlayed = self.totalTimePlayed + increment
        return self.totalTimePlayed
    }
    
    func incrementTotalPlayerMovesMade(increment: Int) -> Int {
        self.totalMovesMade = self.totalMovesMade + increment
        return self.totalMovesMade
        }
    
    func incrementTotalPlayerMovesDeleted(increment: Int) -> Int {
        self.totalMovesDeleted = self.totalMovesDeleted + increment
        return totalMovesDeleted
    }

    //
    // only a few can set set outright during normal use
    //
    func setHighestScore(score: Int) -> Bool {
        if self.highestScore == 0 || self.highestScore < score {
            self.highestScore = score
            return true
        }
        return false
    }
    
    func setLowestScore(score: Int) -> Bool {
        if self.lowestScore > score {
            self.lowestScore = score
            return true
        }
        return false
    }
    
    func setFastestTime(newTime: Int) -> Bool {
        if self.fastestGame == 0 || self.fastestGame < newTime {
            self.fastestGame = newTime
            return true
        }
        return false
    }
    
    func setSlowestTime(newTime: Int) -> Bool {
        if newTime > self.slowestGame {
            self.slowestGame = newTime
            return true
        }
        return false
    }
}