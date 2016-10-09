//
//  ViewController.swift
//  ChalkBoardSudoku
//
//  Created by Graham Watson on 18/08/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var applicationVersion: Int = 100
    var debug: Int = 1
    var boardDimensions: Int = 3
    
    //
    // enum for subviews (internal to this ViewController only)
    //
    enum subViewTags: Int {
        case sudokuBoard = 0
        case controlPanel = 1
        case settingsPanel = 2
    }
    
    //
    // the board background graphic accessed here
    //
    @IBOutlet weak var boardBackground: UIImageView!
    
    //
    // the board to solve
    //
    var viewSudokuBoard: UIView!
    var sudokuBoard: SudokuGameBoard!
    var displayBoard: GameBoardImages!
    
    //
    // user progress through puzzle
    //
    var userSolution: TrackSolution!
    
    //
    // the control panel
    //
    var viewControlPanel: UIView!
    var controlPanelImages: CellImages!
    
    //
    // settings panel
    //
    //var viewSettings: UIView!
    
    //
    // images used in default buttons
    //
    var startImage: UIImage = UIImage(named:"ImageStart.png")!
    var resetImage: UIImage = UIImage(named:"ImageReset.png")!
    var prefsImage: UIImage = UIImage(named:"ImagePreferences.png")!
    var hintsImage: UIImage = UIImage(named:"ImageHint.png")!
    
    //
    // user selects board position
    //
    var userSelectImage: UIImage = UIImage(named:"UserSelect.png")!
    
    //
    // image library referenced [state][image set][number]
    //
    // State:
    //
    // 0 = origin
    //      used as the default display image
    // 1 = select
    //      when the user selects via the control panel
    // 2 = delete
    //      users chooses the 'bin' to delete so we highlight the images using this set
    // 3 = inactive
    //      if the user has completed adding the 'number' to all nine cells
    // 4 = highlight
    //      used in conjunction with inactive. for a moment highlight the images
    //
    // Image Set:
    //
    // 0 = Numbers
    // 1 = Greek
    // 2 = Alpha
    //
    var imageLibrary: [[[UIImage]]] = [
        [[
            UIImage(named:"Image001_origin.png")!,
            UIImage(named:"Image002_origin.png")!,
            UIImage(named:"Image003_origin.png")!,
            UIImage(named:"Image004_origin.png")!,
            UIImage(named:"Image005_origin.png")!,
            UIImage(named:"Image006_origin.png")!,
            UIImage(named:"Image007_origin.png")!,
            UIImage(named:"Image008_origin.png")!,
            UIImage(named:"Image009_origin.png")!,
            UIImage(named:"ImageClear_origin.png")!
        ],[
            UIImage(named:"Alt001_origin.png")!,
            UIImage(named:"Alt002_origin.png")!,
            UIImage(named:"Alt003_origin.png")!,
            UIImage(named:"Alt004_origin.png")!,
            UIImage(named:"Alt005_origin.png")!,
            UIImage(named:"Alt006_origin.png")!,
            UIImage(named:"Alt007_origin.png")!,
            UIImage(named:"Alt008_origin.png")!,
            UIImage(named:"Alt009_origin.png")!,
            UIImage(named:"ImageClear_origin.png")!
        ],[
            UIImage(named:"Alpha001_origin.png")!,
            UIImage(named:"Alpha002_origin.png")!,
            UIImage(named:"Alpha003_origin.png")!,
            UIImage(named:"Alpha004_origin.png")!,
            UIImage(named:"Alpha005_origin.png")!,
            UIImage(named:"Alpha006_origin.png")!,
            UIImage(named:"Alpha007_origin.png")!,
            UIImage(named:"Alpha008_origin.png")!,
            UIImage(named:"Alpha009_origin.png")!,
            UIImage(named:"ImageClear_origin.png")!
        ]],
        [[
            UIImage(named:"Image001_select.png")!,
            UIImage(named:"Image002_select.png")!,
            UIImage(named:"Image003_select.png")!,
            UIImage(named:"Image004_select.png")!,
            UIImage(named:"Image005_select.png")!,
            UIImage(named:"Image006_select.png")!,
            UIImage(named:"Image007_select.png")!,
            UIImage(named:"Image008_select.png")!,
            UIImage(named:"Image009_select.png")!,
            UIImage(named:"ImageClear_origin.png")!
        ],[
            UIImage(named:"Alt001_select.png")!,
            UIImage(named:"Alt002_select.png")!,
            UIImage(named:"Alt003_select.png")!,
            UIImage(named:"Alt004_select.png")!,
            UIImage(named:"Alt005_select.png")!,
            UIImage(named:"Alt006_select.png")!,
            UIImage(named:"Alt007_select.png")!,
            UIImage(named:"Alt008_select.png")!,
            UIImage(named:"Alt009_select.png")!,
            UIImage(named:"ImageClear_origin.png")!
        ],[
            UIImage(named:"Alpha001_select.png")!,
            UIImage(named:"Alpha002_select.png")!,
            UIImage(named:"Alpha003_select.png")!,
            UIImage(named:"Alpha004_select.png")!,
            UIImage(named:"Alpha005_select.png")!,
            UIImage(named:"Alpha006_select.png")!,
            UIImage(named:"Alpha007_select.png")!,
            UIImage(named:"Alpha008_select.png")!,
            UIImage(named:"Alpha009_select.png")!,
            UIImage(named:"ImageClear_origin.png")!
        ]],
        [[
            UIImage(named:"Image001_delete.png")!,
            UIImage(named:"Image002_delete.png")!,
            UIImage(named:"Image003_delete.png")!,
            UIImage(named:"Image004_delete.png")!,
            UIImage(named:"Image005_delete.png")!,
            UIImage(named:"Image006_delete.png")!,
            UIImage(named:"Image007_delete.png")!,
            UIImage(named:"Image008_delete.png")!,
            UIImage(named:"Image009_delete.png")!,
            UIImage(named:"ImageClear_delete.png")!
        ],[
            UIImage(named:"Alt001_delete.png")!,
            UIImage(named:"Alt002_delete.png")!,
            UIImage(named:"Alt003_delete.png")!,
            UIImage(named:"Alt004_delete.png")!,
            UIImage(named:"Alt005_delete.png")!,
            UIImage(named:"Alt006_delete.png")!,
            UIImage(named:"Alt007_delete.png")!,
            UIImage(named:"Alt008_delete.png")!,
            UIImage(named:"Alt009_delete.png")!,
            UIImage(named:"ImageClear_delete.png")!
        ],[
            UIImage(named:"Alpha001_delete.png")!,
            UIImage(named:"Alpha002_delete.png")!,
            UIImage(named:"Alpha003_delete.png")!,
            UIImage(named:"Alpha004_delete.png")!,
            UIImage(named:"Alpha005_delete.png")!,
            UIImage(named:"Alpha006_delete.png")!,
            UIImage(named:"Alpha007_delete.png")!,
            UIImage(named:"Alpha008_delete.png")!,
            UIImage(named:"Alpha009_delete.png")!,
            UIImage(named:"ImageClear_delete.png")!
        ]],
        [[
            UIImage(named:"Image001_inactive.png")!,
            UIImage(named:"Image002_inactive.png")!,
            UIImage(named:"Image003_inactive.png")!,
            UIImage(named:"Image004_inactive.png")!,
            UIImage(named:"Image005_inactive.png")!,
            UIImage(named:"Image006_inactive.png")!,
            UIImage(named:"Image007_inactive.png")!,
            UIImage(named:"Image008_inactive.png")!,
            UIImage(named:"Image009_inactive.png")!,
            UIImage(named:"ImageClear_inactive.png")!
        ],[
            UIImage(named:"Alt001_inactive.png")!,
            UIImage(named:"Alt002_inactive.png")!,
            UIImage(named:"Alt003_inactive.png")!,
            UIImage(named:"Alt004_inactive.png")!,
            UIImage(named:"Alt005_inactive.png")!,
            UIImage(named:"Alt006_inactive.png")!,
            UIImage(named:"Alt007_inactive.png")!,
            UIImage(named:"Alt008_inactive.png")!,
            UIImage(named:"Alt009_inactive.png")!,
            UIImage(named:"ImageClear_inactive.png")!
        ],[
            UIImage(named:"Alpha001_inactive.png")!,
            UIImage(named:"Alpha002_inactive.png")!,
            UIImage(named:"Alpha003_inactive.png")!,
            UIImage(named:"Alpha004_inactive.png")!,
            UIImage(named:"Alpha005_inactive.png")!,
            UIImage(named:"Alpha006_inactive.png")!,
            UIImage(named:"Alpha007_inactive.png")!,
            UIImage(named:"Alpha008_inactive.png")!,
            UIImage(named:"Alpha009_inactive.png")!,
            UIImage(named:"ImageClear_inactive.png")!
        ]],
        [[
            UIImage(named:"Image001_highlight.png")!,
            UIImage(named:"Image002_highlight.png")!,
            UIImage(named:"Image003_highlight.png")!,
            UIImage(named:"Image004_highlight.png")!,
            UIImage(named:"Image005_highlight.png")!,
            UIImage(named:"Image006_highlight.png")!,
            UIImage(named:"Image007_highlight.png")!,
            UIImage(named:"Image008_highlight.png")!,
            UIImage(named:"Image009_highlight.png")!,
            UIImage(named:"ImageClear_delete.png")!
        ],[
            UIImage(named:"Alt001_highlight.png")!,
            UIImage(named:"Alt002_highlight.png")!,
            UIImage(named:"Alt003_highlight.png")!,
            UIImage(named:"Alt004_highlight.png")!,
            UIImage(named:"Alt005_highlight.png")!,
            UIImage(named:"Alt006_highlight.png")!,
            UIImage(named:"Alt007_highlight.png")!,
            UIImage(named:"Alt008_highlight.png")!,
            UIImage(named:"Alt009_highlight.png")!,
            UIImage(named:"ImageClear_delete.png")!
        ],[
            UIImage(named:"Alpha001_highlight.png")!,
            UIImage(named:"Alpha002_highlight.png")!,
            UIImage(named:"Alpha003_highlight.png")!,
            UIImage(named:"Alpha004_highlight.png")!,
            UIImage(named:"Alpha005_highlight.png")!,
            UIImage(named:"Alpha006_highlight.png")!,
            UIImage(named:"Alpha007_highlight.png")!,
            UIImage(named:"Alpha008_highlight.png")!,
            UIImage(named:"Alpha009_highlight.png")!,
            UIImage(named:"ImageClear_delete.png")!
        ]]
    ]
    
    //
    // sound handling
    //
    var createBoardSound: AVAudioPlayer!
    var placementSounds: [AVAudioPlayer?] = []
    var errorSound:       AVAudioPlayer!
    var ruboutSound:      AVAudioPlayer!
    var victorySound:     AVAudioPlayer!
    
    //
    // prefs
    //
    var userPrefs: PreferencesHandler!
    
    //
    // set in the Hint option dialog, allow the user a one off cell uncover
    //
    var giveHint: Bool!
    
    //
    // timer display and storage for counter etc
    //
    var gameTimer:    UILabel!
    var timer:        Timer!
    var timerActive:  Bool!
    var timerDisplay: Bool!
    
    //
    // state of game (so we can save if we get told the app is to close)
    //
    var userGame: GameStateHandler!
    
    //----------------------------------------------------------------------------
    // start of the code!!!!
    //----------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        // first thing to do is load the correct background graphic
        //
        //self.boardBackground.image = UIImage(named:"Background.iPad.png")!
        //
        // Do any additional setup after loading the view, typically from a nib.
        //
        self.applicationVersion = 100
        self.userPrefs          = PreferencesHandler(redrawFunctions: [])
        self.userGame           = GameStateHandler(applicationVersion: self.applicationVersion)
        self.sudokuBoard        = SudokuGameBoard(size: self.boardDimensions, difficulty: self.mapDifficulty(difficulty: self.userPrefs.difficultySet))
        self.displayBoard       = GameBoardImages(size: self.boardDimensions)
        self.controlPanelImages = CellImages(size: (5, 2))
        self.userSolution       = TrackSolution(row: self.boardDimensions, column: self.boardDimensions, cellRow: self.boardDimensions, cellColumn: self.boardDimensions)
        //
        // now setup displays
        //
        self.setupSudokuBoardDisplay()
        self.setupControlPanelDisplay()
        self.setupGameButtons()
        self.setupGameTimerLabel()
        //
        // setup the timer but dont let game time start yet (not in a game yet)
        //
        self.setupGameTimer()
        self.stopGameTimer()
        self.initialiseGameSounds()
        self.giveHint = false
        //
        // add the function call backs for board redraws used when exiting pref panel in case the char set is changed
        //
        self.userPrefs.drawFunctions = [self.updateControlPanelDisplay, self.updateSudokuBoardDisplay]
        //
        // register routines for app transiting to b/g (used in saving game state etc)
        //
        self.setupApplicationNotifications()
        //
        // load up any saved game, making sure we set the user Start button to 'Reset' if we have a game in progress
        //
        self.userGame.loadGame()
        if self.userGame.getGameInPlay() {
            self.continueSavedGame()
        }
        return
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //----------------------------------------------------------------------------
    // map difficulty to enum for SudokuGameBoard class
    //----------------------------------------------------------------------------
    func mapDifficulty(difficulty: Int) -> sudokuDifficulty {
        switch difficulty {
        case 1:
            return (sudokuDifficulty.Easy)
        case 2:
            return (sudokuDifficulty.Medium)
        case 3:
            return (sudokuDifficulty.Hard)
        default:
            return (sudokuDifficulty.Medium)
        }
    }

    //----------------------------------------------------------------------------
    // app transition events
    //----------------------------------------------------------------------------
    func setupApplicationNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(applicationMovingToBackground), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        notificationCenter.addObserver(self, selector: #selector(applicationMovingToForeground), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        notificationCenter.addObserver(self, selector: #selector(applicationToClose), name: NSNotification.Name.UIApplicationWillTerminate, object: nil)
        return
    }
    
    func applicationToClose() {
        self.userGame.setGameCells(cellArray: self.getCurrentGameBoardState())
        self.userGame.setOriginCells(cellArray: self.getCurrentOriginBoardState())
        self.userGame.setControlPanel(cellArray: self.getCurrentControlPanelState())
        self.userGame.saveGame()
        return
    }
    
    func applicationMovingToForeground() {
        if self.userGame.getGameInPlay() {
            self.startGameTimer()
        }
        return
    }
    
    func applicationMovingToBackground() {
        self.stopGameTimer()
        self.userGame.setGameCells(cellArray: self.getCurrentGameBoardState())
        self.userGame.setOriginCells(cellArray: self.getCurrentOriginBoardState())
        self.userGame.setControlPanel(cellArray: self.getCurrentControlPanelState())
        self.userGame.saveGame()
        return
    }
    
    //----------------------------------------------------------------------------
    // load/play sounds
    //----------------------------------------------------------------------------
    func initialiseGameSounds() {
        self.createBoardSound = self.loadSound(soundName: "CreateBoard_001.aiff")
        self.errorSound       = self.loadSound(soundName: "Mistake_001.aiff")
        self.ruboutSound      = self.loadSound(soundName: "RubOut_001.aiff")
        self.victorySound     = self.loadSound(soundName: "Triumph_001.aiff")
        self.placementSounds.append(self.loadSound(soundName: "Write_001.aiff"))
        self.placementSounds.append(self.loadSound(soundName: "Write_002.aiff"))
        self.placementSounds.append(self.loadSound(soundName: "Write_003.aiff"))
        self.placementSounds.append(self.loadSound(soundName: "Write_004.aiff"))
        self.placementSounds.append(self.loadSound(soundName: "Write_005.aiff"))
        self.placementSounds.append(self.loadSound(soundName: "Write_006.aiff"))
        self.placementSounds.append(self.loadSound(soundName: "Write_007.aiff"))
        self.placementSounds.append(self.loadSound(soundName: "Write_008.aiff"))
        self.placementSounds.append(self.loadSound(soundName: "Write_009.aiff"))
        return
    }
    
    func loadSound(soundName: String) -> AVAudioPlayer! {
        var value: AVAudioPlayer!
        do {
            value = try AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: Bundle.main.path(forResource: soundName, ofType:nil)!) as URL)
        } catch {
            return nil
        }
        return value
    }
    
    func playCreateSound() {
        guard self.createBoardSound != nil && self.userPrefs.soundOn == true else {
            return
        }
        self.createBoardSound.play()
        return
    }
    
    func playErrorSound() {
        guard self.errorSound != nil && self.userPrefs.soundOn == true else {
            return
        }
        self.errorSound.play()
        return
    }
    
    func playPlacementSound(number: Int) {
        guard (self.placementSounds.count) > 0 && (self.userPrefs.soundOn == true) && (1..<(self.placementSounds.count + 1)) ~= number else {
            return
        }
        if self.placementSounds[number - 1] == nil {
            return
        }
        self.placementSounds[number - 1]?.play()
        return
    }
    
    func playRuboutSound() {
        guard self.ruboutSound != nil && self.userPrefs.soundOn == true else {
            return
        }
        self.ruboutSound.play()
        return
    }
    
    func playVictorySound() {
        guard self.victorySound != nil && self.userPrefs.soundOn == true else {
            return
        }
        self.victorySound.play()
        return
    }
    
    //----------------------------------------------------------------------------
    // timer display handling
    //----------------------------------------------------------------------------
    func setupGameTimer() {
        self.timer = Timer()
        self.timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(ViewController.updateGameTime), userInfo: nil, repeats: true)
        return
    }
    
    func resetGameTimer() {
        self.userGame.resetCurrentGameTimePlayed()
        self.gameTimer.text = ""
        return
    }
    
    func startGameTimer() {
        self.timerActive = true
        self.timerDisplay = true
        return
    }
    
    func stopGameTimer() {
        self.timerActive = false
        self.timerDisplay = false
        return
    }
    
    func updateGameTime() {
        if self.timerActive == true {
            self.userGame.incrementTotalGameTimePlayed(diff: self.mapDifficulty(difficulty: self.userPrefs.difficultySet), increment: 1)
            if self.timerDisplay == true {
                let time: Int = self.userGame.incrementCurrentGameTimePlayed(increment: 1)
                self.gameTimer.text = String(format: "%02d", time / 60) + ":" + String(format: "%02d", time % 60)
            }
        }
        return
    }
    
    //----------------------------------------------------------------------------
    // penalty timer additions
    //----------------------------------------------------------------------------
    func addPenaltyToGameTime() {
        self.userGame.incrementTotalGameTimePlayed(diff: self.mapDifficulty(difficulty: self.userPrefs.difficultySet), increment: self.userGame.getGamePenaltyTime())
        let _: Int = self.userGame.incrementCurrentGameTimePlayed(increment: self.userGame.getGamePenaltyTime())
        let _: Int = self.userGame.incrementGamePenaltyTime(increment: self.userGame.incrementGamePenaltyIncrementTime(increment: 1))
        return
    }

    //----------------------------------------------------------------------------
    // start a new game for the user
    //----------------------------------------------------------------------------
    func createNewBoard() {
        self.resetControlPanelSelection()
        self.playCreateSound()
        if self.userPrefs.difficultySet != self.userPrefs.difficultyNew {
            self.userPrefs.difficultySet = self.userPrefs.difficultyNew
        }
        self.sudokuBoard.generateSolution(difficulty: self.mapDifficulty(difficulty: self.userPrefs.difficultySet))
        if self.debug == 1 {
            print(self.sudokuBoard.printSudokuSolution())
        }
        self.sudokuBoard.buildOriginBoard()
        self.finalPreparationForGameStart()
        return
    }
    
    //
    // restore the game state from the saved object
    //
    func continueSavedGame() {
        self.sudokuBoard.clear()
        //
        // copy the saved boards into the sudokuBoard object
        //
        for cell: BoardCell in self.userGame.currentGame.solutionCells {
            let _: Bool = self.sudokuBoard.setNumberOnSolution(coord: Coordinate(row: cell.row, column: cell.col, cell: (row: cell.crow, column: cell.ccol)), number: cell.value)
        }
        for cell: BoardCell in self.userGame.currentGame.originCells {
            let coord: Coordinate = Coordinate(row: cell.row, column: cell.col, cell: (row: cell.crow, column: cell.ccol))
            let _: Bool = self.sudokuBoard.setNumberOnOriginBoard(coord: Coordinate(row: cell.row, column: cell.col, cell: (row: cell.crow, column: cell.ccol)), number: cell.value)
            self.setCoordToStateImage(coord: coord, number: cell.value, imageState: cell.image)
        }
        //
        // now copy the game progress values on top of the origin, and dont forget the solution tracker
        //
        self.sudokuBoard.initialiseGame()
        for cell: BoardCell in self.userGame.currentGame.gameCells {
            let coord: Coordinate = Coordinate(row: cell.row, column: cell.col, cell: (row: cell.crow, column: cell.ccol))
            let _: Bool = self.sudokuBoard.setNumberOnGameBoard(coord: coord, number: cell.value)
            self.setCoordToStateImage(coord: coord, number: cell.value, imageState: cell.image)
            self.userSolution.addCoordinate(coord: coord)
        }
        self.updateSudokuBoardDisplay()
        //
        // finally the state of the control panel
        //
        for cell: BoardCell in self.userGame.currentGame.controlPanel {
            self.setControlPanelToImageValue(coord: (cell.row, cell.col), imageState: cell.image)
        }
        //
        // check if we had a position selected first, and highlight if needed
        //
        if self.userGame.currentGame.boardPosn.row != -1 && self.userGame.currentGame.controlPosn.posn.row == -1 {
            self.setCoordToTouchedImage(coord: self.userGame.currentGame.boardPosn)
        }
        //
        // start the game timer
        //
        self.startGameTimer()
        return
    }
    
    //
    // set a coord to the image of the selected number/state
    //
    func setCoordToStateImage(coord: Coordinate, number: Int, imageState: imageStates) {
        switch imageState {
        case imageStates.Origin:
            self.setCoordToOriginImage(coord: coord, number: number)
            break
        case imageStates.Selected:
            self.setCoordToSelectImage(coord: coord, number: number)
            break
        case imageStates.Delete:
            self.setCoordToDeleteImage(coord: coord, number: number)
            break
        case imageStates.Inactive:
            self.setCoordToInactiveImage(coord: coord, number: number)
            break
        default:
            self.setCoordToOriginImage(coord: coord, number: number)
            break
        }
        return
    }

    //
    // standard prep and setup for final game start/re-start
    //
    func finalPreparationForGameStart() {
        self.sudokuBoard.initialiseGame()
        self.userSolution.clearCoordinates()
        self.displayBoard.clearImageStates()
        self.updateSudokuBoardDisplay()
        self.resetControlPanelPosition()
        self.resetBoardPosition()
        self.resetGameTimer()
        self.startGameTimer()
        self.userGame.setGameInPlay(value: true)
        let _: Int = self.userGame.setGamePenaltyTime(value: self.setInitialPenalty().rawValue)
        self.userGame.resetGamePenaltyIncrementTime(value: self.setInitialPenaltyIncrement().rawValue)
        self.userGame.resetGamePlayerMovesMade()
        self.userGame.resetGamePlayerMovesDeleted()
        self.userGame.incrementStartedGames(diff: self.mapDifficulty(difficulty: self.userPrefs.difficultySet))
        self.userGame.setGameCells(cellArray: self.getCurrentGameBoardState())
        self.userGame.setOriginCells(cellArray: self.getCurrentOriginBoardState())
        self.userGame.setSolutionCells(cellArray: self.getCurrentSolutionBoardState())
        return
    }
    
    func setInitialPenalty() -> initialHintPenalty {
        switch self.mapDifficulty(difficulty: self.userPrefs.difficultySet) {
        case sudokuDifficulty.Easy:
            return initialHintPenalty.Easy
        case sudokuDifficulty.Medium:
            return initialHintPenalty.Medium
        case sudokuDifficulty.Hard:
            return initialHintPenalty.Hard
        }
    }
    
    func setInitialPenaltyIncrement() -> initialPenaltyIncrement {
        switch self.mapDifficulty(difficulty: self.userPrefs.difficultySet) {
        case sudokuDifficulty.Easy:
            return initialPenaltyIncrement.Easy
        case sudokuDifficulty.Medium:
            return initialPenaltyIncrement.Medium
        case sudokuDifficulty.Hard:
            return initialPenaltyIncrement.Hard
        }
    }
    
    //
    // clear any selection the user might have left in the control panel
    //
    func resetControlPanelSelection() {
        for location: (row: Int, column: Int) in self.controlPanelImages.getLocationsOfImageStateNotEqualTo(imageState: imageStates.Origin) {
            let index: Int = (location.row * 2) + location.column
            self.controlPanelImages.setImage(coord: (location), imageToSet: self.imageLibrary[imageStates.Origin.rawValue][self.userPrefs.characterSetInUse][index], imageState: imageStates.Origin)
        }
        return
    }
    
    //
    // redisplay the control panel (needed if the user changes the char set in the pref panel)
    //
    func updateControlPanelDisplay() {
        for y: Int in 0 ..< self.controlPanelImages.getRows() {
            for x: Int in 0 ..< self.controlPanelImages.getColumns() {
                self.setControlPanelToCurrentImageValue(coord: (y, column: x))
            }
        }
        return
    }
    
    //
    // redisplay the whole current board
    //
    func updateSudokuBoardDisplay() {
        for y: Int in 0 ..< self.displayBoard.getRows() {
            for x: Int in 0 ..< self.displayBoard.getColumns() {
                for j: Int in 0 ..< self.displayBoard.gameImages[y][x].getRows() {
                    for k: Int in 0 ..< self.displayBoard.gameImages[y][x].getColumns() {
                        self.redrawCurrentCoordImage(coord: Coordinate(row: y, column: x, cell: (row: j, column: k)))
                    }
                }
            }
        }
        return
    }
    
    //
    // set numbers on the 'game' board to highlighted if the user selects the 'number' from the control panel
    //
    func redrawCurrentCoordImage(coord: Coordinate) {
        let number: Int = self.sudokuBoard.getNumberFromGame(coord: coord)
        if number == 0 {
            self.setCellToBlankImage(coord: coord)
        } else {
            var imageState: imageStates = self.displayBoard.gameImages[coord.row][coord.column].getImageState(coord: (coord.cell.row, coord.cell.column))
            if imageState == imageStates.Blank {
                imageState = imageStates.Origin
            }
            self.displayBoard.gameImages[coord.row][coord.column].setImage(coord: (coord.cell.row, coord.cell.column), imageToSet: self.imageLibrary[imageState.rawValue][self.userPrefs.characterSetInUse][number - 1], imageState: imageState)
        }
        return
    }
    
    //------------------------------------------------------------------------------------
    // Handle the control panel display, setup event handler and detect taps in the board
    //------------------------------------------------------------------------------------
    func setupControlPanelDisplay() {
        //
        // control panel offsets (iPad)
        //
        var originX:     CGFloat
        var originY:     CGFloat
        var frameWidth:  CGFloat
        var frameHeight: CGFloat
        var offsetX:     CGFloat
        var offsetY:     CGFloat

        //
        // iPad Pro (frame width = 1366)
        //
        if self.view.frame.width > 1024 {
            originX     = 1100
            originY     = 286.6
            frameWidth  = 197.3
            frameHeight = 460
            offsetX     = 15
            offsetY     = 10
        } else {
            originX     = 825
            originY     = 215
            frameWidth  = 148
            frameHeight = 350
            offsetX     = 15
            offsetY     = 6
        }
        
        self.viewControlPanel = UIView(frame: CGRect(x: originX, y: originY, width: frameWidth, height: frameHeight))
        self.viewControlPanel.tag = subViewTags.controlPanel.rawValue
        self.view.addSubview(self.viewControlPanel)
        let ctrlPanel: Panel = Panel(hostFrame: self.viewControlPanel.frame, xOrigin: 0, yOrigin: 0, xMargin: offsetX, yMargin: offsetY, rows: 5, columns: 2)
        for image: ImagePosition in ctrlPanel.imageDetails {
            self.controlPanelImages.contents[image.coord.row][image.coord.column].imageView.frame = image.image
            self.controlPanelImages.contents[image.coord.row][image.coord.column].imageView.image = self.imageLibrary[imageStates.Origin.rawValue][self.userPrefs.characterSetInUse][(image.coord.row * 2) + image.coord.column]
            self.controlPanelImages.contents[image.coord.row][image.coord.column].imageState      = imageStates.Origin
            self.viewControlPanel.addSubview(self.controlPanelImages.contents[image.coord.row][image.coord.column].imageView)
        }
        self.initialiseControlPanelUIViewToAcceptTouch(view: self.viewControlPanel)
        return
    }
    
    
    //
    // sets up and allows touches to be detected on SudokuBoard view only
    //
    func initialiseControlPanelUIViewToAcceptTouch(view: UIView) {
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.detectedControlPanelUIViewTapped(recognizer:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        view.addGestureRecognizer(singleTap)
        view.isUserInteractionEnabled = true
        return
    }
    
    //
    // user interactiom with the control panel
    //
    func detectedControlPanelUIViewTapped(recognizer: UITapGestureRecognizer) {
        if recognizer.state != UIGestureRecognizerState.ended {
            return
        }
        // only worried if a board is in play
        if self.userGame.getGameInPlay() == false {
            return
        }
        // has the user tapped in a control panel icon?
        let posn: (row: Int, column: Int) = self.getPositionOfControlPanelImageTapped(location: recognizer.location(in: recognizer.view))
        if posn == (-1, -1) {
            return
        }
        
        if self.userGame.currentGame.boardPosn.row == -1 {
            self.setControlPanelPosition(coord: self.userSelectedControlPanelFirst(currentPosn: posn, previousPosn: self.userGame.currentGame.controlPosn.posn))
        } else {
            //
            // user placing / removing is a one off deal, so reset positions when done
            //
            if self.userSelectBoardBeforeControlPanel(currentPosn: posn, previousPosn: self.userGame.currentGame.controlPosn.posn, boardPosn: self.userGame.currentGame.boardPosn) == true {
                self.resetBoardPosition()
            }
            self.resetControlPanelPosition()
        }
        return
    }
    
    func getPositionOfControlPanelImageTapped(location: CGPoint) -> (row: Int, column: Int) {
        for y: Int in 0 ..< self.controlPanelImages.getRows() {
            for x: Int in 0 ..< self.controlPanelImages.getColumns() {
                if self.isTapWithinImage(location: location, image: self.controlPanelImages.contents[y][x].imageView) == true {
                    return(y, x)
                }
            }
        }
        return(-1, -1)
    }
    
    //----------------------------------------------------------------------------
    // setup the game buttons that user interacts with
    //----------------------------------------------------------------------------
    func setupGameButtons() {
        //
        // button for prefs dialog
        //
        let prefsButton: UIButton = UIButton()
        if self.view.frame.width > 1024 {
            prefsButton.frame = CGRect(x: 1233, y: 908, width: 61, height: 61)
        } else {
            prefsButton.frame = CGRect(x: 925, y: 681, width: 46, height: 46)
        }
        prefsButton.setImage(self.prefsImage, for: UIControlState.normal)
        prefsButton.addTarget(self, action: #selector(ViewController.preferencesButtonUsed(_:)), for: .touchUpInside)
        self.view.addSubview(prefsButton)
        //
        // hints button
        //
        let hintsButton: UIButton = UIButton()
        if self.view.frame.width > 1024 {
            hintsButton.frame = CGRect(x: 1121, y: 908, width: 61, height: 61)
        } else {
            hintsButton.frame = CGRect(x: 841, y: 681, width: 46, height: 46)
        }
        hintsButton.setImage(self.hintsImage, for: UIControlState.normal)
        hintsButton.addTarget(self, action: #selector(ViewController.hintButtonUsed(_:)), for: .touchUpInside)
        self.view.addSubview(hintsButton)
        //
        // start button
        //
        let startButton: UIButton = UIButton()
        if self.view.frame.width > 1024 {
            startButton.frame = CGRect(x: 1129, y: 780, width: 145, height: 61)
        } else {
            startButton.frame = CGRect(x: 847, y: 585, width: 109, height: 46)
        }
        startButton.setImage(self.startImage, for: UIControlState.normal)
        startButton.addTarget(self, action: #selector(ViewController.startButtonUsed(_:)), for: .touchUpInside)
        self.view.addSubview(startButton)
        return
    }
    
    //
    // what happens when we use the prefs button
    //
    func preferencesButtonUsed(_ sender: UIButton) {
        // first save the current preferences
        let pViewController: Preferences = Preferences()
        pViewController.modalPresentationStyle = UIModalPresentationStyle.popover
        pViewController.prefs = self.userPrefs
        pViewController.state = self.userGame
        self.present(pViewController, animated: true, completion: nil)
        let popoverController = pViewController.popoverPresentationController
        popoverController?.sourceView = sender
        return
    }

    //
    // a bit more can happen when the hints button is used (but only if the hints are turned on in the prefs panel)
    //
    func hintButtonUsed(_ sender: UIButton) {
        var alertController: UIAlertController!
        if self.userGame.getGameInPlay() == false {
            self.playErrorSound()
            alertController = UIAlertController(title: "Hint Options", message: "Hints are only useful when you have a game in progress!", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in //action -> Void in
                // nothing to do here, user bailed on using a hint
            }
            alertController.addAction(cancelAction)
            return
        }
        if self.userPrefs.hintsOn == false {
            self.playErrorSound()
            alertController = UIAlertController(title: "Hint Options", message: "Hints have been turned off! You can turn them back on in the prefs panel.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in //action -> Void in
                // nothing to do here, user bailed on using a hint
            }
            alertController.addAction(cancelAction)
        } else {
            alertController = UIAlertController(title: "Hint Options", message: "So you want to use a hint, this will add some time to your game clock. Ok?",preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in //action -> Void in
                // nothing to do here, user bailed on using a hint
            }
            alertController.addAction(cancelAction)
            let useHintAction = UIAlertAction(title: "Give me a hint!", style: .default) { (action:UIAlertAction!) in
                if self.addHintToBoard() {
                    self.addPenaltyToGameTime()
                }
            }
            alertController.addAction(useHintAction)
            let userSelectAction = UIAlertAction(title: "Let me select a cell to uncover!", style: .default) { (action:UIAlertAction!) in
                self.giveHint = true
            }
            alertController.addAction(userSelectAction)
            //
            // if we have detected numbers placed incorrectly give option to highlight (then pretend bin has been selected with restricted set)
            //
            let incorrectPlacements: [Coordinate] = self.incorrectNumbersPlacedOnBoard()
            if incorrectPlacements.count > 0 {
                var msg: String = ""
                if incorrectPlacements.count == 1 {
                    msg = "There is an incorrect number, show it!"
                } else {
                    msg = "\(incorrectPlacements.count) incorrect numbers, show them!"
                }
                let useHighlightAction = UIAlertAction(title: msg, style: .default) { (action:UIAlertAction!) in
                    //
                    // need to clear any ctrl posn and board cells already highlighted
                    //
                    if self.userGame.currentGame.controlPosn.posn != (-1, -1) {
                        self.resetControlPanelImage(index: (self.userGame.currentGame.controlPosn.posn.row * 2) + self.userGame.currentGame.controlPosn.posn.column)
                    }
                    self.unsetSelectNumbersOnBoard()
                    self.unsetDeleteNumbersOnBoard()
                    //
                    // highlight the incorrect numbers and the 'bin' as though the user had done it!
                    //
                    self.setControlPanelToDeleteImageValue(coord: (4, column: 1))
                    self.setControlPanelPosition(coord: (4,1))
                    self.setDeleteLocationsOnBoard(locations: incorrectPlacements)
                    self.resetBoardPosition()
                }
                alertController.addAction(useHighlightAction)
            }
        }
        self.present(alertController, animated: true, completion:nil)
        return
    }
    
    //
    // If they have a 'selected' number highlighted use that!
    // then failover to a random hint
    //
    func addHintToBoard() -> Bool {
        var optionsToRemove: [Coordinate] = []
        if self.userGame.currentGame.controlPosn.posn == (-1, -1) {
            optionsToRemove = self.sudokuBoard.getFreeLocationsOnGameBoard()
        } else {
            let index: Int = (self.userGame.currentGame.controlPosn.posn.row * 2) + self.userGame.currentGame.controlPosn.posn.column
            if index > 8 {
                optionsToRemove = self.sudokuBoard.getFreeLocationsOnGameBoard()
            } else {
                optionsToRemove = self.sudokuBoard.getFreeNumberLocationsOnGameBoard(number: index + 1)
            }
        }
        //
        // if we found none to remove, escape cleanly (shouldn't happen though)
        //
        if optionsToRemove.count == 0 {
            return false
        }
        //
        // choose a random hint
        //
        let posnToRemove: Int = Int(arc4random_uniform(UInt32(optionsToRemove.count)))
        let number: Int = self.sudokuBoard.getNumberFromSolution(coord: optionsToRemove[posnToRemove])
        if self.sudokuBoard.setNumberOnGameBoard(coord: optionsToRemove[posnToRemove], number: number) {
            self.userSolution.addCoordinate(coord: optionsToRemove[posnToRemove])
            let _: Int = self.userGame.incrementGamePlayerMovesMade()
            // do we need to make number 'inactive'?
            if self.sudokuBoard.isNumberFullyUsedInGame(number: number) == false {
                self.setCoordToSelectImage(coord: optionsToRemove[posnToRemove], number: number)
                self.playPlacementSound(number: number)
            } else {
                self.setCoordToOriginImage(coord: optionsToRemove[posnToRemove], number: number)
                self.setControlPanelToInactiveImageValue(coord: ((number - 1) / 2, column: (number - 1) % 2))
                self.unsetSelectNumbersOnBoard()
                self.resetControlPanelPosition()
                self.playPlacementSound(number: number)
                // have we completed the game
                if self.sudokuBoard.isGameCompleted() {
                    self.userCompletesGame()
                }
            }
        }
        return true
    }
    
    //
    // use the userSolution and compare against the 'Origin' board to see if we have incorrect placements
    //
    func incorrectNumbersPlacedOnBoard() -> [Coordinate] {
        var incorrectCoords: [Coordinate] = []
        let coordsInSolution: [Coordinate] = self.userSolution.getCoordinatesInSolution()
        for coord in coordsInSolution {
            if self.sudokuBoard.getNumberFromGame(coord: coord) != self.sudokuBoard.getNumberFromSolution(coord: coord) {
                incorrectCoords.append(coord)
            }
        }
        return incorrectCoords
    }
    
    //
    // and the start button
    //
    func startButtonUsed(_ sender: UIButton) {
        //
        // if we have 'Start' button, build the board
        //
        if sender.currentImage?.isEqual(self.startImage) == true {
            self.createNewBoard()
            sender.setImage(self.resetImage, for: UIControlState.normal)
        } else {
            //
            // then we can:
            //
            //      1. cancel and forget the user asked to reset
            //      2. go back to the start of the current game
            //      3. restart the game
            //
            let alertController = UIAlertController(title: "Reset Options", message: "So you want to reset the puzzle?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in //action -> Void in
                // nothing to do here, user bailed on reseting the game
            }
            alertController.addAction(cancelAction)
            let resetAction = UIAlertAction(title: "Restart this puzzle!", style: .default) { (action:UIAlertAction!) in
                self.resetControlPanelSelection()
                self.finalPreparationForGameStart()
            }
            alertController.addAction(resetAction)
            let restartAction = UIAlertAction(title: "New Puzzle!", style: .default) { (action:UIAlertAction!) in
                self.createNewBoard()
            }
            alertController.addAction(restartAction)
            self.present(alertController, animated: true, completion:nil)
        }
        return
    }
    
    //----------------------------------------------------------------------------
    // label for the game time to be displayed
    //----------------------------------------------------------------------------
    func setupGameTimerLabel() {
        //
        // button for prefs dialog
        //
        self.gameTimer = UILabel()
        if self.view.frame.width > 1024 {
            self.gameTimer.frame = CGRect(x: 1112, y: 200, width: 179, height: 61)
        } else {
            self.gameTimer.frame = CGRect(x: 834, y: 150, width: 134, height: 46)
        }
        self.gameTimer.text          = "00:00"
        self.gameTimer.textAlignment = NSTextAlignment.natural
        self.gameTimer.textColor     = UIColor.white
        self.gameTimer.shadowColor   = UIColor.black
        self.gameTimer.shadowOffset  = CGSize(width: 4, height: 4)
        self.gameTimer.font          = UIFont(name: "Chalkduster", size: CGFloat(36))
        self.view.addSubview(self.gameTimer)
        return
    }
    
    //----------------------------------------------------------------------------
    // the user came straight to the control panel no board posn set
    //----------------------------------------------------------------------------
    func userSelectedControlPanelFirst(currentPosn: (row: Int, column: Int), previousPosn: (row: Int, column: Int)) -> (row: Int, column: Int) {
        let index: Int = (currentPosn.row * 2) + currentPosn.column
        if previousPosn.row != -1 {
            let pIndex = (previousPosn.row * 2) + previousPosn.column
            if index != pIndex {
                //
                // revert previous selected ctrl panel posn and numbers set
                //
                self.resetControlPanelImage(index: pIndex)
                self.unsetSelectNumbersOnBoard()
                self.unsetDeleteNumbersOnBoard()
            } else {
                let currentState: imageStates = self.controlPanelImages.getImageState(coord: (currentPosn))
                switch index {
                case 0..<9:
                    if currentState == imageStates.Selected {
                        if self.sudokuBoard.isNumberFullyUsedInGame(number: index + 1) == true {
                            self.setControlPanelToInactiveImageValue(coord: (index / 2, column: index % 2))
                        } else {
                            self.setControlPanelToOriginImageValue(coord: (index / 2, column: index % 2))
                        }
                        self.unsetSelectNumbersOnBoard()
                        return (-1, -1)
                    }
                    self.setControlPanelToSelectImageValue(coord: (index / 2, column: index % 2))
                    self.setSelectNumbersOnBoard(number: index + 1)
                    break
                case 9:
                    if currentState == imageStates.Delete {
                        self.setControlPanelToOriginImageValue(coord: (index / 2, column: index % 2))
                        self.unsetDeleteNumbersOnBoard()
                        return (-1, -1)
                    } else {
                        self.setControlPanelToDeleteImageValue(coord: (index / 2, column: index % 2))
                        self.setDeleteLocationsOnBoard(locations: self.userSolution.getCoordinatesInSolution())
                    }
                    break
                default:
                    break
                }
                return (currentPosn)
            }
        }
        //
        // process the current posn
        //
        switch index {
        case 0..<9:
            self.setControlPanelToSelectImageValue(coord: (index / 2, column: index % 2))
            self.setSelectNumbersOnBoard(number: index + 1)
            break;
        case 9:
            self.setControlPanelToDeleteImageValue(coord: (index / 2, column: index % 2))
            self.setDeleteLocationsOnBoard(locations: self.userSolution.getCoordinatesInSolution())
            break
        default:
            // this should never happen
            break
        }
        return currentPosn
    }
    
    //
    // we have an active board position selected before the user used the control panel
    //
    func userSelectBoardBeforeControlPanel(currentPosn: (row: Int, column: Int), previousPosn: (row: Int, column: Int), boardPosn: Coordinate) -> Bool {
        let index: Int = (currentPosn.row * 2) + currentPosn.column
        switch index {
        case 0..<9:
            //
            // place the selected number on the board if we can put it there
            //
            if self.sudokuBoard.isNumberLegalOnGameBoard(coord: boardPosn, number: index + 1) == false {
                self.playErrorSound()
                return false
            }
            //
            // if already have a number there, clear it!
            //
            if self.sudokuBoard.isGameLocationUsed(coord: boardPosn) == true {
                self.sudokuBoard.clearGameBoardLocation(coord: boardPosn)
            }
            //
            // place the number, if we can
            //
            if self.sudokuBoard.setNumberOnGameBoard(coord: boardPosn, number: index + 1) == false {
                self.playErrorSound()
                return false
            }
            self.userSolution.addCoordinate(coord: boardPosn)
            let _: Int = self.userGame.incrementGamePlayerMovesMade()
            self.playPlacementSound(number: index + 1)
            if self.sudokuBoard.isNumberFullyUsedInGame(number: index + 1) == true {
                self.setControlPanelToInactiveImageValue(coord: (index / 2, column: index % 2))
                self.setUserUsedNumberCompletion(number: index + 1)
                if self.sudokuBoard.isGameCompleted() {
                    self.userCompletesGame()
                }
            } else {
                self.setCoordToOriginImage(coord: boardPosn, number: index + 1)
            }
            break
        case 9:
            let number: Int = self.sudokuBoard.getNumberFromGame(coord: boardPosn)
            if number > 0 {
                self.playRuboutSound()
                self.sudokuBoard.clearGameBoardLocation(coord: boardPosn)
                self.setCellToBlankImage(coord: boardPosn)
                self.userSolution.removeCoordinate(coord: boardPosn)
                let _: Int = self.userGame.incrementGamePlayerMovesDeleted()
                //
                // may need to reactivate 'inactive' control panel posn
                //
                self.resetInactiveNumberOnBoard(number: number)
            }
            break
        default:
            // this should never happen
            break
        }
        return true
    }
    
    //----------------------------------------------------------------------------
    // Handle the board display, setup event handler and detect taps in the board
    //----------------------------------------------------------------------------
    // build the initial board display, we only do this once!
    //----------------------------------------------------------------------------
    func setupSudokuBoardDisplay() {
        //
        // defaults for positioning UIImageView components for main board (iPad width = 1024)
        //
        var kMainViewMargin:  CGFloat
        var kCellWidthMargin: CGFloat
        var kCellDepthMargin: CGFloat
        if self.view.frame.width > 1024 {
            kMainViewMargin  = 52
            kCellWidthMargin = 11.7
            kCellDepthMargin = 9.33
        } else {
            kMainViewMargin  = 40.0
            kCellWidthMargin = 8.8
            kCellDepthMargin = 7
        }
        //
        // add the image containers onto the board row by row
        //
        func addImagesViewsToSudokuBoard(boardRows: Int, boardColumns: Int, cellWidthMargin: CGFloat, cellDepthMargin: CGFloat) {
            //
            // calculate the size of the image views we'll use on the board
            //
            func calculateBoardCellWidth(boardColumns: Int, margin: CGFloat) -> CGFloat {
                var cellWidth: CGFloat = self.viewSudokuBoard.bounds.width
                cellWidth -= (CGFloat(boardColumns + 1) * margin)
                return cellWidth / CGFloat(boardColumns)
            }
            
            func calculateBoardCellDepth(boardRows: Int, margin: CGFloat) -> CGFloat {
                var cellDepth: CGFloat = self.viewSudokuBoard.bounds.height
                cellDepth -= (CGFloat(boardRows + 1) * margin)
                return cellDepth / CGFloat(boardRows)
            }
            
            let cellWidth: CGFloat = calculateBoardCellWidth(boardColumns: boardColumns * boardColumns, margin: cellWidthMargin)
            let cellDepth: CGFloat = calculateBoardCellDepth(boardRows: boardRows * boardRows, margin: cellWidthMargin)
            var yStart: CGFloat = cellDepthMargin
            for y: Int in 0 ..< boardRows {
                var jStart: CGFloat = 0
                for j: Int in 0 ..< boardColumns {
                    var xStart: CGFloat = cellWidthMargin
                    for x: Int in 0 ..< boardRows {
                        var kStart: CGFloat = 0
                        for k: Int in 0 ..< boardColumns {
                            self.displayBoard.gameImages[y][x].contents[j][k].imageView.frame = CGRect(x: xStart + kStart, y: yStart + jStart, width: cellWidth, height: cellWidth)
                            self.viewSudokuBoard.addSubview(self.displayBoard.gameImages[y][x].contents[j][k].imageView)
                            kStart += cellWidth + cellWidthMargin
                        }
                        xStart += kStart + (cellWidthMargin * 2)
                    }
                    jStart += cellDepth + cellDepthMargin
                }
                yStart += jStart + (cellDepthMargin * 2)
            }
            return
        }
        
        //
        // allowing touches to be detected on SudokuBoard view only
        //
        func initialiseSudokuBoardUIViewToAcceptTouch(view: UIView) {
            let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.detectedSudokuBoardUIViewTapped(recognizer:)))
            singleTap.numberOfTapsRequired = 1
            singleTap.numberOfTouchesRequired = 1
            view.addGestureRecognizer(singleTap)
            view.isUserInteractionEnabled = true
            return
        }

        let originX: CGFloat = self.view.bounds.origin.x + kMainViewMargin
        let originY: CGFloat = kMainViewMargin
        let frameWidth: CGFloat = self.view.bounds.height - (2 * kMainViewMargin)
        let frameHeight: CGFloat = self.view.bounds.height - (2 * kMainViewMargin)
        self.viewSudokuBoard = UIView(frame: CGRect(x: originX, y: originY, width: frameWidth, height: frameHeight))
        self.viewSudokuBoard.tag = subViewTags.sudokuBoard.rawValue
        self.view.addSubview(self.viewSudokuBoard)
        addImagesViewsToSudokuBoard(boardRows: self.boardDimensions, boardColumns: self.boardDimensions, cellWidthMargin: kCellWidthMargin, cellDepthMargin: kCellDepthMargin)
        initialiseSudokuBoardUIViewToAcceptTouch(view: self.viewSudokuBoard)
        return
    }

    //
    // handle user interaction with the game board
    //
    func detectedSudokuBoardUIViewTapped(recognizer: UITapGestureRecognizer) {
        if(recognizer.state != UIGestureRecognizerState.ended) {
            return
        }
        //
        // we're only interested if the board is in play
        //
        if self.userGame.getGameInPlay() == false {
            return
        }
        //
        // has the user tapped in a cell?
        //
        let posn: Coordinate = self.getPositionOfSudokuBoardImageTapped(location: recognizer.location(in: recognizer.view))
        if posn.column == -1 {
            return
        }
        //
        // ignore the 'origin' positions
        //
        if self.sudokuBoard.isOriginLocationUsed(coord: posn) {
            return
        }
        //
        // if we have an active Hint to place see if the board cell is clear and fill it!
        //
        if self.giveHint == true {
            if self.sudokuBoard.isGameLocationUsed(coord: posn) == true {
                self.playErrorSound()
            } else {
                self.placeUserHintOnBoard(location: posn)
            }
            return
        }
        //
        // if there's no action to process from the control panel, store the board posn, highlight it and leave
        //
        if self.userGame.currentGame.controlPosn.posn == (-1, -1) {
            self.userGame.currentGame.boardPosn = self.userSelectedBoardFirst(currentPosn: posn, previousPosn: self.userGame.currentGame.boardPosn)
            return
        }
        let index: Int = (self.userGame.currentGame.controlPosn.posn.row * 2) + self.userGame.currentGame.controlPosn.posn.column
        let number: Int = self.sudokuBoard.getNumberFromGame(coord: posn)
        switch index {
        case 0..<9:
            if self.sudokuBoard.isGameLocationUsed(coord: posn) {
                if index != (number - 1) {
                    return
                }
                self.playRuboutSound()
                self.sudokuBoard.clearGameBoardLocation(coord: posn)
                self.setCellToBlankImage(coord: posn)
                self.userSolution.removeCoordinate(coord: posn)
                let _: Int = self.userGame.incrementGamePlayerMovesDeleted()
                self.resetBoardPosition()
                return
            }
            if self.sudokuBoard.setNumberOnGameBoard(coord: posn, number: index + 1) == false {
                self.playErrorSound()
                return
            }
            self.userSolution.addCoordinate(coord: posn)
            let _: Int = self.userGame.incrementGamePlayerMovesMade()
            //
            // do we need to make number 'inactive'?
            //
            if self.sudokuBoard.isNumberFullyUsedInGame(number: index + 1) == false {
                self.setCoordToSelectImage(coord: posn, number: index + 1)
                self.playPlacementSound(number: index + 1)
            } else {
                self.setCoordToOriginImage(coord: posn, number: index + 1)
                self.setControlPanelToInactiveImageValue(coord: (index / 2, column: index % 2))
                self.unsetSelectNumbersOnBoard()
                self.resetControlPanelPosition()
                self.playPlacementSound(number: index + 1)
                //
                // have we completed the game
                //
                if self.sudokuBoard.isGameCompleted() {
                    self.userCompletesGame()
                }
            }
        case 9:
            if number == 0 {
                return
            }
            //
            // when user selects posn on board and it's populated by a user solution, clear it if it's set to 'delete' state!
            //
            if self.displayBoard.getImageState(coord: posn) != imageStates.Delete {
                self.playErrorSound()
                return
            }
            self.playRuboutSound()
            self.sudokuBoard.clearGameBoardLocation(coord: posn)
            self.setCellToBlankImage(coord: posn)
            self.userSolution.removeCoordinate(coord: posn)
            let _: Int = self.userGame.incrementGamePlayerMovesDeleted()
            self.resetBoardPosition()
            //
            // may need to reactivate 'inactive' control panel posn
            //
            self.resetInactiveNumberOnBoard(number: number)
            //
            // if we have exhausted all 'delete' options, then reset the control panel icon, and selected ctrl panel posn
            //
            if self.displayBoard.getLocationsOfImages(imageState: imageStates.Delete).count == 0 {
                self.setControlPanelToSelectImageValue(coord: (index / 2, column: index % 2))
                self.resetControlPanelPosition()
            }
            break
        default:
            // this should never happen
            break
        }
        return
    }
    
    func getPositionOfSudokuBoardImageTapped(location: CGPoint) -> Coordinate {
        for y: Int in 0 ..< self.displayBoard.getRows() {
            for x: Int in 0 ..< self.displayBoard.getColumns() {
                for j: Int in 0 ..< self.displayBoard.gameImages[y][x].getRows() {
                    for k: Int in 0 ..< self.displayBoard.gameImages[y][x].getColumns() {
                        if self.isTapWithinImage(location: location, image: self.displayBoard.gameImages[y][x].contents[j][k].imageView) == true {
                            return Coordinate(row: y, column: x, cell: (j, k))
                        }
                    }
                }
            }
        }
        return Coordinate(row: -1, column: -1, cell: (-1, -1))
    }
    
    //
    // place users hint on the board, if we can
    //
    func placeUserHintOnBoard(location: Coordinate) {
        let number: Int = self.sudokuBoard.getNumberFromSolution(coord: location)
        //
        // the user could have placed an incorrect number stopping the placement ofa correct number from working. so warn them!
        //
        if self.sudokuBoard.setNumberOnGameBoard(coord: location, number: number) == false {
            self.playErrorSound()
            let alertController = UIAlertController(title: "Hint Error", message: "I can't put the correct number there! An incorrectly placed number is stopping me", preferredStyle: .alert)
            let warningAction = UIAlertAction(title: "Ok!", style: .default) { (action:UIAlertAction!) in
                // just a warning message
            }
            alertController.addAction(warningAction)
            self.present(alertController, animated: true, completion:nil)
            return
        }
        //
        // add the number to the solution
        //
        self.userSolution.addCoordinate(coord: location)
        let _: Int = self.userGame.incrementGamePlayerMovesMade()
        self.playPlacementSound(number: number)
        self.giveHint = false
        //
        // reset control panel if needed, and clear down any selected or highlighted numbers from before the user selected the hint placement (if any)
        //
        if self.userGame.currentGame.controlPosn.posn != (-1, -1) {
            self.resetControlPanelImage(index: (self.userGame.currentGame.controlPosn.posn.row * 2) + self.userGame.currentGame.controlPosn.posn.column)
            self.resetControlPanelPosition()
        }
        self.unsetDeleteNumbersOnBoard()
        self.unsetSelectNumbersOnBoard()
        //
        // placing the number might complete the usage of a number
        //
        if self.sudokuBoard.isNumberFullyUsedInGame(number: number) == true {
            self.setCoordToOriginImage(coord: location, number: number)
            if self.sudokuBoard.isGameCompleted() {
                self.userCompletesGame()
            }
            return
        }
        //
        // if not then highlight the number, the control panel and it's siblings
        //
        self.setCoordToSelectImage(coord: location, number: number)
        self.setSelectNumbersOnBoard(number: number)
        let index: Int = number - 1
        self.setControlPanelToSelectImageValue(coord: (index / 2, column: index % 2))
        self.setControlPanelPosition(coord: (index / 2, column: index % 2))
        return
    }
    
    //
    // if the user selects the board first
    //
    func userSelectedBoardFirst(currentPosn: Coordinate, previousPosn: Coordinate) -> Coordinate {
        //
        // if we've previously selected the same cell, if it was blank remove the highlight
        //
        if currentPosn.isEqual(coord: previousPosn) {
            if self.sudokuBoard.isGameLocationUsed(coord: currentPosn) == false {
                self.setCellToBlankImage(coord: currentPosn)
            } else {
                self.setCoordToOriginImage(coord: currentPosn, number: self.sudokuBoard.getNumberFromGame(coord: currentPosn))
            }
            return Coordinate(row: -1, column: -1, cell:(-1, -1))
        }
        if previousPosn.row != -1 {
            if self.sudokuBoard.isGameLocationUsed(coord: previousPosn) == false {
                self.setCellToBlankImage(coord: previousPosn)
            } else {
                self.setCoordToOriginImage(coord: previousPosn, number: self.sudokuBoard.getNumberFromGame(coord: previousPosn))
            }
        }
        if self.sudokuBoard.isGameLocationUsed(coord: currentPosn) == false {
            self.setCoordToTouchedImage(coord: currentPosn)
        } else {
            self.setCoordToSelectImage(coord: currentPosn, number: self.sudokuBoard.getNumberFromGame(coord: currentPosn))
        }
        return currentPosn
    }
    
    //----------------------------------------------------------------------------
    // routines to make numbers inactive/active if all are completed on board
    //----------------------------------------------------------------------------
    func resetInactiveNumberOnBoard(number: Int) {
        let index: Int = number - 1
        self.setControlPanelToOriginImageValue(coord: (index / 2, column: index % 2))
        return
    }
    
    //----------------------------------------------------------------------------
    // detect if the user has selected within a designated image view
    //----------------------------------------------------------------------------
    func isTapWithinImage(location: CGPoint, image: UIImageView) -> Bool {
        if (location.x >= image.frame.origin.x) && (location.x <= (image.frame.origin.x + image.frame.width)) {
            if (location.y >= image.frame.origin.y) && (location.y <= (image.frame.origin.y + image.frame.height)) {
                return true
            }
        }
        return false
    }
    
    //----------------------------------------------------------------------------
    // things to do when the user completes the game
    //----------------------------------------------------------------------------
    func userCompletesGame() {
        self.stopGameTimer()
        self.playVictorySound()
        //
        // set up a customised message for the user
        //
        var completedMsg: String = ""
        if self.userGame.setFastestPlayerTime(diff: self.mapDifficulty(difficulty: self.userPrefs.difficultySet)) == true {
            completedMsg.append("Wow! You have just set your fastest time of " + self.timeInText(time: self.userGame.getCurrentGameTimePlayed()) + " for this difficulty, do")
        } else {
            if self.userGame.setSlowestPlayerTime(diff: self.mapDifficulty(difficulty: self.userPrefs.difficultySet)) == false {
                completedMsg.append("Do")
            } else {
                completedMsg.append("I think! You have just taken the most time " + self.timeInText(time: self.userGame.getCurrentGameTimePlayed()) + " to complete the puzzle for this difficulty, do")
            }
        }
        completedMsg.append(" you want to start again with another puzzle?")
        //
        // save things about the game we care about
        //
        self.userGame.incrementTotalPlayerMovesMade(diff: self.mapDifficulty(difficulty: self.userPrefs.difficultySet), increment: self.userGame.getGamePlayerMovesMade())
        self.userGame.incrementTotalPlayerMovesDeleted(diff: self.mapDifficulty(difficulty: self.userPrefs.difficultySet), increment: self.userGame.getGamePlayerMovesDeleted())
        self.userGame.incrementCompletedGames(diff: self.mapDifficulty(difficulty: self.userPrefs.difficultySet))
        self.userGame.setGameInPlay(value: false)
        //
        // go again?
        //
        let alertController = UIAlertController(title: "Congratulations", message: completedMsg, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in //action -> Void in
            // nothing to do here, user bailed on reseting the game (why???????)
        }
        alertController.addAction(cancelAction)
        let restartAction = UIAlertAction(title: "New Puzzle!", style: .default) { (action:UIAlertAction!) in
            self.createNewBoard()
        }
        alertController.addAction(restartAction)
        self.present(alertController, animated: true, completion:nil)
        return
    }
    
    func timeInText(time:Int) -> String {
        return String(format: "%d", time / 60) + " minutes and " + String(format: "%d", time % 60) + " seconds"
    }
    
    //----------------------------------------------------------------------------
    // all board image setting routines live here!
    //----------------------------------------------------------------------------
    func unsetDeleteNumbersOnBoard() {
        let locations: [Coordinate] = self.displayBoard.getLocationsOfImages(imageState: imageStates.Delete)
        self.unsetDeleteLocationsOnBoard(locations: locations)
        return
    }
    
    func unsetDeleteLocationsOnBoard(locations: [Coordinate]) {
        if locations.isEmpty == false {
            for coord in locations {
                self.setCoordToOriginImage(coord: coord, number: self.sudokuBoard.getNumberFromGame(coord: coord))
            }
        }
        return
    }
    
    func setDeleteLocationsOnBoard(locations: [Coordinate]) {
        if locations.isEmpty == false {
            for coord in locations {
                self.setCoordToDeleteImage(coord: coord, number: self.sudokuBoard.getNumberFromGame(coord: coord))
            }
        }
        return
    }
    
    func unsetSelectNumbersOnBoard() {
        let locations: [Coordinate] = self.displayBoard.getLocationsOfImages(imageState: imageStates.Selected)
        self.unsetSelectLocationsOnBoard(locations: locations)
        return
    }
    
    func unsetSelectLocationsOnBoard(locations: [Coordinate]) {
        if locations.isEmpty == true {
            return
        }
        for coord in locations {
            self.setCoordToOriginImage(coord: coord, number: self.sudokuBoard.getNumberFromGame(coord: coord))
        }
        return
    }
    
    func setSelectNumbersOnBoard(number: Int) {
        // index will give the 'number' selected from the control panel
        let locations: [Coordinate] = self.sudokuBoard.getNumberLocationsOnGameBoard(number: number)
        self.setSelectLocationsOnBoard(locations: locations)
        return
    }
    
    func setSelectLocationsOnBoard(locations: [Coordinate]) {
        if locations.isEmpty == true {
            return
        }
        for coord in locations {
            self.setCoordToSelectImage(coord: coord, number: self.sudokuBoard.getNumberFromGame(coord: coord))
        }
        return
    }
    
    //
    // clear the current image at the coord
    //
    func setCellToBlankImage(coord: Coordinate) {
        self.displayBoard.gameImages[coord.row][coord.column].clearImage(coord: (coord.cell))
        return
    }
    
    //
    // set space on board to cell having been 'touched', we use this when the user selects the board cell first and not the control panel
    //
    func setCoordToTouchedImage(coord: Coordinate) {
        self.displayBoard.gameImages[coord.row][coord.column].setImage(coord: (coord.cell), imageToSet: self.userSelectImage, imageState: imageStates.Origin)
        return
    }
    
    //
    // set numbers on the 'game' board to inactive when all of that number has been used
    //
    func setCoordToInactiveImage(coord: Coordinate, number: Int) {
        self.displayBoard.gameImages[coord.row][coord.column].setImage(coord: (coord.cell), imageToSet: self.imageLibrary[imageStates.Inactive.rawValue][self.userPrefs.characterSetInUse][number - 1], imageState: imageStates.Inactive)
        return
    }
    
    //
    // set numbers on the 'game' board to origin if they are also part of the origin board
    //
    func setCoordToOriginImage(coord: Coordinate, number: Int) {
        self.displayBoard.gameImages[coord.row][coord.column].setImage(coord: (coord.cell), imageToSet: self.imageLibrary[imageStates.Origin.rawValue][self.userPrefs.characterSetInUse][number - 1], imageState: imageStates.Origin)
        return
    }
    
    //
    // set numbers on the 'game' board to highlighted if the user selects the 'number' from the control panel
    //
    func setCoordToSelectImage(coord: Coordinate, number: Int) {
        self.displayBoard.gameImages[coord.row][coord.column].setImage(coord: (coord.cell), imageToSet: self.imageLibrary[imageStates.Selected.rawValue][self.userPrefs.characterSetInUse][number - 1], imageState: imageStates.Selected)
        return
    }
    
    //
    // set numbers on the 'game' board to highlighted if the user selects the 'number' from the control panel
    //
    func setCoordToDeleteImage(coord: Coordinate, number: Int) {
        self.displayBoard.gameImages[coord.row][coord.column].setImage(coord: (coord.cell), imageToSet: self.imageLibrary[imageStates.Delete.rawValue][self.userPrefs.characterSetInUse][number - 1], imageState: imageStates.Delete)
        return
    }
    
    //----------------------------------------------------------------------------
    // all control panel image setting routines live here!
    //----------------------------------------------------------------------------
    // set numbers on the control panel to whatever 'state' is stored (used when we swap char sets)
    //
    func setControlPanelToCurrentImageValue(coord: (row: Int, column: Int)) {
        let imgState: imageStates = self.controlPanelImages.getImageState(coord: (coord.row, coord.column))
        self.controlPanelImages.setImage(coord: (coord), imageToSet: self.imageLibrary[imgState.rawValue][self.userPrefs.characterSetInUse][(coord.row * 2) + coord.column], imageState: imgState)
        return
    }
    
    //
    // set numbers on the control panel to 'inactive' 'state'
    //
    func setControlPanelToInactiveImageValue(coord: (row: Int, column: Int)) {
        self.controlPanelImages.setImage(coord: (coord), imageToSet: self.imageLibrary[imageStates.Inactive.rawValue][self.userPrefs.characterSetInUse][(coord.row * 2) + coord.column], imageState: imageStates.Inactive)
        return
    }
    
    //
    // set numbers on the control panel to 'origin' 'state'
    //
    func setControlPanelToOriginImageValue(coord: (row: Int, column: Int)) {
        self.controlPanelImages.setImage(coord: (coord), imageToSet: self.imageLibrary[imageStates.Origin.rawValue][self.userPrefs.characterSetInUse][(coord.row * 2) + coord.column], imageState: imageStates.Origin)
        return
    }
    
    //
    // set numbers on the control panel to 'selected' 'state'
    //
    func setControlPanelToSelectImageValue(coord: (row: Int, column: Int)) {
        self.controlPanelImages.setImage(coord: (coord), imageToSet: self.imageLibrary[imageStates.Selected.rawValue][self.userPrefs.characterSetInUse][(coord.row * 2) + coord.column], imageState: imageStates.Selected)
        return
    }
    
    //
    // set numbers on the control panel to 'selected' 'state'
    //
    func setControlPanelToDeleteImageValue(coord: (row: Int, column: Int)) {
        self.controlPanelImages.setImage(coord: (coord), imageToSet: self.imageLibrary[imageStates.Delete.rawValue][self.userPrefs.characterSetInUse][(coord.row * 2) + coord.column], imageState: imageStates.Delete)
        return
    }

    //
    // set numbers to supplied 'state' (used on game reload)
    //
    func setControlPanelToImageValue(coord: (row: Int, column: Int), imageState: imageStates) {
        self.controlPanelImages.setImage(coord: (coord), imageToSet: self.imageLibrary[imageState.rawValue][self.userPrefs.characterSetInUse][(coord.row * 2) + coord.column], imageState: imageState)
        return
    }
    
    //----------------------------------------------------------------------------
    // translate game to/from GameStateHandler
    //----------------------------------------------------------------------------
    //
    // Game cells linked to the solution tracker
    //
    func getCurrentGameBoardState() -> [BoardCell] {
        var cells: [BoardCell] = []
        for coord in self.userSolution.getCoordinatesInSolution() {
            let number: Int = self.sudokuBoard.getNumberFromGame(coord: coord)
            var cell: BoardCell = BoardCell()
            cell.row    = coord.row
            cell.col    = coord.column
            cell.crow   = coord.cell.row
            cell.ccol   = coord.cell.column
            cell.value  = number
            cell.image  = self.displayBoard.getImageState(coord: coord)
            cell.active = self.displayBoard.getActiveState(coord: coord)
            cells.append(cell)
        }
        return cells
    }
    
    //
    // Only populated origin cells
    //
    func getCurrentOriginBoardState() -> [BoardCell] {
        var cells: [BoardCell] = []
        for y: Int in 0 ..< self.displayBoard.getRows() {
            for x: Int in 0 ..< self.displayBoard.getColumns() {
                for j: Int in 0 ..< self.displayBoard.gameImages[y][x].getRows() {
                    for k: Int in 0 ..< self.displayBoard.gameImages[y][x].getColumns() {
                        let coord: Coordinate = Coordinate(row: y, column: x, cell: (j, k))
                        let number: Int = self.sudokuBoard.getNumberFromOrigin(coord: coord)
                        if number > 0 {
                            var cell: BoardCell = BoardCell()
                            cell.row    = coord.row
                            cell.col    = coord.column
                            cell.crow   = coord.cell.row
                            cell.ccol   = coord.cell.column
                            cell.value  = number
                            cell.image  = self.displayBoard.getImageState(coord: coord)
                            cell.active = self.displayBoard.getActiveState(coord: coord)
                            cells.append(cell)
                        }
                    }
                }
            }
        }
        return cells
    }
    
    //
    // All solution cells
    //
    func getCurrentSolutionBoardState() -> [BoardCell] {
        var cells: [BoardCell] = []
        for y: Int in 0 ..< self.displayBoard.getRows() {
            for x: Int in 0 ..< self.displayBoard.getColumns() {
                for j: Int in 0 ..< self.displayBoard.gameImages[y][x].getRows() {
                    for k: Int in 0 ..< self.displayBoard.gameImages[y][x].getColumns() {
                        let coord: Coordinate = Coordinate(row: y, column: x, cell: (row: j, column: k))
                        var cell: BoardCell = BoardCell()
                        cell.row    = coord.row
                        cell.col    = coord.column
                        cell.crow   = coord.cell.row
                        cell.ccol   = coord.cell.column
                        cell.value  = self.sudokuBoard.getNumberFromSolution(coord: coord)
                        cell.image  = self.displayBoard.getImageState(coord: coord)
                        cell.active = self.displayBoard.getActiveState(coord: coord)
                        cells.append(cell)
                    }
                }
            }
        }
        return cells
    }

    //
    // handle the control panel also
    //
    func getCurrentControlPanelState() -> [BoardCell] {
        var cells: [BoardCell] = []
        for y: Int in 0 ..< self.controlPanelImages.getRows() {
            for x: Int in 0 ..< self.controlPanelImages.getColumns() {
                var cell: BoardCell = BoardCell()
                cell.row    = y
                cell.col    = x
                cell.crow   = 0
                cell.ccol   = 0
                cell.value  = (y * 2) + x + 1
                cell.image  = self.controlPanelImages.getImageState(coord: (row: y, column: x))
                cell.active = self.controlPanelImages.getActiveState(coord: (row: y, column: x))
                cells.append(cell)
            }
        }
        return cells
    }
    
    //----------------------------------------------------------------------------
    // has the user completed a row, col, cell or even fully used a number
    //----------------------------------------------------------------------------
    func setUserRowCompletion(coord: Coordinate) -> Bool {
        let locations: [Coordinate] = self.sudokuBoard.getCorrectLocationsFromCompletedRowOnGameBoard(coord: coord)
        if locations.isEmpty == true {
            return false
        }
        for coord in locations {
            self.setCoordToInactiveImage(coord: coord, number: self.sudokuBoard.getNumberFromGame(coord: coord))
        }
        return true
    }

    func setUserColumnCompletion(coord: Coordinate) -> Bool {
        let locations: [Coordinate] = self.sudokuBoard.getCorrectLocationsFromCompletedColumnOnGameBoard(coord: coord)
        if locations.isEmpty == true {
            return false
        }
        for coord in locations {
                self.setCoordToInactiveImage(coord: coord, number: self.sudokuBoard.getNumberFromGame(coord: coord))
        }
        return true
    }
    
    func setUserCellCompletion(coord: Coordinate) -> Bool {
        let locations: [Coordinate] = self.sudokuBoard.getCorrectLocationsFromCompletedCellOnGameBoard(coord: coord)
        if locations.isEmpty == true {
            return false
        }
        for coord in locations {
            self.setCoordToInactiveImage(coord: coord, number: self.sudokuBoard.getNumberFromGame(coord: coord))
        }
        return true
    }
    
    func setUserUsedNumberCompletion(number: Int) {
        let locations: [Coordinate] = self.sudokuBoard.getCorrectLocationsFromCompletedNumberOnGameBoard(number: number)
        if locations.isEmpty == true {
            return
        }
        for coord in locations {
            self.setCoordToInactiveImage(coord: coord, number: number)
        }
        return
    }
    
    //----------------------------------------------------------------------------
    // reset the control panel image and position / board position
    //----------------------------------------------------------------------------
    func resetControlPanelImage(index: Int) {
        guard (0..<10) ~= index else {
            return
        }
        let coord: (row: Int, column: Int) = (index / 2, column: index % 2)
        if index == 9 {
            self.setControlPanelToOriginImageValue(coord: coord)
        } else {
            if self.sudokuBoard.isNumberFullyUsedInGame(number: index + 1) {
                self.setControlPanelToInactiveImageValue(coord: coord)
            } else {
                self.setControlPanelToOriginImageValue(coord: coord)
            }
        }
        return
    }
    
    func setControlPanelPosition(coord: (row: Int, column: Int)) {
        self.userGame.currentGame.controlPosn.posn = coord
        return
    }
    
    func resetControlPanelPosition() {
        self.userGame.currentGame.controlPosn.posn = (-1, -1)
        return
    }

    func resetBoardPosition() {
        self.userGame.currentGame.boardPosn = Coordinate(row: -1, column: -1, cell:(row: -1, column: -1))
        return
    }
    
}

