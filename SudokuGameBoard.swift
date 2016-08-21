//
//  SudokuGameBoard.swift
//  ChalkBoardSudoku
//
//  Created by Graham Watson on 21/08/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation

class SudokuGameBoard {
    
    //
    // Boards needed:
    //
    // 1. Solution, will hold the completed puzzle
    // 2. Origin, Solution minus the numbers removed for the start of the puzzle
    // 3. Game, the user solution in progress. Origin + User moves
    //
    private var solutionBoard: [[SudokuCell]] = []
    private var gameBoard:     [[SudokuCell]] = []
    private var originBoard:   [[SudokuCell]] = []
    
    private var coordinates:   [(row: Int, column: Int)] = []
    private var size:          (rows: Int, columns: Int) = (0, 0)
    private var stalls:        Int = 0
    
    //
    // internal represnetaion of the game difficulty
    //
    enum gameDifficulty: Int {
        case Easy   = 3
        case Medium = 5
        case Hard   = 7
    }
    private var difficulty:    gameDifficulty = gameDifficulty.Medium

    init (size: Int = 3, difficulty: sudokuDifficulty = sudokuDifficulty.Medium) {
        //
        // allow only 3x3 or 4x4
        //
        self.size.columns = size
        if self.size.columns != 3 && self.size.columns != 4 {
            self.size.columns = 3
        }
        self.size.rows = self.size.columns
        //
        // need to remap diff level passed to internal useful value
        //
        self.difficulty = self.setDifficulty(difficulty)
        //
        // init the all copies of the board ie solution/game and origin
        //
        func initialiseBoard() -> [[SudokuCell]] {
            var board: [[SudokuCell]] = []
            for row: Int in 0 ..< self.size.rows {
                var rowOfCells: [SudokuCell] = [SudokuCell(size: self.size.columns)]
                for column: Int in 0 ..< self.size.columns {
                    self.coordinates.append((row, column))
                    if column > 0 {
                        rowOfCells.append(SudokuCell(size: self.size.columns))
                    }
                }
                board.append(rowOfCells)
            }
            return board
        }
        
        self.solutionBoard.appendContentsOf(initialiseBoard())
        self.originBoard.appendContentsOf(initialiseBoard())
        self.gameBoard.appendContentsOf(initialiseBoard())
        return
    }
    
    //----------------------------------------------------------------------------
    // Remap internally held game difficulty to something the outside world uses
    //----------------------------------------------------------------------------
    func getDifficulty() -> sudokuDifficulty {
        switch self.difficulty {
        case gameDifficulty.Easy:
            return sudokuDifficulty.Easy
        case gameDifficulty.Medium:
            return sudokuDifficulty.Medium
        case gameDifficulty.Hard:
            return sudokuDifficulty.Hard
        }
    }

    func setDifficulty(difficulty: sudokuDifficulty) -> gameDifficulty {
        switch difficulty {
        case sudokuDifficulty.Easy:
            return(gameDifficulty.Easy)
        case sudokuDifficulty.Medium:
            return(gameDifficulty.Medium)
        case sudokuDifficulty.Hard:
            return(gameDifficulty.Hard)
        }
    }
    
    //----------------------------------------------------------------------------
    // Generic are we within the bounds of the board check
    //----------------------------------------------------------------------------
    private func coordBoundsCheck(coord: Coordinate) -> Bool {
        guard (0..<self.size.rows) ~= coord.row &&
            (0..<self.size.columns) ~= coord.column &&
            (0..<self.size.rows) ~= coord.cell.row &&
            (0..<self.size.columns) ~= coord.cell.column
            else {
                return false
        }
        return true
    }
    
    //----------------------------------------------------------------------------
    // Board level functions
    //----------------------------------------------------------------------------
    func getSize() -> (Int, Int) {
        return (self.size.rows, self.size.columns)
    }
    
    func clear() {
        func clearBoard(inout board: [[SudokuCell]]) {
            for row: [SudokuCell] in board {
                for column: SudokuCell in row {
                    column.clear()
                }
            }
        }
        clearBoard(&self.solutionBoard)
        clearBoard(&self.originBoard)
        clearBoard(&self.gameBoard)
        return
    }

    //----------------------------------------------------------------------------
    // Get / Set numbers on the boards
    //----------------------------------------------------------------------------
    func getNumberFromGame(coord: Coordinate) -> Int {
        guard self.coordBoundsCheck(coord) else {
            return 0
        }
        return self.gameBoard[coord.row][coord.column].getNumber(coord.cell)
    }
    
    func getNumberFromOrigin(coord: Coordinate) -> Int {
        guard self.coordBoundsCheck(coord) else {
            return 0
        }
        return self.originBoard[coord.row][coord.column].getNumber(coord.cell)
    }
    
