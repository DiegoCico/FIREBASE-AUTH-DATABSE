import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

// Define EventsListViewController class, inheriting from UIViewController and conforming to UITableViewDataSource
class EventsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Array to store event data
    var events: [Event] = []
    
    // Outlet for the table view
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the table view's data source to this view controller
        tableView.dataSource = self
        tableView.delegate = self
        // Fetch events from Firebase
        fetchEventsFromFirebase()
        
        // Register a UITableViewCell for reuse
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "EventCell")
        
    }
    
    // Define Event struct to model event data
    struct Event {
        let title: String
        let description: String
        let date: Date
    }
    
    lazy var dateFormatter: DateFormatter = {
         let formatter = DateFormatter()
         formatter.dateStyle = .medium
         formatter.timeStyle = .none
         return formatter
     }()
    
    // Function to fetch events from Firebase
    func fetchEventsFromFirebase() {
        // Guard to check if a user is logged in
        guard let userID = Auth.auth().currentUser?.uid else {
               print("No user logged in")
               // Handle the case where no user is logged in
               return
        }
        
        // Reference to the Firebase database node
        let ref = Database.database().reference().child("userItems").child(userID)
        // Observe changes in the Firebase database
        ref.observe(.value) { snapshot in
            print("Snapshot: \(snapshot)")
            var newEvents: [Event] = []
            // Iterate through children of the snapshot
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let value = snapshot.value as? [String: Any],
                   let title = value["title"] as? String,
                   let description = value["description"] as? String,
                   let timestamp = value["date"] as? TimeInterval {
                    let date = Date(timeIntervalSince1970: timestamp)
                    // Append new events to the array
                    newEvents.append(Event(title: title, description: description, date: date))
                }
            }
            // Reload table view on the main thread
            DispatchQueue.main.async {
                self.events = newEvents
                self.tableView.reloadData()
            }
        }
    }
    
    // UITableViewDataSource method to return the number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return events.count
    }

    // UITableViewDataSource method to configure each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        let event = events[indexPath.row]
        cell.textLabel?.text = event.title
        cell.detailTextLabel?.text = "\(event.description) - \(dateFormatter.string(from: event.date))"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetailSegue", sender: self)
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "showDetailSegue" {
               if let detailVC = segue.destination as? DetailViewController,
                  let indexPath = tableView.indexPathForSelectedRow {
                   let selectedEvent = events[indexPath.row]
                   detailVC.event = selectedEvent
               }
           }
       }

    // Action method for Add button
    @IBAction func addClicked(_ sender: Any) {
        // Implement the action for your Add button here.
    }


}
