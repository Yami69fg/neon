import UIKit
import SpriteKit
import GameplayKit
import AVFAudio
import SnapKit

class SpaceController: UIViewController {
    
    weak var SpaceScene: Space?
    
    var neonCurrentLevel = 1
    var neonOnReturnToMenu: (() -> Void)?
    
    private let neonScoreBackgroundImageView = UIImageView()
    private let neonGlobalScoreLabel = UILabel()
    private let neonPauseButton = UIButton()
    
    let neonTargetScores = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120]
    
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
            if let savedData = UserDefaults.standard.data(forKey: "Space") {
                if let savedArray = try? JSONDecoder().decode([Bool].self, from: savedData) {
                    return savedArray
                }
            }
            return Array(repeating: false, count: 12)
        }
        set {
            if let encodedData = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encodedData, forKey: "Space")
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
            let SpaceScene = Space(size: skView.bounds.size)
            self.SpaceScene = SpaceScene
            SpaceScene.neonTargetScore = neonTargetScores[neonCurrentLevel]
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
        SpaceScene?.neonPauseGame()
        let neonController = NeonSettingsController()
        neonController.neonOnReturnToMenu = { [weak self] in
            self?.dismiss(animated: false)
            self?.neonOnReturnToMenu?()
        }
        neonController.neonResume = { [weak self] in
            self?.SpaceScene?.neonResumeGame()
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
        SpaceScene?.neonPauseGame()
        endViewController.neonOnReturnToMenu = { [weak self] in
            self?.dismiss(animated: false)
            self?.neonOnReturnToMenu?()
        }
        endViewController.neonOnRestart = { [weak self] in
            self?.SpaceScene?.neonRestartGame()
        }
        endViewController.modalPresentationStyle = .overCurrentContext
        self.present(endViewController, animated: false, completion: nil)
    }
    
    func neonUpdateScore() {
        neonGlobalScore += 1
    }
    
    func neonCompleteLevel(at index: Int) {
        guard index >= 0 && index < neonLevelCompletionStatus.count else { return }
        neonLevelCompletionStatus[index] = true
    }

}
