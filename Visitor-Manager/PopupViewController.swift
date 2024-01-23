//
//  PopupViewController.swift
//  Visitor-Manager
//
//  Created by Diego Cicotoste on 1/21/24.
//

import UIKit
import Firebase

class PopupViewController: UIViewController {

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
        let ref = Database.database().reference()

        //FIRE DATABSE
         // Process the data (e.g., save to Firebase, delegate it back to main screen, etc.)
         let data: [String: Any] = ["title": title, "description": description, "date": date.timeIntervalSince1970] // using UNIX timestamp for date

         // You can save the data under a specific path like "userItems"
         ref.child("userItems").childByAutoId().setValue(data) { error, _ in
             if let error = error {
                 print("Data could not be saved: \(error.localizedDescription)")
             } else {
                 print("Data saved successfully")
             }
         }
        
        // FOR FIRESTORE
//        let db = Firestore.firestore()
//        let data: [String: Any] = ["title": title, "description": description, "date": Timestamp(date: date)] // Firestore Timestamp for date
//
//        // Add a new document in collection "userItems"
//        db.collection("userItems").addDocument(data: data) { error in
//            if let error = error {
//                print("Error adding document: \(error.localizedDescription)")
//            } else {
//                print("Document added successfully")
//            }
//        }


         dismiss(animated: true, completion: nil)
    }
    
}
