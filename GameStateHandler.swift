//
//  SaveGameHandler.swift
//  SudokuTest
//
//  Created by Graham Watson on 27/07/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//
//----------------------------------------------------------------------------
// this class defines the 'protocol' used to allow the settings dialog to
// delegate the responsibility of keeping the defaults updated and including
// ensuring they are updated
//----------------------------------------------------------------------------

import Foundation

protocol GameStateDelegate: class {
    // game stats
    var currentGame: GameState { get set }
    func getTotalGameTimePlayedAsString() -> String
    func getFastestGameTimeAsString() -> String
}

class GameStateHandler: NSObject, GameStateDelegate {
    private var gameSave: [String: AnyObject]!
    internal var currentGame: GameState = GameState()
    
    override init() {
        super.init()
        self.currentGame.startedGames          = 0
        self.currentGame.completedGames        = 0
        self.currentGame.totalTimePlayed       = 0
        self.currentGame.totalMovesMade        = 0
        self.currentGame.totalMovesDeleted     = 0
        self.currentGame.highScore             = 0
        self.currentGame.lowScore              = 0
        self.currentGame.fastestGame           = 0
        self.currentGame.slowestGame           = 0
        self.currentGame.gameInPlay            = false
        self.currentGame.penaltyValue          = 0
        self.currentGame.penaltyIncrementValue = 0
        self.currentGame.currentGameTime       = 0
        self.currentGame.gameMovesMade         = 0
        self.currentGame.gameMovesDeleted      = 0
        self.currentGame.gameCells             = []
        self.currentGame.originCells           = []
        self.currentGame.solutionCells         = []
        self.gameSave                          = [:]
        self.updateGameSaveObjects()
        return
    }

    //-------------------------------------------------------------------------------
    // format the seconds played into hrs/mins/secs string
    //-------------------------------------------------------------------------------
    private func formatTimeInSecondsAsTimeString(time: Int) -> String {
        let hours: Int = time / 3600
        let mins:  Int = (time - (hours * 3600)) / 60
        let secs:  Int = time - (hours * 3600) - (mins * 60)
        return String(format: "%02d", hours) + ":" + String(format: "%02d", mins) + ":" + String(format: "%02d", secs)
    }
    
    //-------------------------------------------------------------------------------
    // load/save to/from internal 'currentgame' state and save dictionary 'gameSave'
    //-------------------------------------------------------------------------------
    private func updateGameSaveValue(keyValue: String, value: AnyObject) {
        self.gameSave[keyValue] = value
        return
    }
    
    private func translateCellFromDictionary(dictCell: [String: Int]) -> BoardCell {
        var cell: BoardCell = BoardCell()
        for (key, value) in dictCell {
            switch key {
            case cellDictionary.row.rawValue:
                cell.row = value
                break
            case cellDictionary.col.rawValue:
                cell.col = value
                break
            case cellDictionary.crow.rawValue:
                cell.crow = value
                break
            case cellDictionary.ccol.rawValue:
                cell.ccol = value
                break
            case cellDictionary.value.rawValue:
                cell.value = value
                break
            case cellDictionary.image.rawValue:
                cell.image = self.translateIntToImagesState(value)
                break
            case cellDictionary.active.rawValue:
                cell.active = self.translateIntToActiveState(value)
                break
            default:
                break
            }
        }
        return cell
    }
    
    private func translateIntToActiveState(state: Int) -> activeStates {
        switch state {
        case activeStates.Blank.rawValue:
            return activeStates.Blank
        case activeStates.Active.rawValue:
            return activeStates.Active
        case activeStates.Inactive.rawValue:
            return activeStates.Inactive
        default:
            return activeStates.Blank
        }
    }

    private func translateActiveStateToInt(state: activeStates) -> Int {
        switch state {
        case activeStates.Blank:
            return activeStates.Blank.rawValue
        case activeStates.Active:
            return activeStates.Active.rawValue
        case activeStates.Inactive:
            return activeStates.Inactive.rawValue
        }
    }
    
    private func translateIntToImagesState(state: Int) -> imageStates {
        switch state {
        case imageStates.Blank.rawValue:
            return imageStates.Blank
        case imageStates.Origin.rawValue:
            return imageStates.Origin
        case imageStates.Selected.rawValue:
            return imageStates.Selected
        case imageStates.Delete.rawValue:
            return imageStates.Delete
        case imageStates.Inactive.rawValue:
            return imageStates.Inactive
        case imageStates.Highlight.rawValue:
            return imageStates.Highlight
        default:
            return imageStates.Blank
        }
    }
    
