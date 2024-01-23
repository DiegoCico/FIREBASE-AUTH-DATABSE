import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class EventsListViewController: UIViewController, UITableViewDataSource {
    var events: [Event] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        fetchEventsFromFirebase()
    }
    
    struct Event {
        let title: String
        let description: String
        let date: Date
    }
    
    func fetchEventsFromFirebase() {
        guard let userID = Auth.auth().currentUser?.uid else {
               print("No user logged in")
               // Handle the case where no user is logged in
               return
           }
        
        // Assuming each user has their events stored under a node named with their userID
        let ref = Database.database().reference().child("userEvents").child(userID)
        ref.observe(.value) { snapshot in
            print("Snapshot: \(snapshot)")
            var newEvents: [Event] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let value = snapshot.value as? [String: Any],
                   let title = value["title"] as? String,
                   let description = value["description"] as? String,
                   let timestamp = value["date"] as? TimeInterval {
                    let date = Date(timeIntervalSince1970: timestamp)
                    newEvents.append(Event(title: title, description: description, date: date))
                }
            }
            DispatchQueue.main.async {
                self.events = newEvents
                self.tableView.reloadData()
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
           cell.detailTextLabel?.text = "\(event.description) - \(event.date)"
           return cell
       }


    @IBAction func addClicked(_ sender: Any) {
        // Implement the action for your Add button here.
    }

 
}
