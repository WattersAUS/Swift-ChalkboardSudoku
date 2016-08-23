//
//  Struct.swift
//  SudokuTest
//
//  Created by Graham Watson on 28/07/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation

struct Coordinate {
    var row:        Int = 0
    var column:     Int = 0
    var cell:       (row: Int, column: Int) = (0,0)
    
    init(row: Int, column: Int, cell: (row: Int, column: Int)) {
        self.row         = row
        self.column      = column
        self.cell.row    = cell.row
        self.cell.column = cell.column
    }
}

struct BoardCell {
    var row:    Int          = 0
    var col:    Int          = 0
    var crow:   Int          = 0
    var ccol:   Int          = 0
    var value:  Int          = 0
    var image:  imageStates  = imageStates.Blank
    var active: activeStates = activeStates.Blank
}

struct GameState {
    var startedGames:                  Int = 0
    var completedGames:                Int = 0
    var totalTimePlayed:               Int = 0
    var totalMovesMade:                Int = 0
    var totalMovesDeleted:             Int = 0
    var highScore:                     Int = 0
    var lowScore:                      Int = 0
    var fastestGame:                   Int = 0
    var slowestGame:                   Int = 0
    // now game state vars that will change for the game instance
    // game defaults ie char set are stored via NSUserDefaults
    var applicationVersion:            Int = 0
    var gameInPlay:                   Bool = false
    var penaltyValue:                  Int = 0
    var penaltyIncrementValue:         Int = 0
    var currentGameTime:               Int = 0
    var gameMovesMade:                 Int = 0
    var gameMovesDeleted:              Int = 0
    var gameCells:             [BoardCell] = []
    var originCells:           [BoardCell] = []
    var solutionCells:         [BoardCell] = []
}

