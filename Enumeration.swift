//
//  Enumeration.swift
//  SudokuTest
//
//  Created by Graham Watson on 11/07/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation

//
// states we'l use during display/game
//
enum imgStates: Int {
    case Origin    = 0
    case Selected  = 1
    case Delete    = 2
    case Inactive  = 3
    case Highlight = 4
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
// external difficulty (used everywhere except in the Game Board Class)
//
enum gameDiff: Int {
    case Easy   = 0
    case Medium = 1
    case Hard   = 2
}

//
// internal game board difficulty
//
enum gameBoardDiff: Int {
    case Easy   = 3
    case Medium = 5
    case Hard   = 7
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
    case GamesStarted          = "GAMESSTARTED"
    case GamesCompleted        = "GAMESCOMPLETED"
    case TotalTimePlayed       = "TOTALTIMEPLAYED"
    case TotalMovesMade        = "TOTALMOVESMADE"
    case TotalMovesDeleted     = "TOTALMOVESDELETED"
    case HighScore             = "HIGHSCORE"
    case LowScore              = "LOWSCORE"
    case FastestGameTime       = "FASTESTGAMETIME"
    case SlowestGameTime       = "SLOWESTGAMETIME"
    case GameInPlay            = "GAMEINPLAY"
    case PenaltyValue          = "PENALTYVALUE"
    case PenaltyIncrementValue = "PENALTYINCREMENTVALUE"
    case CurrentGameTime       = "CURRENTGAMETIME"
    case GameMovesMade         = "GAMEMOVESMADE"
    case GameMovesDeleted      = "GAMEMOVESDELETED"
    case GameBoard             = "GAMEBOARD"
    case OriginBoard           = "ORIGINBOARD"
    case SolutionBoard         = "SOLUTIONBOARD"
}

//
// define dictionary keys for cell storage
//
enum cellDictionary: String {
    case row   = "row"
    case col   = "col"
    case crow  = "crow"
    case ccol  = "ccol"
    case value = "value"
    case state = "state"
    case board = "board"
}
