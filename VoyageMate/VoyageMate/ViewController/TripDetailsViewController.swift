//
//  TripDetailsViewController.swift
//  VoyageMate
//
//  Created by user228347 on 8/11/24.
//

import UIKit

class TripDetailsViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var destinationLabel: UILabel!
    
    @IBOutlet weak var startLabel: UILabel!
    
    @IBOutlet weak var endLabel: UILabel!
    
    @IBOutlet weak var notesTextView: UITextView!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    
 
    //Context for Core Data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var trip: Trip?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        nameLabel.text = trip?.name
        
        var destination = Constants.Destination.withoutDestination
        if let dest = trip?.destination, !dest.isEmpty {
            destination = (trip?.destination)!
        }
        destinationLabel.text = destination
        

        startLabel.text = formatDate(trip?.start)
        
        endLabel.text = formatDate(trip?.end)
        
        notesTextView.text = trip?.notes
        notesTextView.translatesAutoresizingMaskIntoConstraints = false
        notesTextView.isScrollEnabled = true
        notesTextView.showsVerticalScrollIndicator = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let tabBar = tabBarController as! TabBarViewController
        if tabBar.objTrip == nil && trip != nil {
            tabBar.objTrip = trip
        } else {
            trip = tabBar.objTrip
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let tabBar = tabBarController as! TabBarViewController
        tabBar.objTrip = trip
    }
    
    @IBAction func editTrip(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tripFormVC = storyboard.instantiateViewController(withIdentifier: "NewTrip") as? TripFormViewController {
            tripFormVC.trip = trip
            self.navigationController?.pushViewController(tripFormVC, animated: true)
        }
    }
    
    
    @IBAction func deleteTrip(_ sender: Any) {
        
        let alert = UIAlertController(title: "Delete Trip", message: "Are you sure you want to delete this trip?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.deleteTrip(trip: self.trip!)
            self.goToTirpList()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
//        print(date)
        return formatter.string(from: date)
    }
    
    func goToTirpList(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tripList = storyboard.instantiateViewController(withIdentifier: "TripList") as? TripViewController {
            navigationController?.pushViewController(tripList, animated: true)
        }
    }
    
}

// MARK: Core Data ---
extension TripDetailsViewController{
    
    func deleteTrip(trip: Trip){
        //        print(trip)
        context.delete(trip)
        do {
            try context.save()
        }catch{
            print("TRIP DELETE ERROR:\(error)")
            let alert = UIAlertController(title: "Oops! An unexpected error occurred", message: "We couldn't delete your trips.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
