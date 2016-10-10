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
    
    //
    // internal representation of the game difficulty
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
        self.setDifficulty(difficulty: difficulty)
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
        
        self.solutionBoard.append(contentsOf: initialiseBoard())
        self.originBoard.append(contentsOf: initialiseBoard())
        self.gameBoard.append(contentsOf: initialiseBoard())
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

    private func setDifficulty(difficulty: sudokuDifficulty) {
        switch difficulty {
        case sudokuDifficulty.Easy:
            self.difficulty = gameDifficulty.Easy
        case sudokuDifficulty.Medium:
            self.difficulty = gameDifficulty.Medium
        case sudokuDifficulty.Hard:
            self.difficulty = gameDifficulty.Hard
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
        func clearBoard( board: inout [[SudokuCell]]) {
            for row: [SudokuCell] in board {
                for column: SudokuCell in row {
                    column.clear()
                }
            }
        }
        clearBoard(board: &self.solutionBoard)
        clearBoard(board: &self.originBoard)
        clearBoard(board: &self.gameBoard)
        return
    }

    //----------------------------------------------------------------------------
    // Get / Set numbers on the boards
    //----------------------------------------------------------------------------
    func clearGameBoardLocation(coord: Coordinate) {
        guard self.coordBoundsCheck(coord: coord) else {
            return
        }
        self.gameBoard[coord.row][coord.column].clearNumber(coord: coord.cell)
        return
    }

    func getNumberFromGame(coord: Coordinate) -> Int {
        guard self.coordBoundsCheck(coord: coord) else {
            return 0
        }
        return self.gameBoard[coord.row][coord.column].getNumber(coord: coord.cell)
    }

    func setNumberOnGameBoard(coord: Coordinate, number: Int) -> Bool {
        guard self.coordBoundsCheck(coord: coord) else {
            return false
        }
        if self.gameBoard[coord.row][coord.column].isNumberUsed(number: number) == true {
            return false
        }
        if self.isNumberLegalOnBoard(in: self.gameBoard, coord: coord, number: number) == false {
            return false
        }
        //
        // passed all the validation, so add it. could still be a wrong move ofc
        //
        let _: Bool = self.gameBoard[coord.row][coord.column].setNumber(coord: coord.cell, number: number)
        return true
    }

    func getNumberFromOrigin(coord: Coordinate) -> Int {
        guard self.coordBoundsCheck(coord: coord) else {
            return 0
        }
        return self.originBoard[coord.row][coord.column].getNumber(coord: coord.cell)
    }
    
    func setNumberOnOriginBoard(coord: Coordinate, number: Int) -> Bool {
        guard self.coordBoundsCheck(coord: coord) else {
            return false
        }
        if self.originBoard[coord.row][coord.column].isNumberUsed(number: number) == true {
            return false
        }
        let _: Bool = self.originBoard[coord.row][coord.column].setNumber(coord: coord.cell, number: number)
        return true
    }

    private func clearNumberFromSolution(coord: Coordinate) {
        guard self.coordBoundsCheck(coord: coord) else {
            return
        }
        self.solutionBoard[coord.row][coord.column].clearNumber(coord: coord.cell)
        return
    }
    
    func getNumberFromSolution(coord: Coordinate) -> Int {
        guard self.coordBoundsCheck(coord: coord) else {
            return 0
        }
        return self.solutionBoard[coord.row][coord.column].getNumber(coord: coord.cell)
    }

    func setNumberOnSolution(coord: Coordinate, number: Int) -> Bool {
        guard self.coordBoundsCheck(coord: coord) else {
            return false
        }
        if self.solutionBoard[coord.row][coord.column].isNumberUsed(number: number) == true {
            return false
        }
        let _: Bool = self.solutionBoard[coord.row][coord.column].setNumber(coord: coord.cell, number: number)
        return true
    }
    
    //----------------------------------------------------------------------------
    // Can the number go here on the board
    //----------------------------------------------------------------------------
    private func isNumberLegalOnBoard(in board: [[SudokuCell]], coord: Coordinate, number: Int) -> Bool {
        for row: Int in 0 ..< self.size.rows {
            if board[row][coord.column].isNumberInColumn(column:coord.cell.column, number: number) == true {
                return false
            }
        }
        for column: Int in 0 ..< self.size.columns {
            if board[coord.row][column].isNumberInRow(row: coord.cell.row, number: number) == true {
                return false
            }
        }
        return true
    }
    
    //
    // can the number exist in this position in the game
    //
    func isNumberLegalOnGameBoard(coord: Coordinate, number: Int) -> Bool {
        guard self.coordBoundsCheck(coord: coord) else {
            return false
        }
        if self.gameBoard[coord.row][coord.column].isNumberUsed(number: number) == true {
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
        guard self.coordBoundsCheck(coord: coord) else {
            return false
        }
        return (board[coord.row][coord.column].getNumber(coord: (coord.cell.row, coord.cell.column)) == 0) ? false : true
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
                if board[self.coordinates[index].row][self.coordinates[index].column].isNumberUsed(number: number) == false {
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
    private func copyBoardFromTo(in sourceBoard: [[SudokuCell]], destinationBoard: inout [[SudokuCell]]) {
        destinationBoard.removeAll()
        for row: Int in 0 ..< self.size.rows {
            var rowOfCells: [SudokuCell] = []
            rowOfCells.append(sourceBoard[row][0].copy() as! SudokuCell)
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
            let locationsSelection: [Coordinate] = self.getNumberLocationsOnOriginBoard(number: number)
            remove.append(contentsOf: self.getLocationsToRemove(coords: locationsSelection, count: clear))
            number = number + 1
        }
        for location in remove {
            self.originBoard[location.row][location.column].clearNumber(coord: (location.cell.row, location.cell.column))
        }
        return
    }
    
    func getLocationsToRemove(coords: [Coordinate], count: Int) -> [Coordinate] {
        var choose: [Coordinate] = []
        choose.append(contentsOf: coords)
        var remove: [Coordinate] = []
        for _: Int in 0 ..< count {
            let posn: Int = Int(arc4random_uniform(UInt32(choose.count)))
            remove.append(choose[posn])
            choose.remove(at: posn)
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
                let coord: (row: Int, column: Int) = board[row][column].getLocationOfNumber(number: number)
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
    // empty locations on the gameBoard (used in hints)
    //
    func getFreeLocationsOnGameBoard() -> [Coordinate] {
        var coords: [Coordinate] = []
        for number: Int in 1 ..< (self.size.rows * self.size.columns) + 1 {
            coords.append(contentsOf: self.getFreeNumberLocationsOnGameBoard(number: number))
        }
        return coords
    }
    
    //
    // where the 'number' hasn't been used yet (used in hints)
    //
    func getFreeNumberLocationsOnGameBoard(number: Int) -> [Coordinate] {
        var coords: [Coordinate] = []
        for row: Int in 0 ..< self.size.rows {
            for column: Int in 0 ..< self.size.columns {
                if self.gameBoard[row][column].isNumberUsed(number: number) == false {
                    let coord: (row: Int, column: Int) = self.solutionBoard[row][column].getLocationOfNumber(number: number)
                    coords.append(Coordinate(row: row, column: column, cell: (row: coord.row, column: coord.column)))
                }
            }
        }
        return coords
    }
    
    //
    // when a cell is completed and correct, used to set cell contents to 'inactive' if user supplies correct solution
    //
    func getCorrectLocationsFromCompletedCellOnGameBoard(coord: Coordinate) -> [Coordinate] {
        guard self.coordBoundsCheck(coord: coord) && self.gameBoard[coord.row][coord.column].isCellCompleted() else {
            return []
        }
        var coords: [Coordinate] = []
        for row: Int in 0 ..< self.size.rows {
            for column: Int in 0 ..< self.size.columns {
                if self.gameBoard[coord.row][coord.column].getNumber(coord: (row, column)) != self.solutionBoard[coord.row][coord.column].getNumber(coord: (row, column)) {
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
        guard self.coordBoundsCheck(coord: coord) else {
            return []
        }
        var coords: [Coordinate] = []
        for row: Int in 0 ..< self.size.rows {
            for cellrow: Int in 0 ..< self.size.rows {
                if self.gameBoard[row][coord.column].getNumber(coord: (cellrow, column: coord.cell.column)) != self.solutionBoard[row][coord.column].getNumber(coord: (cellrow, column: coord.cell.column)) {
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
        guard self.coordBoundsCheck(coord: coord) else {
            return []
        }
        var coords: [Coordinate] = []
        for column: Int in 0 ..< self.size.columns {
            for cellcolumn: Int in 0 ..< self.size.columns {
                if self.gameBoard[coord.row][column].getNumber(coord: (coord.cell.row, column: cellcolumn)) != self.solutionBoard[coord.row][column].getNumber(coord: (coord.cell.row, column: cellcolumn)) {
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
        guard self.isNumberFullyUsedInGame(number: number) else {
            return []
        }
        var coords: [Coordinate] = []
        for location: Coordinate in self.getNumberLocationsOnGameBoard(number: number) {
            if self.getNumberFromGame(coord: location) != self.getNumberFromSolution(coord: location) {
                return []
            }
            coords.append(location)
        }
        return coords
    }

    //----------------------------------------------------------------------------
    // Build the Board
    //----------------------------------------------------------------------------
    //
    // Build an array of places where we will place a number
    //
    func getPlacementLocations() -> [Placement] {
        var origin: [Placement] = []
        for row: Int in 0 ..< size.rows {
            for column: Int in 0 ..< size.columns {
                for crow: Int in 0 ..< size.columns {
                    for ccol: Int in 0 ..< size.columns {
                        origin.append(Placement(coord: (row, column, cell: (crow, ccol))))
                    }
                }
            }
        }
        return origin
    }
    
    //
    // we need an array of adjacent numbers for a transposition check against the Placement location
    //
    // except when the Placement position is:
    //
    //  1. In the first cell
    //  2. In the first cell row of the first row
    //  3. In the first cell col of the first col
    //  4. The first location of any cell i.e (0,0)
    //
    func getAdjacentNumberPlacements(origin: Placement) -> [Adjacent] {
        var adjacent: [Adjacent] = []
        if origin.location.row == 0 && origin.location.cell.row == 0 {
            return adjacent
        }
        if origin.location.column == 0 && origin.location.cell.column == 0 {
            return adjacent
        }
        if origin.location.row == 0 && origin.location.column == 0 {
            return adjacent
        }
        if origin.location.cell.row == 0 && origin.location.cell.column == 0 {
            return adjacent
        }
        //
        // get adjacent columns but only if we are not on the first row of cells
        //
        if origin.location.column > 0 {
            for i: Int in 0 ..< origin.location.cell.row {
                let coord: Coordinate = Coordinate(row: origin.location.row, column: origin.location.column, cell: (row: i, column: origin.location.cell.column))
                let number: Int = self.getNumberFromSolution(coord: coord)
                if number > 0 {
                    adjacent.append(Adjacent(coord: coord, number: number, axis: axis.column))
                }
            }
        }
        //
        // same for rows, only interested if we are beyond the initial column of cells
        //
        if origin.location.row > 0 {
            for i: Int in 0 ..< origin.location.cell.column {
                let coord: Coordinate = Coordinate(row: origin.location.row, column: origin.location.column, cell: (row: origin.location.cell.row, column: i))
                let number: Int = self.getNumberFromSolution(coord: coord)
                if number > 0 {
                    adjacent.append(Adjacent(coord: coord, number: number, axis: axis.row))
                }
            }
        }
        return adjacent
    }
    
    //
    // from the adjacent Placements and a possible number to place, check if the number breaks the transposition rule
    //
    func isTranspositionRuleOk(input: Placement, number: Int, adjacent: [Adjacent]) -> Bool {
        guard adjacent.count > 0 else {
            return true
        }
        //
        // iterate around number of possible transpositions and if we find one exit
        //
        //  1. the direction we test depends on the positioning of the adjacent number to the proposed number to be placed
        //  2. we move cell by cell
        //  3. should never fail to find a number, either proposed or adjacent but test anyway
        //
        for i: Int in 0 ..< adjacent.count {
            if adjacent[i].axis == axis.column {
                for x: Int in 0 ..< adjacent[i].location.column {
                    let proposedNum: (row: Int, column: Int) = self.solutionBoard[adjacent[i].location.row][x].getLocationOfNumber(number: number)
                    if proposedNum.row != -1 {
                        let adjacentNum: (row: Int, column: Int) = self.solutionBoard[adjacent[i].location.row][x].getLocationOfNumber(number: adjacent[i].number)
                        if adjacentNum.row != -1 {
                            //
                            // numbers should exist in the same column in the cell we're testing
                            // but reversed rows compared to the input and adjacent positions
                            //
                            if adjacentNum.column == proposedNum.column && input.location.cell.row == adjacentNum.row && adjacent[i].location.cell.row == proposedNum.row {
                                return false
                            }
                        }
                    }
                }
            } else {
                for y: Int in 0 ..< adjacent[i].location.row {
                    let proposedNum: (row: Int, column: Int) = self.solutionBoard[y][adjacent[i].location.column].getLocationOfNumber(number: number)
                    if proposedNum.row != -1 {
                        let adjacentNum: (row: Int, column: Int) = self.solutionBoard[y][adjacent[i].location.column].getLocationOfNumber(number: adjacent[i].number)
                        if adjacentNum.row != -1 {
                            //
                            // numbers should exist in the same row in the cell we're testing
                            // but reversed coilumns compared to the input and adjacent positions
                            //
                            if adjacentNum.row == proposedNum.row && input.location.cell.column == adjacentNum.column && adjacent[i].location.cell.column == proposedNum.column {
                                return false
                            }
                        }
                    }
                }
            }
        }
        return true
    }
    
    func rewindSolution(input: inout [Placement], output: inout [Placement]) {
        input[0].tried = []
        self.clearNumberFromSolution(coord: Coordinate(row: output[0].location.row, column: output[0].location.column, cell: (output[0].location.cell)))
        output[0].number = 0
        input.insert(output[0], at: 0)
        output.remove(at: 0)
        return
    }
    
    //
    // work through the placements row/column cell/row/column in turn
    //
    func placeNumbers(input: inout [Placement], output: inout [Placement], rewind: inout Int, reset: inout Int) {
        guard input.count > 0 else {
            return
        }
        while true {
            //
            // using the list of used / excluded numbers, build a list of possibles for that posn
            //
            var possibleNums: [Int] = []
            var numberUsage: [Bool] = self.solutionBoard[input[0].location.row][input[0].location.column].getNumberUsage()
            for i: Int in 0 ..< numberUsage.count {
                if numberUsage[i] == false {
                    if input[0].tried.contains(i + 1) == false {
                        possibleNums.append(i + 1)
                    }
                }
            }
            //
            // get the adjacent numbers to this location (used for the transposition check)
            //
            let adjNumbers: [Adjacent] = self.getAdjacentNumberPlacements(origin: input[0])
            //
            // see if one of the possibles can be placed
            //
            while possibleNums.count > 0 {
                let index: Int  = Int(arc4random_uniform(UInt32(possibleNums.count)))
                let number: Int = possibleNums[index]
                input[0].tried.append(number)
                if self.isNumberLegalOnBoard(in: self.solutionBoard, coord: input[0].location, number: number) {
                    if self.isTranspositionRuleOk(input: input[0], number: number, adjacent: adjNumbers) == true {
                        input[0].number = number
                        let _: Bool = self.setNumberOnSolution(coord: input[0].location, number: number)
                        output.insert(input[0], at: 0)
                        input.remove(at: 0)
                        return
                    }
                }
                possibleNums.remove(at: index)
            }
            //
            // failed to place one of the numbers, so rewind the solution one place and try again
            //
            rewind = rewind + 1
            //
            // if we've repeatedly rewound then brute force the puzzle back to just after the first cell and try again
            //
            if rewind < 256 {
                self.rewindSolution(input: &input, output: &output)
            } else {
                rewind = 0
                reset = reset + 1
                while (output.count > (self.size.rows * self.size.columns)) {
                    self.rewindSolution(input: &input, output: &output)
                }
            }
        }
    }
    
    func generateSolution(difficulty: sudokuDifficulty) {
        self.setDifficulty(difficulty: difficulty)
        self.clear()
        var start:  [Placement] = getPlacementLocations()
        var board:  [Placement] = []
        let stime:  CFAbsoluteTime = CFAbsoluteTimeGetCurrent()
        var stall: Int = 0
        var times: Int = 0
        while start.count > 0 {
            placeNumbers(input: &start, output: &board, rewind: &stall, reset: &times)
        }
        let elapsed: CFAbsoluteTime = CFAbsoluteTimeGetCurrent() - stime
        print("CBS: \(elapsed) seconds passed during the board generation, this included \(times) resets...")
        return
    }

    //----------------------------------------------------------------------------
    // Build the Board
    //----------------------------------------------------------------------------
    func printSudokuSolution() -> String {
        guard self.isBoardCompleted(in: self.solutionBoard) == true else {
            return "ChalkBoardSudoku: Solution board is not completed"
        }
        var dumpOfBoard: String = ""
        for row: Int in 0 ..< self.size.rows {
            dumpOfBoard += "\nBoard row: \(row)\n"
            for cellrow: Int in 0 ..< self.size.rows {
                var dumpOfCellRow: String = ""
                for column: Int in 0 ..< self.size.columns {
                    let cellColumns: [Int] = self.solutionBoard[row][column].getRowNumbers(row: cellrow)
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
    
}
