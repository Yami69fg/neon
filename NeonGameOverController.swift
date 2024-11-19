import UIKit
import SnapKit
import AVFAudio

class NeonGameOverController: UIViewController {
    
    var neonPlayerAudio: AVAudioPlayer?
    
    var neonOnReturnToMenu: (() -> ())?
    var neonOnRestart: (() -> ())?
    
    var neonIsWin = false
    var neonScore = 0

    private let neonBackgroundDetailsImageView = UIImageView()
    private let neonSettingsHeaderImageView = UIImageView()
    
    private let neonScoreTitleLabel = UILabel()
    private let neonTotalScoreTitleLabel = UILabel()
    
    private let neonMainMenuButton = UIButton()
    private let neonRetryButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.bool(forKey: "neonSound") {
            guard let url = Bundle.main.url(forResource: "neonOver", withExtension: "mp3") else {
                return
            }
            do {
                neonPlayerAudio = try AVAudioPlayer(contentsOf: url)
                neonPlayerAudio?.play()
            } catch {
            }
        }
        
        neonSetupInterface()
        neonUpdateContent()
    }
    
    private func neonSetupInterface() {
        neonAddSubviews()
        neonAddSubviewConstraints()
        neonConfigureActions()
        neonSetupUI()
    }
    
    private func neonAddSubviews() {
        view.addSubview(neonBackgroundDetailsImageView)
        view.addSubview(neonSettingsHeaderImageView)
        view.addSubview(neonScoreTitleLabel)
        view.addSubview(neonTotalScoreTitleLabel)
        view.addSubview(neonMainMenuButton)
        view.addSubview(neonRetryButton)
    }
    
    private func neonAddSubviewConstraints() {
        neonAddBackgroundDetailsConstraints()
        neonAddSettingsHeaderConstraints()
        neonAddScoreTitleLabelConstraints()
        neonAddTotalScoreTitleLabelConstraints()
        neonAddMainMenuButtonConstraints()
        neonAddRetryButtonConstraints()
    }
    
    private func neonAddBackgroundDetailsConstraints() {
        neonBackgroundDetailsImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.25)
        }
    }
    
    private func neonAddSettingsHeaderConstraints() {
        neonSettingsHeaderImageView.snp.makeConstraints { make in
            make.bottom.equalTo(neonBackgroundDetailsImageView.snp.top).offset(25)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(250)
        }
    }
    
    private func neonAddScoreTitleLabelConstraints() {
        neonScoreTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(neonBackgroundDetailsImageView.snp.left).offset(50)
            make.centerY.equalToSuperview().offset(-30)
        }
    }
    
    private func neonAddTotalScoreTitleLabelConstraints() {
        neonTotalScoreTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(neonBackgroundDetailsImageView.snp.left).offset(30)
            make.centerY.equalToSuperview().offset(30)
        }
    }
    
    private func neonAddMainMenuButtonConstraints() {
        neonMainMenuButton.snp.makeConstraints { make in
            make.top.equalTo(neonBackgroundDetailsImageView.snp.bottom)
            make.leading.equalToSuperview().offset(50)
            make.width.equalTo(120)
            make.height.equalTo(60)
        }
    }
    
    private func neonAddRetryButtonConstraints() {
        neonRetryButton.snp.makeConstraints { make in
            make.top.equalTo(neonBackgroundDetailsImageView.snp.bottom)
            make.trailing.equalToSuperview().offset(-50)
            make.width.equalTo(120)
            make.height.equalTo(60)
        }
    }
    
    private func neonConfigureActions() {
        neonMainMenuButton.addTarget(self, action: #selector(neonNavigateToMainMenu), for: .touchUpInside)
        addNeonSound(button: neonMainMenuButton)
        neonRetryButton.addTarget(self, action: #selector(neonRestartGameSession), for: .touchUpInside)
        addNeonSound(button: neonRetryButton)
    }
    
    private func neonUpdateContent() {
        if neonIsWin {
            neonSettingsHeaderImageView.image = UIImage(named: "Win")
        } else {
            neonSettingsHeaderImageView.image = UIImage(named: "Lose")
        }
        
        neonScoreTitleLabel.text = "Score \(neonScore)"
        neonTotalScoreTitleLabel.text = "Total score \(UserDefaults.standard.integer(forKey: "neonScore"))"
    }
    
    @objc private func neonNavigateToMainMenu() {
        dismiss(animated: false)
        neonOnReturnToMenu?()
    }
    
    @objc private func neonRestartGameSession() {
        dismiss(animated: true)
        neonOnRestart?()
    }

    private func neonSetupBackgroundDetailsImageView() {
        neonBackgroundDetailsImageView.image = UIImage(named: "NeonForElements")
        neonBackgroundDetailsImageView.contentMode = .scaleToFill
    }
    
    private func neonSetupSettingsHeaderImageView() {
        neonSettingsHeaderImageView.image = UIImage(named: "Win")
        neonSettingsHeaderImageView.contentMode = .scaleAspectFit
    }
    
    private func neonSetupScoreTitleLabel() {
        neonScoreTitleLabel.text = "Score"
        neonScoreTitleLabel.font = UIFont(name: "Questrian", size: 32)
        neonScoreTitleLabel.textColor = .white
        neonScoreTitleLabel.textAlignment = .center
    }
    
    private func neonSetupTotalScoreTitleLabel() {
        neonTotalScoreTitleLabel.text = "Total score"
        neonTotalScoreTitleLabel.font = UIFont(name: "Questrian", size: 28)
        neonTotalScoreTitleLabel.textColor = .white
        neonTotalScoreTitleLabel.textAlignment = .center
    }
    
    private func neonSetupMainMenuButton() {
        neonMainMenuButton.setImage(UIImage(named: "NeonMenu"), for: .normal)
    }
    
    private func neonSetupRetryButton() {
        neonRetryButton.setImage(UIImage(named: "NeonRestart"), for: .normal)
    }
    
    private func neonSetupUI() {
        neonSetupBackgroundDetailsImageView()
        neonSetupSettingsHeaderImageView()
        neonSetupScoreTitleLabel()
        neonSetupTotalScoreTitleLabel()
        neonSetupMainMenuButton()
        neonSetupRetryButton()
    }
    
    private func verifyCustomFont() {
        guard let font = UIFont(name: "Questrian", size: 32) else {
            return
        }
        neonScoreTitleLabel.font = font
    }
}
