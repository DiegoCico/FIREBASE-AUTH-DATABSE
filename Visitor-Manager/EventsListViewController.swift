import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class EventsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var events: [Event] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        fetchEventsFromFirebase()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "EventCell")
    }
    
    struct Event {
        let title: String
        let description: String
        let date: Date
        let userID: String // Include the user's UID
    }
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    func saveEventToFirebase(event: Event) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("No user logged in")
            return
        }
        
        let eventRef = Database.database().reference().child("events").childByAutoId()
        let eventData: [String: Any] = [
            "title": event.title,
            "description": event.description,
            "date": event.date.timeIntervalSince1970,
            "userID": userID  // Include the user's UID
        ]
        
        eventRef.setValue(eventData) { (error, _) in
            if let error = error {
                print("Data could not be saved: \(error.localizedDescription)")
            } else {
                print("Data saved successfully")
            }
        }
    }
    
    // Function to fetch events from Firebase
    func fetchEventsFromFirebase() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("No user logged in")
            return
        }
        
        let ref = Database.database().reference().child("userItems").child(userID)
        ref.observe(.childAdded) { snapshot  in
            print("Snapshot: \(snapshot)")
            if let value = snapshot.value as? [String: Any],
               let title = value["title"] as? String,
               let description = value["description"] as? String,
               let timestamp = value["date"] as? TimeInterval {
                let date = Date(timeIntervalSince1970: timestamp)
                let newEvent = Event(title: title, description: description, date: date, userID: userID)
                self.events.append(newEvent)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

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

    @IBAction func addClicked(_ sender: Any) {
        // Implement the action for your Add button here.
    }
}
