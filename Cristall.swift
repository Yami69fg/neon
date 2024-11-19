import SpriteKit
import UIKit
import AVFAudio

class Cristall: SKScene {
    
    var neonPlayerAudio: AVAudioPlayer?
    
    weak var neonGameController: CristallController?
    var crystalCount = 0
    
    private let containerNames = ["RedContainer", "YellowContainer", "BlueContainer", "GreenContainer", "PurpleContainer"]
    private let crystalNames = ["RedCristall", "YellowCristall", "BlueCristall", "GreenCristall", "PurpleCristall"]
    
    private var containers: [SKSpriteNode] = []
    private var crystals: [SKSpriteNode] = []
    private var selectedCrystal: SKSpriteNode?
    
    private var score = 0
    private var mistakes = 0
    private var isGamePaused = false
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupContainers()
        generateCrystals()
    }
    
    private func setupBackground() {
        let background = SKSpriteNode(imageNamed:  UserDefaults.standard.string(forKey: "img") ?? "NeonBackGround")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.size = size
        background.zPosition = 0
        addChild(background)
    }
    
    private func setupContainers() {
        let containerSize = CGSize(width: size.width / 6, height: size.width / 5)
        let yOffset: CGFloat = 80
        
        for (index, containerName) in containerNames.enumerated() {
            let container = SKSpriteNode(imageNamed: containerName)
            container.size = containerSize
            let xPos = CGFloat(index) * (containerSize.width + 10) + containerSize.width / 2 + 10
            container.position = CGPoint(x: xPos, y: yOffset)
            container.name = containerName
            container.zPosition = 1
            addChild(container)
            containers.append(container)
        }
    }
    
    private func generateCrystals() {
        let crystalSize = CGSize(width: size.width / 10, height: size.width / 10)
        
        for _ in 0..<crystalCount {
            let randomCrystalName = crystalNames.randomElement()!
            let crystal = SKSpriteNode(imageNamed: randomCrystalName)
            crystal.size = crystalSize
            
            var position: CGPoint
            repeat {
                position = CGPoint(
                    x: CGFloat.random(in: crystalSize.width / 2...(size.width - crystalSize.width / 2)),
                    y: CGFloat.random(in: (size.height * 0.2)...(size.height * 0.8))
                )
            } while crystals.contains(where: { $0.frame.intersects(CGRect(origin: position, size: crystalSize)) })
            
            crystal.position = position
            crystal.name = randomCrystalName
            crystal.zPosition = 2
            crystals.append(crystal)
            addChild(crystal)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, !isGamePaused else { return }
        let location = touch.location(in: self)
        
        if let crystal = nodes(at: location).first(where: { $0 is SKSpriteNode }) as? SKSpriteNode, crystalNames.contains(crystal.name ?? "") {
            selectCrystal(crystal)
        } else if let container = nodes(at: location).first as? SKSpriteNode, containerNames.contains(container.name ?? ""), let selectedCrystal = selectedCrystal {
            checkMatching(container: container, crystal: selectedCrystal)
        }
    }
    
    private func selectCrystal(_ crystal: SKSpriteNode) {
        if let currentlySelected = selectedCrystal {
            currentlySelected.setScale(1.0)
        }
        
        selectedCrystal = crystal
        crystal.setScale(1.5)
    }
    
    private func checkMatching(container: SKSpriteNode, crystal: SKSpriteNode) {
        guard let crystalName = crystal.name, let containerName = container.name else { return }
        
        let crystalColor = crystalName.replacingOccurrences(of: "Cristall", with: "")
        let containerColor = containerName.replacingOccurrences(of: "Container", with: "")
        
        if crystalColor == containerColor {
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
            score += 1
            neonGameController?.neonUpdateScore()
            crystal.removeFromParent()
            selectedCrystal = nil
        } else {
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
            mistakes += 1
            if mistakes > 3 {
                neonGameController?.neonEndGame(neonScore: score, neonIsWin: false)
            }
        }

        if crystals.filter({ $0.parent != nil }).isEmpty {
            neonGameController?.neonEndGame(neonScore: score, neonIsWin: true)
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
        containers.removeAll()
        crystals.removeAll()
        selectedCrystal = nil
        score = 0
        mistakes = 0
        
        setupBackground()
        setupContainers()
        generateCrystals()
        
        isGamePaused = false
        isPaused = false
    }
}
