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
}

class GameStateHandler: NSObject, GameStateDelegate {
    private var gameSave: [String: AnyObject]!
    internal var currentGame: GameState = GameState()
    
    init(applicationVersion: Int) {
        super.init()
        self.currentGame.applicationVersion    = applicationVersion
        self.currentGame.gameInPlay            = false
        self.currentGame.penaltyValue          = 0
        self.currentGame.penaltyIncrementValue = 0
        self.currentGame.currentGameTime       = 0
        self.currentGame.gameMovesMade         = 0
        self.currentGame.gameMovesDeleted      = 0
        self.currentGame.userHistory           = []
        self.currentGame.gameCells             = []
        self.currentGame.originCells           = []
        self.currentGame.solutionCells         = []
        self.gameSave                          = [:]
        self.updateGameSaveObjects()
        return
    }

    //-------------------------------------------------------------------------------
    // for cell storage, generate the 'text' names for the JSON file
    //-------------------------------------------------------------------------------
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

    //-------------------------------------------------------------------------------
    // now for user history scores / moves etc
    //-------------------------------------------------------------------------------
    private func translateUserScoreFromDictionary(dictDiff: [String: Int]) -> GameHistory {
        var history: GameHistory!
        //
        // when we find the difficulty we can init the obj and then start to build it!
        //
        for (key, value) in dictDiff {
            if key == userGameHistory.difficulty.rawValue {
                history = GameHistory(difficulty: self.translateDifficulty(value))
            }
        }
        //
        // should never happen, but if is does!
        //
        if history == nil {
            history = GameHistory()
        }
        //
        // now we can populate the object
        //
        for (key, value) in dictDiff {
            switch key {
            case userGameHistory.difficulty.rawValue:
                // already used this to create the obj so can be ignored
                break
            case userGameHistory.gamesStarted.rawValue:
                history.setStartedGames(value)
                break
            case userGameHistory.gamesCompleted.rawValue:
                history.setCompletedGames(value)
                break
            case userGameHistory.totalTimePlayed.rawValue:
                history.setTotalGameTimePlayed(value)
                break
            case userGameHistory.totalMovesMade.rawValue:
                history.setTotalPlayerMovesMade(value)
                break
            case userGameHistory.totalMovesDeleted.rawValue:
                history.setTotalPlayerMovesDeleted(value)
                break
            case userGameHistory.highestScore.rawValue:
                history.setHighestScore(value)
                break
            case userGameHistory.lowestScore.rawValue:
                history.setLowestScore(value)
                break
            case userGameHistory.fastestTime.rawValue:
                history.setFastestTime(value)
                break
            case userGameHistory.slowestTime.rawValue:
                history.setSlowestTime(value)
                break
            default:
                break
            }
        }
        return history
    }
        
    //-------------------------------------------------------------------------------
    // move between the enum values for image and active states to the Int value
    //-------------------------------------------------------------------------------
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
    
    //-------------------------------------------------------------------------------
    // same for the difficulty
    //-------------------------------------------------------------------------------
    func translateDifficulty(difficulty: Int) -> sudokuDifficulty {
        switch difficulty {
        case 1:
            return(sudokuDifficulty.Easy)
        case 2:
            return (sudokuDifficulty.Medium)
        case 3:
            return (sudokuDifficulty.Hard)
        default:
            return (sudokuDifficulty.Medium)
        }
    }

