//
//  ChalkBoardSudokuTests.swift
//  ChalkBoardSudokuTests
//
//  Created by Graham Watson on 18/08/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import XCTest
@testable import ChalkBoardSudoku

class ChalkBoardSudokuTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //----------------------------------------------------------------------------
    // Start of Class Tests
    //----------------------------------------------------------------------------
    // Class: NumberGrid
    //----------------------------------------------------------------------------
    func testNumberGridSizeOverriddenCorrectly() {
        var testGrid: NumberGrid!
        testGrid = NumberGrid(size: (0,0))
        XCTAssertEqual(testGrid.getRows(),    3, "Incorrect initial rows reported")
        XCTAssertEqual(testGrid.getColumns(), 3, "Incorrect initial columns reported")
        let testSize: (rows: Int, columns: Int) = testGrid.getSize()
        XCTAssertEqual(testSize.rows,         3, "Incorrect initial rows reported")
        XCTAssertEqual(testSize.columns,      3, "Incorrect initial columns reported")
        //
        // test default values are set
        //
        XCTAssertEqual(testGrid.getNumber(coord: (0,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber(coord: (0,1)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber(coord: (0,2)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber(coord: (1,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber(coord: (1,1)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber(coord: (1,2)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber(coord: (2,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber(coord: (2,1)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber(coord: (2,2)),  0, "Incorrect initial value reported")
        //
        // now invalid coords
        //
        XCTAssertEqual(testGrid.getNumber(coord: (-1,0)), 0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber(coord: (0,-1)), 0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber(coord: (3,-1)), 0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber(coord: (3,3)),  0, "Incorrect initial value reported")
        return
    }
    
    func testNumberGridSizeSetCorrectly() {
        var testGrid: NumberGrid!
        testGrid = NumberGrid(size: (1,4))
        XCTAssertEqual(testGrid.getRows(),    1, "Incorrect initial rows reported")
        XCTAssertEqual(testGrid.getColumns(), 4, "Incorrect initial columns reported")
        let testSize: (rows: Int, columns: Int) = testGrid.getSize()
        XCTAssertEqual(testSize.rows,         1, "Incorrect initial rows reported")
        XCTAssertEqual(testSize.columns,      4, "Incorrect initial columns reported")
        //
        // defaults
        //
        XCTAssertEqual(testGrid.getNumber(coord: (0,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber(coord: (0,1)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber(coord: (0,2)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber(coord: (0,3)),  0, "Incorrect initial value reported")
        //
        // invalid coords
        //
        XCTAssertEqual(testGrid.getNumber(coord: (-1,0)), 0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber(coord: (0,-1)), 0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber(coord: (3,-1)), 0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber(coord: (3,3)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber(coord: (0,4)),  0, "Incorrect initial value reported")
        return
    }
    
    func testNumberGridFunctions() {
        var testGrid: NumberGrid!
        testGrid = NumberGrid(size: (2,2))
        XCTAssertEqual(testGrid.getNumber(coord: (0,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber(coord: (0,1)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber(coord: (1,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber(coord: (1,1)),  0, "Incorrect initial value reported")
        //
        // set some values
        //
        XCTAssertEqual(testGrid.setNumber(coord: (0,0),  number: 1),  true, "Unable to set number")
        XCTAssertEqual(testGrid.setNumber(coord: (1,1),  number: 9),  true, "Unable to set number")
        XCTAssertEqual(testGrid.setNumber(coord: (-1,1), number: 2), false, "Set a number using an Illegal coord")
        XCTAssertEqual(testGrid.setNumber(coord: (1,-1), number: 5), false, "Set a number using an Illegal coord")
        XCTAssertEqual(testGrid.setNumber(coord: (0,3),  number: 7), false, "Set a number using an Illegal coord")
        //
        // read them back
        //
        XCTAssertEqual(testGrid.getNumber(coord: (0,0)),  1, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber(coord: (0,1)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber(coord: (1,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber(coord: (1,1)),  9, "Incorrect initial value reported")
        //
        // overwrite
        //
        XCTAssertEqual(testGrid.setNumber(coord: (0,0), number: 4),  true, "Unable to set number")
        XCTAssertEqual(testGrid.getNumber(coord: (0,0)),                4, "Incorrect value reported")
        //
        // clear the grid
        //
        testGrid.clear()
        XCTAssertEqual(testGrid.getNumber(coord: (0,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber(coord: (0,1)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber(coord: (1,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber(coord: (1,1)),  0, "Incorrect initial value reported")
        //
        // test we only set a single number and it's right
        //
        let _: Bool = testGrid.setNumber(coord: (1,1), number: 7)
        let testLocations: [(row: Int, column: Int)] = testGrid.getLocationsOfNumber(number: 7)
        XCTAssertEqual(testLocations.count,        1, "Incorrect number of locations reported")
        XCTAssertEqual(testLocations[0].row,       1, "Incorrect location row reported")
        XCTAssertEqual(testLocations[0].column,    1, "Incorrect location column reported")
        XCTAssertEqual(testGrid.getNumber(coord: (1,1)),  7, "Incorrect initial value reported")
        //
        // coords tests
        //
        let testCoords: [(row: Int, column: Int)] = testGrid.getCoords()
        XCTAssertEqual(testCoords.count,        4, "Incorrect coord count reported")
        XCTAssertEqual(testCoords[0].row,       0, "Incorrect location row reported")
        XCTAssertEqual(testCoords[0].column,    0, "Incorrect location column reported")
        XCTAssertEqual(testCoords[1].row,       0, "Incorrect location row reported")
        XCTAssertEqual(testCoords[1].column,    1, "Incorrect location column reported")
        XCTAssertEqual(testCoords[2].row,       1, "Incorrect location row reported")
        XCTAssertEqual(testCoords[2].column,    0, "Incorrect location column reported")
        XCTAssertEqual(testCoords[3].row,       1, "Incorrect location row reported")
        XCTAssertEqual(testCoords[3].column,    1, "Incorrect location column reported")
        //
        // copy the obj and make sure it's worked
        //
        let copyGrid: NumberGrid = testGrid.copy() as! NumberGrid
        XCTAssertEqual(copyGrid.getNumber(coord: (0,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(copyGrid.getNumber(coord: (0,1)),  0, "Incorrect initial value reported")
        XCTAssertEqual(copyGrid.getNumber(coord: (1,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(copyGrid.getNumber(coord: (1,1)),  7, "Incorrect initial value reported")
        let copyLocations: [(row: Int, column: Int)] = testGrid.getLocationsOfNumber(number: 7)
        XCTAssertEqual(copyLocations.count,        1, "Incorrect number of locations reported")
        XCTAssertEqual(copyLocations[0].row,       1, "Incorrect location row reported")
        XCTAssertEqual(copyLocations[0].column,    1, "Incorrect location column reported")
        //
        // and it's a diff obj, change the copy and recheck the original
        //
        let _: Bool = copyGrid.setNumber(coord: (1,0), number: 2)
        XCTAssertEqual(copyGrid.getNumber(coord: (1,0)),    2, "Incorrect initial value reported")
        XCTAssertNotEqual(testGrid.getNumber(coord: (1,0)), 2, "Incorrect initial value reported")
        return
    }
    
    //----------------------------------------------------------------------------
    // Class: SudokuCell
    //----------------------------------------------------------------------------
    func testSudokuCellSizeOverriddenCorrectly() {
        var testCell: SudokuCell!
        testCell = SudokuCell(size: 0)
        XCTAssertEqual(testCell.getRows(),    3, "Incorrect initial rows reported")
        XCTAssertEqual(testCell.getColumns(), 3, "Incorrect initial columns reported")
        let testSize: (rows: Int, columns: Int) = testCell.getSize()
        XCTAssertEqual(testSize.rows,         3, "Incorrect initial rows reported")
        XCTAssertEqual(testSize.columns,      3, "Incorrect initial columns reported")
        //
        // test default values are set
        //
        XCTAssertEqual(testCell.getNumber(coord: (0,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber(coord: (0,1)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber(coord: (0,2)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber(coord: (1,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber(coord: (1,1)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber(coord: (1,2)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber(coord: (2,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber(coord: (2,1)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber(coord: (2,2)),  0, "Incorrect initial value reported")
        //
        // now invalid coords
        //
        XCTAssertEqual(testCell.getNumber(coord: (-1,0)), 0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber(coord: (0,-1)), 0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber(coord: (3,-1)), 0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber(coord: (3,3)),  0, "Incorrect initial value reported")
        return
    }
    
    func testSudokuCellSizeSetCorrectly() {
        var testCell: SudokuCell!
        testCell = SudokuCell(size: 3)
        XCTAssertEqual(testCell.getRows(),    3, "Incorrect initial rows reported")
        XCTAssertEqual(testCell.getColumns(), 3, "Incorrect initial columns reported")
        let testSize: (rows: Int, columns: Int) = testCell.getSize()
        XCTAssertEqual(testSize.rows,         3, "Incorrect initial rows reported")
        XCTAssertEqual(testSize.columns,      3, "Incorrect initial columns reported")
        //
        // defaults
        //
        XCTAssertEqual(testCell.getNumber(coord: (0,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber(coord: (0,1)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber(coord: (0,2)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber(coord: (1,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber(coord: (1,1)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber(coord: (1,2)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber(coord: (2,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber(coord: (2,1)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber(coord: (2,2)),  0, "Incorrect initial value reported")
        //
        // invalid coords
        //
        XCTAssertEqual(testCell.getNumber(coord: (-1,0)), 0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber(coord: (0,-1)), 0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber(coord: (3,-1)), 0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber(coord: (3,3)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber(coord: (0,4)),  0, "Incorrect initial value reported")
        return
    }
    
    func testSudokoCellFunctions() {
        var testCell: SudokuCell!
        testCell = SudokuCell(size: 2)
        XCTAssertEqual(testCell.getNumber(coord: (0,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber(coord: (0,1)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber(coord: (1,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber(coord: (1,1)),  0, "Incorrect initial value reported")
        //
        // set some values
        //
        XCTAssertEqual(testCell.setNumber(coord: (0,0),  number: 1),  true, "Unable to set number")
        XCTAssertEqual(testCell.setNumber(coord: (1,1),  number: 9), false, "Set number out of range")
        XCTAssertEqual(testCell.setNumber(coord: (1,1),  number: 4),  true, "Unable to set number")
        XCTAssertEqual(testCell.setNumber(coord: (-1,1), number: 2), false, "Set a number using an Illegal coord")
        XCTAssertEqual(testCell.setNumber(coord: (1,-1), number: 5), false, "Set a number using an Illegal coord")
        XCTAssertEqual(testCell.setNumber(coord: (0,3),  number: 2), false, "Set a number using an Illegal coord")
        //
        // read them back
        //
        XCTAssertEqual(testCell.getNumber(coord: (0,0)),  1, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber(coord: (0,1)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber(coord: (1,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber(coord: (1,1)),  4, "Incorrect initial value reported")
        //
        // try to set a cell already set, diff from base class this should fail
        //
        XCTAssertEqual(testCell.setNumber(coord: (0,0), number: 4),  false, "Unable to set number")
        XCTAssertEqual(testCell.getNumber(coord: (0,0)),                1, "Incorrect value reported")
        //
        // set a number 'again' in the cell
        //
        XCTAssertEqual(testCell.setNumber(coord: (0,1),  number: 1),  false, "Set the same number twice")
        //
        // check we can detect the numbers have been used
        //
        XCTAssertEqual(testCell.isNumberUsed(number: 0), false, "Found unused number")
        XCTAssertEqual(testCell.isNumberUsed(number: 1),  true, "Cannot find used number")
        XCTAssertEqual(testCell.isNumberUsed(number: 2), false, "Found unused number")
        XCTAssertEqual(testCell.isNumberUsed(number: 3), false, "Found unused number")
        XCTAssertEqual(testCell.isNumberUsed(number: 4),  true, "Cannot find used number")
        //
        // check cell completion
        //
        XCTAssertEqual(testCell.isCellCompleted(),            false, "Cell is not completed")
        XCTAssertEqual(testCell.setNumber(coord: (0,1),  number: 2),  true, "Set the same number twice")
        XCTAssertEqual(testCell.setNumber(coord: (1,0),  number: 3),  true, "Set the same number twice")
        XCTAssertEqual(testCell.isCellCompleted(),             true, "Cell is not completed")
        //
        // get values from row/column
        //
        var numbers: [Int] = testCell.getRowNumbers(row: 0)
        XCTAssertEqual(numbers[0], 1, "Incorrect value reported")
        XCTAssertEqual(numbers[1], 2, "Incorrect value reported")
        numbers = testCell.getRowNumbers(row: 1)
        XCTAssertEqual(numbers[0], 3, "Incorrect value reported")
        XCTAssertEqual(numbers[1], 4, "Incorrect value reported")
        //
        numbers = testCell.getColumnNumbers(column: 0)
        XCTAssertEqual(numbers[0], 1, "Incorrect value reported")
        XCTAssertEqual(numbers[1], 3, "Incorrect value reported")
        numbers = testCell.getColumnNumbers(column: 1)
        XCTAssertEqual(numbers[0], 2, "Incorrect value reported")
        XCTAssertEqual(numbers[1], 4, "Incorrect value reported")
        //
        XCTAssertEqual(testCell.isNumberInRow(row: 0, number: 1),  true, "Incorrect value reported")
        XCTAssertEqual(testCell.isNumberInRow(row: 0, number: 2),  true, "Incorrect value reported")
        XCTAssertEqual(testCell.isNumberInRow(row: 0, number: 3), false, "Incorrect value reported")
        XCTAssertEqual(testCell.isNumberInRow(row: 1, number: 3),  true, "Incorrect value reported")
        XCTAssertEqual(testCell.isNumberInRow(row: 1, number: 4),  true, "Incorrect value reported")
        XCTAssertEqual(testCell.isNumberInRow(row: 1, number: 1), false, "Incorrect value reported")
        //
        XCTAssertEqual(testCell.isNumberInColumn(column: 0, number: 1),  true, "Incorrect value reported")
        XCTAssertEqual(testCell.isNumberInColumn(column: 0, number: 3),  true, "Incorrect value reported")
        XCTAssertEqual(testCell.isNumberInColumn(column: 0, number: 2), false, "Incorrect value reported")
        XCTAssertEqual(testCell.isNumberInColumn(column: 1, number: 2),  true, "Incorrect value reported")
        XCTAssertEqual(testCell.isNumberInColumn(column: 1, number: 4),  true, "Incorrect value reported")
        XCTAssertEqual(testCell.isNumberInColumn(column: 1, number: 1), false, "Incorrect value reported")
        //
        // clear a number
        //
        testCell.clearNumber(coord: (0,1))
        XCTAssertEqual(testCell.getNumber(coord: (0,0)), 1, "Incorrect value reported")
        XCTAssertEqual(testCell.getNumber(coord: (0,1)), 0, "Incorrect value reported")
        XCTAssertEqual(testCell.getNumber(coord: (1,0)), 3, "Incorrect value reported")
        XCTAssertEqual(testCell.getNumber(coord: (1,1)), 4, "Incorrect value reported")
        XCTAssertEqual(testCell.isCellCompleted(),            false, "Cell is set completed")
        XCTAssertEqual(testCell.setNumber(coord: (0,1),  number: 2),  true, "Unable to set number")
        XCTAssertEqual(testCell.isCellCompleted(),             true, "Cell is not completed")
        //
        // unused number / location
        //
        testCell.clearNumber(coord: (0,1))
        XCTAssertEqual(testCell.getRandomUnusedNumber(), 2, "Incorrect value reported")
        var location: (row: Int, column: Int) = testCell.getRandomUnusedLocation()
        XCTAssertEqual(location.row,    0, "Incorrect row reported")
        XCTAssertEqual(location.column, 1, "Incorrect column reported")
        //
        // used location
        //
        testCell.clearNumber(coord: (0,0))
        testCell.clearNumber(coord: (0,1))
        testCell.clearNumber(coord: (1,1))
        location = testCell.getRandomUsedLocation()
        XCTAssertEqual(location.row,    1, "Incorrect row reported")
        XCTAssertEqual(location.column, 0, "Incorrect column reported")
        //
        // copy the cell, complete it, test and retest original
        //
        let copyCell: SudokuCell = testCell.copy() as! SudokuCell
        location = copyCell.getRandomUsedLocation()
        XCTAssertEqual(location.row,    1, "Incorrect row reported")
        XCTAssertEqual(location.column, 0, "Incorrect column reported")
        XCTAssertEqual(copyCell.getNumber(coord: (1,0)), 3, "Incorrect value reported")
        XCTAssertEqual(copyCell.isCellCompleted(),            false, "Cell is set completed")
        //
        // complete it, and retest original
        //
        XCTAssertEqual(copyCell.setNumber(coord: (0,0),  number: 1),  true, "Unable to set number")
        XCTAssertEqual(copyCell.setNumber(coord: (0,1),  number: 2),  true, "Set the same number twice")
        XCTAssertEqual(copyCell.setNumber(coord: (1,1),  number: 9), false, "Set number out of range")
        XCTAssertEqual(copyCell.setNumber(coord: (1,1),  number: 4),  true, "Unable to set number")
        XCTAssertEqual(copyCell.setNumber(coord: (-1,1), number: 2), false, "Set a number using an Illegal coord")
        XCTAssertEqual(copyCell.isCellCompleted(),             true, "Cell is not completed")
        location = testCell.getRandomUsedLocation()
        XCTAssertEqual(location.row,    1, "Incorrect row reported")
        XCTAssertEqual(location.column, 0, "Incorrect column reported")
        XCTAssertEqual(testCell.isCellCompleted(),             false, "Cell is not completed")
        //
        // clear the original cell
        //
        testCell.clear()
        XCTAssertEqual(testCell.getNumber(coord: (0,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber(coord: (0,1)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber(coord: (1,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber(coord: (1,1)),  0, "Incorrect initial value reported")
        return
    }

    //----------------------------------------------------------------------------
    // Class: SudokuGameBoard
    //----------------------------------------------------------------------------
    func testSudokuBoardGameSizeOverriddenCorrectly() {
        var testBoard: SudokuGameBoard!
        testBoard = SudokuGameBoard(size: 0)
        let testSize: (rows: Int, columns: Int) = testBoard.getSize()
        XCTAssertEqual(testSize.rows,    3, "Incorrect initial rows reported")
        XCTAssertEqual(testSize.columns, 3, "Incorrect initial columns reported")
        XCTAssertEqual(testBoard.getDifficulty(), sudokuDifficulty.Medium, "Incorrect initial columns reported")
        //
        // default values are set
        //
        var coord: Coordinate
        for row: Int in 0 ..< testSize.rows {
            for column: Int in 0 ..< testSize.columns {
                for crow: Int in 0 ..< testSize.rows {
                    for ccolumn: Int in 0 ..< testSize.columns {
                        coord = Coordinate(row: row, column: column, cell: (crow, ccolumn))
                        XCTAssertEqual(testBoard.getNumberFromSolution(coord: coord), 0, "Incorrect initial value reported")
                        XCTAssertEqual(testBoard.getNumberFromOrigin(coord: coord),   0, "Incorrect initial value reported")
                        XCTAssertEqual(testBoard.getNumberFromGame(coord: coord),     0, "Incorrect initial value reported")
                    }
                }
            }
        }
        //
        // and an invalid coord
        //
        coord = Coordinate(row: 0, column: 0, cell: (0, 9))
        XCTAssertEqual(testBoard.getNumberFromSolution(coord: coord), 0, "Incorrect initial value reported")
        coord = Coordinate(row: 7, column: 0, cell: (0, 0))
        XCTAssertEqual(testBoard.getNumberFromOrigin(coord: coord),   0, "Incorrect initial value reported")
        coord = Coordinate(row: -1, column: 0, cell: (0, 9))
        XCTAssertEqual(testBoard.getNumberFromGame(coord: coord),     0, "Incorrect initial value reported")
        return
    }
    
    func testSudokuBoardGameSizeSetCorrectly() {
        var testBoard: SudokuGameBoard!
        testBoard = SudokuGameBoard(size: 4)
        let testSize: (rows: Int, columns: Int) = testBoard.getSize()
        XCTAssertEqual(testSize.rows,    4, "Incorrect initial rows reported")
        XCTAssertEqual(testSize.columns, 4, "Incorrect initial columns reported")
        XCTAssertEqual(testBoard.getDifficulty(), sudokuDifficulty.Medium, "Incorrect initial columns reported")
        //
        // default values are set
        //
        var coord: Coordinate
        for row: Int in 0 ..< testSize.rows {
            for column: Int in 0 ..< testSize.columns {
                for crow: Int in 0 ..< testSize.rows {
                    for ccolumn: Int in 0 ..< testSize.columns {
                        coord = Coordinate(row: row, column: column, cell: (crow, ccolumn))
                        XCTAssertEqual(testBoard.getNumberFromSolution(coord: coord), 0, "Incorrect initial value reported")
                        XCTAssertEqual(testBoard.getNumberFromOrigin(coord: coord),   0, "Incorrect initial value reported")
                        XCTAssertEqual(testBoard.getNumberFromGame(coord: coord),     0, "Incorrect initial value reported")
                    }
                }
            }
        }
        //
        // and an invalid coord
        //
        coord = Coordinate(row: 0, column: 0, cell: (0, 9))
        XCTAssertEqual(testBoard.getNumberFromSolution(coord: coord), 0, "Incorrect initial value reported")
        coord = Coordinate(row: 7, column: 0, cell: (0, 0))
        XCTAssertEqual(testBoard.getNumberFromOrigin(coord: coord),   0, "Incorrect initial value reported")
        coord = Coordinate(row: -1, column: 0, cell: (0, 9))
        XCTAssertEqual(testBoard.getNumberFromGame(coord: coord),     0, "Incorrect initial value reported")
        return
    }
    
    func testSudokuBoardGameFunctions() {
        var testBoard: SudokuGameBoard!
        testBoard = SudokuGameBoard(size: 3)
        //
        // build a game
        //
        testBoard.generateSolution(difficulty: sudokuDifficulty.Medium)

        
//        var coord: Coordinate = Coordinate(row: 0, column: 0, cell: (0, 0))
//        XCTAssertEqual(testBoard.setNumberOnSolutionBoard(coord, number: 1),  true, "Unable to set number")
//        

//        
//        
//        
//        
//        let testSize: (rows: Int, columns: Int) = testBoard.getSize()
//        XCTAssertEqual(testSize.rows,    4, "Incorrect initial rows reported")
//        XCTAssertEqual(testSize.columns, 4, "Incorrect initial columns reported")
//        XCTAssertEqual(testBoard.getDifficulty(), sudokuDifficulty.Medium, "Incorrect initial columns reported")
//        //
//        // and an invalid coord
//        //
//        coord = Coordinate(row: 0, column: 0, cell: (0, 9))
//        XCTAssertEqual(testBoard.getNumberFromSolution(coord), 0, "Incorrect initial value reported")
//        coord = Coordinate(row: 7, column: 0, cell: (0, 0))
//        XCTAssertEqual(testBoard.getNumberFromOrigin(coord),   0, "Incorrect initial value reported")
//        coord = Coordinate(row: -1, column: 0, cell: (0, 9))
//        XCTAssertEqual(testBoard.getNumberFromGame(coord),     0, "Incorrect initial value reported")
        return
    }
    

    
    //----------------------------------------------------------------------------
    // End of Class Tests
    //----------------------------------------------------------------------------
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
