//
//  Enumeration.swift
//  SudokuTest
//
//  Created by Graham Watson on 11/07/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation

//
// what version of the game are we
//
enum gameBuild: Int {
    case Version   = 1
}
//
// states we'l use during display/game
//
enum imageStates: Int {
    case Blank     = -1
    case Origin    =  0
    case Selected  =  1
    case Delete    =  2
    case Inactive  =  3
    case Highlight =  4
}

enum activeStates: Int {
    case Blank     = -1
    case Inactive  =  0
    case Active    =  1
}

//
// images sets we have available
//
enum imageSet: Int {
    case Default = 0
    case Greek   = 1
    case Alpha   = 2
}

//
// external difficulty (used everywhere except in the SudokuGameBoard class)
//
enum sudokuDifficulty: Int {
    case Easy   = 1
    case Medium = 2
    case Hard   = 3
}

//
// initial hint penalty values
//
enum initialHintPenalty: Int {
    case Easy   = 5
    case Medium = 10
    case Hard   = 15
}

enum initialPenaltyIncrement: Int {
    case Easy   = 1
    case Medium = 3
    case Hard   = 5
}

//
// game modes
//
enum gameMode: Int {
    case Normal    = 0
    case Challenge = 1
    case Timer     = 2
}

//
// what we'll save from the current game to maintain state when app is closed/re-opened (JSON)
//
enum saveGameDictionary: String {
    case ApplicationVersion    = "APPLICATIONVERSION"
    case GameInPlay            = "GAMEINPLAY"
    case PenaltyValue          = "PENALTYVALUE"
    case PenaltyIncrementValue = "PENALTYINCREMENTVALUE"
    case CurrentGameTime       = "CURRENTGAMETIME"
    case GameMovesMade         = "GAMEMOVESMADE"
    case GameMovesDeleted      = "GAMEMOVESDELETED"
    case GameBoard             = "GAMEBOARD"
    case OriginBoard           = "ORIGINBOARD"
    case SolutionBoard         = "SOLUTIONBOARD"
    case UserHistory           = "USERHISTORY"
    case ControlPanel          = "CONTROLPANEL"
    case ControlPosition       = "CONTROLPOSITION"
    case BoardPosition         = "BOARDPOSITION"
}

//
// define dictionary keys for cell storage
//
enum cellDictionary: String {
    case row    = "row"
    case col    = "col"
    case crow   = "crow"
    case ccol   = "ccol"
    case value  = "value"
    case image  = "image"
    case active = "active"
    case board  = "board"
}

//
// define dictionary keys for position storage
//
enum posnDictionary: String {
    case row    = "row"
    case column = "column"
}

//
// user history
//
enum userGameHistory: String {
    case difficulty        = "difficulty"
    case gamesStarted      = "gamestarted"
    case gamesCompleted    = "gamescompleted"
    case totalTimePlayed   = "totaltimeplayed"
    case totalMovesMade    = "totalmovesmade"
    case totalMovesDeleted = "totalmovesdeleted"
    case highestScore      = "highestscore"
    case lowestScore       = "lowestscore"
    case fastestTime       = "fastesttime"
    case slowestTime       = "slowesttime"
}