    //-------------------------------------------------------------------------------
    // move between the enum values for image and active states to the Int value
    //-------------------------------------------------------------------------------
    func updateGameSaveObjects() {
        self.updateGameSaveValue(saveGameDictionary.ApplicationVersion.rawValue,    value: self.currentGame.applicationVersion)
        self.updateGameSaveValue(saveGameDictionary.GameInPlay.rawValue,            value: self.currentGame.gameInPlay)
        self.updateGameSaveValue(saveGameDictionary.PenaltyValue.rawValue,          value: self.currentGame.penaltyValue)
        self.updateGameSaveValue(saveGameDictionary.PenaltyIncrementValue.rawValue, value: self.currentGame.penaltyIncrementValue)
        self.updateGameSaveValue(saveGameDictionary.CurrentGameTime.rawValue,       value: self.currentGame.currentGameTime)
        self.updateGameSaveValue(saveGameDictionary.GameMovesMade.rawValue,         value: self.currentGame.gameMovesMade)
        self.updateGameSaveValue(saveGameDictionary.GameMovesDeleted.rawValue,      value: self.currentGame.gameMovesDeleted)
        //
        // Game
        //
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
        self.updateGameSaveValue(saveGameDictionary.GameBoard.rawValue, value: cellArray)
        //
        // Origin
        //
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
        self.updateGameSaveValue(saveGameDictionary.OriginBoard.rawValue, value: cellArray)
        //
        // Solution
        //
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
        self.updateGameSaveValue(saveGameDictionary.SolutionBoard.rawValue, value: cellArray)
        //
        // finally handle the user score/moves (stored against difficulty)
        //
        cellArray.removeAll()
        for history: GameHistory in self.currentGame.userHistory {
            cellArray.append([
                userGameHistory.difficulty.rawValue:        history.getDifficulty().rawValue,
                userGameHistory.gamesStarted.rawValue:      history.getStartedGames(),
                userGameHistory.gamesCompleted.rawValue:    history.getCompletedGames(),
                userGameHistory.totalTimePlayed.rawValue:   history.getTotalTimePlayed(),
                userGameHistory.totalMovesMade.rawValue:    history.getTotalMovesMade(),
                userGameHistory.totalMovesDeleted.rawValue: history.getTotalMovedDeleted(),
                userGameHistory.highestScore.rawValue:      history.getHighestScore(),
                userGameHistory.lowestScore.rawValue:       history.getLowestScore(),
                userGameHistory.fastestTime.rawValue:       history.getFastestGame(),
                userGameHistory.slowestTime.rawValue:       history.getSlowestGame()
            ])
        }
        self.updateGameSaveValue(saveGameDictionary.UserHistory.rawValue, value: cellArray)
        return
    }
    
    //-------------------------------------------------------------------------------
    // load/save to/from internal 'currentgame' state and save dictionary 'gameSave'
    //-------------------------------------------------------------------------------
    private func updateGameSaveValue(keyValue: String, value: AnyObject) {
        self.gameSave[keyValue] = value
        return
    }
    
    func loadGameSaveObjects() {
        self.currentGame.applicationVersion    = self.getGameStateValue(saveGameDictionary.ApplicationVersion,    obj: self.currentGame.applicationVersion) as! Int
        self.currentGame.gameInPlay            = self.getGameStateValue(saveGameDictionary.GameInPlay,            obj: self.currentGame.gameInPlay) as! Bool
        self.currentGame.penaltyValue          = self.getGameStateValue(saveGameDictionary.PenaltyValue,          obj: self.currentGame.penaltyValue) as! Int
        self.currentGame.penaltyIncrementValue = self.getGameStateValue(saveGameDictionary.PenaltyIncrementValue, obj: self.currentGame.penaltyIncrementValue) as! Int
        self.currentGame.currentGameTime       = self.getGameStateValue(saveGameDictionary.CurrentGameTime,       obj: self.currentGame.currentGameTime)  as! Int
        self.currentGame.gameMovesMade         = self.getGameStateValue(saveGameDictionary.GameMovesMade,         obj: self.currentGame.gameMovesMade) as! Int
        self.currentGame.gameMovesDeleted      = self.getGameStateValue(saveGameDictionary.GameMovesDeleted,      obj: self.currentGame.gameMovesDeleted) as! Int
        self.currentGame.gameCells.removeAll()
        for cell: [String: Int] in self.getGameStateValue(saveGameDictionary.GameBoard) as! [[String: Int]] {
            self.currentGame.gameCells.append(self.translateCellFromDictionary(cell))
        }
        self.currentGame.originCells.removeAll()
        for cell: [String: Int] in self.getGameStateValue(saveGameDictionary.OriginBoard) as! [[String: Int]] {
            self.currentGame.originCells.append(self.translateCellFromDictionary(cell))
        }
        self.currentGame.solutionCells.removeAll()
        for cell: [String: Int] in self.getGameStateValue(saveGameDictionary.SolutionBoard) as! [[String: Int]] {
            self.currentGame.solutionCells.append(self.translateCellFromDictionary(cell))
        }
        self.currentGame.userHistory.removeAll()
        for history: [String: Int] in self.getGameStateValue(saveGameDictionary.UserHistory) as! [[String: Int]] {
            self.currentGame.userHistory.append(self.translateUserScoreFromDictionary(history))
        }
        return
    }
    
//    private func doesDictionaryEntryExist(keyValue: saveGameDictionary) -> Bool {
//        if self.gameSave.indexForKey(<#T##key: Hashable##Hashable#>)
//        return false
//    }
    
    //-------------------------------------------------------------------------------
    // pick out the dictionary 'keys/value' when we load the game
    // if we don't yet have a value return a default (when we might add a new entry)
    //-------------------------------------------------------------------------------
    private func getGameStateValue(keyValue: saveGameDictionary) -> AnyObject {
        return (self.gameSave.indexForKey(keyValue.rawValue) == nil) ? [] : self.gameSave[keyValue.rawValue]!
    }
    