    func getNumberFromSolution(coord: Coordinate) -> Int {
        guard self.coordBoundsCheck(coord) else {
            return 0
        }
        return self.solutionBoard[coord.row][coord.column].getNumber(coord.cell)
    }

    func setNumberOnSolutionBoard(coord: Coordinate, number: Int) -> Bool {
        guard self.coordBoundsCheck(coord) else {
            return false
        }
        if self.solutionBoard[coord.row][coord.column].isNumberUsed(number) == true {
            return false
        }
        self.solutionBoard[coord.row][coord.column].setNumber(coord.cell, number: number)
        return true
    }
    
    func setNumberOnOriginBoard(coord: Coordinate, number: Int) -> Bool {
        guard self.coordBoundsCheck(coord) else {
            return false
        }
        if self.originBoard[coord.row][coord.column].isNumberUsed(number) == true {
            return false
        }
        self.originBoard[coord.row][coord.column].setNumber(coord.cell, number: number)
        return true
    }
    
    func setNumberOnGameBoard(coord: Coordinate, number: Int) -> Bool {
        guard self.coordBoundsCheck(coord) else {
            return false
        }
        if self.gameBoard[coord.row][coord.column].isNumberUsed(number) == true {
            return false
        }
        if self.isNumberLegalOnBoard(in: self.gameBoard, coord: coord, number: number) == false {
            return false
        }
        //
        // passed all the validation, so add it. could still be a wrong move ofc
        //
        self.gameBoard[coord.row][coord.column].setNumber(coord.cell, number: number)
        return true
    }
    
    func clearGameBoardLocation(coord: Coordinate) {
        guard self.coordBoundsCheck(coord) else {
            return
        }
        self.gameBoard[coord.row][coord.column].clearNumber(coord.cell)
        return
    }

    //----------------------------------------------------------------------------
    // Can the number go here on the board
    //----------------------------------------------------------------------------
    private func isNumberLegalOnBoard(in board: [[SudokuCell]], coord: Coordinate, number: Int) -> Bool {
        for row: Int in 0 ..< self.size.rows {
            if board[row][coord.column].isNumberInColumn(coord.cell.column, number: number) == true {
                return false
            }
        }
        for column: Int in 0 ..< self.size.columns {
            if board[coord.row][column].isNumberInRow(coord.cell.row, number: number) == true {
                return false
            }
        }
        return true
    }
    
    //
    // can the number exist in this position in the game
    //
    func isNumberValidOnGameBoard(coord: Coordinate, number: Int) -> Bool {
        guard self.coordBoundsCheck(coord) else {
            return false
        }
        if self.gameBoard[coord.row][coord.column].isNumberUsed(number) == true {
            return false
        }
        if self.isNumberLegalOnBoard(in: self.gameBoard, coord: coord, number: number) == false {
            return false
        }
        return true
    }
    
    //
    // is the location on the origin board populated
    //
    private func isLocationUsed(in board: [[SudokuCell]], coord: Coordinate) -> Bool {
        guard self.coordBoundsCheck(coord) else {
            return false
        }
        return (board[coord.row][coord.column].getNumber((coord.cell.row, coord.cell.column)) == 0) ? false : true
    }

    func isOriginLocationUsed(coord: Coordinate) -> Bool {
        return self.isLocationUsed(in: originBoard, coord: coord)
    }

    func isGameLocationUsed(coord: Coordinate) -> Bool {
        return self.isLocationUsed(in: gameBoard, coord: coord)
    }
    
    //----------------------------------------------------------------------------
    // Is a board fully populated?
    //----------------------------------------------------------------------------   
    private func isBoardCompleted(in board: [[SudokuCell]]) -> Bool {
        for index: Int in 0 ..< self.coordinates.count {
            if board[self.coordinates[index].row][self.coordinates[index].column].isCellCompleted() == false {
                return false
            }
        }
        return true
    }
    
    func isGameCompleted() -> Bool {
        return self.isBoardCompleted(in: self.gameBoard)
    }
    
    private func isNumberFullyUsedOnBoard(in board: [[SudokuCell]], number: Int) -> Bool {
        for index: Int in 0 ..< self.coordinates.count {
            if board[self.coordinates[index].row][coordinates[index].column].isCellCompleted() == false {
                if board[self.coordinates[index].row][self.coordinates[index].column].isNumberUsed(number) == false {
                    return false
                }
            }
        }
        return true
    }
    
    func isNumberFullyUsedInGame(number: Int) -> Bool {
        return self.isNumberFullyUsedOnBoard(in: self.gameBoard, number: number)
    }
    
