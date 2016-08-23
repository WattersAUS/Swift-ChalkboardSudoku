//
//  GameBoardImages.swift
//  SudokuTest
//
//  Created by Graham Watson on 12/05/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation

class GameBoardImages {
    
    var gameImages: [[CellImages]] = []
    var boardCoordinates: [(row: Int, column: Int)] = []
    private var size: (rows: Int, columns: Int) = (0,0)
    
    init (size: Int = 3) {
        var setSize: Int = size
        if setSize != 3 {
            setSize = 3
        }
        
        func allocateImageArray(rows: Int, columns: Int) {
            self.size.rows = rows
            self.size.columns = columns
            for row: Int in 0 ..< rows {
                var cells: [CellImages] = [CellImages(size: (rows, columns))]
                for column: Int in 0 ..< columns {
                    self.boardCoordinates.append((row, column))
                    if column > 0 {
                        cells.append(CellImages(size: (rows, columns)))
                    }
                }
                self.gameImages.append(cells)
            }
            return
        }
        
        allocateImageArray(setSize, columns: setSize)
        return
    }
    
    //----------------------------------------------------------------------------
    // Get sizes
    //----------------------------------------------------------------------------
    func getSize() -> (rows: Int, columns: Int) {
        return size
    }
    
    func getColumns() -> Int {
        return self.size.columns
    }
    
    func getRows() -> Int {
        return self.size.rows
    }

    //----------------------------------------------------------------------------
    // Get / Set 'active' state (is there an image) and image types
    //----------------------------------------------------------------------------
    func getImageState(coord: Coordinate) -> imageStates {
        return self.gameImages[coord.row][coord.column].getImageState((coord.cell.row, coord.cell.column))
    }
    
    func setImageStates(setState: imageStates) {
        for row: Int in 0 ..< self.size.rows {
            for column: Int in 0 ..< self.size.columns {
                for location: (row:Int, column: Int) in self.gameImages[row][column].getLocationsOfImageStateEqualTo(setState) {
                    self.gameImages[row][column].setImageState((location), imageState: setState)
                }
            }
        }
        return
    }
    
    func setActiveStates(setState: activeStates) {
        for row: Int in 0 ..< self.size.rows {
            for column: Int in 0 ..< self.size.columns {
                for location: (row:Int, column: Int) in self.gameImages[row][column].getLocationsOfActiveStateEqualTo(setState) {
                    self.gameImages[row][column].setActiveState((location), activeState: setState)
                }
            }
        }
        return
    }
    
    //----------------------------------------------------------------------------
    // Get / Set 'active' state (is there an image) and image types
    //----------------------------------------------------------------------------
    //
    // we use this to pass back to the ViewController an array of images selected by the user when selecting a control panel 'number'
    //
    func getLocationsOfImages(imageState: imageStates) -> [Coordinate] {
        var coords: [Coordinate] = []
        for row: Int in 0 ..< self.size.rows {
            for column: Int in 0 ..< self.size.columns {
                let images: [(row: Int, column: Int)] = self.gameImages[row][column].getLocationsOfImageStateEqualTo(imageState)
                if images.isEmpty == false {
                    for coord in images {
                        coords.append(Coordinate(row: row, column: column, cell: (row: coord.row, column: coord.column)))
                    }
                }
            }
        }
        return(coords)
    }
    
}
