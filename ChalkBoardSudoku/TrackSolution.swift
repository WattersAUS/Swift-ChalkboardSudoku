//
//  TrackSolution.swift
//  SudokuTest
//
//  Created by Graham Watson on 14/04/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation

class TrackSolution: NSObject {
    
    private var coords: [Coordinate] = []
    private var size: Coordinate = Coordinate(row: -1, column: -1, cell: (-1, -1))
    
    init(row: Int = 3, column: Int = 3, cellRow: Int = 3, cellColumn: Int = 3) {
        self.size.row = row
        self.size.column = column
        self.size.cell.row = cellRow
        self.size.cell.column = cellColumn
        return
    }
    
    //----------------------------------------------------------------------------
    // Generic are we within the bounds of the board check
    //----------------------------------------------------------------------------
    private func coordBoundsCheck(coord: Coordinate) -> Bool {
        guard (0..<self.size.row) ~= coord.row &&
            (0..<self.size.column) ~= coord.column &&
            (0..<self.size.cell.row) ~= coord.cell.row &&
            (0..<self.size.cell.column) ~= coord.cell.column
            else {
                return false
        }
        return true
    }
    
    //----------------------------------------------------------------------------
    // Generic equality test
    //----------------------------------------------------------------------------
    private func coordinatesEqual(coord1: Coordinate, coord2: Coordinate) -> Bool {
        guard coord1.row == coord2.row && coord1.column == coord2.column && coord1.cell.row == coord2.cell.row && coord1.cell.column == coord2.cell.column else {
            return false
        }
        return true
    }
    
    //
    // only add the coord if in bounds of the board we're tracking, and it hasn't already been added
    //
    func addCoordinate(coord: Coordinate) -> Int {
        guard self.coordBoundsCheck(coord) && self.getCoordinateIndex(coord) == -1 else {
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
    
    func getCoordinatesInSolution() -> [Coordinate] {
        return coords
    }

    func getCoordinateAtIndex(index: Int) -> Coordinate {
        if index > self.countOfUserSolution() - 1 {
            return Coordinate(row: -1, column: -1, cell: (-1, -1))
        }
        return coords[index]
    }
    
    func getCoordinateIndex(coord: Coordinate) -> Int {
        for index: Int in 0 ..< self.countOfUserSolution() {
            if self.coordinatesEqual(coord, coord2: coords[index]) {
                return index
            }
        }
        return -1
    }
    
    //
    // remove the coord only if in bounds of the board and it's been stored previously
    //
    func removeCoordinate(coord: Coordinate) -> Int {
        guard self.coordBoundsCheck(coord) else {
            return -1
        }
        for index: Int in 0 ..< self.countOfUserSolution() {
            
            if self.coordinatesEqual(coord, coord2: coords[index]) {
                coords.removeAtIndex(index)
                return self.coords.count
            }
        }
        return -1
    }
    
}