//
//  Placement.swift
//  ChalkBoardSudoku
//
//  Created by Graham Watson on 25/08/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation

class Placement {
    var location:     Coordinate
    var number:       Int   = 0
    var tried:        [Int] = []
    
    init(coord: Coordinate) {
        self.location = coord
        self.number   = 0
        self.tried    = []
        return
    }
    
    init(coord: Coordinate, number: Int) {
        self.location = coord
        self.number   = number
        self.tried    = []
        return
    }
    
    init(coord: (row: Int, column: Int, cell: (row: Int, column: Int))) {
        self.location = Coordinate(row: coord.row, column: coord.column, cell: (coord.cell))
        self.number   = 0
        self.tried    = []
        return
    }
    
    init(coord: (row: Int, column: Int, cell: (row: Int, column: Int)), number: Int) {
        self.location = Coordinate(row: coord.row, column: coord.column, cell: (coord.cell))
        self.number   = number
        self.tried    = []
        return
    }
    
}
