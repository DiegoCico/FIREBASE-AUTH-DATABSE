//
//  CreateEventViewController.swift
//  Visitor-Manager
//
//  Created by Diego Cicotoste on 1/23/24.
//

import UIKit
import Firebase

class CreateEventViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func saveButtonClicked(_ sender: Any) {
        let title = titleTextField.text ?? ""
        let description = descriptionTextField.text ?? ""
        let date = datePicker.date
        
        guard let userID = Auth.auth().currentUser?.uid else {
               print("User not logged in")
               return
           }

           let data: [String: Any] = ["title": title, "description": description, "date": date.timeIntervalSince1970]

           let ref = Database.database().reference()
           ref.child("userItems").child(userID).childByAutoId().setValue(data) { error, _ in
               if let error = error {
                   print("Data could not be saved: \(error.localizedDescription)")
               } else {
                   print("Data saved successfully")
               }
           }
    }

}
