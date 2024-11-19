import UIKit
import SnapKit

class NeonLevelsController: UIViewController {
    
    private let neonBackgroundView = UIImageView()
    private let neonCloseButton = UIButton()
    private let neonScoreContainerImage = UIImageView()
    private let neonScoreLabel = UILabel()
    private let neonShadowOverlay = UIImageView()
    private let neonDopContainerImage = UIImageView()
    private let neonLevelHeadingImage = UIImageView()
    private let neonGuideButton = UIButton()
    
    private var neonLevelButtonsArray: [UIButton] = []
    private var neonTotalScore: Int {
        get {
            return UserDefaults.standard.integer(forKey: "neonScore")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "neonScore")
            neonScoreLabel.text = "\(newValue)"
        }
    }
    
    private var neonArray: [Bool] {
        get {
            if let savedData = UserDefaults.standard.data(forKey: neonKey) {
                if let savedArray = try? JSONDecoder().decode([Bool].self, from: savedData) {
                    return savedArray
                }
            }
            return Array(repeating: false, count: 12)
        }
        set {
            if let encodedData = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encodedData, forKey: neonKey)
            }
        }
    }
    
    var neonOnReturnToMenu: (() -> ())?
    var neonGameType = 1
    var neonKey = "Space"

    override func viewDidLoad() {
        super.viewDidLoad()
        neonArray[0] = true
        neonScoreLabel.text = "\(neonTotalScore)"
        configureNeonInterface()
        configureNeonActions()
        initializeNeonLevels()
    }

    private func configureNeonInterface() {
        neonBackgroundView.image = UIImage(named: "NeonBackGround")
        neonBackgroundView.contentMode = .scaleAspectFill
        view.addSubview(neonBackgroundView)
        neonBackgroundView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        neonCloseButton.setImage(UIImage(named: "NeonToBack"), for: .normal)
        view.addSubview(neonCloseButton)
        neonCloseButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.left.equalToSuperview().inset(20)
            make.width.height.equalTo(45)
        }

        neonScoreContainerImage.image = UIImage(named: "NeonScore")
        view.addSubview(neonScoreContainerImage)
        neonScoreContainerImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.size.equalTo(CGSize(width: 150, height: 55))
        }
        
        neonScoreLabel.font = UIFont(name: "Questrian", size: 22)
        neonScoreLabel.textColor = .white
        neonScoreLabel.textAlignment = .center
        neonScoreContainerImage.addSubview(neonScoreLabel)
        neonScoreLabel.snp.makeConstraints { $0.center.equalToSuperview() }

        neonDopContainerImage.image = UIImage(named: "NeonForElements")
        neonDopContainerImage.contentMode = .scaleAspectFit
        neonDopContainerImage.isUserInteractionEnabled = true
        view.addSubview(neonDopContainerImage)
        neonDopContainerImage.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.height.equalToSuperview().multipliedBy(0.4)
        }
        
        neonLevelHeadingImage.image = UIImage(named: "Levels")
        neonLevelHeadingImage.contentMode = .scaleAspectFit
        view.addSubview(neonLevelHeadingImage)
        neonLevelHeadingImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(neonDopContainerImage.snp.top).offset(50)
            $0.size.equalTo(CGSize(width: 300, height: 150))
        }
        
        neonGuideButton.setImage(UIImage(named: "NeonInstruction"), for: .normal)
        view.addSubview(neonGuideButton)
        neonGuideButton.snp.makeConstraints { make in
            make.top.equalTo(neonDopContainerImage.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
    }
    
    private func initializeNeonLevels() {
        let columns = 4
        for index in 0..<12 {
            let levelButton = UIButton(type: .custom)
            levelButton.tag = index
            levelButton.addTarget(self, action: #selector(neonLevelTapped(_:)), for: .touchUpInside)
            addNeonSound(button: levelButton)
            neonLevelButtonsArray.append(levelButton)
            neonDopContainerImage.addSubview(levelButton)
            
            levelButton.snp.makeConstraints { make in
                make.width.equalTo(neonDopContainerImage).multipliedBy(0.175)
                make.height.equalTo(levelButton.snp.width)
                
                if index % columns == 0 {
                    make.left.equalTo(neonDopContainerImage.snp.left).offset(35)
                } else {
                    make.left.equalTo(neonDopContainerImage.subviews[index - 1].snp.right).offset(5)
                }
                
                if index / columns == 0 {
                    make.top.equalTo(neonDopContainerImage.snp.top).offset(50)
                } else {
                    make.top.equalTo(neonDopContainerImage.subviews[index - columns].snp.bottom).offset(15)
                }
            }
            
            configureNeonButtonAppearance(levelButton, forIndex: index)
        }
    }
    
    private func configureNeonButtonAppearance(_ levelButton: UIButton, forIndex index: Int) {
        let levelNumber = index + 1
        
        if neonArray[index] {
            levelButton.setImage(UIImage(named: "NeonOpen"), for: .normal)
            let levelLabel = UILabel()
            levelLabel.text = "\(levelNumber)"
            levelLabel.textColor = .white
            levelLabel.textAlignment = .center
            levelLabel.font = UIFont(name: "Questrian", size: 20)
            levelButton.isUserInteractionEnabled = true
            levelButton.addSubview(levelLabel)
            
            levelLabel.snp.makeConstraints { $0.center.equalToSuperview() }
        } else {
            levelButton.setImage(UIImage(named: "NeonLock"), for: .normal)
            levelButton.isUserInteractionEnabled = false
        }
    }
    
    private func configureNeonActions() {
        neonCloseButton.addTarget(self, action: #selector(neonCloseTapped), for: .touchUpInside)
        addNeonSound(button: neonCloseButton)
        neonGuideButton.addTarget(self, action: #selector(neonGuideTapped), for: .touchUpInside)
        addNeonSound(button: neonGuideButton)
    }

    @objc private func neonCloseTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func neonGuideTapped() {
        let instructionController = NeonGuideControll()
        instructionController.neonInstructionType = neonGameType
        instructionController.modalTransitionStyle = .crossDissolve
        instructionController.modalPresentationStyle = .fullScreen
        present(instructionController, animated: false)
    }

    @objc private func neonLevelTapped(_ sender: UIButton) {
        let levelIndex = sender.tag
        let levelController: UIViewController
        
        switch neonGameType {
        case 1:
            let controller = SpaceController()
            controller.neonOnReturnToMenu = { [weak self] in
                self?.dismiss(animated: false, completion: nil)
                self?.neonOnReturnToMenu?()
            }
            controller.neonCurrentLevel = levelIndex
            levelController = controller
        case 2:
            let controller = ChestController()
            controller.neonOnReturnToMenu = { [weak self] in
                self?.dismiss(animated: false, completion: nil)
                self?.neonOnReturnToMenu?()
            }
            controller.neonCurrentLevel = levelIndex
            levelController = controller
        case 3:
            let controller = CristallController()
            controller.neonOnReturnToMenu = { [weak self] in
                self?.dismiss(animated: false, completion: nil)
                self?.neonOnReturnToMenu?()
            }
            controller.neonCurrentLevel = levelIndex
            levelController = controller
        default:
            return
        }
        
        levelController.modalTransitionStyle = .crossDissolve
        levelController.modalPresentationStyle = .fullScreen
        present(levelController, animated: false)
    }
}

