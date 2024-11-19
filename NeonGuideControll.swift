import UIKit
import SnapKit

class NeonGuideControll: UIViewController {

    private let neonBackdropImageView = UIImageView()
    private let neonCloseButton = UIButton()
    private let neonDopImageView = UIImageView()
    private let neonInstructionImageView = UIImageView()
    private let neonInstructionLabel = UILabel()
    
    var neonInstructionType = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNeonInterface()
        setupNeonInstructionText()
    }

    private func configureNeonInterface() {
        configureNeonBackdropImageView()
        configureNeonDopImageView()
        configureNeonInstructionImageView()
        configureNeonCloseButton()
        configureNeonInstructionLabel()
    }

    private func configureNeonBackdropImageView() {
        neonBackdropImageView.image = UIImage(named: "NeonBackGround")
        neonBackdropImageView.contentMode = .scaleAspectFill
        view.addSubview(neonBackdropImageView)
        neonBackdropImageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    private func configureNeonCloseButton() {
        neonCloseButton.setImage(UIImage(named: "NeonToBack"), for: .normal)
        neonCloseButton.addTarget(self, action: #selector(neonCloseTapped), for: .touchUpInside)
        addNeonSound(button: neonCloseButton)
        view.addSubview(neonCloseButton)
        neonCloseButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.left.equalToSuperview().inset(10)
            $0.size.equalTo(45)
        }
    }

    private func configureNeonDopImageView() {
        neonDopImageView.image = UIImage(named: "NeonForElements")
        view.addSubview(neonDopImageView)
        neonDopImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.height.equalTo(neonDopImageView.snp.width).multipliedBy(1.3)
        }
    }

    private func configureNeonInstructionImageView() {
        neonInstructionImageView.image = UIImage(named: "Info")
        neonInstructionImageView.contentMode = .scaleAspectFit
        view.addSubview(neonInstructionImageView)
        neonInstructionImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(neonDopImageView.snp.top)
            $0.width.equalTo(300)
            $0.height.equalTo(100)
        }
    }

    private func configureNeonInstructionLabel() {
        neonInstructionLabel.font = UIFont(name: "Questrian", size: 28)
        neonInstructionLabel.textColor = .white
        neonInstructionLabel.textAlignment = .center
        neonInstructionLabel.numberOfLines = 0
        neonInstructionLabel.adjustsFontSizeToFitWidth = true
        neonInstructionLabel.minimumScaleFactor = 0.49
        neonDopImageView.addSubview(neonInstructionLabel)
        neonInstructionLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.78)
            $0.height.equalTo(neonDopImageView.snp.width).multipliedBy(1.2)
        }
    }

    private func setupNeonInstructionText() {
        switch neonInstructionType {
        case 1:
            neonInstructionLabel.text = "You have a ship that you can control to move left and right. You must avoid crashing into flying meteors. If you crash into them, you lose. However, if you survive for a long time, you pass the level."
        case 2:
            neonInstructionLabel.text = "You have 15 chests, 12 of which are empty and 3 contain crystals. You can open only 5 chests to find the ones with crystals. If you find them, you win; if not, you lose."
        default:
            neonInstructionLabel.text = "You have 5 types of crystals and 5 containers of the same colors as the crystals. You are given a random number of crystals, and you need to match them by color by clicking on the crystal and then clicking on the corresponding container."
        }
    }

    @objc private func neonCloseTapped() {
        dismiss(animated: true, completion: nil)
    }
}
