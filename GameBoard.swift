//
//  GameBoard.swift
//  SudokuTest
//
//  Created by Graham Watson on 02/04/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation

class GameBoard: NSObject, NSCopying {
    
    // will contain the solution to the puzzle
    private var solutionBoardCells: [[Cell]] = []
    // the solution with random numbers blanked out (this will be the board shown to the user)
    var gameBoardCells: [[Cell]] = []
    // the board before the user starts (used to restart board functions)
    var originBoardCells: [[Cell]] = []

    private var boardCoordinates: [(row: Int, column: Int)] = []
    private var boardRows: Int = 0
    private var boardColumns: Int = 0
    private var difficulty: Int = 0
    private var stalls: Int = 0
    
    init (size: Int = 3, setDifficulty: Int = 1) {
        super.init()
        self.boardColumns = size
        if self.boardColumns != 3 {
            self.boardColumns = 3
        }
        self.boardRows = self.boardColumns
        // need to remap diff level passed to internal useful value
        self.setBoardDifficulty(setDifficulty)
        // init the all copiees of the board ie solution/game and origin
        for row: Int in 0 ..< self.boardRows {
            var rowOfCells: [Cell] = [Cell(size: self.boardColumns)]
            for column: Int in 0 ..< boardColumns {
                self.boardCoordinates.append((row, column))
                if column > 0 {
                    rowOfCells.append(Cell(size: self.boardColumns))
                }
            }
            self.solutionBoardCells.append(rowOfCells)
        }
        // init the game cells
        for row: Int in 0 ..< self.boardRows {
            var rowOfCells: [Cell] = [Cell(size: self.boardColumns)]
            for column: Int in 0 ..< boardColumns {
                self.boardCoordinates.append((row, column))
                if column > 0 {
                    rowOfCells.append(Cell(size: self.boardColumns))
                }
            }
            self.gameBoardCells.append(rowOfCells)
        }
        // init the origin cells
        for row: Int in 0 ..< self.boardRows {
            var rowOfCells: [Cell] = [Cell(size: self.boardColumns)]
            for column: Int in 0 ..< boardColumns {
                self.boardCoordinates.append((row, column))
                if column > 0 {
                    rowOfCells.append(Cell(size: self.boardColumns))
                }
            }
            self.originBoardCells.append(rowOfCells)
        }
    }

    //
    // private functions
    //
    private func isNumberLegalInSolution(coord: (row: Int, column: Int, cellRow: Int, cellColumn: Int), number: Int) -> Bool {
        for boardRow: Int in 0 ..< coord.row {
            if self.solutionBoardCells[boardRow][coord.column].isNumberUsedInColumn(number, column: coord.cellColumn) == true {
                return false
            }
        }
        for boardColumn: Int in 0 ..< coord.column {
            if self.solutionBoardCells[coord.row][boardColumn].isNumberUsedInRow(number, row: coord.cellRow) == true {
                return false
            }
        }
        return true
    }

    private func isNumberLegalInGame(coord: (row: Int, column: Int, cellRow: Int, cellColumn: Int), number: Int) -> Bool {
        for boardRow: Int in 0 ..< self.boardRows {
            if self.gameBoardCells[boardRow][coord.column].isNumberUsedInColumn(number, column: coord.cellColumn) == true {
                return false
            }
        }
        for boardColumn: Int in 0 ..< self.boardColumns {
            if self.gameBoardCells[coord.row][boardColumn].isNumberUsedInRow(number, row: coord.cellRow) == true {
                return false
            }
        }
        return true
    }
    
    private func buildCell(row: Int, column: Int) -> Bool {
        var stalled: Int = 0
        while self.solutionBoardCells[row][column].isCellCompleted() == false {
            // get an unused row/cell location and an unused number
            let unUsedPosition: (unUsedRow: Int, unUsedColumn: Int) = self.solutionBoardCells[row][column].getRandomFreePosition()
            let unUsedNumber: Int = self.solutionBoardCells[row][column].getRandomFreeNumber()
            // check if the unused number can exist in that location by checking adjacent solutionBoardCells
            if isNumberLegalInSolution((row, column: column, cellRow: unUsedPosition.unUsedRow, cellColumn: unUsedPosition.unUsedColumn), number: unUsedNumber) == true {
                self.solutionBoardCells[row][column].setNumberAtCellPosition(unUsedPosition.unUsedRow, column: unUsedPosition.unUsedColumn, number: unUsedNumber)
                stalled = 0
            } else {
                stalled = stalled + 1
                if stalled > 100 {
                    return false
                }
            }
        }
        return true
    }
    