    private func translateImageStateToInt(state: imageStates) -> Int {
        switch state {
        case imageStates.Blank:
            return imageStates.Blank.rawValue
        case imageStates.Origin:
            return imageStates.Origin.rawValue
        case imageStates.Selected:
            return imageStates.Selected.rawValue
        case imageStates.Delete:
            return imageStates.Delete.rawValue
        case imageStates.Inactive:
            return imageStates.Inactive.rawValue
        case imageStates.Highlight:
            return imageStates.Highlight.rawValue
        }
    }
    
    func updateGameSaveObjects() {
        self.updateGameSaveValue(saveGameDictionary.GamesStarted.rawValue,          value: self.currentGame.startedGames)
        self.updateGameSaveValue(saveGameDictionary.GamesCompleted.rawValue,        value: self.currentGame.completedGames)
        self.updateGameSaveValue(saveGameDictionary.TotalTimePlayed.rawValue,       value: self.currentGame.totalTimePlayed)
        self.updateGameSaveValue(saveGameDictionary.TotalMovesMade.rawValue,        value: self.currentGame.totalMovesMade)
        self.updateGameSaveValue(saveGameDictionary.TotalMovesDeleted.rawValue,     value: self.currentGame.totalMovesDeleted)
        self.updateGameSaveValue(saveGameDictionary.HighScore.rawValue,             value: self.currentGame.highScore)
        self.updateGameSaveValue(saveGameDictionary.LowScore.rawValue,              value: self.currentGame.lowScore)
        self.updateGameSaveValue(saveGameDictionary.FastestGameTime.rawValue,       value: self.currentGame.fastestGame)
        self.updateGameSaveValue(saveGameDictionary.SlowestGameTime.rawValue,       value: self.currentGame.slowestGame)
        self.updateGameSaveValue(saveGameDictionary.GameInPlay.rawValue,            value: self.currentGame.gameInPlay)
        self.updateGameSaveValue(saveGameDictionary.PenaltyValue.rawValue,          value: self.currentGame.penaltyValue)
        self.updateGameSaveValue(saveGameDictionary.PenaltyIncrementValue.rawValue, value: self.currentGame.penaltyIncrementValue)
        self.updateGameSaveValue(saveGameDictionary.CurrentGameTime.rawValue,       value: self.currentGame.currentGameTime)
        self.updateGameSaveValue(saveGameDictionary.GameMovesMade.rawValue,         value: self.currentGame.gameMovesMade)
        self.updateGameSaveValue(saveGameDictionary.GameMovesDeleted.rawValue,      value: self.currentGame.gameMovesDeleted)
        var cellArray: [AnyObject] = []
        for cell: BoardCell in self.currentGame.gameCells {
            cellArray.append([
                cellDictionary.row.rawValue:    cell.row,
                cellDictionary.col.rawValue:    cell.col,
                cellDictionary.crow.rawValue:   cell.crow,
                cellDictionary.ccol.rawValue:   cell.ccol,
                cellDictionary.value.rawValue:  cell.value,
                cellDictionary.image.rawValue:  self.translateImageStateToInt(cell.image),
                cellDictionary.active.rawValue: self.translateActiveStateToInt(cell.active)
            ])
        }
        self.updateGameSaveValue(saveGameDictionary.GameBoard.rawValue,         value: cellArray)
        cellArray.removeAll()
        for cell: BoardCell in self.currentGame.originCells {
            cellArray.append([
                cellDictionary.row.rawValue:    cell.row,
                cellDictionary.col.rawValue:    cell.col,
                cellDictionary.crow.rawValue:   cell.crow,
                cellDictionary.ccol.rawValue:   cell.ccol,
                cellDictionary.value.rawValue:  cell.value,
                cellDictionary.image.rawValue:  self.translateImageStateToInt(cell.image),
                cellDictionary.active.rawValue: self.translateActiveStateToInt(cell.active)
            ])
        }
        self.updateGameSaveValue(saveGameDictionary.OriginBoard.rawValue,       value: cellArray)
        cellArray.removeAll()
        for cell: BoardCell in self.currentGame.solutionCells {
            cellArray.append([
                cellDictionary.row.rawValue:    cell.row,
                cellDictionary.col.rawValue:    cell.col,
                cellDictionary.crow.rawValue:   cell.crow,
                cellDictionary.ccol.rawValue:   cell.ccol,
                cellDictionary.value.rawValue:  cell.value,
                cellDictionary.image.rawValue:  self.translateImageStateToInt(cell.image),
                cellDictionary.active.rawValue: self.translateActiveStateToInt(cell.active)
            ])
        }
        self.updateGameSaveValue(saveGameDictionary.SolutionBoard.rawValue,     value: cellArray)
        return
    }

    private func getGameStateValue(keyValue: String) -> AnyObject {
        return self.gameSave[keyValue]!
    }
    
