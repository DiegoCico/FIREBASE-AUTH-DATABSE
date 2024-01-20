//
//  LoginViewController.swift
//  Visitor-Manager
//
//  Created by Diego Cicotoste on 1/19/24.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logInClicked(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(message: "Please enter your email.")
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Please enter your password.")
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] firebaseResult, error in
            guard let strongSelf = self else { return }

            if let e = error {
                DispatchQueue.main.async {
                    strongSelf.showAlert(message: "Error signing in: \(e.localizedDescription)")
                }
                return
            }

            DispatchQueue.main.async {
                strongSelf.performSegue(withIdentifier: "goToNext", sender: strongSelf)
            }
        }
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Authentication Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }

        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
    }
}
