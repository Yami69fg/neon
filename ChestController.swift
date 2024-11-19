import UIKit
import SpriteKit
import GameplayKit
import AVFAudio
import SnapKit

class ChestController: UIViewController {
    
    weak var ChestsScene: Chests?
    
    var neonCurrentLevel = 1
    var neonOnReturnToMenu: (() -> Void)?
    
    private let neonScoreBackgroundImageView = UIImageView()
    private let neonGlobalScoreLabel = UILabel()
    private let neonPauseButton = UIButton()
    
    let neonTargetScores = [3, 3, 3, 3, 2, 2, 2, 2, 1, 1, 1, 1]
    
    private var neonGlobalScore: Int {
        get {
            return UserDefaults.standard.integer(forKey: "neonScore")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "neonScore")
            neonGlobalScoreLabel.text = "\(newValue)"
        }
    }
    
    private var neonLevelCompletionStatus: [Bool] {
        get {
            if let savedData = UserDefaults.standard.data(forKey: "Chests") {
                if let savedArray = try? JSONDecoder().decode([Bool].self, from: savedData) {
                    return savedArray
                }
            }
            return Array(repeating: false, count: 12)
        }
        set {
            if let encodedData = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encodedData, forKey: "Chests")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        neonGlobalScoreLabel.text = "\(neonGlobalScore)"
        setupNeonScene()
        configureNeonUI()
        configureNeonActions()
    }
    
    private func setupNeonScene() {
        self.view = SKView(frame: view.frame)
        
        if let skView = self.view as? SKView {
            let SpaceScene = Chests(size: skView.bounds.size)
            self.ChestsScene = SpaceScene
            SpaceScene.winningChestCount = neonTargetScores[neonCurrentLevel]
            SpaceScene.neonGameController = self
            SpaceScene.scaleMode = .aspectFill
            skView.presentScene(SpaceScene)
        }
    }
    
    private func configureNeonUI() {
        neonScoreBackgroundImageView.image = UIImage(named: "NeonScore")
        neonScoreBackgroundImageView.contentMode = .scaleAspectFit
        view.addSubview(neonScoreBackgroundImageView)
        
        neonScoreBackgroundImageView.addSubview(neonGlobalScoreLabel)
        neonScoreBackgroundImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.size.equalTo(CGSize(width: 150, height: 55))
        }
        
        neonGlobalScoreLabel.font = UIFont(name: "Questrian", size: 22)
        neonGlobalScoreLabel.textColor = .white
        neonGlobalScoreLabel.textAlignment = .center
        neonGlobalScoreLabel.snp.makeConstraints { $0.center.equalToSuperview() }
        
        view.addSubview(neonPauseButton)
        neonPauseButton.setImage(UIImage(named: "NeonSettings"), for: .normal)
        neonPauseButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.right.equalToSuperview().inset(10)
            make.width.height.equalTo(55)
        }
    }
    
    private func configureNeonActions() {
        neonPauseButton.addTarget(self, action: #selector(neonHandlePauseButtonPress), for: .touchUpInside)
        addNeonSound(button: neonPauseButton)
    }
    
    @objc private func neonHandlePauseButtonPress() {
        ChestsScene?.neonPauseGame()
        let neonController = NeonSettingsController()
        neonController.neonOnReturnToMenu = { [weak self] in
            self?.dismiss(animated: false)
            self?.neonOnReturnToMenu?()
        }
        neonController.neonResume = { [weak self] in
            self?.ChestsScene?.neonResumeGame()
        }
        neonController.modalPresentationStyle = .overCurrentContext
        self.present(neonController, animated: false, completion: nil)
    }
    
    func neonEndGame(neonScore: Int, neonIsWin: Bool) {
        let endViewController = NeonGameOverController()
        endViewController.neonIsWin = neonIsWin
        endViewController.neonScore = neonScore
        if neonIsWin {
            neonCompleteLevel(at: neonCurrentLevel+1)
        }
        ChestsScene?.neonPauseGame()
        endViewController.neonOnReturnToMenu = { [weak self] in
            self?.dismiss(animated: false)
            self?.neonOnReturnToMenu?()
        }
        endViewController.neonOnRestart = { [weak self] in
            self?.ChestsScene?.neonRestartGame()
        }
        endViewController.modalPresentationStyle = .overCurrentContext
        self.present(endViewController, animated: false, completion: nil)
    }
    
    func neonUpdateScore() {
        neonGlobalScore += 10
    }
    
    func neonCompleteLevel(at index: Int) {
        guard index >= 0 && index < neonLevelCompletionStatus.count else { return }
        neonLevelCompletionStatus[index] = true
    }

}
