//
//  TrackSolution.swift
//  SudokuTest
//
//  Created by Graham Watson on 14/04/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation

class TrackSolution: NSObject, NSCopying {
    
    private var coords: [(row: Int, column: Int, cellRow: Int, cellColumn: Int)] = []
    private var boardSize: (row: Int, column: Int, cellRow: Int, cellColumn: Int) = (-1, -1, -1, -1)
    
    init(row: Int = 3, column: Int = 3, cellRow: Int = 3, cellColumn: Int = 3) {
        self.boardSize.row = row
        self.boardSize.column = column
        self.boardSize.cellRow = cellRow
        self.boardSize.cellColumn = cellColumn
        return
    }
    
    // only add the coord if in bounds of the board we're tracking, and it hasn't already been added
    func addCoordinate(coord: (row: Int, column: Int, cellRow: Int, cellColumn: Int)) -> Int {
        if coord.row < 0 || coord.column < 0 || coord.cellRow < 0 || coord.cellColumn < 0 {
            return -1
        }
        if coord.row >= self.boardSize.row || coord.column >= self.boardSize.column || coord.cellRow >= self.boardSize.cellRow || coord.cellColumn >= self.boardSize.cellColumn {
            return -1
        }
        if self.getCoordinateIndex(coord) > -1 {
            return -1
        }
        coords.append(coord)
        return self.coords.count
    }

    func clearCoordinates() {
        self.coords.removeAll()
        return
    }
    
    func countOfUserSolution() -> Int {
        return coords.count
    }
    
    func getCoordinatesInSolution() -> [(row: Int, column: Int, cellRow: Int, cellColumn: Int)] {
        return coords
    }

    func getCoordinateAtIndex(index: Int) -> (row: Int, column: Int, cellRow: Int, cellColumn: Int) {
        if index > self.countOfUserSolution() - 1 {
            return(-1, -1, -1, -1)
        }
        return coords[index]
    }
    
    func getCoordinateIndex(coord: (row: Int, column: Int, cellRow: Int, cellColumn: Int)) -> Int {
        for index: Int in 0 ..< self.countOfUserSolution() {
            if coord == coords[index] {
                return index
            }
        }
        return -1
    }
    
    func getBoardSize() -> ((row: Int, column: Int, cellRow: Int, cellColumn: Int)) {
        return boardSize
    }
    
    // remove the coord only if in bounds of the board and it's been stored
    func removeCoordinate(coord: (row: Int, column: Int, cellRow: Int, cellColumn: Int)) -> Int {
        if coord.row < 0 || coord.column < 0 || coord.cellRow < 0 || coord.cellColumn < 0 {
            return -1
        }
        if coord.row >= self.boardSize.row || coord.column >= self.boardSize.column || coord.cellRow >= self.boardSize.cellRow || coord.cellColumn >= self.boardSize.cellColumn {
            return -1
        }
        for index: Int in 0 ..< self.countOfUserSolution() {
            if coord == coords[index] {
                coords.removeAtIndex(index)
                return self.coords.count
            }
        }
        return -1
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = TrackSolution(row: self.boardSize.row, column: self.boardSize.column, cellRow: self.boardSize.cellRow, cellColumn: self.boardSize.cellColumn)
        for coord in self.coords {
            copy.coords.append(coord)
        }
        copy.boardSize = self.boardSize
        return copy
    }
    
}