    private func getGameStateValue(keyValue: saveGameDictionary, obj: AnyObject) -> AnyObject {
        return (self.gameSave.indexForKey(keyValue.rawValue) == nil) ? self.defaultGameStateValue(obj) : self.gameSave[keyValue.rawValue]!
    }
    
    private func getValue(keyValue: saveGameDictionary) -> AnyObject {
        return self.gameSave[keyValue.rawValue]!
    }
    
    private func defaultGameStateValue(obj: AnyObject) -> AnyObject {
        switch obj {
        case is Bool:
            return false
        case is Int:
            return 0
        case is String:
            return ""
        default:
            return ""
        }
    }

    //-------------------------------------------------------------------------------
    // gets/sets if needed for the 'game'
    //-------------------------------------------------------------------------------
    // help formatting a 'time' string for the use of this class and elsewhere
    //
    private func formatTimeInSecondsAsTimeString(time: Int) -> String {
        let hours: Int = time / 3600
        let mins:  Int = (time - (hours * 3600)) / 60
        let secs:  Int = time - (hours * 3600) - (mins * 60)
        return String(format: "%02d", hours) + ":" + String(format: "%02d", mins) + ":" + String(format: "%02d", secs)
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
    
    func setGameInPlay(value: Bool) {
        self.currentGame.gameInPlay = value
        return
    }
    
    func setGamePenaltyTime(value: Int) -> Int {
        self.currentGame.penaltyValue = value
        return self.currentGame.penaltyValue
    }

    //-------------------------------------------------------------------------------
    // resets used when the user starts a new game
    //-------------------------------------------------------------------------------
    func resetCurrentGameTimePlayed() {
        self.currentGame.currentGameTime = 0
        return
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
    
    //-------------------------------------------------------------------------------
    // sets for the GameHistory difficulty array based values
    //-------------------------------------------------------------------------------
    // can we retrieve the history for selected difficulty if not return blank one
    // remembering to add 'new' diff level history to user Save
    //-------------------------------------------------------------------------------
    private func getUserHistoryIndex(diff: sudokuDifficulty) -> Int! {
        for index: Int in 0 ..< self.currentGame.userHistory.count {
            if diff == self.currentGame.userHistory[index].getDifficulty() {
                return index
            }
        }
        let new: GameHistory = GameHistory(difficulty: diff)
        self.currentGame.userHistory.append(new)
        return self.currentGame.userHistory.count - 1
    }

    func setFastestPlayerTime(diff: sudokuDifficulty) -> Bool {
        let index: Int = self.getUserHistoryIndex(diff)
        return self.currentGame.userHistory[index].setFastestTime(self.currentGame.currentGameTime)
    }
    
    func setSlowestPlayerTime(diff: sudokuDifficulty) -> Bool {
        let index: Int = self.getUserHistoryIndex(diff)
        return self.currentGame.userHistory[index].setSlowestTime(self.currentGame.currentGameTime)
    }

    //-------------------------------------------------------------------------------
    // Increments
    //-------------------------------------------------------------------------------
    func incrementStartedGames(diff: sudokuDifficulty) {
        let index: Int = self.getUserHistoryIndex(diff)
        self.currentGame.userHistory[index].incrementStartedGames()
        return
    }

    func incrementCompletedGames(diff: sudokuDifficulty) {
        let index: Int = self.getUserHistoryIndex(diff)
        self.currentGame.userHistory[index].incrementCompletedGames()
        return
    }

    func incrementTotalGameTimePlayed(diff: sudokuDifficulty, increment: Int) {
        let index: Int = self.getUserHistoryIndex(diff)
        self.currentGame.userHistory[index].incrementTotalGameTimePlayed(increment)
        return
    }
    
    func incrementTotalPlayerMovesMade(diff: sudokuDifficulty, increment: Int) {
        let index: Int = self.getUserHistoryIndex(diff)
        self.currentGame.userHistory[index].incrementTotalPlayerMovesMade(increment)
        return
    }
    
    func incrementTotalPlayerMovesDeleted(diff: sudokuDifficulty, increment: Int) {
        let index: Int = self.getUserHistoryIndex(diff)
        self.currentGame.userHistory[index].incrementTotalPlayerMovesDeleted(increment)
        return
    }
    
    //-------------------------------------------------------------------------------
    // increments for the 'game' in progress
    //-------------------------------------------------------------------------------
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
    // sets for the difficulty array based values
    //-------------------------------------------------------------------------------
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