    //----------------------------------------------------------------------------
    // copy board from -> to
    //----------------------------------------------------------------------------
    private func copyBoardFromTo(in sourceBoard: [[SudokuCell]], inout destinationBoard: [[SudokuCell]]) {
        destinationBoard.removeAll()
        for row: Int in 0 ..< self.size.rows {
            var rowOfCells: [SudokuCell] = [sourceBoard[row][0].copy() as! SudokuCell]
            for column: Int in 1 ..< self.size.columns {
                rowOfCells.append(sourceBoard[row][column].copy() as! SudokuCell)
            }
            destinationBoard.append(rowOfCells)
        }
        return
    }
    
    private func copySolutionToOrigin() {
        self.copyBoardFromTo(in: self.solutionBoard, destinationBoard: &self.originBoard)
        return
    }
    
    private func copyOriginToGame() {
        self.copyBoardFromTo(in: self.originBoard, destinationBoard: &self.gameBoard)
        return
    }
    
    func initialiseGame() {
        self.copyOriginToGame()
        return
    }
    
    //----------------------------------------------------------------------------
    // building the solution board
    //----------------------------------------------------------------------------
    private func buildSolutionCell(coord: Coordinate) -> Bool {
        var stalled: Int = 0
        while self.solutionBoard[coord.row][coord.column].isCellCompleted() == false {
            let newLocation: (row: Int, column: Int) = self.solutionBoard[coord.row][coord.column].getRandomUnusedLocation()
            let newNumber: Int = self.solutionBoard[coord.row][coord.column].getRandomUnusedNumber()
            let newCoord: Coordinate = Coordinate(row: coord.row, column: coord.column, cell: (newLocation.row, newLocation.column))
            if self.isNumberLegalOnBoard(in: self.solutionBoard, coord: newCoord, number: newNumber) {
                self.setNumberOnSolutionBoard(newCoord, number: newNumber)
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
    
    func buildSudokuSolution() {
        var index: Int = 0
        self.stalls = 0
        while (self.isBoardCompleted(in: self.solutionBoard) == false) {
            let coord: Coordinate = Coordinate(row: self.coordinates[index].row, column: self.coordinates[index].column, cell: (0,0))
            if self.buildSolutionCell(coord) == true {
                index = index + 1
            } else {
                self.stalls = self.stalls + 1
                var i: Int = index
                while i > 0 {
                    self.solutionBoard[self.coordinates[i].row][self.coordinates[i].column].clear()
                    i = i - 1
                }
                index = 0
            }
        }
        return
    }
    
    func printSudokuSolution() -> String {
        guard self.isBoardCompleted(in: self.solutionBoard) == true else {
            return "Solution board is not completed"
        }
        var dumpOfBoard: String = ""
        for row: Int in 0 ..< self.size.rows {
            dumpOfBoard += "\nBoard row: \(row)\n"
            for cellrow: Int in 0 ..< self.size.rows {
                var dumpOfCellRow: String = ""
                for column: Int in 0 ..< self.size.columns {
                    let cellColumns: [Int] = self.solutionBoard[row][column].getRowNumbers(cellrow)
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
    
    //----------------------------------------------------------------------------
    // building the origin board
    //----------------------------------------------------------------------------
    //
    // from the prebuilt solution board, we need to remove random numbers (depending on the set difficulty)
    //
    func buildOriginBoard() {
        //
        // get how many of each number we will remove from board
        //
        var clearFromBoard: [Int] = []
        for _: Int in 0 ..< (self.size.rows * self.size.columns) {
            clearFromBoard.append(self.difficulty.rawValue + 1 - Int(arc4random_uniform(UInt32(2))))
        }
        //
        // setup the origin board that we're going to remove the numbers from
        //
        self.originBoard.removeAll()
        self.copySolutionToOrigin()
        //
        // from the board build up the array of locations we're going to remove, number by number
        //
        var remove: [Coordinate] = []
        var number: Int = 1
        for clear: Int in clearFromBoard {
            let locationsSelection: [Coordinate] = self.getNumberLocationsOnOriginBoard(number)
            remove.appendContentsOf(self.getLocationsToRemove(locationsSelection, count: clear))
            number = number + 1
        }
        for location in remove {
            self.originBoard[location.row][location.column].clearNumber((location.cell.row, location.cell.column))
        }
        return
    }
    
    func getLocationsToRemove(coords: [Coordinate], count: Int) -> [Coordinate] {
        var choose: [Coordinate] = []
        choose.appendContentsOf(coords)
        var remove: [Coordinate] = []
        for _: Int in 0 ..< count {
            let posn: Int = Int(arc4random_uniform(UInt32(choose.count)))
            remove.append(choose[posn])
            choose.removeAtIndex(posn)
        }
        return remove
    }
    
    //----------------------------------------------------------------------------
    // Following routines return array of coords (row, col, cellrow, cellcolumn)
    //----------------------------------------------------------------------------
    func getNumberLocationsOnBoard(in board: [[SudokuCell]], number: Int) -> [Coordinate] {
        var coords: [Coordinate] = []
        for row: Int in 0 ..< self.size.rows {
            for column: Int in 0 ..< self.size.columns {
                let coord: (row: Int, column: Int) = board[row][column].getLocationOfNumber(number)
                if (coord != (-1,-1)) {
                    coords.append(Coordinate(row: row, column: column, cell: (row: coord.row, column: coord.column)))
                }
            }
        }
        return coords
    }
    
    //
    // for a 'number' on the start of the solution (used to differentiate during highlight of numbers)
    //
    func getNumberLocationsOnOriginBoard(number: Int) -> [Coordinate] {
        return self.getNumberLocationsOnBoard(in: originBoard, number: number)
    }
    
    //
    // for a used 'number'
    //
    func getNumberLocationsOnGameBoard(number: Int) -> [Coordinate] {
        return self.getNumberLocationsOnBoard(in: gameBoard, number: number)
    }
    
    //
    // where the 'number' hasn't been used yet (used in hints)
    //
    func getFreeNumberLocationsOnGameBoard(number: Int) -> [Coordinate] {
        var coords: [Coordinate] = []
        for row: Int in 0 ..< self.size.rows {
            for column: Int in 0 ..< self.size.columns {
                if self.gameBoard[row][column].isNumberUsed(number) == false {
                    let coord: (row: Int, column: Int) = self.solutionBoard[row][column].getLocationOfNumber(number)
                    coords.append(Coordinate(row: row, column: column, cell: (row: coord.row, column: coord.column)))
                }
            }
        }
        return coords
    }
    
    //
    // empty locations on the gameBoard (used in hints)
    //
    func getFreeLocationsOnGameBoard() -> [Coordinate] {
        var coords: [Coordinate] = []
        for number: Int in 1 ..< (self.size.rows * self.size.columns) + 1 {
            coords.appendContentsOf(self.getFreeNumberLocationsOnGameBoard(number))
        }
        return coords
    }
    
    //
    // when a cell is completed and correct, used to set cell contents to 'inactive' if user supplies correct solution
    //
    func getCorrectLocationsFromCompletedCellOnGameBoard(coord: Coordinate) -> [Coordinate] {
        guard self.coordBoundsCheck(coord) && self.gameBoard[coord.row][coord.column].isCellCompleted() else {
            return []
        }
        var coords: [Coordinate] = []
        for row: Int in 0 ..< self.size.rows {
            for column: Int in 0 ..< self.size.columns {
                if self.gameBoard[coord.row][coord.column].getNumber((row, column)) != self.solutionBoard[coord.row][coord.column].getNumber((row, column)) {
                    return []
                }
                coords.append(Coordinate(row: coord.row, column: coord.column, cell:(row: row, column: column)))
            }
        }
        return coords
    }
    
    //
    // as above but for a column
    //
    func getCorrectLocationsFromCompletedColumnOnGameBoard(coord: Coordinate) -> [Coordinate] {
        guard self.coordBoundsCheck(coord) else {
            return []
        }
        var coords: [Coordinate] = []
        for row: Int in 0 ..< self.size.rows {
            for cellrow: Int in 0 ..< self.size.rows {
                if self.gameBoard[row][coord.column].getNumber((cellrow, column: coord.cell.column)) != self.solutionBoard[row][coord.column].getNumber((cellrow, column: coord.cell.column)) {
                    return []
                }
                coords.append(Coordinate(row: row, column: coord.column, cell: (row: cellrow, coord.cell.column)))
            }
        }
        return coords
    }
    
    //
    // now for the row
    //
    func getCorrectLocationsFromCompletedRowOnGameBoard(coord: Coordinate) -> [Coordinate] {
        guard self.coordBoundsCheck(coord) else {
            return []
        }
        var coords: [Coordinate] = []
        for column: Int in 0 ..< self.size.columns {
            for cellcolumn: Int in 0 ..< self.size.columns {
                if self.gameBoard[coord.row][column].getNumber((coord.cell.row, column: cellcolumn)) != self.solutionBoard[coord.row][column].getNumber((coord.cell.row, column: cellcolumn)) {
                    return []
                }
                coords.append(Coordinate(row: coord.row, column: column, cell: (coord.cell.row, cellcolumn)))
            }
        }
        return coords
    }
    
    //
    // and for number
    //
    func getCorrectLocationsFromCompletedNumberOnGameBoard(number: Int) -> [Coordinate] {
        guard self.isNumberFullyUsedInGame(number) else {
            return []
        }
        var coords: [Coordinate] = []
        for location: Coordinate in self.getNumberLocationsOnGameBoard(number) {
            if self.getNumberFromGame(location) != self.getNumberFromSolution(location) {
                return []
            }
            coords.append(location)
        }
        return coords
    }

}