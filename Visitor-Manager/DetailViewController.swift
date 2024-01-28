import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class DetailViewController: UIViewController {

    var event: EventsListViewController.Event?
    var dateFormatter: DateFormatter?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let selectedEvent = event {
            titleLabel.text = selectedEvent.title
            dateLabel.text = dateFormatter?.string(from: selectedEvent.date)
            descriptionLabel.text = selectedEvent.description
        }
    }

    @IBAction func addButtonClicked(_ sender: Any) {
        // Create a UIAlertController
        let alertController = UIAlertController(title: "Add Event",
                                                message: "Enter name and email",
                                                preferredStyle: .alert)

        // Add text fields for name and email
        alertController.addTextField { (textField) in
            textField.placeholder = "Name"
        }

        alertController.addTextField { (textField) in
            textField.placeholder = "Email"
        }

        // Add "Save" action
        let saveAction = UIAlertAction(title: "Save", style: .default) { (_) in
            if let nameTextField = alertController.textFields?[0],
               let emailTextField = alertController.textFields?[1],
               let name = nameTextField.text,
               let email = emailTextField.text,
               let currentUser = Auth.auth().currentUser {

                // Create a dictionary with name and email
                let userData: [String: Any] = [
                    "name": name,
                    "email": email
                ]

                // Reference to the user's account data
                let userRef = Database.database().reference().child("userItems").child(currentUser.uid)

                // Save the data in Firebase
                userRef.setValue(userData) { (error, _) in
                    if let error = error {
                        print("Data could not be saved: \(error.localizedDescription)")
                    } else {
                        print("Data saved successfully")
                    }
                }
            }
        }

        // Add "Cancel" action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        // Add actions to the UIAlertController
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        // Present the UIAlertController
        self.present(alertController, animated: true, completion: nil)
    }
}
