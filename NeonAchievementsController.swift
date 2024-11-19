import UIKit
import SnapKit

class NeonAchievementsController: UIViewController {
    
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
        updateAchieve()
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
        neonPortalButton.setImage(UIImage(named: "first"), for: .normal)
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
        neonMarketButton.setImage(UIImage(named: "Fifty"), for: .normal)
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
        neonAchievementButton.setImage(UIImage(named: "ten"), for: .normal)
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
        neonAlert(message: "Achievement Unlocked: First Time!")
        neonPortalButton.alpha = 1.0
    }

    @objc private func neonOpenMarket() {
        if neonGlobalScore >= 500 {
            neonAlert(message: "Achievement Unlocked: 500 Points Reached!")
            neonMarketButton.alpha = 1.0
        } else {
            neonAlert(message: "Achievement Not Unlocked: Reach 500 Points.")
            neonMarketButton.alpha = 0.7
        }
    }

    @objc private func neonViewAchievements() {
        if neonGlobalScore >= 1000 {
            neonAlert(message: "Achievement Unlocked: 1000 Points Reached!")
            neonAchievementButton.alpha = 1.0
        } else {
            neonAlert(message: "Achievement Not Unlocked: Reach 1000 Points.")
            neonAchievementButton.alpha = 0.7
        }
    }
    
    private func updateAchieve() {
        neonPortalButton.alpha = 1.0
        
        neonMarketButton.alpha = neonGlobalScore >= 500 ? 1.0 : 0.7
        
        neonAchievementButton.alpha = neonGlobalScore >= 1000 ? 1.0 : 0.7
    }

    private func neonAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
}
