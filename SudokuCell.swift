//
//  SudokuCell.swift
//  ChalkBoardSudoku
//
//  Created by Graham Watson on 20/08/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation

class SudokuCell: NumberGrid {
    private var used: [Bool] = []
    
    init (size: Int = 3) {
        super.init(size: (size, size))
        for _: Int in 0 ..< (self.getRows() * self.getColumns()) {
            self.used.append(false)
        }
        return
    }

    //
    // private functions - for number usage array
    //
    private func getNumbersUsedArray() -> [Bool] {
        var values: [Bool] = []
        for index: Int in 0 ..< self.used.count {
            values.append(self.used[index])
        }
        return values
    }
    
    private func setNumberUsed(number: Int) {
        guard (1..<(self.used.count + 1)) ~= number else {
            return
        }
        self.used[number - 1] = true
        return
    }
    
    private func resetNumberUsed(number: Int) {
        guard (1..<(self.used.count + 1)) ~= number else {
            return
        }
        self.used[number - 1] = false
        return
    }

    //
    // public functions - cell level operations
    //
    override func clear() {
        super.clear()
        for index: Int in 0 ..< self.used.count {
            self.used[index] = false
        }
        return
    }

    func isNumberUsed(number: Int) -> Bool {
        guard (1..<(self.used.count + 1)) ~= number else {
            return false
        }
        return used[number - 1]
    }
    
    func isCellCompleted() -> Bool {
        return !self.used.contains(false)
    }
    
    //
    // public functions - number level operations
    //
    func clearNumber(coord: (row: Int, column: Int)) {
        guard self.boundsCheck(coord) else {
            return
        }
        self.resetNumberUsed(self.getNumber(coord))
        super.setNumber(coord, number: 0)
        return
    }
    
    override func setNumber(coord: (row: Int, column: Int), number: Int) -> Bool {
        guard self.boundsCheck(coord) && (1..<(self.used.count + 1)) ~= number && self.isNumberUsed(number) == false && self.getNumber(coord) == 0 else {
            return false
        }
        if super.setNumber(coord, number: number) {
            self.setNumberUsed(number)
            return true
        }
        return false
    }
    
    //
    // public functions - row/column level operations
    //
    func getNumberUsage() -> [Bool] {
        return self.used
    }
    
    func getRowNumbers(row: Int) -> [Int] {
        guard (0..<self.getRows()) ~= row else {
            return []
        }
        var numbers: [Int] = []
        for column: Int in 0 ..< self.getColumns() {
            numbers.append(self.getNumber((row, column)))
        }
        return numbers
    }
    
    func getColumnNumbers(column: Int) -> [Int] {
        guard (0..<self.getColumns()) ~= column else {
            return []
        }
        var numbers: [Int] = []
        for row: Int in 0 ..< self.getRows() {
            numbers.append(self.getNumber((row, column)))
        }
        return numbers
    }

    //
    // below both should only return one coord max if the number is used, as we restrict 'set' in setNumberAtLocation
    //
    func isNumberInRow(row: Int, number: Int) -> Bool {
        guard (0..<self.getRows()) ~= row && (1..<(self.used.count + 1)) ~= number && used[number - 1] else {
            return false
        }
        let coords: [(row: Int, column: Int)] = self.getLocationsOfNumber(number)
        if coords.count > 0  && coords[0].row == row {
            return true
        }
        return false
    }
    
    func isNumberInColumn(column: Int, number: Int) -> Bool {
        guard (0..<self.getColumns()) ~= column && (1..<(self.used.count + 1)) ~= number && used[number - 1] else {
            return false
        }
        let coords: [(row: Int, column: Int)] = self.getLocationsOfNumber(number)
        if coords.count > 0  && coords[0].column == column {
            return true
        }
        return false
    }
    
    //
    // public functions - random driven operations
    //
    func getRandomUnusedNumber() -> Int {
        let usage: [Bool] = self.getNumbersUsedArray()
        var unused: [Int] = []
        for index: Int in 0 ..< usage.count {
            if usage[index] == false {
                unused.append(index + 1)
            }
        }
        return unused[Int(arc4random_uniform(UInt32(unused.count)))]
    }
    
    func getRandomUnusedLocation() -> (row: Int, column: Int) {
        guard !self.isCellCompleted() else {
            return (-1, -1)
        }
        let locations: [(row: Int, column: Int)] = self.getLocationsOfNumber(0)
        return (locations.count == 0) ? (-1, -1) : locations[Int(arc4random_uniform(UInt32(locations.count)))]
    }
    
    func getUnusedLocations() -> [(row: Int, column: Int)] {
        guard !self.isCellCompleted() else {
            return []
        }
        return self.getLocationsOfNumber(0)
    }
    
    func getRandomUsedLocation() -> (row: Int, column: Int) {
        guard self.used.contains(true) else {
            return (-1, -1)
        }
        var numbers: [Int] = []
        for index: Int in 0 ..< self.used.count {
            if self.used[index] == true {
                numbers.append(index + 1)
            }
        }
        return (numbers.count == 0) ? (-1, -1) : self.getLocationsOfNumber(numbers[Int(arc4random_uniform(UInt32(numbers.count)))])[0]
    }
    
    func getLocationOfNumber(number: Int) -> (row: Int, column: Int) {
        let locations: [(row: Int, column: Int)] = self.getLocationsOfNumber(number)
        return (locations.count == 0) ? (-1, -1) : locations[0]
    }
    
    //
    // copy object operation
    //
    override func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = SudokuCell(size: self.getRows())
        for coord in copy.getCoords() {
            copy.setNumber(coord, number: self.getNumber(coord))
        }
        for index: Int in 0 ..< copy.used.count {
            copy.used[index] = self.used[index]
        }
        return copy
    }

}
