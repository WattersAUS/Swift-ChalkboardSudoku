//
//  Struct.swift
//  SudokuTest
//
//  Created by Graham Watson on 28/07/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation

//
// coordinate system / how cell and user inaction position is mapped
//
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
    
    func isEqual(coord: Coordinate) -> Bool {
        guard self.row == coord.row && self.column == coord.column && self.cell.row == coord.cell.row && self.cell.column == coord.cell.column else {
            return false
        }
        return true
    }
}

//
// saving and retrieving user game progress and user history from the JSON structure we use to store it
//
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
    //
    // now game state vars that will change for the game instance
    // game defaults ie char set are stored via NSUserDefaults
    //
    var applicationVersion:    Int = 0
    var gameInPlay:           Bool = false
    var penaltyValue:          Int = 0
    var penaltyIncrementValue: Int = 0
    var currentGameTime:       Int = 0
    var gameMovesMade:         Int = 0
    var gameMovesDeleted:      Int = 0
    //
    // then store all the difficulty dependant stuff, games played, moves, scores etc
    //
    var userHistory: [GameHistory] = []
    //
    // store the game board themselves
    //
    var gameCells:     [BoardCell] = []
    var originCells:   [BoardCell] = []
    var solutionCells: [BoardCell] = []
    //
    // and the control panel
    //
    var controlPanel:  [BoardCell] = []
}

