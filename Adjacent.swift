//
//  Adjacent.swift
//  ChalkBoardSudoku
//
//  Created by Graham Watson on 02/10/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation

enum axis {
    case row
    case column
}

class Adjacent {
    var location: Coordinate
    var number:   Int   = 0
    var axis:     axis
    
    init(coord: Coordinate, number: Int, axis: axis) {
        self.location = coord
        self.number   = number
        self.axis     = axis
        return
    }
    
    init(coord: (row: Int, column: Int, cell: (row: Int, column: Int)), number: Int, axis: axis) {
        self.location = Coordinate(row: coord.row, column: coord.column, cell: (coord.cell))
        self.number   = number
        self.axis     = axis
        return
    }
    
}
