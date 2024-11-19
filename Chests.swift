import SpriteKit
import UIKit
import AVFAudio

class Chests: SKScene {
    
    weak var neonGameController: ChestController?
    
    var neonPlayerAudio: AVAudioPlayer?
    
    private var backgroundNode: SKSpriteNode!
    private let maxAttempts = 5
    private var currentAttempts = 0
    private var winCount = 0
    private var chestButtons: [SKSpriteNode] = []
    private var winningChests: Set<Int> = []
    
    private var isGamePaused = false
    
    private let totalChests = 15
    var winningChestCount = 3
    private let chestSizeRatio: CGFloat = 1/5
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupChests()
        generateWinningChests()
    }
    
    private func setupBackground() {
        let background = SKSpriteNode(imageNamed: UserDefaults.standard.string(forKey: "img") ?? "NeonBackGround")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.size = size
        background.zPosition = -1
        addChild(background)
    }
    
    private func generateWinningChests() {
        while winningChests.count < winningChestCount {
            let randomIndex = Int.random(in: 0..<totalChests)
            winningChests.insert(randomIndex)
        }
    }
    
    private func setupChests() {
        let chestSize = CGSize(width: size.width * chestSizeRatio, height: size.width * chestSizeRatio)
        let safePadding: CGFloat = 20
        let maxRetries = 100

        let spawnAreaWidth = size.width
        let spawnAreaHeight = size.height * 0.8
        let xOffset = (size.width - spawnAreaWidth) / 2
        let yOffset = (size.height - spawnAreaHeight) / 2

        for _ in 0..<totalChests {
            var chestNode: SKSpriteNode?
            var position: CGPoint
            var attempts = 0
            
            repeat {
                position = CGPoint(
                    x: CGFloat.random(in: chestSize.width / 2 + xOffset + safePadding...(xOffset + spawnAreaWidth - chestSize.width / 2 - safePadding)),
                    y: CGFloat.random(in: chestSize.height / 2 + yOffset + safePadding...(yOffset + spawnAreaHeight - chestSize.height / 2 - safePadding))
                )
                chestNode = createChest(at: position, size: chestSize)
                attempts += 1
            } while (!isPositionValid(chestNode!) && attempts < maxRetries)
            
            if let chest = chestNode {
                chestButtons.append(chest)
                addChild(chest)
            }
        }
    }
    
    private func createChest(at position: CGPoint, size: CGSize) -> SKSpriteNode {
        let chest = SKSpriteNode(imageNamed: "NeonChest")
        chest.position = position
        chest.size = size
        chest.name = "chest"
        chest.isUserInteractionEnabled = false
        return chest
    }
    
    private func isPositionValid(_ chest: SKSpriteNode) -> Bool {
        for existingChest in chestButtons {
            if chest.frame.intersects(existingChest.frame) {
                return false
            }
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, currentAttempts < maxAttempts, !isGamePaused else { return }
        let location = touch.location(in: self)
        
        if let chest = nodes(at: location).first as? SKSpriteNode, chest.name == "chest" {
            handleChestSelection(chest)
        }
    }
    
    private func handleChestSelection(_ chest: SKSpriteNode) {
        if UserDefaults.standard.bool(forKey: "neonSound") {
            guard let url = Bundle.main.url(forResource: "openChest", withExtension: "wav") else {
                return
            }
            do {
                neonPlayerAudio = try AVAudioPlayer(contentsOf: url)
                neonPlayerAudio?.play()
            } catch {
            }
        }
        guard chest.userData == nil else { return }
        
        guard let chestIndex = chestButtons.firstIndex(of: chest) else { return }
        currentAttempts += 1
        if winningChests.contains(chestIndex) {
            chest.texture = SKTexture(imageNamed: "NeonCristallChest")
            neonGameController?.neonUpdateScore()
            isGamePaused = true
            run(SKAction.sequence([
                SKAction.wait(forDuration: 1.0),
                SKAction.run { [weak self] in
                    self?.neonGameController?.neonEndGame(neonScore: 10, neonIsWin: true)
                }
            ]))
            
        } else {
            chest.texture = SKTexture(imageNamed: "NeonOpenChest")
        }
        chest.userData = ["opened": true]
        checkGameOver()
    }
    
    private func checkGameOver() {
        if currentAttempts >= maxAttempts && winCount < winningChestCount {
            run(SKAction.sequence([
                SKAction.wait(forDuration: 1.0),
                SKAction.run { [weak self] in
                    self?.neonGameController?.neonEndGame(neonScore: 0, neonIsWin: false)
                }
            ]))
        }
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
        chestButtons.removeAll()
        winningChests.removeAll()
        currentAttempts = 0
        
        setupBackground()
        setupChests()
        generateWinningChests()
        
        isGamePaused = false
        isPaused = false
    }
}