    //
    // once we have a solved board, need to copy to origin where we will remove random numbers to produce the game board
    //
    private func copySolutionCellsToOriginCells() {
        self.originBoardCells.removeAll()
        for row: Int in 0 ..< self.boardRows {
            var rowOfCells: [Cell] = [self.solutionBoardCells[row][0].copy() as! Cell]
            for column: Int in 1 ..< self.boardColumns {
                rowOfCells.append(self.solutionBoardCells[row][column].copy() as! Cell)
            }
            self.originBoardCells.append(rowOfCells)
        }
        return
    }
    
    //
    // for restarting, take the game board back to before the user started solving the puzzle
    //
    private func copyOriginCellsToGameCells() {
        self.gameBoardCells.removeAll()
        for row: Int in 0 ..< self.boardRows {
            var rowOfCells: [Cell] = [self.originBoardCells[row][0].copy() as! Cell]
            for column: Int in 1 ..< self.boardColumns {
                rowOfCells.append(self.originBoardCells[row][column].copy() as! Cell)
            }
            self.gameBoardCells.append(rowOfCells)
        }
        return
    }
    
    private func clearSolutionBoard() {
        for cellRow: [Cell] in self.solutionBoardCells {
            for cellColumn: Cell in cellRow {
                cellColumn.clearCell()
            }
        }
        return
    }
    
    private func clearGameBoard() {
        for cellRow: [Cell] in self.gameBoardCells {
            for cellColumn: Cell in cellRow {
                cellColumn.clearCell()
            }
        }
        return
    }
    
    private func clearOriginBoard() {
        for cellRow: [Cell] in self.originBoardCells {
            for cellColumn: Cell in cellRow {
                cellColumn.clearCell()
            }
        }
        return
    }
    
    //
    // are we within the bounds of the board
    //
    private func coordBoundsCheck(coord: (row: Int, column: Int, cellRow: Int, cellColumn: Int)) -> Bool {
        guard (0..<self.boardRows) ~= coord.row &&
                (0..<self.self.boardColumns) ~= coord.column &&
                (0..<self.gameBoardCells[coord.row][coord.column].cellDepth()) ~= coord.cellRow &&
                (0..<self.gameBoardCells[coord.row][coord.column].cellWidth()) ~= coord.cellColumn
        else {
            return false
        }
        return true
    }

    //
    // public functions - remap game difficulty to useful internal value
    //
    
    func getGameDifficulty() -> Int {
        // remap the diff level to ui control mapping
        var difficulty: Int = gameDiff.Medium.rawValue
        switch self.difficulty {
            case gameBoardDiff.Easy.rawValue:
                difficulty = gameDiff.Easy.rawValue
                break
            case gameBoardDiff.Medium.rawValue:
                difficulty = gameDiff.Medium.rawValue
                break
            case gameBoardDiff.Hard.rawValue:
                difficulty = gameDiff.Hard.rawValue
                break
            default:
                break
        }
        return difficulty
    }
    
    func setBoardDifficulty(newDifficulty: Int) {
        switch newDifficulty {
        case 0:
            self.difficulty = gameBoardDiff.Easy.rawValue
            break
        case 1:
            self.difficulty = gameBoardDiff.Medium.rawValue
            break
        case 2:
            self.difficulty = gameBoardDiff.Hard.rawValue
            break
        default:
            self.difficulty = gameBoardDiff.Medium.rawValue
            break
        }
        return
    }
    
    func clearBoard() {
        self.clearSolutionBoard()
        self.clearOriginBoard()
        self.clearGameBoard()
        return
    }
    
    func isSolutionCompleted() -> Bool {
        for index: Int in 0 ..< self.boardCoordinates.count {
            if self.solutionBoardCells[self.boardCoordinates[index].row][self.boardCoordinates[index].column].isCellCompleted() == false {
                return false
            }
        }
        return true
    }

    func isGameCompleted() -> Bool {
        for index: Int in 0 ..< self.boardCoordinates.count {
            if self.gameBoardCells[self.boardCoordinates[index].row][self.boardCoordinates[index].column].isCellCompleted() == false {
                return false
            }
        }
        return true
    }
    
