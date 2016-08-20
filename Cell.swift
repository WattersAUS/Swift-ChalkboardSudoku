//
//  Cell.swift
//  SudokuTest
//
//  Created by Graham Watson on 02/04/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation

class Cell: NSObject, NSCopying {
    
    private var cellNumbers: [[Int]] = []
    private var cellCoordinates: [(row: Int, column: Int)] = []
    private var cellColumns: Int = 0
    private var cellRows: Int = 0
    
    private var numbersUsed: [Bool] = []
    //private var cellCompleted: Bool = false

    init (size: Int = 3) {
        self.cellColumns = size
        if self.cellColumns != 3 {
            self.cellColumns = 3
        }
        self.cellRows = self.cellColumns
        
        for row: Int in 0 ..< self.cellRows {
            var rowOfNumbers: [Int] = [ 0 ]
            for column: Int in 0 ..< self.cellColumns {
                cellCoordinates.append((row, column))
                if column > 0 {
                    rowOfNumbers.append(0)
                }
            }
            self.cellNumbers.append(rowOfNumbers)
        }
        for _: Int in 0 ..< (self.cellRows * self.cellColumns) {
            self.numbersUsed.append(false)
        }
        return
    }
    
    //
    // private functions
    //
    private func resetCellUsage() {
        for index: Int in 0 ..< self.numbersUsed.count {
            self.numbersUsed[index] = false
        }
        return
    }
    
    private func getNumbersArray() -> [Bool] {
        var values: [Bool] = []
        for index: Int in 0 ..< self.numbersUsed.count {
            values.append(self.numbersUsed[index])
        }
        return values
    }
    
    private func setNumberAsUsed(numberUsed: Int) {
        guard (1..<(self.numbersUsed.count + 1)) ~= numberUsed else {
            return
        }
        self.numbersUsed[numberUsed - 1] = true
        return
    }
    
    private func setNumberAsUnUsed(numberUsed: Int) {
        guard (1..<(self.numbersUsed.count + 1)) ~= numberUsed else {
            return
        }
        self.numbersUsed[numberUsed - 1] = false
        return
    }

    //
    // public - object state functions
    //
    func cellWidth() -> Int {
        return self.cellColumns
    }
    
    func cellDepth() -> Int {
        return self.cellRows
    }
    
    func isCellCompleted() -> Bool {
        return !self.numbersUsed.contains(false)
    }
    
    //
    // public functions - number level operations
    //
    func clearNumberAtCellPosition(row: Int, column: Int) {
        guard (0..<self.cellRows) ~= row && (0..<self.cellColumns) ~= column else {
            return
        }
        self.setNumberAsUnUsed(self.cellNumbers[row][column])
        self.cellNumbers[row][column] = 0
        return
    }

    func getNumberAtCellPosition(row: Int, column: Int) -> Int {
        guard (0..<self.cellRows) ~= row && (0..<self.cellColumns) ~= column else {
            return 0
        }
        return self.cellNumbers[row][column]
    }
    
    func setNumberAtCellPosition(row: Int, column: Int, number: Int) -> Bool {
        guard (0..<self.cellRows) ~= row && (0..<self.cellColumns) ~= column && (1..<(self.numbersUsed.count + 1)) ~= number && self.cellNumbers[row][column] == 0 else {
            return false
        }
        self.cellNumbers[row][column] = number
        self.setNumberAsUsed(self.cellNumbers[row][column])
        return self.isCellCompleted()
    }

    //
    // public functions - row/column level operations
    //
    func getValuesFromRow(row: Int) -> [Int] {
        guard (0..<self.cellRows) ~= row else {
            return []
        }
        var values: [Int] = []
        for column: Int in 0 ..< self.cellColumns {
            values.append(self.cellNumbers[row][column])
        }
        return values
    }
    
    func getValuesFromColumn(column: Int) -> [Int] {
        guard (0..<self.cellColumns) ~= column else {
            return []
        }
        var values: [Int] = []
        for row: Int in 0 ..< self.cellRows {
            values.append(self.cellNumbers[row][column])
        }
        return values
    }
    
