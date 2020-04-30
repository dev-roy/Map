import UIKit
import LocalAuthentication

class AuthenticationViewController: UIViewController {
    
    private let laContext = LAContext()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotifications()
    }
    
    // MARK: - Init
    @objc
    func authenticationWithBiometrics() {
        laContext.localizedFallbackTitle = "Please use your Passcode"
        var authorizationError: NSError?

        if laContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authorizationError) {
            self.evaluatePolicy()
        } else {
            guard let error = authorizationError else { return }
            print(error)
        }
    }
    
    func evaluatePolicy() {
        let reason = "Authentication required to access the map"
        laContext.evaluatePolicy(.deviceOwnerAuthentication,
                                 localizedReason: reason) { success, evaluateError in
            if success {
                self.unregisterNotifications()
                DispatchQueue.main.async() {
                    self.performSegue(withIdentifier: "segueToMap", sender: self)
                }
            } else {
                guard let error = evaluateError else { return }
                print(error)
            }
        }
    }
    
    func registerNotifications() {
        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(authenticationWithBiometrics),
                         name: UIApplication.willEnterForegroundNotification,
                         object: nil)
        
    }
    
    func unregisterNotifications() {
        NotificationCenter
            .default
            .removeObserver(self,
                            name: UIApplication.willEnterForegroundNotification,
                            object: nil)
    }
}
