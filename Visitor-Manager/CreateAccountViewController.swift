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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func createAccountClicked(_ sender: UIButton) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { firebaseResult, error in
            if let e = error {
                DispatchQueue.main.async {
                    print("Error signing in: \(e.localizedDescription)")
                }
            } else {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "goToNext", sender: self)
                }
            }
        }

        
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
