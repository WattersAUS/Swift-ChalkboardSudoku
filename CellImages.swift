//
//  CellImages.swift
//  SudokuTest
//
//  Created by Graham Watson on 10/05/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation
import UIKit

//
// to hold reference to image/type of image displayed ie. default, selected, highlighted
//
struct Content {
    var imageView:   UIImageView!
    var activeState: activeStates!
    var imageState:  imageStates!
}

class CellImages {
    var contents: [[Content]] = []
    private var size: (rows: Int, columns: Int) = (0,0)

    //
    // allows for symmetric arrays (board), or non symmetric (ctrl panel)
    //
    init (size: (rows: Int, columns: Int)) {
        self.size.rows = size.rows
        if (self.size.rows < 3) || (self.size.rows > 6) {
            self.size.rows = 6
        }
        self.size.columns = size.columns
        if (self.size.columns < 2) || (self.size.columns > 4) {
            self.size.columns = 2
        }
        self.allocateCellArray(size: self.size)
        return
    }

    private func allocateCellArray(size: (rows: Int, columns: Int)) {
        for _: Int in 0 ..< size.rows {
            var rowOfImages: [Content] = []
            for _: Int in 0 ..< size.columns {
                var image         = Content()
                image.imageView   = UIImageView()
                image.activeState = activeStates.Blank
                image.imageState  = imageStates.Blank
                //image.imageView.backgroundColor = UIColor.red
                rowOfImages.append(image)
            }
            self.contents.append(rowOfImages)
        }
        return
    }
    
    //----------------------------------------------------------------------------
    // Generic are we within the bounds of the board check
    //----------------------------------------------------------------------------
    private func boundsCheck(coord: (row: Int, column: Int)) -> Bool {
        guard (0..<self.size.rows) ~= coord.row &&
              (0..<self.size.columns) ~= coord.column
        else {
            return false
        }
        return true
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
    // Get / set actual image
    //----------------------------------------------------------------------------
    func setImage(coord: (row: Int, column: Int), imageToSet: UIImage, imageState: imageStates) {
        guard self.boundsCheck(coord: coord) else {
            return
        }
        self.contents[coord.row][coord.column].imageView.image = imageToSet
        self.contents[coord.row][coord.column].imageState      = imageState
        return
    }
    
    func setImageWithAnimationFlipFromLeft(coord: (row: Int, column: Int), imageToSet: UIImage, imageState: imageStates) {
        guard self.boundsCheck(coord: coord) else {
            return
        }
        UIView.transition(with: self.contents[coord.row][coord.column].imageView,
                          duration: 0.3,
                          options: .transitionFlipFromLeft,
                          animations: { self.contents[coord.row][coord.column].imageView.image = imageToSet },
                          completion: nil)
        self.contents[coord.row][coord.column].imageState      = imageState
        return
    }
    
    func setImageWithAnimationCrossDissolve(coord: (row: Int, column: Int), imageToSet: UIImage, imageState: imageStates) {
        guard self.boundsCheck(coord: coord) else {
            return
        }
        UIView.transition(with: self.contents[coord.row][coord.column].imageView,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: { self.contents[coord.row][coord.column].imageView.image = imageToSet },
                          completion: nil)
        self.contents[coord.row][coord.column].imageState      = imageState
        return
    }
    
    func clearImage(coord: (row: Int, column: Int)) {
        guard self.boundsCheck(coord: coord) else {
            return
        }
        self.contents[coord.row][coord.column].imageView.image = nil
        self.contents[coord.row][coord.column].imageState      = imageStates.Blank
        self.contents[coord.row][coord.column].activeState     = activeStates.Blank
        return
    }
    
    func clearImageWithAnimationCrossDissolve(coord: (row: Int, column: Int)) {
        guard self.boundsCheck(coord: coord) else {
            return
        }
        UIView.transition(with: self.contents[coord.row][coord.column].imageView,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: { self.contents[coord.row][coord.column].imageView.image = nil },
                          completion: nil)
        self.contents[coord.row][coord.column].imageState      = imageStates.Blank
        self.contents[coord.row][coord.column].activeState     = activeStates.Blank
        return
    }

    //----------------------------------------------------------------------------
    // Get / set image states
    //----------------------------------------------------------------------------
    func getImageState(coord: (row: Int, column: Int)) -> imageStates {
        guard self.boundsCheck(coord: coord) else {
            return imageStates.Blank
        }
        return self.contents[coord.row][coord.column].imageState
    }
    
    func setImageState(coord: (row: Int, column: Int), imageState: imageStates) {
        guard self.boundsCheck(coord: coord) else {
            return
        }
        self.contents[coord.row][coord.column].imageState = imageState
        return
    }
    
    func getActiveState(coord: (row: Int, column: Int)) -> activeStates {
        guard self.boundsCheck(coord: coord) else {
            return activeStates.Blank
        }
        return self.contents[coord.row][coord.column].activeState
    }
    
    func setActiveState(coord: (row: Int, column: Int), activeState: activeStates) {
        guard self.boundsCheck(coord: coord) else {
            return
        }
        self.contents[coord.row][coord.column].activeState = activeState
        return
    }
    
    func getLocationsOfImageStateEqualTo(imageState: imageStates) -> [(row: Int, column: Int)] {
        var coords: [(row: Int, column: Int)] = []
        for row: Int in 0 ..< self.size.rows {
            for column: Int in 0 ..< self.size.columns {
                if self.contents[row][column].imageState == imageState {
                    coords.append((row, column))
                }
            }
        }
        return (coords)
    }
    
    func getLocationsOfImageStateNotEqualTo(imageState: imageStates) -> [(row: Int, column: Int)] {
        var coords: [(row: Int, column: Int)] = []
        for row: Int in 0 ..< self.size.rows {
            for column: Int in 0 ..< self.size.columns {
                if self.contents[row][column].imageState != imageState {
                    coords.append((row, column))
                }
            }
        }
        return (coords)
    }
    
    func getLocationsOfActiveStateEqualTo(activeState: activeStates) -> [(row: Int, column: Int)] {
        var coords: [(row: Int, column: Int)] = []
        for row: Int in 0 ..< self.size.rows {
            for column: Int in 0 ..< self.size.columns {
                if self.contents[row][column].activeState == activeState {
                    coords.append((row, column))
                }
            }
        }
        return (coords)
    }
    
    func getLocationsOfCellStateNotEqualTo(activeState: activeStates) -> [(row: Int, column: Int)] {
        var coords: [(row: Int, column: Int)] = []
        for row: Int in 0 ..< self.size.rows {
            for column: Int in 0 ..< self.size.columns {
                if self.contents[row][column].activeState != activeState {
                    coords.append((row, column))
                }
            }
        }
        return (coords)
    }
    
}