    func isNumberUsedInRow(number: Int, row: Int) -> Bool {
        guard (0..<self.cellRows) ~= row && (1..<(self.numbersUsed.count + 1)) ~= number && numbersUsed[number - 1] else {
            return false
        }
        for column: Int in 0 ..< self.cellColumns {
            if number == self.cellNumbers[row][column] {
                return true
            }
        }
        return false
    }
    
    func isNumberUsedInColumn(number: Int, column: Int) -> Bool {
        guard (0..<self.cellColumns) ~= column && (1..<(self.numbersUsed.count + 1)) ~= number && numbersUsed[number - 1] else {
            return false
        }
        for row: Int in 0 ..< self.cellRows {
            if number == self.cellNumbers[row][column] {
                return true
            }
        }
        return false
    }
    
    //
    // public functions - cell level operations
    //
    func clearCell() {
        for index: Int in 0 ..< self.cellCoordinates.count {
            self.cellNumbers[self.cellCoordinates[index].row][self.cellCoordinates[index].column] = 0
        }
        self.resetCellUsage()
        return
    }
    
    func isNumberUsedInCell(number: Int) -> Bool {
        guard (1..<(self.numbersUsed.count + 1)) ~= number else {
            return false
        }
        return numbersUsed[number - 1]
    }
    
    func getLocationOfNumberInCell(number: Int) -> (Int, Int) {
        guard (1..<(self.numbersUsed.count + 1)) ~= number && numbersUsed[number - 1] else {
            return (-1, -1)
        }
        for row: Int in 0 ..< self.cellRows {
            for column: Int in 0 ..< self.cellColumns {
                if number == self.cellNumbers[row][column] {
                    return (row, column)
                }
            }
        }
        return (-1, -1)
    }
    
    //
    // public functions - random driven operations
    //
    func getRandomFreeNumber() -> Int {
        let numberUsage: [Bool] = self.getNumbersArray()
        var numbersToUse: [Int] = []
        for index: Int in 0 ..< numberUsage.count {
            if numberUsage[index] == false {
                numbersToUse.append(index + 1)
            }
        }
        return numbersToUse[Int(arc4random_uniform(UInt32(numbersToUse.count)))]
    }
    
    func getRandomFreePosition() -> (unUsedRow: Int, unUsedColumn: Int) {
        guard !self.isCellCompleted() else {
            return(-1 , -1)
        }
        var row: Int = Int(arc4random_uniform(UInt32(self.cellRows)))
        var column: Int = Int(arc4random_uniform(UInt32(self.cellColumns)))
        while self.cellNumbers[row][column] > 0 {
            row = Int(arc4random_uniform(UInt32(self.cellRows)))
            column = Int(arc4random_uniform(UInt32(self.cellColumns)))
        }
        return (row, column)
    }
    
    func getRandomUsedPosition() -> (usedRow: Int, usedColumn: Int) {
        guard self.numbersUsed.contains(true) else {
            return(-1 , -1)
        }
        var index: Int = Int(arc4random_uniform(UInt32(self.cellCoordinates.count)))
        while self.cellNumbers[self.cellCoordinates[index].row][self.cellCoordinates[index].column] == 0 {
            index = Int(arc4random_uniform(UInt32(self.cellCoordinates.count)))
        }
        return (self.cellCoordinates[index].row, self.cellCoordinates[index].column)
    }
    
    //
    // copy object operation
    //
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = Cell(size: self.cellRows)
        for row: Int in 0 ..< self.cellRows {
            for column: Int in 0 ..< self.cellColumns {
                copy.cellNumbers[row][column] = self.cellNumbers[row][column]
            }
        }
        for index: Int in 0 ..< self.numbersUsed.count {
            copy.numbersUsed[index] = self.numbersUsed[index]
        }
        for index: Int in 0 ..< self.cellCoordinates.count {
            copy.cellCoordinates[index] = self.cellCoordinates[index]
        }
        copy.cellColumns = self.cellColumns
        copy.cellRows = self.cellRows
        return copy
    }
    
}