    func loadGameSaveObjects() {
        self.currentGame.startedGames          = self.getGameStateValue(saveGameDictionary.GamesStarted.rawValue) as! Int
        self.currentGame.completedGames        = self.getGameStateValue(saveGameDictionary.GamesCompleted.rawValue) as! Int
        self.currentGame.totalTimePlayed       = self.getGameStateValue(saveGameDictionary.TotalTimePlayed.rawValue) as! Int
        self.currentGame.totalMovesMade        = self.getGameStateValue(saveGameDictionary.TotalMovesMade.rawValue) as! Int
        self.currentGame.totalMovesDeleted     = self.getGameStateValue(saveGameDictionary.TotalMovesDeleted.rawValue) as! Int
        self.currentGame.highScore             = self.getGameStateValue(saveGameDictionary.HighScore.rawValue) as! Int
        self.currentGame.lowScore              = self.getGameStateValue(saveGameDictionary.LowScore.rawValue) as! Int
        self.currentGame.fastestGame           = self.getGameStateValue(saveGameDictionary.FastestGameTime.rawValue) as! Int
        self.currentGame.slowestGame           = self.getGameStateValue(saveGameDictionary.SlowestGameTime.rawValue) as! Int
        self.currentGame.gameInPlay            = self.getGameStateValue(saveGameDictionary.GameInPlay.rawValue) as! Bool
        self.currentGame.penaltyValue          = self.getGameStateValue(saveGameDictionary.PenaltyValue.rawValue) as! Int
        self.currentGame.penaltyIncrementValue = self.getGameStateValue(saveGameDictionary.PenaltyIncrementValue.rawValue) as! Int
        self.currentGame.currentGameTime       = self.getGameStateValue(saveGameDictionary.CurrentGameTime.rawValue)  as! Int
        self.currentGame.gameMovesMade         = self.getGameStateValue(saveGameDictionary.GameMovesMade.rawValue) as! Int
        self.currentGame.gameMovesDeleted      = self.getGameStateValue(saveGameDictionary.GameMovesDeleted.rawValue) as! Int
        for cell: [String: Int] in self.getGameStateValue(saveGameDictionary.GameBoard.rawValue) as! [[String: Int]] {
            self.currentGame.gameCells.append(self.translateCellFromDictionary(cell))
        }
        for cell: [String: Int] in self.getGameStateValue(saveGameDictionary.OriginBoard.rawValue) as! [[String: Int]] {
            self.currentGame.originCells.append(self.translateCellFromDictionary(cell))
        }
        for cell: [String: Int] in self.getGameStateValue(saveGameDictionary.SolutionBoard.rawValue) as! [[String: Int]] {
            self.currentGame.solutionCells.append(self.translateCellFromDictionary(cell))
        }
        return
    }

    //-------------------------------------------------------------------------------
    // update/access to internal 'currentgame' and the outside world
    //-------------------------------------------------------------------------------
    //
    // gets first
    //
    func getStartedGames() -> Int {
        return self.currentGame.startedGames
    }
    
    func getCompletedGames() -> Int {
        return self.currentGame.completedGames
    }

    func getTotalGameTimePlayed() -> Int {
        return self.currentGame.totalTimePlayed
    }

    func getTotalGameTimePlayedAsString() -> String {
        return(self.formatTimeInSecondsAsTimeString(self.currentGame.totalTimePlayed))
    }
    
    func getTotalPlayerMovesMade() -> Int {
        return self.currentGame.totalMovesMade
    }
    
    func getTotalPlayerMovesDeleted() -> Int {
        return self.currentGame.totalMovesDeleted
    }

    func getFastestGameTimeAsString() -> String {
        return(self.formatTimeInSecondsAsTimeString(self.currentGame.fastestGame))
    }
    
    func getGameInPlay() -> Bool {
        return self.currentGame.gameInPlay
    }
    
    func getGamePenaltyTime() -> Int {
        return self.currentGame.penaltyValue
    }
    
    func getCurrentGameTimePlayed() -> Int {
        return self.currentGame.currentGameTime
    }
    
    func getCurrentGameTimePlayedAsString() -> String {
        return(self.formatTimeInSecondsAsTimeString(self.currentGame.currentGameTime))
    }
    
    func getGamePlayerMovesMade() -> Int {
        return self.currentGame.gameMovesMade
    }
    
    func getGamePlayerMovesDeleted() -> Int {
        return self.currentGame.gameMovesDeleted
    }
    
    //
    // sets if needed
    //
    func setGameInPlay(value: Bool) {
        self.currentGame.gameInPlay = value
        return
    }
    
    func resetCurrentGameTimePlayed() {
        self.currentGame.currentGameTime = 0
        return
    }
    
    func setGamePenaltyTime(value: Int) -> Int {
        self.currentGame.penaltyValue = value
        return self.currentGame.penaltyValue
    }

    func resetGamePenaltyIncrementTime(value: Int) {
        self.currentGame.penaltyIncrementValue = value
        return
    }
    
    func resetGamePlayerMovesMade() {
        self.currentGame.gameMovesMade = 0
        return
    }
    
