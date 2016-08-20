//
//  ChalkBoardSudokuSudokuCellTests.swift
//  ChalkBoardSudoku
//
//  Created by Graham Watson on 20/08/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import XCTest
@testable import ChalkBoardSudoku

class ChalkBoardSudokuSudokuCellTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

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
        XCTAssertEqual(testCell.getNumber((0,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber((0,1)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber((0,2)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber((1,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber((1,1)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber((1,2)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber((2,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber((2,1)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber((2,2)),  0, "Incorrect initial value reported")
        //
        // now invalid coords
        //
        XCTAssertEqual(testCell.getNumber((-1,0)), 0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber((0,-1)), 0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber((3,-1)), 0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber((3,3)),  0, "Incorrect initial value reported")
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
        XCTAssertEqual(testCell.getNumber((0,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber((0,1)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber((0,2)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber((1,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber((1,1)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber((1,2)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber((2,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber((2,1)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber((2,2)),  0, "Incorrect initial value reported")
        //
        // invalid coords
        //
        XCTAssertEqual(testCell.getNumber((-1,0)), 0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber((0,-1)), 0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber((3,-1)), 0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber((3,3)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber((0,4)),  0, "Incorrect initial value reported")
        return
    }

    func testSudokoCellFunctions() {
        var testCell: SudokuCell!
        testCell = SudokuCell(size: 2)
        XCTAssertEqual(testCell.getNumber((0,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber((0,1)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber((1,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber((1,1)),  0, "Incorrect initial value reported")
        //
        // set some values
        //
        XCTAssertEqual(testCell.setNumber((0,0),  number: 1),  true, "Unable to set number")
        XCTAssertEqual(testCell.setNumber((1,1),  number: 9), false, "Set number out of range")
        XCTAssertEqual(testCell.setNumber((1,1),  number: 4),  true, "Unable to set number")
        XCTAssertEqual(testCell.setNumber((-1,1), number: 2), false, "Set a number using an Illegal coord")
        XCTAssertEqual(testCell.setNumber((1,-1), number: 5), false, "Set a number using an Illegal coord")
        XCTAssertEqual(testCell.setNumber((0,3),  number: 2), false, "Set a number using an Illegal coord")
        //
        // read them back
        //
        XCTAssertEqual(testCell.getNumber((0,0)),  1, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber((0,1)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber((1,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber((1,1)),  4, "Incorrect initial value reported")
        //
        // try to set a cell already set, diff from base class this should fail
        //
        XCTAssertEqual(testCell.setNumber((0,0), number: 4),  false, "Unable to set number")
        XCTAssertEqual(testCell.getNumber((0,0)),                1, "Incorrect value reported")
        //
        // set a number 'again' in the cell
        //
        XCTAssertEqual(testCell.setNumber((0,1),  number: 1),  false, "Set the same number twice")
        //
        // check we can detect the numbers have been used
        //
        XCTAssertEqual(testCell.isNumberUsed(0), false, "Found unused number")
        XCTAssertEqual(testCell.isNumberUsed(1),  true, "Cannot find used number")
        XCTAssertEqual(testCell.isNumberUsed(2), false, "Found unused number")
        XCTAssertEqual(testCell.isNumberUsed(3), false, "Found unused number")
        XCTAssertEqual(testCell.isNumberUsed(4),  true, "Cannot find used number")
        //
        // check cell completion
        //
        XCTAssertEqual(testCell.isCellCompleted(),            false, "Cell is not completed")
        XCTAssertEqual(testCell.setNumber((0,1),  number: 2),  true, "Set the same number twice")
        XCTAssertEqual(testCell.setNumber((1,0),  number: 3),  true, "Set the same number twice")
        XCTAssertEqual(testCell.isCellCompleted(),             true, "Cell is not completed")
        //
        // get values from row/column
        //
        var numbers: [Int] = testCell.getRowNumbers(0)
        XCTAssertEqual(numbers[0], 1, "Incorrect value reported")
        XCTAssertEqual(numbers[1], 2, "Incorrect value reported")
        numbers = testCell.getRowNumbers(1)
        XCTAssertEqual(numbers[0], 3, "Incorrect value reported")
        XCTAssertEqual(numbers[1], 4, "Incorrect value reported")
        //
        numbers = testCell.getColumnNumbers(0)
        XCTAssertEqual(numbers[0], 1, "Incorrect value reported")
        XCTAssertEqual(numbers[1], 3, "Incorrect value reported")
        numbers = testCell.getColumnNumbers(1)
        XCTAssertEqual(numbers[0], 2, "Incorrect value reported")
        XCTAssertEqual(numbers[1], 4, "Incorrect value reported")
        //
        XCTAssertEqual(testCell.isNumberInRow(0, number: 1),  true, "Incorrect value reported")
        XCTAssertEqual(testCell.isNumberInRow(0, number: 2),  true, "Incorrect value reported")
        XCTAssertEqual(testCell.isNumberInRow(0, number: 3), false, "Incorrect value reported")
        XCTAssertEqual(testCell.isNumberInRow(1, number: 3),  true, "Incorrect value reported")
        XCTAssertEqual(testCell.isNumberInRow(1, number: 4),  true, "Incorrect value reported")
        XCTAssertEqual(testCell.isNumberInRow(1, number: 1), false, "Incorrect value reported")
        //
        XCTAssertEqual(testCell.isNumberInColumn(0, number: 1),  true, "Incorrect value reported")
        XCTAssertEqual(testCell.isNumberInColumn(0, number: 3),  true, "Incorrect value reported")
        XCTAssertEqual(testCell.isNumberInColumn(0, number: 2), false, "Incorrect value reported")
        XCTAssertEqual(testCell.isNumberInColumn(1, number: 2),  true, "Incorrect value reported")
        XCTAssertEqual(testCell.isNumberInColumn(1, number: 4),  true, "Incorrect value reported")
        XCTAssertEqual(testCell.isNumberInColumn(1, number: 1), false, "Incorrect value reported")
        //
        // clear a number
        //
        testCell.clearNumber((0,1))
        XCTAssertEqual(testCell.getNumber((0,0)), 1, "Incorrect value reported")
        XCTAssertEqual(testCell.getNumber((0,1)), 0, "Incorrect value reported")
        XCTAssertEqual(testCell.getNumber((1,0)), 3, "Incorrect value reported")
        XCTAssertEqual(testCell.getNumber((1,1)), 4, "Incorrect value reported")
        XCTAssertEqual(testCell.isCellCompleted(),            false, "Cell is set completed")
        XCTAssertEqual(testCell.setNumber((0,1),  number: 2),  true, "Unable to set number")
        XCTAssertEqual(testCell.isCellCompleted(),             true, "Cell is not completed")
        //
        // unused number / location
        //
        testCell.clearNumber((0,1))
        XCTAssertEqual(testCell.getRandomUnusedNumber(), 2, "Incorrect value reported")
        var location: (row: Int, column: Int) = testCell.getRandomUnusedLocation()
        XCTAssertEqual(location.row,    0, "Incorrect row reported")
        XCTAssertEqual(location.column, 1, "Incorrect column reported")
        //
        // used location
        //
        testCell.clearNumber((0,0))
        testCell.clearNumber((0,1))
        testCell.clearNumber((1,1))
        location = testCell.getRandomUsedPosition()
        XCTAssertEqual(location.row,    1, "Incorrect row reported")
        XCTAssertEqual(location.column, 0, "Incorrect column reported")
        //
        // copy the cell, complete it, test and retest original
        //
        let copyCell: SudokuCell = testCell.copy() as! SudokuCell
        location = copyCell.getRandomUsedPosition()
        XCTAssertEqual(location.row,    1, "Incorrect row reported")
        XCTAssertEqual(location.column, 0, "Incorrect column reported")
        XCTAssertEqual(copyCell.getNumber((1,0)), 3, "Incorrect value reported")
        XCTAssertEqual(copyCell.isCellCompleted(),            false, "Cell is set completed")
        //
        // complete it, and retest original
        //
        XCTAssertEqual(copyCell.setNumber((0,0),  number: 1),  true, "Unable to set number")
        XCTAssertEqual(copyCell.setNumber((0,1),  number: 2),  true, "Set the same number twice")
        XCTAssertEqual(copyCell.setNumber((1,1),  number: 9), false, "Set number out of range")
        XCTAssertEqual(copyCell.setNumber((1,1),  number: 4),  true, "Unable to set number")
        XCTAssertEqual(copyCell.setNumber((-1,1), number: 2), false, "Set a number using an Illegal coord")
        XCTAssertEqual(copyCell.isCellCompleted(),             true, "Cell is not completed")
        //
        // clear the original cell
        //
        testCell.clear()
        XCTAssertEqual(testCell.getNumber((0,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber((0,1)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber((1,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testCell.getNumber((1,1)),  0, "Incorrect initial value reported")
        return
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
