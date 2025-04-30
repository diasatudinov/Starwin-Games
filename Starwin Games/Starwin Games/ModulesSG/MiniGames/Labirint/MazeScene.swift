import SpriteKit
import UIKit

class MazeScene: SKScene {
    // MARK: - Properties
    let tileSize = CGSize(width: 40, height: 40)
    
    // 0 = empty, 1 = wall, 2 = exit
    let maze: [[Int]] = [
        [1,1,1,1,1,1,1,1,1,1],
        [1,0,0,0,1,0,0,0,2,1],
        [1,0,1,0,1,0,1,0,1,1],
        [1,0,1,0,0,0,1,0,0,1],
        [1,0,1,1,1,0,1,1,0,1],
        [1,0,0,0,1,0,0,0,0,1],
        [1,1,1,0,1,1,1,1,0,1],
        [1,0,0,0,0,0,0,1,0,1],
        [1,0,1,1,1,1,0,0,0,1],
        [1,1,1,1,1,1,1,1,1,1]
    ]
    
    var player: SKSpriteNode!
    var exitNode: SKSpriteNode!
    var timerLabel: SKLabelNode!
    var restartButton: SKLabelNode!
    var rewardButton: SKLabelNode!
    
    var timeLeft = 60 {
        didSet { timerLabel.text = "Time: \(timeLeft)" }
    }
    var gameTimer: Timer?
    
    // MARK: - Scene Lifecycle
    override func didMove(to view: SKView) {
        backgroundColor = .black
        setupMaze()
        setupPlayer()
        setupExit()
        setupUI()
        startTimer()
        setupSwipeGestures()
    }
    
    // MARK: - Setup Methods
    private func setupMaze() {
        for (rowIndex, row) in maze.enumerated() {
            for (colIndex, tile) in row.enumerated() {
                let pos = CGPoint(x: CGFloat(colIndex) * tileSize.width,
                                  y: CGFloat(maze.count - rowIndex - 1) * tileSize.height)
                if tile == 1 {
                    let wall = SKSpriteNode(color: .gray, size: tileSize)
                    wall.position = pos
                    addChild(wall)
                }
            }
        }
    }
    
    private func setupPlayer() {
        // Start at first empty cell [1][1]
        let start = CGPoint(x: tileSize.width, y: CGFloat(maze.count-2) * tileSize.height)
        player = SKSpriteNode(color: .blue, size: tileSize)
        player.position = start
        addChild(player)
    }
    
    private func setupExit() {
        // Exit at cell marked 2
        for (rowIndex, row) in maze.enumerated() {
            if let colIndex = row.firstIndex(of: 2) {
                let pos = CGPoint(x: CGFloat(colIndex) * tileSize.width,
                                  y: CGFloat(maze.count - rowIndex - 1) * tileSize.height)
                exitNode = SKSpriteNode(color: .green, size: tileSize)
                exitNode.position = pos
                addChild(exitNode)
                break
            }
        }
    }
    
    private func setupUI() {
        timerLabel = SKLabelNode(text: "Time: \(timeLeft)")
        timerLabel.fontName = "AvenirNext-Bold"
        timerLabel.fontSize = 20
        timerLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 40)
        addChild(timerLabel)
        
        restartButton = SKLabelNode(text: "Restart")
        restartButton.name = "restart"
        restartButton.fontName = "AvenirNext"
        restartButton.fontSize = 18
        restartButton.position = CGPoint(x: frame.minX + 60, y: frame.maxY - 40)
        addChild(restartButton)
        
        rewardButton = SKLabelNode(text: "Claim Reward")
        rewardButton.name = "reward"
        rewardButton.fontName = "AvenirNext"
        rewardButton.fontSize = 18
        rewardButton.position = CGPoint(x: frame.maxX - 80, y: frame.maxY - 40)
        rewardButton.isHidden = true
        addChild(rewardButton)
    }
    
    // MARK: - Timer
    private func startTimer() {
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.timeLeft -= 1
            if self.timeLeft <= 0 {
                self.gameOver(didWin: false)
            }
        }
    }
    
    private func stopTimer() {
        gameTimer?.invalidate()
        gameTimer = nil
    }
    
    // MARK: - Swipe Controls
    private func setupSwipeGestures() {
        guard let view = self.view else { return }
        let directions: [UISwipeGestureRecognizer.Direction] = [.up, .down, .left, .right]
        for dir in directions {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
            swipe.direction = dir
            view.addGestureRecognizer(swipe)
        }
    }
    
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        var delta = CGVector(dx: 0, dy: 0)
        switch gesture.direction {
        case .up: delta.dy = tileSize.height
        case .down: delta.dy = -tileSize.height
        case .left: delta.dx = -tileSize.width
        case .right: delta.dx = tileSize.width
        default: break
        }
        movePlayer(by: delta)
    }
    
    private func movePlayer(by delta: CGVector) {
        let newPos = CGPoint(x: player.position.x + delta.dx,
                             y: player.position.y + delta.dy)
        let col = Int(newPos.x / tileSize.width)
        let row = maze.count - 1 - Int(newPos.y / tileSize.height)
        guard row >= 0, row < maze.count, col >= 0, col < maze[0].count else { return }
        if maze[row][col] != 1 {
            let move = SKAction.move(to: newPos, duration: 0.1)
            player.run(move) {
                if maze[row][col] == 2 {
                    self.gameOver(didWin: true)
                }
            }
        }
    }
    
    // MARK: - Touches for Buttons
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodes = self.nodes(at: location)
        for node in nodes {
            if node.name == "restart" {
                restartGame()
            } else if node.name == "reward", !rewardButton.isHidden {
                claimReward()
            }
        }
    }
    
    // MARK: - Game Flow
    private func gameOver(didWin: Bool) {
        stopTimer()
        if didWin {
            rewardButton.isHidden = false
        } else {
            // Show game over logic
            let gameOverLabel = SKLabelNode(text: "Time's up!")
            gameOverLabel.fontName = "AvenirNext-Bold"
            gameOverLabel.fontSize = 30
            gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY)
            addChild(gameOverLabel)
        }
    }
    
    private func restartGame() {
        removeAllChildren()
        timeLeft = 60
        didMove(to: self.view!)
    }
    
    private func claimReward() {
        // Handle reward logic, e.g., present a popup or transition
        let rewardLabel = SKLabelNode(text: "You earned 100 points!")
        rewardLabel.fontName = "AvenirNext-Bold"
        rewardLabel.fontSize = 24
        rewardLabel.position = CGPoint(x: frame.midX, y: frame.midY - 40)
        addChild(rewardLabel)
        rewardButton.isHidden = true
    }
}