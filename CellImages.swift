//
//  CellImages.swift
//  SudokuTest
//
//  Created by Graham Watson on 10/05/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation
import UIKit

// to hold reference to image/type of image displayed ie. default, selected, highlighted
struct CellContent {
    var imageView: UIImageView!
    var state: Int!
}

class CellImages {
    var cellContents: [[CellContent]] = []
    var cellColumns: Int = 0
    var cellRows: Int = 0

    // for main board array where rows = cols
    init (size: Int = 3) {
        var setRows: Int = size
        if setRows != 3 {
            setRows = 3
        }
        self.allocateCellArray(setRows, columns: setRows)
        return
    }

    // for control panel where rows != cols
    // allowed rows 3 -> 6, columns 2 -> 4
    init (rows: Int = 6, columns: Int = 2) {
        var setRows: Int = rows
        var setColumns: Int = columns
        if (setColumns < 2) || (setColumns > 4) {
            setColumns = 2
        }
        if (setRows < 3) || (setRows > 6) {
            setRows = 6
        }
        self.allocateCellArray(setRows, columns: setColumns)
        return
    }

    private func allocateCellArray(rows: Int, columns: Int) {
        for _: Int in 0 ..< rows {
            var rowOfImages: [CellContent] = []
            for _: Int in 0 ..< columns {
                var image = CellContent()
                image.imageView = UIImageView()
                image.state = -1
                rowOfImages.append(image)
            }
            self.cellContents.append(rowOfImages)
        }
        self.cellRows = rows
        self.cellColumns = columns
        return
    }
    
    // public functions
    func setImage(row: Int, column: Int, imageToSet: UIImage, imageState: Int) {
        if (row < 0) || (row > self.cellRows) || (column < 0 ) || (column > self.cellColumns) {
            return
        }
        self.cellContents[row][column].imageView.image = imageToSet
        self.cellContents[row][column].state = imageState
        return
    }
    
    func unsetImage(row: Int, column: Int) {
        if (row < 0) || (row > self.cellRows) || (column < 0 ) || (column > self.cellColumns) {
            return
        }
        self.cellContents[row][column].imageView.image = nil
        self.cellContents[row][column].state = -1
        return
    }
    
    func getImageState(row: Int, column: Int) -> Int {
        if (row < 0) || (row > self.cellRows) || (column < 0 ) || (column > self.cellColumns) {
            return -2
        }
        return self.cellContents[row][column].state
    }
    
    func setImageState(row: Int, column: Int, imageState: Int) {
        if (row < 0) || (row > self.cellRows) || (column < 0 ) || (column > self.cellColumns) {
            return
        }
        self.cellContents[row][column].state = imageState
        return
    }
    
    func getLocationsOfCellsStateEqualTo(state: Int) -> [(cellRow: Int, cellColumn: Int)] {
        var returnCoords: [(cellRow: Int, cellColumn: Int)] = []
        for row: Int in 0 ..< self.cellRows {
            for column: Int in 0 ..< self.cellColumns {
                if self.cellContents[row][column].state == state {
                    returnCoords.append((row, column))
                }
            }
        }
        return (returnCoords)
    }
    
    func getLocationsOfCellsStateNotEqualTo(state: Int) -> [(cellRow: Int, cellColumn: Int)] {
        var returnCoords: [(cellRow: Int, cellColumn: Int)] = []
        for row: Int in 0 ..< self.cellRows {
            for column: Int in 0 ..< self.cellColumns {
                if self.cellContents[row][column].state != state {
                    returnCoords.append((row, column))
                }
            }
        }
        return (returnCoords)
    }
    
}