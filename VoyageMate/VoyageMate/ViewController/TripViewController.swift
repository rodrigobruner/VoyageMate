//
//  TripViewController.swift
//  VoyageMate
//
//  Created by user228347 on 8/11/24.
//

import UIKit

class TripViewController: UIViewController {
    
    //UI
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var contentView: UIView!
    
    //Context for Core Data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Table View
    let tableView = UITableView()
    
    private var models = [Trip]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TableView
        tableView.register(TripTableViewCell.self, forCellReuseIdentifier: "tripCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        contentView.addSubview(tableView);
    }
}

// MARK: - Table View
extension TripViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath)
        
        cell.textLabel?.text = model.name
        
        return cell
    }
}

// MARK: - Core Data
extension TripViewController{

    func createTrip(name:String, destination:String, start:Date, end:Date, notes:String){
        let newTrip = Trip(context: context)
        newTrip.tripID = UUID()
        newTrip.name = name
        newTrip.destination = destination
        newTrip.start = start
        newTrip.end = end
        newTrip.notes = notes
        
        do {
            try context.save()
            getAllTrip()
        }catch{
            let alert = UIAlertController(title: "Oops! An unexpected error occurred", message: "We couldn't create your trips.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func updateTrip(trip: Trip, name:String, destination:String, start:Date, end:Date, notes:String){
        trip.name = name
        trip.destination = destination
        trip.start = start
        trip.end = end
        trip.notes = notes
        
        do {
            try context.save()
            getAllTrip()
        }catch{
            let alert = UIAlertController(title: "Oops! An unexpected error occurred", message: "We couldn't update your trips.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func deleteTrip(trip: Trip){
        context.delete(trip)
        do {
            try context.save()
            getAllTrip()
        }catch{
            let alert = UIAlertController(title: "Oops! An unexpected error occurred", message: "We couldn't delete your trips.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func getAllTrip(){
        do {
            models = try context.fetch(Trip.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }catch{
            let alert = UIAlertController(title: "Oops! An unexpected error occurred", message: "We couldn't get your trips.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
