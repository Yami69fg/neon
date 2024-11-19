import UIKit
import SnapKit

class NeonGamesController: UIViewController {
    
    var neonBackMenuClosure: (() -> ())?

    private let neonBackdropImageView = UIImageView()
    private let neonReturnButton = UIButton()
    private let neonPortalButton = UIButton()
    private let neonMarketButton = UIButton()
    private let neonAchievementButton = UIButton()
    private let neonScoreBackgroundImageView = UIImageView()
    private let neonGlobalScoreLabel = UILabel()

    private var neonGlobalScore: Int {
        get {
            return UserDefaults.standard.integer(forKey: "neonScore")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "neonScore")
            neonGlobalScoreLabel.text = "\(newValue)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNeonUI()
        setupNeonActions()
        neonGlobalScoreLabel.text = "\(neonGlobalScore)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        neonGlobalScoreLabel.text = "\(neonGlobalScore)"
    }

    private func configureNeonUI() {
        setupNeonBackdrop()
        setupNeonScoreElements()
        setupNeonReturnButton()
        setupNeonPortalButton()
        setupNeonMarketButton()
        setupNeonAchievementButton()
    }
    
    private func setupNeonBackdrop() {
        neonBackdropImageView.image = UIImage(named: "NeonBackGround")
        neonBackdropImageView.contentMode = .scaleAspectFill
        view.addSubview(neonBackdropImageView)
        neonBackdropImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupNeonScoreElements() {
        neonScoreBackgroundImageView.image = UIImage(named: "NeonScore")
        view.addSubview(neonScoreBackgroundImageView)
        
        neonGlobalScoreLabel.textColor = .white
        neonGlobalScoreLabel.textAlignment = .center
        neonGlobalScoreLabel.font = UIFont(name: "Questrian", size: 20)
        neonGlobalScoreLabel.text = "\(neonGlobalScore)"
        
        neonScoreBackgroundImageView.addSubview(neonGlobalScoreLabel)
        
        neonScoreBackgroundImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(65)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(45)
        }
        
        neonGlobalScoreLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupNeonReturnButton() {
        neonReturnButton.setImage(UIImage(named: "NeonToBack"), for: .normal)
        view.addSubview(neonReturnButton)
        neonReturnButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.left.equalToSuperview().inset(20)
            make.width.height.equalTo(45)
        }
        neonReturnButton.addTarget(self, action: #selector(neonReturnToMenu), for: .touchUpInside)
    }
    
    private func setupNeonPortalButton() {
        neonPortalButton.setImage(UIImage(named: "Space"), for: .normal)
        view.addSubview(neonPortalButton)
        neonPortalButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(120)
            make.width.equalToSuperview().multipliedBy(0.52)
            make.height.equalToSuperview().multipliedBy(0.22)
        }
        neonPortalButton.addTarget(self, action: #selector(neonOpenPortal), for: .touchUpInside)
    }
    
    private func setupNeonMarketButton() {
        neonMarketButton.setImage(UIImage(named: "Chests"), for: .normal)
        view.addSubview(neonMarketButton)
        neonMarketButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(neonPortalButton.snp.bottom).offset(20)
            make.width.equalToSuperview().multipliedBy(0.52)
            make.height.equalToSuperview().multipliedBy(0.22)
        }
        neonMarketButton.addTarget(self, action: #selector(neonOpenMarket), for: .touchUpInside)
    }
    
    private func setupNeonAchievementButton() {
        neonAchievementButton.setImage(UIImage(named: "Cristalls"), for: .normal)
        view.addSubview(neonAchievementButton)
        neonAchievementButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(neonMarketButton.snp.bottom).offset(20)
            make.width.equalToSuperview().multipliedBy(0.52)
            make.height.equalToSuperview().multipliedBy(0.22)
        }
        neonAchievementButton.addTarget(self, action: #selector(neonViewAchievements), for: .touchUpInside)
    }


    private func setupNeonActions() {
        neonReturnButton.addTarget(self, action: #selector(neonReturnToMenu), for: .touchUpInside)
        addNeonSound(button: neonReturnButton)
        neonPortalButton.addTarget(self, action: #selector(neonOpenPortal), for: .touchUpInside)
        addNeonSound(button: neonPortalButton)
        neonMarketButton.addTarget(self, action: #selector(neonOpenMarket), for: .touchUpInside)
        addNeonSound(button: neonMarketButton)
        neonAchievementButton.addTarget(self, action: #selector(neonViewAchievements), for: .touchUpInside)
        addNeonSound(button: neonAchievementButton)
    }

    @objc private func neonReturnToMenu() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func neonOpenPortal() {
        presentNeonGameViewController(game: 1, key: "Space")
    }

    @objc private func neonOpenMarket() {
        presentNeonGameViewController(game: 2, key: "Chests")
    }

    @objc private func neonViewAchievements() {
        presentNeonGameViewController(game: 3, key: "Cristall")
    }

    private func presentNeonGameViewController(game: Int, key: String) {
        let viewController = NeonLevelsController()
        viewController.neonGameType = game
        viewController.neonKey = key
        viewController.neonOnReturnToMenu = { [weak self] in
            self?.dismiss(animated: false)
        }
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: false, completion: nil)
    }
}
