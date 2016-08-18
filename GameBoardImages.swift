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
    var boardRows: Int = 0
    var boardColumns: Int = 0
    
    init (size: Int = 3) {
        var setSize: Int = size
        if setSize != 3 {
            setSize = 3
        }
        self.allocateImageArray(setSize, columns: setSize)
        return
    }

    private func allocateImageArray(rows: Int, columns: Int) {
        self.boardRows = rows
        self.boardColumns = columns
        for row: Int in 0 ..< rows {
            var rowOfCells: [CellImages] = [CellImages(rows: rows, columns: columns)]
            for column: Int in 0 ..< columns {
                self.boardCoordinates.append((row, column))
                if column > 0 {
                    rowOfCells.append(CellImages(rows: rows, columns: columns))
                }
            }
            self.gameImages.append(rowOfCells)
        }
        return
    }

    //
    // on a board reset we need to 'clear' states of all images
    //
    func setImageStates(toImageState: Int) {
        for boardRow: Int in 0 ..< self.boardRows {
            for boardColumn: Int in 0 ..< self.boardColumns {
                for location: (cellRow:Int, cellColumn: Int) in self.gameImages[boardRow][boardColumn].getLocationsOfCellsStateNotEqualTo(toImageState) {
                    self.gameImages[boardRow][boardColumn].setImageState(location.cellRow, column: location.cellColumn, imageState: toImageState)
                }
            }
        }
        return
    }
    
    //
    // get locations 'state', used for save routine
    //
    func getImageState(coord: (row: Int, column: Int, cellRow: Int, cellColumn: Int)) -> Int {
        return self.gameImages[coord.row][coord.column].getImageState(coord.cellRow, column: coord.cellColumn)
    }
    
    //
    // we use this to pass back to the ViewController an array of images selected by the user when selecting a control panel 'number'
    //
    func getLocationsOfImages(imageState: Int) -> [(row: Int, column: Int, cellRow: Int, cellColumn: Int)] {
        var returnCoords: [(row: Int, column: Int, cellRow: Int, cellColumn: Int)] = []
        for boardRow: Int in 0 ..< self.boardRows {
            for boardColumn: Int in 0 ..< self.boardColumns {
                let images: [(cellRow: Int, cellColumn: Int)] = self.gameImages[boardRow][boardColumn].getLocationsOfCellsStateEqualTo(imageState)
                if images.isEmpty == false {
                    for coord in images {
                        returnCoords.append((boardRow, boardColumn, coord.cellRow, coord.cellColumn))
                    }
                }
            }
        }
        return(returnCoords)
    }
    
}
