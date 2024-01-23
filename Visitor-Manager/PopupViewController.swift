import UIKit
import Firebase

// Define PopupViewController class, inheriting from UIViewController
class PopupViewController: UIViewController {

    // UI Outlets for title, description, and date picker
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Additional setup after loading the view can be done here.
    }

    // Action method for the save button
    @IBAction func saveButtonClicked(_ sender: Any) {
        // Retrieve input data from UI elements
        let title = titleTextField.text ?? ""
        let description = descriptionTextField.text ?? ""
        let date = datePicker.date
        
        // Check if a user is logged in
        guard let userID = Auth.auth().currentUser?.uid else {
               print("User not logged in")
               // Consider handling the case where no user is logged in more gracefully
               return
        }

        // Prepare data for saving to Firebase
        let data: [String: Any] = ["title": title, "description": description, "date": date.timeIntervalSince1970]

        // Reference to the Firebase database
        let ref = Database.database().reference()
        // Save data to Firebase under the user's unique ID
        ref.child("userItems").child(userID).childByAutoId().setValue(data) { error, _ in
            if let error = error {
                // Handle error when saving data
                print("Data could not be saved: \(error.localizedDescription)")
            } else {
                // Confirm data was saved successfully
                print("Data saved successfully")
                // Consider providing user feedback through the UI, such as a confirmation message or alert
            }
        }
    }
}