    func isNumberFullyUsedOnGameBoard(number: Int) -> Bool {
        for index: Int in 0 ..< self.boardCoordinates.count {
            if self.gameBoardCells[self.boardCoordinates[index].row][self.boardCoordinates[index].column].isCellCompleted() == false {
                if self.gameBoardCells[self.boardCoordinates[index].row][self.boardCoordinates[index].column].isNumberUsedInCell(number) == false {
                    return false
                }
            }
        }
        return true
    }
    
    func buildSolution() {
        var index: Int = 0
        self.stalls = 0
        while (self.isSolutionCompleted() == false) {
            if buildCell(self.boardCoordinates[index].row, column: self.boardCoordinates[index].column) == true {
                index = index + 1
            } else {
                self.stalls = self.stalls + 1
                var i: Int = index
                while i > 0 {
                    self.solutionBoardCells[self.boardCoordinates[i].row][self.boardCoordinates[i].column].clearCell()
                    i = i - 1
                }
                index = 0
            }
        }
        return
    }
    
    //
    // from the prebuilt solution board, we need to remove random numbers (depending on the set difficulty)
    //
    func buildOriginBoard() {
        // get how many of each number we will remove from board
        var clearFromBoard: [Int] = []
        for _: Int in 0 ..< (self.boardColumns * self.boardRows) {
            clearFromBoard.append(self.difficulty + 1 - Int(arc4random_uniform(UInt32(2))))
        }
        // setup the origin board that we're going to remove the numbers from
        self.originBoardCells.removeAll()
        self.copySolutionCellsToOriginCells()
        // from the board build up the array of locations we're going to remove, number by number
        var remove: [(row: Int, column: Int, cellRow: Int, cellColumn: Int)] = []
        var number: Int = 1
        for clear: Int in clearFromBoard {
            // get positions of the number on the board
            let locationsSelection: [(row: Int, column: Int, cellRow: Int, cellColumn: Int)] = self.getLocationsOfNumberOnOriginBoard(number)
            remove.appendContentsOf(self.getLocationsToRemove(clear, locations: locationsSelection))
            number = number + 1
        }
        for location in remove {
            self.originBoardCells[location.row][location.column].clearNumberAtCellPosition(location.cellRow, column: location.cellColumn)
        }
        return
    }
    
    func getLocationsToRemove(clear: Int, locations: [(row: Int, column: Int, cellRow: Int, cellColumn: Int)]) -> [(row: Int, column: Int, cellRow: Int, cellColumn: Int)] {
        var numberToRemove: Int = clear
        var chooseFrom: [(row: Int, column: Int, cellRow: Int, cellColumn: Int)] = []
        chooseFrom.appendContentsOf(locations)
        var locationsToRemove: [(row: Int, column: Int, cellRow: Int, cellColumn: Int)] = []
        while numberToRemove > 0 {
            let posn: Int = Int(arc4random_uniform(UInt32(chooseFrom.count)))
            locationsToRemove.append(chooseFrom[posn])
            chooseFrom.removeAtIndex(posn)
            numberToRemove = numberToRemove - 1
        }
        return locationsToRemove
    }
    
    //
    // always created from the 'origin' board, which is the solution with random numbers removed and where the user starts to solve the puzzle
    //
    func initialiseGameBoard() {
        self.gameBoardCells.removeAll()
        self.copyOriginCellsToGameCells()
        return
    }
    
    func dumpSolutionBoard() -> String {
        guard self.isSolutionCompleted() == true else {
            return "Board is not completed"
        }
        var dumpOfBoard: String = ""
        for boardRow: Int in 0 ..< 3 {
            dumpOfBoard += "\nBoard row: \(boardRow)\n"
            for cellRow: Int in 0 ..< 3 {
                var dumpOfCellRow: String = ""
                for boardColumn: Int in 0 ..< 3 {
                    let cellColumns: [Int] = self.solutionBoardCells[boardRow][boardColumn].getValuesFromRow(cellRow)
                    dumpOfCellRow += " |"
                    for i: Int in 0 ..< cellColumns.count {
                        dumpOfCellRow += " \(cellColumns[i])"
                    }
                    dumpOfCellRow += " |"
                }
                dumpOfBoard += "\n" + dumpOfCellRow
            }
            dumpOfBoard += "\n"
        }
        return dumpOfBoard
    }
    
