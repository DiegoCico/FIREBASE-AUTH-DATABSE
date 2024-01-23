// Import necessary modules
import UIKit
import Firebase

// Define CreateAccountViewController class, inheriting from UIViewController
class CreateAccountViewController: UIViewController {

    // UI Outlets for email and password input fields
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordCheckTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Additional UI setup after loading the view can be done here.
    }
    
    // Action method for create account button click
    @IBAction func createAccountClicked(_ sender: UIButton) {
        // Validate if email text field is not empty
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(message: "Please enter an email address.")
            return
        }
        // Validate if password text field is not empty
        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Please enter a password.")
            return
        }
        // Validate if password check text field is not empty
        guard let passwordCheck = passwordCheckTextField.text, !passwordCheck.isEmpty else {
            showAlert(message: "Please confirm your password.")
            return
        }
        
        // Check if the entered passwords match
        if password == passwordCheck {
            // Use Firebase to create a new user with the provided email and password
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
                // Use a strong reference to self, if self is not nil
                guard let strongSelf = self else { return }

                // Handle the error case
                if let e = error {
                    // Update UI on the main thread
                    DispatchQueue.main.async {
                        strongSelf.showAlert(message: "Error creating account: \(e.localizedDescription)")
                    }
                    return
                }
                // If account creation is successful, perform segue on the main thread
                DispatchQueue.main.async {
                    strongSelf.performSegue(withIdentifier: "goToNext", sender: strongSelf)
                }
            }
        } else {
            // Clear the password fields if they do not match
            passwordTextField.text = ""
            passwordCheckTextField.text = ""
            showAlert(message: "Passwords do not match.")
        }
    }
    
    // Private method to show alert messages
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        // Present the alert to the user
        self.present(alert, animated: true)
    }
}
