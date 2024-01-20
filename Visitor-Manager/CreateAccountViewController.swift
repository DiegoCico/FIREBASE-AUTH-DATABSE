//
//  CreateAccountViewController.swift
//  Visitor-Manager
//
//  Created by Diego Cicotoste on 1/19/24.
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordCheckTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func createAccountClicked(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty else {
            // Handle empty email field
            showAlert(message: "Please enter an email address.")
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            // Handle empty password field
            showAlert(message: "Please enter a password.")
            return
        }
        guard let passwordCheck = passwordCheckTextField.text, !passwordCheck.isEmpty else {
            // Handle empty password check field
            showAlert(message: "Please confirm your password.")
            return
        }
        
        if password == passwordCheck{
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
                guard let strongSelf = self else { return }

                if let e = error {
                    DispatchQueue.main.async {
                        strongSelf.showAlert(message: "Error creating account: \(e.localizedDescription)")
                    }
                    return
                }
                    DispatchQueue.main.async {
                        strongSelf.performSegue(withIdentifier: "goToNext", sender: strongSelf)
                    }
            }
        } else {
            passwordTextField.text = ""
            passwordCheckTextField.text = ""
            showAlert(message: "Passwords do not match.")
                
        }

        
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }

}