    //
    // get a number from the board the user is completing
    //
    func getNumberFromGameBoard(coord: (row: Int, column: Int, cellRow: Int, cellColumn: Int)) -> Int {
        guard self.coordBoundsCheck(coord) == true else {
            return 0
        }
        return self.gameBoardCells[coord.row][coord.column].getNumberAtCellPosition(coord.cellRow, column: coord.cellColumn)
    }

    //
    // get a number from the origin board
    //
    func getNumberFromOriginBoard(coord: (row: Int, column: Int, cellRow: Int, cellColumn: Int)) -> Int {
        guard self.coordBoundsCheck(coord) == true else {
            return 0
        }
        return self.originBoardCells[coord.row][coord.column].getNumberAtCellPosition(coord.cellRow, column: coord.cellColumn)
    }

    //
    // get a number from the solution board
    //
    func getNumberFromSolutionBoard(coord: (row: Int, column: Int, cellRow: Int, cellColumn: Int)) -> Int {
        guard self.coordBoundsCheck(coord) == true else {
            return 0
        }
        return self.solutionBoardCells[coord.row][coord.column].getNumberAtCellPosition(coord.cellRow, column: coord.cellColumn)
    }
    
    //
    // is the location an 'origin' posn, we'll use this to work out if the user can interact with that position
    //
    func isOriginBoardCellUsed(coord: (row: Int, column: Int, cellRow: Int, cellColumn: Int)) -> Bool {
        guard self.coordBoundsCheck(coord) == true else {
            return false
        }
        return (self.originBoardCells[coord.row][coord.column].getNumberAtCellPosition(coord.cellRow, column: coord.cellColumn) == 0) ? false : true
    }
    
    //
    // is the location on the game board used
    //
    func isGameBoardCellUsed(coord: (row: Int, column: Int, cellRow: Int, cellColumn: Int)) -> Bool {
        guard self.coordBoundsCheck(coord) == true else {
            return false
        }
        return (self.gameBoardCells[coord.row][coord.column].getNumberAtCellPosition(coord.cellRow, column: coord.cellColumn) == 0) ? false : true
    }
    
    //
    // can the number exist in this position in the game
    //
    func isNumberValidOnGameBoard(coord: (row: Int, column: Int, cellRow: Int, cellColumn: Int), number: Int) -> Bool {
        guard self.coordBoundsCheck(coord) == true else {
            return false
        }
        if self.gameBoardCells[coord.row][coord.column].isNumberUsedInCell(number) == true {
            return false
        }
        return self.isNumberLegalInGame(coord, number: number)
    }
    
    //
    // populate a position on the 'boards'
    //
    func setNumberOnSolutionBoard(coord: (row: Int, column: Int, cellRow: Int, cellColumn: Int), number: Int) -> Bool {
        guard self.coordBoundsCheck(coord) == true else {
            return false
        }
        if self.solutionBoardCells[coord.row][coord.column].isNumberUsedInCell(number) == true {
            return false
        }
        self.solutionBoardCells[coord.row][coord.column].setNumberAtCellPosition(coord.cellRow, column: coord.cellColumn, number: number)
        return true
    }
    
    func setNumberOnOriginBoard(coord: (row: Int, column: Int, cellRow: Int, cellColumn: Int), number: Int) -> Bool {
        guard self.coordBoundsCheck(coord) == true else {
            return false
        }
        if self.originBoardCells[coord.row][coord.column].isNumberUsedInCell(number) == true {
            return false
        }
        self.originBoardCells[coord.row][coord.column].setNumberAtCellPosition(coord.cellRow, column: coord.cellColumn, number: number)
        return true
    }
    
    func setNumberOnGameBoard(coord: (row: Int, column: Int, cellRow: Int, cellColumn: Int), number: Int) -> Bool {
        guard self.coordBoundsCheck(coord) == true else {
            return false
        }
        if self.gameBoardCells[coord.row][coord.column].isNumberUsedInCell(number) == true {
            return false
        }
        if self.isNumberLegalInGame(coord, number: number) == false {
            return false
        }
        //
        // passed all the validation, so add it. could still be wrong ofc
        //
        self.gameBoardCells[coord.row][coord.column].setNumberAtCellPosition(coord.cellRow, column: coord.cellColumn, number: number)
        return true
    }

    //
    // remove a number from the board
    //
    func clearLocationOnGameBoard(coord: (row: Int, column: Int, cellRow: Int, cellColumn: Int)) {
        guard self.coordBoundsCheck(coord) == true else {
            return
        }
        self.gameBoardCells[coord.row][coord.column].clearNumberAtCellPosition(coord.cellRow, column: coord.cellColumn)
        return
    }
    
