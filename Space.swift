import SpriteKit
import UIKit
import AVFAudio

class Space: SKScene {
    
    weak var neonGameController: SpaceController?
    var neonTargetScore = 0
    private var meteorDestroyedCount = 0
    
    var neonPlayerAudio: AVAudioPlayer?
    
    private var spaceShip: SKSpriteNode!
    private let shipWidthRatio: CGFloat = 1/5
    private var moveDistance: CGFloat {
        return self.size.width * shipWidthRatio
    }
    private var isGamePaused = false
    private var isMoving = false

    override func didMove(to view: SKView) {
        backgroundColor = .black
        setupBackground()
        setupSpaceShip()
        spawnEnemiesPeriodically()
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
    }
    
    private func setupBackground() {
        let background = SKSpriteNode(imageNamed:  UserDefaults.standard.string(forKey: "img") ?? "NeonBackGround")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.size = size
        background.zPosition = -1
        addChild(background)
    }
    
    private func setupSpaceShip() {
        let shipSize = CGSize(width: size.width * shipWidthRatio, height: size.width * shipWidthRatio)
        spaceShip = SKSpriteNode(imageNamed: "SpaceShip")
        spaceShip.size = shipSize
        spaceShip.position = CGPoint(x: size.width / 2, y: spaceShip.size.height / 2 + 50)
        spaceShip.name = "SpaceShip"
        
        let physicsScale: CGFloat = 0.5
        spaceShip.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: spaceShip.size.width * physicsScale, height: spaceShip.size.height * physicsScale))
        spaceShip.physicsBody?.isDynamic = true
        spaceShip.physicsBody?.categoryBitMask = PhysicsCategory.spaceShip
        spaceShip.physicsBody?.contactTestBitMask = PhysicsCategory.neonMeteor
        spaceShip.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        addChild(spaceShip)
    }
    
    private enum MoveDirection {
        case left, right
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if !isGamePaused {
            if location.x < size.width / 2 {
                moveSpaceShip(direction: .left)
            } else {
                moveSpaceShip(direction: .right)
            }
        }
    }
    
    private func moveSpaceShip(direction: MoveDirection) {
        if isMoving { return }

        var newPosition = spaceShip.position.x
        switch direction {
        case .left:
            newPosition -= moveDistance
        case .right:
            newPosition += moveDistance
        }

        newPosition = max(spaceShip.size.width / 2, min(size.width - spaceShip.size.width / 2, newPosition))

        isMoving = true
        
        if UserDefaults.standard.bool(forKey: "neonSound") {
            guard let url = Bundle.main.url(forResource: "neonButton", withExtension: "wav") else {
                return
            }
            do {
                neonPlayerAudio = try AVAudioPlayer(contentsOf: url)
                neonPlayerAudio?.play()
            } catch {
            }
        }

        let moveAction = SKAction.moveTo(x: newPosition, duration: 0.2)
        let completionAction = SKAction.run {
            self.isMoving = false
        }

        let sequence = SKAction.sequence([moveAction, completionAction])
        spaceShip.run(sequence)
    }

    func neonPauseGame() {
        if !isGamePaused {
            isGamePaused = true
            isPaused = true
        }
    }
    
    func neonResumeGame() {
        if isGamePaused {
            isGamePaused = false
            isPaused = false
        }
    }
    
    func neonRestartGame() {
        removeAllChildren()
        setupBackground()
        setupSpaceShip()
        meteorDestroyedCount = 0
        isGamePaused = false
        isPaused = false
    }
    
    private func spawnEnemiesPeriodically() {
        let spawnAction = SKAction.run { [weak self] in
            self?.spawnEnemies()
        }
        let waitAction = SKAction.wait(forDuration: 2.0)
        let sequence = SKAction.sequence([spawnAction, waitAction])
        let repeatAction = SKAction.repeatForever(sequence)
        run(repeatAction)
    }
    
    private func spawnEnemies() {
        updateMeteorDestroyedCount()
        let enemyCount = 5
        let enemySpacing: CGFloat = size.width / CGFloat(enemyCount)
        let missingEnemyIndex = Int.random(in: 0..<enemyCount)
        
        for i in 0..<enemyCount {
            if i == missingEnemyIndex { continue }
            
            let enemy = SKSpriteNode(imageNamed: "NeonMeteor")
            let sizeRatio: CGFloat = 1/5
            let enemySize = CGSize(width: size.width * sizeRatio, height: size.width * sizeRatio)
            enemy.size = enemySize
            
            let xPosition = CGFloat(i) * enemySpacing + enemySize.width / 2
            enemy.position = CGPoint(x: xPosition, y: size.height + enemySize.height / 2)
            enemy.name = "NeonMeteor"
            
            let physicsScale: CGFloat = 0.5
            enemy.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: enemy.size.width * physicsScale, height: enemy.size.height * physicsScale))
            enemy.physicsBody?.isDynamic = true
            enemy.physicsBody?.categoryBitMask = PhysicsCategory.neonMeteor
            enemy.physicsBody?.contactTestBitMask = PhysicsCategory.spaceShip
            enemy.physicsBody?.collisionBitMask = PhysicsCategory.none
            
            addChild(enemy)
            
            let moveAction = SKAction.moveTo(y: -enemySize.height / 2, duration: 4.0)
            let removeAction = SKAction.removeFromParent()
            let sequence = SKAction.sequence([moveAction, removeAction])
            enemy.run(sequence)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if meteorDestroyedCount >= neonTargetScore {
            neonGameController?.neonEndGame(neonScore: meteorDestroyedCount, neonIsWin: true)
        }
    }
    
    private func updateMeteorDestroyedCount() {
        meteorDestroyedCount += 1
        neonGameController?.neonUpdateScore()
    }
}

struct PhysicsCategory {
    static let none: UInt32 = 0
    static let spaceShip: UInt32 = 0b1
    static let neonMeteor: UInt32 = 0b10
}

extension Space: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if (firstBody.categoryBitMask == PhysicsCategory.spaceShip && secondBody.categoryBitMask == PhysicsCategory.neonMeteor) ||
           (firstBody.categoryBitMask == PhysicsCategory.neonMeteor && secondBody.categoryBitMask == PhysicsCategory.spaceShip) {
            neonGameController?.neonEndGame(neonScore: meteorDestroyedCount, neonIsWin: false)
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == PhysicsCategory.neonMeteor && secondBody.categoryBitMask == PhysicsCategory.none {
            updateMeteorDestroyedCount()
        }
    }
}
