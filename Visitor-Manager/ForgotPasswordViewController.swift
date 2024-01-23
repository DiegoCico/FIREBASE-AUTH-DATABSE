// Import necessary modules
import UIKit
import Firebase

// Define ForgotPasswordViewController class, inheriting from UIViewController
class ForgotPasswordViewController: UIViewController {
    
    // UI Outlet for email input field
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Additional UI setup after loading the view can be done here.
    }
    
    // Action method for forgot password button click
    @IBAction func forgotClicked(_ sender: Any) {
        // Validate if email text field is not empty
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(message: "Please enter an email address.")
            return
        }
      
        // Use Firebase to send a password reset email
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            // Ensure operations are performed on the main thread
            DispatchQueue.main.async {
                if let error = error {
                    // Show error message if there's an error
                    self?.showAlert(message: error.localizedDescription)
                    return
                } else {
                    // Show success message if email is sent successfully
                    self?.showAlert(message: "A password reset email has been sent. Please check your inbox and follow the instructions to reset your password.")
                }
            }
        }
    }
    
    // Private method to show alert messages
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Sent!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        // Present the alert to the user
        self.present(alert, animated: true)
    }
}
