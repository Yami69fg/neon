import UIKit
import SpriteKit
import AVFoundation

class NeonSound {
    
    static let shared = NeonSound()
    private var audio: AVAudioPlayer?

    private init() {}
    
    func neonPlay() {
        let neonSound = UserDefaults.standard.bool(forKey: "neonSound")
        if neonSound {
            guard let sound = Bundle.main.url(forResource: "neonButton", withExtension: "wav") else { return }
            audio = try? AVAudioPlayer(contentsOf: sound)
            audio?.play()
        }
        
        let neonVibro = UserDefaults.standard.bool(forKey: "NeonON")
        if neonVibro {
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
            feedbackGenerator.impactOccurred()
        }
    }
}



extension UIViewController {
    
    func addNeonSound(button: UIButton) {
        button.addTarget(self, action: #selector(handleButtonTouchDown(sender:)), for: .touchDown)
    }
    
    @objc private func handleButtonTouchDown(sender: UIButton) {
        NeonSound.shared.neonPlay()
    }
}
