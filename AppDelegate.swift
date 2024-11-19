import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var mainWindow: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if UserDefaults.standard.object(forKey: "neonSound") == nil {
            UserDefaults.standard.set(true, forKey: "neonSound")
        }
        if UserDefaults.standard.object(forKey: "neonVibro") == nil {
            UserDefaults.standard.set(true, forKey: "neonVibro")
        }
        
        self.mainWindow = UIWindow(frame: UIScreen.main.bounds)
        self.mainWindow?.rootViewController = UINavigationController(rootViewController: NeonLoadController())
        self.mainWindow?.makeKeyAndVisible()
        
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        return .portrait
    }


}