    //
    // bit of a hack needs work
    //
    func getBoardWidthInCells() -> Int {
        if self.solutionBoardCells.count < 1 {
            return self.boardColumns * self.boardColumns
        }
        return self.boardColumns * self.solutionBoardCells[0][0].cellWidth()
    }

    func getBoardRows() -> Int {
        return self.boardRows
    }
    
    func getBoardColumns() -> Int {
        return self.boardColumns
    }
    
    func getLocationsOfNumberOnGameBoard(number: Int) -> [(row: Int, column: Int, cellRow: Int, cellColumn: Int)] {
        var returnCoords: [(row: Int, column: Int, cellRow: Int, cellColumn: Int)] = []
        for boardRow: Int in 0 ..< self.boardRows {
            for boardColumn: Int in 0 ..< self.boardColumns {
                let cellCoords: (cellRow: Int, cellColumn: Int) = self.gameBoardCells[boardRow][boardColumn].getLocationOfNumberInCell(number)
                if (cellCoords != (-1,-1)) {
                    returnCoords.append((boardRow, boardColumn, cellCoords.cellRow, cellCoords.cellColumn))
                }
            }
        }
        return returnCoords
    }
    
    func getFreeLocationsForNumberOnGameBoard(number: Int) -> [(row: Int, column: Int, cellRow: Int, cellColumn: Int)] {
        var returnCoords: [(row: Int, column: Int, cellRow: Int, cellColumn: Int)] = []
        for boardRow: Int in 0 ..< self.boardRows {
            for boardColumn: Int in 0 ..< self.boardColumns {
                if self.gameBoardCells[boardRow][boardColumn].isNumberUsedInCell(number) == false {
                    let cellCoords: (cellRow: Int, cellColumn: Int) = self.solutionBoardCells[boardRow][boardColumn].getLocationOfNumberInCell(number)
                    returnCoords.append((boardRow, boardColumn, cellCoords.cellRow, cellCoords.cellColumn))
                }
            }
        }
        return returnCoords
    }
    
    func getFreeLocationsOnGameBoard() -> [(row: Int, column: Int, cellRow: Int, cellColumn: Int)] {
        var returnCoords: [(row: Int, column: Int, cellRow: Int, cellColumn: Int)] = []
        for boardRow: Int in 0 ..< self.boardRows {
            for boardColumn: Int in 0 ..< self.boardColumns {
                for number: Int in 1 ..< (self.boardRows * self.boardColumns) + 1 {
                    if self.gameBoardCells[boardRow][boardColumn].isNumberUsedInCell(number) == false {
                        let cellCoords: (cellRow: Int, cellColumn: Int) = self.solutionBoardCells[boardRow][boardColumn].getLocationOfNumberInCell(number)
                        returnCoords.append((boardRow, boardColumn, cellCoords.cellRow, cellCoords.cellColumn))
                    }
                }
            }
        }
        return returnCoords
    }
    
    func getLocationsOfNumberOnOriginBoard(number: Int) -> [(row: Int, column: Int, cellRow: Int, cellColumn: Int)] {
        var returnCoords: [(row: Int, column: Int, cellRow: Int, cellColumn: Int)] = []
        for boardRow: Int in 0 ..< self.boardRows {
            for boardColumn: Int in 0 ..< self.boardColumns {
                let cellCoords: (cellRow: Int, cellColumn: Int) = self.originBoardCells[boardRow][boardColumn].getLocationOfNumberInCell(number)
                if (cellCoords != (-1,-1)) {
                    returnCoords.append((boardRow, boardColumn, cellCoords.cellRow, cellCoords.cellColumn))
                }
            }
        }
        return returnCoords
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = GameBoard(size: self.boardColumns)
        for row: Int in 0 ..< self.boardRows {
            var rowOfCells: [Cell] = [self.solutionBoardCells[row][0].copy() as! Cell]
            for column: Int in 1 ..< self.boardColumns {
                rowOfCells.append(self.solutionBoardCells[row][column].copy() as! Cell)
            }
            copy.solutionBoardCells.append(rowOfCells)
        }
        for index: Int in 0 ..< self.boardCoordinates.count {
            copy.boardCoordinates.append(self.boardCoordinates[index])
        }
        copy.boardRows = self.boardRows
        copy.boardColumns = self.boardColumns
        copy.stalls = self.stalls
        return copy
    }
    
}