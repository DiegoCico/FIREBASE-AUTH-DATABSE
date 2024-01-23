// Import necessary modules
import UIKit
import Firebase

// Define LoginViewController class, inheriting from UIViewController
class LoginViewController: UIViewController {
    
    // UI Outlets for email and password input fields
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Additional UI setup after loading the view can be done here.
    }
    
    // Action method for login button click
    @IBAction func logInClicked(_ sender: UIButton) {
        // Validate if email text field is not empty
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(message: "Please enter your email.")
            return
        }
        // Validate if password text field is not empty
        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Please enter your password.")
            return
        }

        // Use Firebase authentication to sign in with email and password
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] firebaseResult, error in
            // Use a strong reference to self, if self is not nil
            guard let strongSelf = self else { return }

            // Handle the error case
            if let e = error {
                // Update UI on the main thread
                DispatchQueue.main.async {
                    strongSelf.showAlert(message: "Error signing in: \(e.localizedDescription)")
                }
                return
            }

            // If sign-in is successful, perform segue on the main thread
            DispatchQueue.main.async {
                strongSelf.performSegue(withIdentifier: "goToNext", sender: strongSelf)
            }
        }
    }

    // Private method to show alert messages
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Authentication Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        // Present the alert to the user
        self.present(alert, animated: true)
    }
        
}
