//
//  ChalkBoardSudokuNumberGridTests.swift
//  ChalkBoardSudoku
//
//  Created by Graham Watson on 20/08/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import XCTest
@testable import ChalkBoardSudoku

class ChalkBoardSudokuNumberGridTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

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
        XCTAssertEqual(testGrid.getNumber((0,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber((0,1)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber((0,2)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber((1,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber((1,1)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber((1,2)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber((2,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber((2,1)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber((2,2)),  0, "Incorrect initial value reported")
        //
        // now invalid coords
        //
        XCTAssertEqual(testGrid.getNumber((-1,0)), 0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber((0,-1)), 0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber((3,-1)), 0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber((3,3)),  0, "Incorrect initial value reported")
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
        XCTAssertEqual(testGrid.getNumber((0,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber((0,1)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber((0,2)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber((0,3)),  0, "Incorrect initial value reported")
        //
        // invalid coords
        //
        XCTAssertEqual(testGrid.getNumber((-1,0)), 0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber((0,-1)), 0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber((3,-1)), 0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber((3,3)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber((0,4)),  0, "Incorrect initial value reported")
        return
    }
    
    func testGridNumbersFunctions() {
        var testGrid: NumberGrid!
        testGrid = NumberGrid(size: (2,2))
        XCTAssertEqual(testGrid.getNumber((0,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber((0,1)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber((1,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber((1,1)),  0, "Incorrect initial value reported")
        //
        // set some values
        //
        XCTAssertEqual(testGrid.setNumber((0,0),  number: 1),  true, "Unable to set number")
        XCTAssertEqual(testGrid.setNumber((1,1),  number: 9),  true, "Unable to set number")
        XCTAssertEqual(testGrid.setNumber((-1,1), number: 2), false, "Set a number using an Illegal coord")
        XCTAssertEqual(testGrid.setNumber((1,-1), number: 5), false, "Set a number using an Illegal coord")
        XCTAssertEqual(testGrid.setNumber((0,3),  number: 7), false, "Set a number using an Illegal coord")
        //
        // read them back
        //
        XCTAssertEqual(testGrid.getNumber((0,0)),  1, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber((0,1)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber((1,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber((1,1)),  9, "Incorrect initial value reported")
        //
        // overwrite
        //
        XCTAssertEqual(testGrid.setNumber((0,0), number: 4),  true, "Unable to set number")
        XCTAssertEqual(testGrid.getNumber((0,0)),                4, "Incorrect value reported")
        //
        // clear the grid
        //
        testGrid.clear()
        XCTAssertEqual(testGrid.getNumber((0,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber((0,1)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber((1,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(testGrid.getNumber((1,1)),  0, "Incorrect initial value reported")
        //
        // test we only set a single number and it's right
        //
        testGrid.setNumber((1,1), number: 7)
        let testLocations: [(row: Int, column: Int)] = testGrid.getLocationsOfNumber(7)
        XCTAssertEqual(testLocations.count,        1, "Incorrect number of locations reported")
        XCTAssertEqual(testLocations[0].row,       1, "Incorrect location row reported")
        XCTAssertEqual(testLocations[0].column,    1, "Incorrect location column reported")
        XCTAssertEqual(testGrid.getNumber((1,1)),  7, "Incorrect initial value reported")
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
        XCTAssertEqual(copyGrid.getNumber((0,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(copyGrid.getNumber((0,1)),  0, "Incorrect initial value reported")
        XCTAssertEqual(copyGrid.getNumber((1,0)),  0, "Incorrect initial value reported")
        XCTAssertEqual(copyGrid.getNumber((1,1)),  7, "Incorrect initial value reported")
        let copyLocations: [(row: Int, column: Int)] = testGrid.getLocationsOfNumber(7)
        XCTAssertEqual(copyLocations.count,        1, "Incorrect number of locations reported")
        XCTAssertEqual(copyLocations[0].row,       1, "Incorrect location row reported")
        XCTAssertEqual(copyLocations[0].column,    1, "Incorrect location column reported")
        //
        // and it's a diff obj, change the copy and recheck the original
        //
        copyGrid.setNumber((1,0), number: 2)
        XCTAssertEqual(copyGrid.getNumber((1,0)),    2, "Incorrect initial value reported")
        XCTAssertNotEqual(testGrid.getNumber((1,0)), 2, "Incorrect initial value reported")
        return
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
