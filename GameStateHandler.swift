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
                cell.image = self.translateIntToImagesState(state: value)
                break
            case cellDictionary.active.rawValue:
                cell.active = self.translateIntToActiveState(state: value)
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
                history = GameHistory(difficulty: self.translateDifficulty(difficulty: value))
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
                history.setStartedGames(games: value)
                break
            case userGameHistory.gamesCompleted.rawValue:
                history.setCompletedGames(games: value)
                break
            case userGameHistory.totalTimePlayed.rawValue:
                history.setTotalGameTimePlayed(time: value)
                break
            case userGameHistory.totalMovesMade.rawValue:
                history.setTotalPlayerMovesMade(moves: value)
                break
            case userGameHistory.totalMovesDeleted.rawValue:
                history.setTotalPlayerMovesDeleted(moves: value)
                break
            case userGameHistory.highestScore.rawValue:
                history.setHighestScore(score: value)
                break
            case userGameHistory.lowestScore.rawValue:
                history.setLowestScore(score: value)
                break
            case userGameHistory.fastestTime.rawValue:
                history.setFastestTime(newTime: value)
                break
            case userGameHistory.slowestTime.rawValue:
                history.setSlowestTime(newTime: value)
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
        self.updateGameSaveValue(keyValue: saveGameDictionary.ApplicationVersion.rawValue,    value: self.currentGame.applicationVersion)
        self.updateGameSaveValue(keyValue: saveGameDictionary.GameInPlay.rawValue,            value: self.currentGame.gameInPlay)
        self.updateGameSaveValue(keyValue: saveGameDictionary.PenaltyValue.rawValue,          value: self.currentGame.penaltyValue)
        self.updateGameSaveValue(keyValue: saveGameDictionary.PenaltyIncrementValue.rawValue, value: self.currentGame.penaltyIncrementValue)
        self.updateGameSaveValue(keyValue: saveGameDictionary.CurrentGameTime.rawValue,       value: self.currentGame.currentGameTime)
        self.updateGameSaveValue(keyValue: saveGameDictionary.GameMovesMade.rawValue,         value: self.currentGame.gameMovesMade)
        self.updateGameSaveValue(keyValue: saveGameDictionary.GameMovesDeleted.rawValue,      value: self.currentGame.gameMovesDeleted)
        //
        // Game
        //
        var cellArray: [[String: Int]] = []
        for cell: BoardCell in self.currentGame.gameCells {
            cellArray.append(self.convertCellEntry(cell: cell))
        }
        self.updateGameSaveValue(keyValue: saveGameDictionary.GameBoard.rawValue, value: cellArray)
        //
        // Origin
        //
        cellArray.removeAll()
        for cell: BoardCell in self.currentGame.originCells {
            cellArray.append(self.convertCellEntry(cell: cell))
        }
        self.updateGameSaveValue(keyValue: saveGameDictionary.OriginBoard.rawValue, value: cellArray)
        //
        // Solution
        //
        cellArray.removeAll()
        for cell: BoardCell in self.currentGame.solutionCells {
            cellArray.append(self.convertCellEntry(cell: cell))
        }
        self.updateGameSaveValue(keyValue: saveGameDictionary.SolutionBoard.rawValue, value: cellArray)
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
        self.updateGameSaveValue(keyValue: saveGameDictionary.UserHistory.rawValue, value: cellArray)
        return
    }
    
    func convertCellEntry(cell: BoardCell) -> [String: Int] {
        var array: [String: Int] = [:]
        array[cellDictionary.row.rawValue]    = cell.row
        array[cellDictionary.col.rawValue]    = cell.col
        array[cellDictionary.crow.rawValue]   = cell.crow
        array[cellDictionary.ccol.rawValue]  = cell.ccol
        array[cellDictionary.value.rawValue]  = cell.value
        array[cellDictionary.image.rawValue]  = self.translateImageStateToInt(state: cell.image)
        array[cellDictionary.active.rawValue] = self.translateActiveStateToInt(state: cell.active)
        return array
    }
    
    //-------------------------------------------------------------------------------
    // load/save to/from internal 'currentgame' state and save dictionary 'gameSave'
    //-------------------------------------------------------------------------------
    private func updateGameSaveValue(keyValue: String, value: Int) {
        self.gameSave[keyValue] = value as? AnyObject
        return
    }
    
    private func updateGameSaveValue(keyValue: String, value: Bool) {
        self.gameSave[keyValue] = value as? AnyObject
        return
    }
    
    private func updateGameSaveValue(keyValue: String, value: AnyObject) {
        self.gameSave[keyValue] = value as? AnyObject
        return
    }
    
    private func updateGameSaveValue(keyValue: String, value: [[String: Int]]) {
        self.gameSave[keyValue] = value as? AnyObject
        return
    }
    
    func loadGameSaveObjects() {
        self.currentGame.applicationVersion    = self.getGameStateValue(keyValue: saveGameDictionary.ApplicationVersion,    obj: self.currentGame.applicationVersion as AnyObject) as! Int
        self.currentGame.gameInPlay            = self.getGameStateValue(keyValue: saveGameDictionary.GameInPlay,            obj: self.currentGame.gameInPlay as AnyObject) as! Bool
        self.currentGame.penaltyValue          = self.getGameStateValue(keyValue: saveGameDictionary.PenaltyValue,          obj: self.currentGame.penaltyValue as AnyObject) as! Int
        self.currentGame.penaltyIncrementValue = self.getGameStateValue(keyValue: saveGameDictionary.PenaltyIncrementValue, obj: self.currentGame.penaltyIncrementValue as AnyObject) as! Int
        self.currentGame.currentGameTime       = self.getGameStateValue(keyValue: saveGameDictionary.CurrentGameTime,       obj: self.currentGame.currentGameTime as AnyObject)  as! Int
        self.currentGame.gameMovesMade         = self.getGameStateValue(keyValue: saveGameDictionary.GameMovesMade,         obj: self.currentGame.gameMovesMade as AnyObject) as! Int
        self.currentGame.gameMovesDeleted      = self.getGameStateValue(keyValue: saveGameDictionary.GameMovesDeleted,      obj: self.currentGame.gameMovesDeleted as AnyObject) as! Int
        self.currentGame.gameCells.removeAll()
        for cell: [String: Int] in self.getGameStateValue(keyValue: saveGameDictionary.GameBoard) as! [[String: Int]] {
            self.currentGame.gameCells.append(self.translateCellFromDictionary(dictCell: cell))
        }
        self.currentGame.originCells.removeAll()
        for cell: [String: Int] in self.getGameStateValue(keyValue: saveGameDictionary.OriginBoard) as! [[String: Int]] {
            self.currentGame.originCells.append(self.translateCellFromDictionary(dictCell: cell))
        }
        self.currentGame.solutionCells.removeAll()
        for cell: [String: Int] in self.getGameStateValue(keyValue: saveGameDictionary.SolutionBoard) as! [[String: Int]] {
            self.currentGame.solutionCells.append(self.translateCellFromDictionary(dictCell: cell))
        }
        self.currentGame.userHistory.removeAll()
        for history: [String: Int] in self.getGameStateValue(keyValue: saveGameDictionary.UserHistory) as! [[String: Int]] {
            self.currentGame.userHistory.append(self.translateUserScoreFromDictionary(dictDiff: history))
        }
        return
    }
    
    //-------------------------------------------------------------------------------
    // pick out the dictionary 'keys/value' when we load the game
    // if we don't yet have a value return a default (when we might add a new entry)
    //-------------------------------------------------------------------------------
    private func getGameStateValue(keyValue: saveGameDictionary) -> AnyObject {
        return (self.gameSave.index(forKey: keyValue.rawValue) == nil) ? ([] as AnyObject) : self.gameSave[keyValue.rawValue]!
    }
    
    private func getGameStateValue(keyValue: saveGameDictionary, obj: AnyObject) -> AnyObject {
        return (self.gameSave.index(forKey: keyValue.rawValue) == nil) ? self.defaultGameStateValue(obj: obj) : self.gameSave[keyValue.rawValue]!
    }
    
    private func getValue(keyValue: saveGameDictionary) -> AnyObject {
        return self.gameSave[keyValue.rawValue]!
    }
    
    private func defaultGameStateValue(obj: AnyObject) -> AnyObject {
        switch obj {
        case is Bool:
            return (false as AnyObject)
        case is Int:
            return (0 as AnyObject)
        case is String:
            return ("" as AnyObject)
        default:
            return ("" as AnyObject)
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
        return(self.formatTimeInSecondsAsTimeString(time: self.currentGame.currentGameTime))
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
        let index: Int = self.getUserHistoryIndex(diff: diff)
        return self.currentGame.userHistory[index].setFastestTime(newTime: self.currentGame.currentGameTime)
    }
    
    func setSlowestPlayerTime(diff: sudokuDifficulty) -> Bool {
        let index: Int = self.getUserHistoryIndex(diff: diff)
        return self.currentGame.userHistory[index].setSlowestTime(newTime: self.currentGame.currentGameTime)
    }

    //-------------------------------------------------------------------------------
    // Increments
    //-------------------------------------------------------------------------------
    func incrementStartedGames(diff: sudokuDifficulty) {
        let index: Int = self.getUserHistoryIndex(diff: diff)
        self.currentGame.userHistory[index].incrementStartedGames()
        return
    }

    func incrementCompletedGames(diff: sudokuDifficulty) {
        let index: Int = self.getUserHistoryIndex(diff: diff)
        self.currentGame.userHistory[index].incrementCompletedGames()
        return
    }

    func incrementTotalGameTimePlayed(diff: sudokuDifficulty, increment: Int) {
        let index: Int = self.getUserHistoryIndex(diff: diff)
        self.currentGame.userHistory[index].incrementTotalGameTimePlayed(increment: increment)
        return
    }
    
    func incrementTotalPlayerMovesMade(diff: sudokuDifficulty, increment: Int) {
        let index: Int = self.getUserHistoryIndex(diff: diff)
        self.currentGame.userHistory[index].incrementTotalPlayerMovesMade(increment: increment)
        return
    }
    
    func incrementTotalPlayerMovesDeleted(diff: sudokuDifficulty, increment: Int) {
        let index: Int = self.getUserHistoryIndex(diff: diff)
        self.currentGame.userHistory[index].incrementTotalPlayerMovesDeleted(increment: increment)
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
        self.currentGame.gameCells.append(contentsOf: cellArray)
        return
    }
    
    func setOriginCells(cellArray: [BoardCell]) {
        self.currentGame.originCells.removeAll()
        self.currentGame.originCells.append(contentsOf: cellArray)
        return
    }
    
    func setSolutionCells(cellArray: [BoardCell]) {
        self.currentGame.solutionCells.removeAll()
        self.currentGame.solutionCells.append(contentsOf: cellArray)
        return
    }
    
    //-------------------------------------------------------------------------------
    // load/save the dictionary object
    //-------------------------------------------------------------------------------
    private func getFilename() -> String {
        let directory: String = getDocumentDirectory() + "/" + "chalkboardsudoku.json"
        return directory
    }
    
    private func getDocumentDirectory() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
    
    func loadGame() {
        let filename: String = self.getFilename()
        do {
            let fileContents: String = try NSString(contentsOfFile: filename, usedEncoding: nil) as String
            let fileData: Data = fileContents.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            self.gameSave = try JSONSerialization.jsonObject(with: fileData, options: .allowFragments) as! Dictionary<String, AnyObject>
            self.loadGameSaveObjects()
        } catch {
            print("Failed to read to file: \(filename)")
        }
        return
    }
    
    func saveGame() {
        self.updateGameSaveObjects()
        if JSONSerialization.isValidJSONObject(self.gameSave) { // True
            do {
                let rawData: Data = try JSONSerialization.data(withJSONObject: self.gameSave, options: .prettyPrinted)
                //Convert NSString to String
                let resultString: String = String(data: rawData as Data, encoding: String.Encoding.utf8)! as String
                let filename: String = self.getFilename()
                do {
                    try resultString.write(toFile: filename, atomically: true, encoding: String.Encoding.utf8)
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


