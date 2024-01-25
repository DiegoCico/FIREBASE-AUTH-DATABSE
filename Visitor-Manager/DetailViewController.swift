import UIKit
import FirebaseDatabase
import Firebase

class DetailViewController: UIViewController, UITableViewDelegate {
    var event: EventsListViewController.Event?
    var dateFormatter: DateFormatter?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView! // Connect this IBOutlet to your table view in the storyboard
    
    struct User {
        var name: String
        var email: String
    }
    
    var users: [User] = [] // Data source for the table view
    
    var isAddUserAlertShown = false // Flag to track if the alert has been shown
    
    // Reference to the Firebase database
    let databaseRef = Database.database().reference()
    
    // Variable to store the current user's UID
    var currentUserUID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UserCell")
        
        if let event = self.event, let dateFormatter = self.dateFormatter {
            // Display event information in the UI elements
            titleLabel.text = event.title
            descriptionLabel.text = event.description
            dateLabel.text = dateFormatter.string(from: event.date)
            
            // Set the title of the page to the event title
            self.title = event.title
        }
        
        // Set the table view delegate and data source
        tableView.delegate = self
        tableView.dataSource = self
        
        // Allow editing (swipe-to-delete) for the table view
        tableView.isEditing = true
        
        // Get the current user's UID
        if let currentUser = Auth.auth().currentUser {
            currentUserUID = currentUser.uid
        }
        
        // Load user data from Firebase and populate the users array
        if let currentUserUID = currentUserUID {
            let userNodeRef = databaseRef.child("userItems").child(currentUserUID)
            userNodeRef.observe(.childAdded) { (snapshot) in
                if let userData = snapshot.value as? [String: String],
                   let name = userData["name"],
                   let email = userData["email"] {
                    let newUser = User(name: name, email: email)
                    self.users.append(newUser)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // Function to add a user when the "Add User" button is tapped
    @IBAction func addUserButtonTapped(_ sender: UIButton) {
        if isAddUserAlertShown {
            isAddUserAlertShown = false
            return // Exit early if the alert has already been shown
        }
        
        let alertController = UIAlertController(title: "Add User", message: "Enter Name and Email", preferredStyle: .alert)
        
        // Add text fields for name and email input
        alertController.addTextField { (nameTextField) in
            nameTextField.placeholder = "Name"
        }
        
        alertController.addTextField { (emailTextField) in
            emailTextField.placeholder = "Email"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            if let nameTextField = alertController.textFields?.first,
               let emailTextField = alertController.textFields?.last,
               let name = nameTextField.text,
               let email = emailTextField.text,
               !name.isEmpty,
               !email.isEmpty {
                
                let newUser = User(name: name, email: email)
                self.addUser(user: newUser)
                
                self.isAddUserAlertShown = true // Set the flag to true after showing the alert
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // Add functions to manage users here
    func addUser(user: User) {
        // Add the user to the local data source (users array)
        users.append(user)
        
        // Save the user to Firebase Realtime Database under the current user's UID
        if let currentUserUID = currentUserUID {
            let userRef = databaseRef.child("userItems").child(currentUserUID).childByAutoId()
            userRef.setValue(["name": user.name, "email": user.email])
        }
        
        // Reload the table view to reflect the changes
        tableView.reloadData()
    }
    
    func sendEmailInvitation(to user: User) {
        // Implement email invitation logic (e.g., using Firebase Authentication)
    }
}

// Implement UITableViewDataSource methods
extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        return cell
    }
    
    // Implement the swipe-to-delete functionality
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove the user from the data source (users array)
            users.remove(at: indexPath.row)
            
            // Update the table view to reflect the deletion
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // Remove the user from the current user's node in Firebase Realtime Database
            if let currentUserUID = currentUserUID, indexPath.row < users.count {
                let deletedUser = users[indexPath.row]
                let userRef = databaseRef.child("userItems").child(currentUserUID).child(deletedUser.name) // Assuming name is a unique identifier for users
                userRef.removeValue()
            }
        }
    }
}
