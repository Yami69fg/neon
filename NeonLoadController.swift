import UIKit
import SnapKit

class NeonLoadController: UIViewController {

    // MARK: - UI Elements
    private var neonBackground: UIImageView!
    private var neonCrystal: UIImageView!
    private var neonLoadingText: UIImageView!
    
    private let crystalImages = ["GreenCristall", "YellowCristall", "BlueCristall", "PurpleCristall", "RedCristall"]
    private var currentCrystalIndex = 0

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNeonBackground()
        setupNeonCrystal()
        setupNeonLoadingText()
        
        startNeonAnimations()
        scheduleNeonTransition()
    }

    // MARK: - UI Setup Functions

    private func setupNeonBackground() {
        neonBackground = UIImageView(image: UIImage(named: "NeonBackGround"))
        view.addSubview(neonBackground)
        neonBackground.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupNeonCrystal() {
        neonCrystal = UIImageView(image: UIImage(named: "BlueCristall"))
        neonCrystal.contentMode = .scaleAspectFit
        view.addSubview(neonCrystal)
        neonCrystal.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(-100)
            make.size.equalTo(250)
        }
    }

    private func setupNeonLoadingText() {
        neonLoadingText = UIImageView(image: UIImage(named: "Loading"))
        view.addSubview(neonLoadingText)
        neonLoadingText.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(200)
            make.size.equalTo(CGSize(width: 350, height: 125))
        }
    }

    // MARK: - Animations
    private func startNeonAnimations() {
        animateNeonCrystalDrop()
        animateNeonCrystalChange()
        animateNeonTextBlink()
    }

    private func animateNeonCrystalDrop() {
        UIView.animate(withDuration: 2.0, delay: 0, options: .curveEaseIn) {
            self.neonCrystal.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height / 2)
        }
    }

    private func animateNeonCrystalChange() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            self.currentCrystalIndex = (self.currentCrystalIndex + 1) % self.crystalImages.count
            let nextImageName = self.crystalImages[self.currentCrystalIndex]
            self.neonCrystal.image = UIImage(named: nextImageName)
        }
    }

    private func animateNeonTextBlink() {
        UIView.animate(withDuration: 0.8, delay: 0, options: [.autoreverse, .repeat]) {
            self.neonLoadingText.alpha = 0.0
        }
    }

    // MARK: - Transition
    private func scheduleNeonTransition() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.neonTransitionToMain()
        }
    }

    private func neonTransitionToMain() {
        let neonMenuController: UIViewController

        if UserDefaults.standard.bool(forKey: "neonLaunched") {
            neonMenuController = NeonMenuController()
        } else {
            UserDefaults.standard.set(true, forKey: "neonLaunched")
            neonMenuController = NeonIntroController()
        }
        neonMenuController.modalTransitionStyle = .crossDissolve
        neonMenuController.modalPresentationStyle = .fullScreen
        present(neonMenuController, animated: false)
    }
}
