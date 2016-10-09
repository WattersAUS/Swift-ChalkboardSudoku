//
//  Struct.swift
//  SudokuTest
//
//  Created by Graham Watson on 28/07/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation
import UIKit

//
// device coordinate/size handling
//
struct ImagePosition {
    var coord: (row:Int, column: Int)
    var image: CGRect
    
    init(row: Int, column: Int, image: CGRect) {
        self.coord.row    = row
        self.coord.column = column
        self.image        = image
    }
}

struct Panel {

    //
    // array of CGRects for creating the board and/or ctrl panel later
    //
    var imageDetails: [ImagePosition]

    //
    // build the array row/column, we start at (yMargin, xMargin) and increment from there
    //
    init(hostFrame: CGRect, xOrigin: CGFloat, yOrigin: CGFloat, xMargin: CGFloat, yMargin: CGFloat, rows: Int, columns: Int) {
        //
        // derive image size
        //
        let iWidth: CGFloat  = (hostFrame.width - (xMargin * CGFloat(columns - 1)) - (xOrigin * 2)) / CGFloat(columns)
        let iHeight: CGFloat = (hostFrame.height - (yMargin * CGFloat(rows - 1)) - (yOrigin * 2)) / CGFloat(rows)
        //
        // iterate thro rows/columns and create array of positions for images to be displayed in the host
        //
        self.imageDetails = []
        var yCoord: CGFloat = yOrigin
        for x: Int in 0 ..< rows {
            var xCoord: CGFloat = xOrigin
            for y: Int in 0 ..< columns {
                self.imageDetails.append(ImagePosition(row: x, column: y, image: CGRect(x: xCoord, y: yCoord, width: iWidth, height: iHeight)))
                xCoord += iWidth + xMargin
            }
            yCoord += iHeight + yMargin
        }
    }
}

//
// user selected board/ctrl panel position
//
struct Position {
    var posn: (row: Int, column: Int) = (-1, -1)
    
    init(row: Int, column: Int) {
        self.posn.row    = row
        self.posn.column = column
    }

    func isEqual(posn: Position) -> Bool {
        guard self.posn.row == posn.posn.row && self.posn.column == posn.posn.column else {
            return false
        }
        return true
    }
}

//
// coordinate system / how cell and user inaction position is mapped
//
struct Coordinate {
    var row:        Int = 0
    var column:     Int = 0
    var cell:       (row: Int, column: Int) = (0, 0)
    
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
    //
    // and positions for board and ctrl panel
    //
    var controlPosn:     Position   = Position(row: -1, column: -1)
    var boardPosn:       Coordinate = Coordinate(row: -1, column: -1, cell: (row: -1, column: -1))
}