    func resetGamePlayerMovesDeleted() {
        self.currentGame.gameMovesDeleted = 0
        return
    }
    
    func setCurrentFastestPlayerTime() -> Bool {
        if (self.currentGame.fastestGame == 0) || (self.currentGame.currentGameTime < self.currentGame.fastestGame) {
            self.currentGame.fastestGame = self.currentGame.currentGameTime
            return true
        }
        return false
    }
    
    func setCurrentSlowestPlayerTime() -> Bool {
        if self.currentGame.currentGameTime > self.currentGame.slowestGame {
            self.currentGame.slowestGame = self.currentGame.currentGameTime
            return true
        }
        return false
    }
    
    func setGameCells(cellArray: [BoardCell]) {
        self.currentGame.gameCells.removeAll()
        self.currentGame.gameCells.appendContentsOf(cellArray)
        return
    }
    
    func setOriginCells(cellArray: [BoardCell]) {
        self.currentGame.originCells.removeAll()
        self.currentGame.originCells.appendContentsOf(cellArray)
        return
    }
    
    func setSolutionCells(cellArray: [BoardCell]) {
        self.currentGame.solutionCells.removeAll()
        self.currentGame.solutionCells.appendContentsOf(cellArray)
        return
    }
    
    //
    // increments
    //
    func incrementStartedGames() {
        self.currentGame.startedGames = self.currentGame.startedGames + 1
        return
    }
    
    func incrementCompletedGames() {
        self.currentGame.completedGames = self.currentGame.completedGames + 1
        return
    }
    
    func incrementTotalGameTimePlayed(increment: Int) -> Int {
        self.currentGame.totalTimePlayed = self.currentGame.totalTimePlayed + increment
        return self.currentGame.totalTimePlayed
    }
    
    func incrementTotalPlayerMovesMade(increment: Int) -> Int {
        self.currentGame.totalMovesMade = self.currentGame.totalMovesMade + increment
        return self.currentGame.totalMovesMade
    }
    
    func incrementTotalPlayerMovesDeleted(increment: Int) -> Int {
        self.currentGame.totalMovesDeleted = self.currentGame.totalMovesDeleted + increment
        return self.currentGame.totalMovesDeleted
    }
    
    func incrementGamePenaltyTime(increment: Int) -> Int {
        self.currentGame.penaltyValue = self.currentGame.penaltyValue + increment
        return self.currentGame.penaltyValue
    }

    func incrementGamePenaltyIncrementTime(increment: Int) -> Int {
        self.currentGame.penaltyIncrementValue = self.currentGame.penaltyIncrementValue + increment
        return self.currentGame.penaltyIncrementValue
    }
    
    func incrementCurrentGameTimePlayed(increment: Int) -> Int {
        self.currentGame.currentGameTime = self.currentGame.currentGameTime + increment
        return self.currentGame.currentGameTime
    }
    
    func incrementGamePlayerMovesMade() -> Int {
        self.currentGame.gameMovesMade = self.currentGame.gameMovesMade + 1
        return self.currentGame.gameMovesMade
    }
    
    func incrementGamePlayerMovesDeleted() -> Int {
        self.currentGame.gameMovesDeleted = self.currentGame.gameMovesDeleted + 1
        return self.currentGame.gameMovesDeleted
    }
    
    //-------------------------------------------------------------------------------
    // load/save the dictionary object
    //-------------------------------------------------------------------------------
    private func getFilename() -> String {
        return getDocumentDirectory().stringByAppendingPathComponent("chalkboardsudoku.json")
    }
    
    private func getDocumentDirectory() -> NSString {
        return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    }
    
    func loadGame() {
        let filename: String = self.getFilename()
        do {
            let fileContents: String = try NSString(contentsOfFile: filename, usedEncoding: nil) as String
            let fileData: NSData = fileContents.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
            self.gameSave = try NSJSONSerialization.JSONObjectWithData(fileData, options: .AllowFragments) as! Dictionary<String, AnyObject>
            self.loadGameSaveObjects()
        } catch {
            print("Failed to read to file: \(filename)")
        }
        return
    }
    
    func saveGame() {
        self.updateGameSaveObjects()
        if NSJSONSerialization.isValidJSONObject(self.gameSave) { // True
            do {
                let rawData: NSData = try NSJSONSerialization.dataWithJSONObject(self.gameSave, options: .PrettyPrinted)
                //Convert NSString to String
                let resultString: String = NSString(data: rawData, encoding: NSUTF8StringEncoding)! as String
                let filename: String = self.getFilename()
                do {
                    try resultString.writeToFile(filename, atomically: true, encoding: NSUTF8StringEncoding)
                } catch {
                    // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
                    print("Failed to write to file: \(filename)")
                }
            } catch {
                // Handle Error
            }
        }
        
        return
    }
    
}


