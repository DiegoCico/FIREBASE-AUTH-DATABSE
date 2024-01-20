//
//  ForgotPasswordViewController.swift
//  Visitor-Manager
//
//  Created by Diego Cicotoste on 1/20/24.
//

import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func forgotClicked(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty else {
            // Handle empty email field
            showAlert(message: "Please enter an email address.")
            return
        }
      
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            DispatchQueue.main.async {
                if let error = error{
                    self.showAlert(message: error.localizedDescription)
                    return
                } else {
                    self.showAlert(message: "A password reset email has been sent. Please check your inbox and follow the instructions to reset your password.")
                }
            }
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }


}
