import UIKit
import SnapKit

class NeonIntroController: UIViewController {
    
    // MARK: - UI Elements
    private var neonBackground: UIImageView!
    private var neonGreetingImage: UIImageView!
    private var neonBonusButton: UIButton!

    private var neonGlobalScore: Int {
        get { return UserDefaults.standard.integer(forKey: "neonScore") }
        set { UserDefaults.standard.set(newValue, forKey: "neonScore") }
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNeonBackground()
        setupNeonGreetingImage()
        setupNeonBonusButton()
        setupNeonButtonAction()
    }
    
    // MARK: - UI Setup Functions

    private func setupNeonBackground() {
        neonBackground = UIImageView()
        neonBackground.image = UIImage(named: "NeonBackGround")
        neonBackground.contentMode = .scaleAspectFill
        view.addSubview(neonBackground)
        
        neonBackground.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupNeonGreetingImage() {
        neonGreetingImage = UIImageView()
        neonGreetingImage.image = UIImage(named: "WelcomeNeon")
        neonGreetingImage.contentMode = .scaleAspectFit
        view.addSubview(neonGreetingImage)
        
        neonGreetingImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.width.equalTo(300)
            make.height.equalTo(200)
        }
    }

    private func setupNeonBonusButton() {
        neonBonusButton = UIButton()
        neonBonusButton.setImage(UIImage(named: "NeonChest"), for: .normal)
        neonBonusButton.contentMode = .scaleAspectFit
        neonBonusButton.layer.cornerRadius = 10
        neonBonusButton.clipsToBounds = true
        view.addSubview(neonBonusButton)
        
        neonBonusButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(200)
        }
    }

    // MARK: - Button Action Setup

    private func setupNeonButtonAction() {
        neonBonusButton.addTarget(self, action: #selector(neonBonusButtonTapped), for: .touchUpInside)
        addNeonSound(button: neonBonusButton)
    }

    @objc private func neonBonusButtonTapped() {
        neonBonusButton.setImage(UIImage(named: "NeonCristallChest"), for: .normal)
        let alert = UIAlertController(
            title: "Welcome To Neon!",
            message: "You've received 25 bonus stars!",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.neonGlobalScore += 25
            self.neonNavigateToMainMenu()
        }))
        present(alert, animated: true)
    }

    // MARK: - Navigation

    private func neonNavigateToMainMenu() {
        let neonMenuController = NeonMenuController()
        neonMenuController.modalTransitionStyle = .crossDissolve
        neonMenuController.modalPresentationStyle = .fullScreen
        present(neonMenuController, animated: true)
    }
}
