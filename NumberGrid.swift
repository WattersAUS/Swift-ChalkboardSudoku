//
//  NumberGrid.swift
//  ChalkBoardSudoku
//
//  Created by Graham Watson on 20/08/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation

class NumberGrid: NSObject, NSCopying {
    
    private var number: [[Int]] = []
    private var coords: [(row: Int, column: Int)] = []
    private var size: (rows: Int, columns: Int)
    
    init (size: (rows: Int, columns: Int)) {
        self.size.rows = size.rows
        if self.size.rows < 1 {
            self.size.rows = 3
        }
        self.size.columns = size.columns
        if self.size.columns < 1 {
            self.size.columns = 3
        }
        for row: Int in 0 ..< self.size.rows {
            var rowOfNumbers: [Int] = [ 0 ]
            for column: Int in 0 ..< self.size.columns {
                coords.append((row, column))
                if column > 0 {
                    rowOfNumbers.append(0)
                }
            }
            self.number.append(rowOfNumbers)
        }
        return
    }
    
    //
    // coord bounds within array
    //
    func boundsCheck(coord: (row: Int, column: Int)) -> Bool {
        guard (0..<self.size.rows) ~= coord.row &&
            (0..<self.size.columns) ~= coord.column
        else {
            return false
        }
        return true
    }
    
    //
    // public - object state functions
    //
    func getSize() -> (rows: Int, columns: Int) {
        return size
    }
    
    func getColumns() -> Int {
        return self.size.columns
    }
    
    func getRows() -> Int {
        return self.size.rows
    }
    
    func getCoords() -> [(row: Int, column: Int)] {
        return self.coords
    }

    //
    // public functions - number level operations
    //
    func getNumber(coord: (row: Int, column: Int)) -> Int {
        guard self.boundsCheck(coord) else {
            return 0
        }
        return self.number[coord.row][coord.column]
    }
    
    func setNumber(coord: (row: Int, column: Int), number: Int)  -> Bool {
        guard self.boundsCheck(coord) else {
            return false
        }
        self.number[coord.row][coord.column] = number
        return true
    }
    
    //
    // public functions - cell level operations
    //
    func clear() {
        for index: Int in 0 ..< self.coords.count {
            self.number[self.coords[index].row][self.coords[index].column] = 0
        }
        return
    }
    
    func getLocationsOfNumber(number: Int) -> [(row: Int, column: Int)] {
        var coords: [(row: Int, column: Int)] = []
        for index: Int in 0 ..< self.coords.count {
            if self.number[self.coords[index].row][self.coords[index].column] == number {
                coords.append(self.coords[index])
            }
        }
        return coords
    }
    
    //
    // copy object operation
    //
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = NumberGrid(size: self.size)
        for index: Int in 0 ..< self.coords.count {
            copy.number[self.coords[index].row][self.coords[index].column] = self.number[self.coords[index].row][self.coords[index].column]
        }
        return copy
    }
    
}